# Static welcome page for the self-healing web tier, served by NGINX.
#
# Build:
#   docker build -t webtier-nginx ./container
#
# Run:
#   docker run --rm -p 8080:80 webtier-nginx
FROM nginx:1.27-alpine

COPY index.html /usr/share/nginx/html/index.html.template
COPY 40-render-hostname.sh /docker-entrypoint.d/40-render-hostname.sh
RUN chmod +x /docker-entrypoint.d/40-render-hostname.sh

EXPOSE 80
