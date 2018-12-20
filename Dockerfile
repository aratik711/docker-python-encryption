FROM aratik711/python:3.6

ARG HOST_NAME=127.0.0.1
ARG HOST_USERNAME=root
ARG HOST_PASSWORD="root@123"
ARG FILE_PATH="/root/files"
ARG ENCRYPT_PASSWORD=mypass

ENV HOST_NAME=$HOST_NAME
ENV HOST_USERNAME=$HOST_USERNAME
ENV HOST_PASSWORD=$HOST_PASSWORD
ENV FILE_PATH=$FILE_PATH
ENV ENCRYPT_PASSWORD=$ENCRYPT_PASSWORD

COPY git_ranger/ /opt/git_ranger
WORKDIR /opt/git_ranger
COPY entrypoint.sh .
RUN chmod +x /opt/git_ranger/entrypoint.sh

RUN apk add --no-cache sshpass openssh

RUN apk add --no-cache libffi-dev && \
    pip install -r requirements.txt --no-cache-dir && \
    apk del --no-cache .build-deps && \
    python3 manage.py collectstatic --noinput

EXPOSE 8000
VOLUME /opt/git_ranger/media
ENTRYPOINT ["sh", "/opt/git_ranger/entrypoint.sh"]