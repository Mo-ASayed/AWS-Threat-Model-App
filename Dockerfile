FROM node:24-alpine AS builder

# Set working directory
WORKDIR /app

COPY package.json yarn.lock ./

# Install dependencies, ignoring strict peer deps
RUN yarn install --legacy-peer-deps

# Copy the rest of the source files
COPY . .

RUN yarn build && mv build dist

FROM node:24-alpine

WORKDIR /app

# Copy node_modules and built app from builder
COPY --from=builder /app/node_modules ./node_modules
COPY --from=builder /app/dist ./dist

EXPOSE 3000

# Install serve to serve the build
RUN yarn global add serve

# Start the app
CMD ["serve", "-s", "dist", "-l", "3000"]
