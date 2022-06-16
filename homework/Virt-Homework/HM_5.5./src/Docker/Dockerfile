FROM nginx:1.21.6-alpine
RUN mkdir /etc/nginx/sites-available
COPY default /etc/nginx/sites-available/default
RUN rm /usr/share/nginx/html/index.html
COPY index.html /usr/share/nginx/html/index.html
EXPOSE 80/tcp
CMD ["/usr/sbin/nginx", "-g", "daemon off;"]
