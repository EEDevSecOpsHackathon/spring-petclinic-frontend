# pull official node base image
FROM node:14.15.0-alpine3.12 as build
WORKDIR /app
COPY . .
RUN yarn install
RUN yarn dist

# production environment
FROM nginx:stable-alpine
COPY --from=build /app/public /usr/share/nginx/html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]