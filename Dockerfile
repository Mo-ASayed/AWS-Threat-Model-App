FROM node:24-alpine3.20 AS builder

# Patch base image packages (fixes OpenSSL CVE)
RUN apk upgrade --no-cache

WORKDIR /app

# Install deps first for caching
COPY package.json yarn.lock ./
RUN yarn install --frozen-lockfile

# Copy source and build
COPY . .
RUN yarn build && mv build dist


FROM node:24-alpine3.20 AS runtime

# Patch packages here too (important!)
RUN apk upgrade --no-cache

ENV NODE_ENV=production
WORKDIR /app

# Create non root user
RUN addgroup -S nodejs && adduser -S appuser -G nodejs

COPY --from=builder /app/dist ./dist
COPY --from=builder /app/package.json ./
COPY --from=builder /app/yarn.lock ./

# Install only production deps
RUN yarn install --frozen-lockfile --production \
    && yarn cache clean

USER appuser

EXPOSE 3000

CMD ["yarn", "serve", "-s", "dist", "-l", "3000"]
