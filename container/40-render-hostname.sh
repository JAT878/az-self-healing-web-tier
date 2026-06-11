set -e

sed "s/__HOSTNAME__/$(hostname)/" \
  /usr/share/nginx/html/index.html.template \
  > /usr/share/nginx/html/index.html
