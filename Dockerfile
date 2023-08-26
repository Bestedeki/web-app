FROM nginx:1.25-alpine
COPY target/web-app.war /usr/share/nginx/html/web-app.war
