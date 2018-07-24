docker run -d \
    -v ${PWD}/nginx.conf:/etc/nginx/nginx.conf \
    -v ~/keys:/opt/nginx/keys \
    -v ${PWD}:/var/lib/nginx/html \
    -p 80:80 \
    -p 443:443 \
    --name nginx \
    blacklabelops/nginx
