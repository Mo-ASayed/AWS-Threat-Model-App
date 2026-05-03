# ─── Stage 1: Build ───────────────────────────────────────
FROM node:20-alpine AS builder

WORKDIR /app

COPY yarn.lock package.json ./
RUN yarn install --frozen-lockfile && yarn cache clean

COPY . .
RUN DISABLE_ESLINT_PLUGIN=true yarn run build

# ─── Stage 2: Runtime ─────────────────────────────────────
FROM node:alpine

RUN npm install -g serve

COPY --from=builder /app/build ./build

RUN addgroup -S appgroup && adduser -S appuser -G appgroup
USER appuser

EXPOSE 3000
CMD ["serve", "-s", "build", "-l", "3000"]