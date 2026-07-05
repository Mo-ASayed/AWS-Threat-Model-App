# syntax=docker/dockerfile:1
# --- Stage 1: Build ---------------------------------------
FROM --platform=$BUILDPLATFORM node:20-alpine3.21 AS builder

WORKDIR /app

COPY yarn.lock package.json ./
RUN --mount=type=secret,id=npmrc,target=/root/.npmrc yarn install --frozen-lockfile

# Copy source
COPY tsconfig.json babel.config.json .eslintrc.json tsconfig.dev.json ./
COPY src/ ./src/
COPY public/ ./public/
COPY config/ ./config/
RUN CI=false GENERATE_SOURCEMAP=false NODE_OPTIONS=--max-old-space-size=1024 DISABLE_ESLINT_PLUGIN=true yarn run build

# --- Stage 2: Runtime -------------------------------------
FROM node:20-alpine3.21

WORKDIR /app

ENV NODE_ENV=production

RUN npm install -g serve@14.2.4 && npm cache clean --force
COPY --from=builder /app/build ./build
USER node

EXPOSE 3000
HEALTHCHECK --interval=30s --timeout=5s --start-period=30s --retries=3 CMD wget -qO- http://localhost:3000/health || exit 1
CMD ["serve", "-s", "build", "-l", "3000"]