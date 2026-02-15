# ---------- Builder ----------
FROM node:24-alpine3.20 AS builder

WORKDIR /app

# Install deps first for better caching
COPY package.json yarn.lock ./
RUN yarn install --frozen-lockfile

# Copy source and build
COPY . .
RUN yarn build && mv build dist


# ---------- Runtime ----------
FROM node:24-alpine3.20 AS runtime

ENV NODE_ENV=production
WORKDIR /app

# Create non root user
RUN addgroup -S nodejs && adduser -S appuser -G nodejs

# Copy only what is needed
COPY --from=builder /app/dist ./dist
COPY --from=builder /app/package.json ./
COPY --from=builder /app/yarn.lock ./

# Install only production deps
RUN yarn install --frozen-lockfile --production && yarn cache clean

# Use non root user
USER appuser

EXPOSE 3000

# Use local serve binary instead of global install
CMD ["yarn", "serve", "-s", "dist", "-l", "3000"]
