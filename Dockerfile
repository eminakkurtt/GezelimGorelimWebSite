FROM nginx:alpine

COPY GezelimGorelimWebsite-main/ /usr/share/nginx/html/

EXPOSE 80