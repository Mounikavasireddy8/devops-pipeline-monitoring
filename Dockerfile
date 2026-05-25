FROM nginx:1.25-alpine

RUN addgroup -S appgroup && \
    adduser -S appuser -G appgroup

RUN mkdir -p /var/cache/nginx/client_temp \
             /var/cache/nginx/proxy_temp \
             /var/cache/nginx/fastcgi_temp \
             /var/cache/nginx/uwsgi_temp \
             /var/cache/nginx/scgi_temp && \
    chown -R appuser:appgroup /var/cache/nginx && \
    chown -R appuser:appgroup /var/log/nginx && \
    chown -R appuser:appgroup /etc/nginx/conf.d && \
    touch /var/run/nginx.pid && \
    chown appuser:appgroup /var/run/nginx.pid

WORKDIR /usr/share/nginx/html

COPY app/index.html .
COPY nginx.conf /etc/nginx/conf.d/default.conf

RUN chown -R appuser:appgroup /usr/share/nginx/html

USER appuser

ENV APP_NAME=DevOpsPipeline
ENV APP_VERSION=1.0
ENV ENVIRONMENT=production

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]