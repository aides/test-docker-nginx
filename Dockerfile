FROM debian:jessie
EXPOSE 8000

ENV NGINX_VERSION 1.11.4-1~jessie

# Install nginx
RUN apt-key adv --keyserver hkp://pgp.mit.edu:80 --recv-keys 573BFD6B3D8FBC641079A6ABABF5BD827BD9BF62 \
    && echo "deb http://nginx.org/packages/mainline/debian/ jessie nginx" >> /etc/apt/sources.list \
    && apt-get update -q \
    && apt-get install --no-install-recommends --no-install-suggests -y -q \
                        nginx=${NGINX_VERSION} \
    && rm -rf /var/lib/apt/lists/*

COPY ./nginx.conf /etc/nginx/
COPY ./index.html /usr/share/nginx/test/

# Below we create a new user, give necessary permissions and run nginx under that user
# There is a permission issue with using default nginx log directory, so we recreate it
# The same for pid file
RUN groupadd -r webgroup \
    && useradd -r -m -g webgroup webuser \
#    && rm -rf /var/log/nginx \
#    && mkdir /var/log/nginx \
#    && touch /var/log/nginx/access.log \
#    && touch /var/log/nginx/error.log \
    && touch /run/nginx.pid \
#    && mkdir -p /var/cache/nginx \
#    && mkdir -p /var/lib/nginx \
    && chown -R webuser:webgroup /var/log/nginx /var/cache/nginx /run/nginx.pid 

USER webuser
CMD nginx
