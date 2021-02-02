FROM neotys/neoload-controller

# https://github.com/Neotys-Labs/Docker/blob/master/neoload-controller/Dockerfile

USER root
RUN apk add --update --no-cache g++ gcc libxml2-dev libxslt-dev python3-dev libffi-dev openssl-dev make

RUN apk update && apk add --no-cache git

RUN apk add -q jq curl

RUN mkdir /opt/neoload
WORKDIR /opt/neoload
ADD "https://www.random.org/cgi-bin/randbyte?nbytes=10&format=h" skipcache
RUN git clone --single-branch --branch add_fastfail_custom_cmd https://github.com/Neotys-Labs/neoload-cli.git
RUN cd neoload-cli && python3 -m pip install .

USER neoload

RUN neoload --version

ENTRYPOINT ["/bin/sh", "/home/neoload/entrypoint.sh"]
