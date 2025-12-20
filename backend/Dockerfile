# FROM node:18-alpine
# WORKDIR /app
# COPY package*.json ./
# RUN npm install --production
# COPY . .
# EXPOSE 5000
# CMD ["node","index.js"]

FROM node:18-alpine
WORKDIR /app
COPY package*.json ./
RUN npm install --force
COPY . .
EXPOSE 3500
CMD ["npm", "start"]
