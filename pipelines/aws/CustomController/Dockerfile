FROM neotys/neoload-controller

# https://github.com/Neotys-Labs/Docker/blob/master/neoload-controller/Dockerfile

USER root
RUN apk update && apk add --no-cache git

USER neoload

ENTRYPOINT ["/bin/sh", "/home/neoload/entrypoint.sh"]
