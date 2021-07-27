### STAGE 1: Build front ###
FROM node:14.17.3 AS build
WORKDIR /app
COPY package.json package-lock.json ./
RUN npm install
COPY . .
RUN npm run build


### STAGE 2: Run ###
FROM nginx:1.20.1
COPY nginx/nginx.conf /etc/nginx/nginx.conf
COPY --from=build /app/dist/client-angular /usr/share/nginx/html