FROM nginx:1.25-alpine
COPY target/*war /usr/local/tomcat/webapps
