FROM ubuntu:14.04
EXPOSE 8000

# Install nginx
RUN apt-get update -q \
    && apt-get install --no-install-recommends --no-install-suggests -y -q \
                        nginx \
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
    && mkdir -p /var/lib/nginx \
    && chown -R webuser:webgroup /var/log/nginx /run/nginx.pid 

USER webuser
CMD nginx
