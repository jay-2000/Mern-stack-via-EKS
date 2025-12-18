# FROM node:18-alpine as builder
# WORKDIR /app
# COPY package*.json ./
# RUN npm install
# COPY . .
# RUN NODE_OPTIONS=--openssl-legacy-provider npm run build

# FROM nginx:stable-alpine
# COPY --from=builder /app/build /usr/share/nginx/html
# EXPOSE 80
# CMD ["nginx","-g","daemon off;"]

# FROM node:18-alpine AS build
# WORKDIR /app
# COPY package*.json ./
# RUN npm install --force
# COPY . .
# RUN npm run build

# FROM nginx:alpine
# COPY --from=build /app/build /usr/share/nginx/html
# EXPOSE 80
# CMD ["nginx", "-g", "daemon off;"]

# Build stage
FROM node:18-alpine AS build

WORKDIR /app
ENV NODE_OPTIONS=--openssl-legacy-provider

COPY package*.json ./
RUN npm install --force

COPY . .
RUN npm run build

# Production stage
FROM nginx:alpine
COPY --from=build /app/build /usr/share/nginx/html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]