FROM node:15.0.1-alpine3.10
WORKDIR /app
COPY . .
RUN yarn install