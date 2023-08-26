FROM nginx:1.25-alpine
COPY target/*.war /usr/share/nginx/html
