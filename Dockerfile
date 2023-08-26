FROM nginx:1.25-alpine
COPY *.war /usr/share/nginx/html
