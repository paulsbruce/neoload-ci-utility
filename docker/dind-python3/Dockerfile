FROM docker:dind

RUN apk add --update --no-cache py-pip py3-setuptools

RUN python3 --version

RUN python3 -m pip install neoload
RUN neoload --help
