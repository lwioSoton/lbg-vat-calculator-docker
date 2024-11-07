FROM node:19-alpine as build

# change into a folder called /app
WORKDIR /app

# only copy package.json
COPY package.json .

# download the project dependencies
RUN npm install

# copy everything from the react app folder to the /app folder in the container
COPY . .

# package up the react project in the /app directory
RUN npm run build

# stage 2
# nginx is a web-based engine. We want this to run on the web
FROM nginx:1.23-alpine
# COPY from /app/build to /usr/share... build in --from=build is "note:19-alpine" (look at Line 1)
COPY --from=build /app/build /usr/share/nginx/html

COPY nginx/nginx.conf /etc/nginx/conf.d/default.conf
# 80 is port num. Expose tells Docker "we are listening on Port 80" ahead of time.
EXPOSE 80

# Tells the cmdline to run these commands on startup.
CMD ["nginx", "-g", "daemon off;"]
