FROM nginx
RUN apt-get update -qq && apt-get -y install apache2-utils
ENV RAILS_ROOT /app
WORKDIR $RAILS_ROOT
RUN mkdir log

COPY ./certs/cert.pem /certs/cert.pem
COPY ./certs/key.pem /certs/key.pem

COPY public public/
COPY nginx.conf /tmp/docker.nginx
RUN envsubst '$RAILS_ROOT' < /tmp/docker.nginx > /etc/nginx/conf.d/default.conf
EXPOSE 80
EXPOSE 443
CMD [ "nginx", "-g", "daemon off;" ]
