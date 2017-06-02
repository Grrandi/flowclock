from httpd:alpine
copy ./flowclock.html /usr/local/apache2/htdocs/index.html
expose 80
