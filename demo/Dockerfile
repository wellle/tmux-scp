# A demo host: sshd with one user, a colored bash prompt and a few files.
# compose.yaml runs it twice, as two hosts with different users and files.
FROM alpine:3.22
RUN apk add --no-cache bash openssh-server openssh-sftp-server \
    && sed -i 's/^#\?PasswordAuthentication.*/PasswordAuthentication no/' /etc/ssh/sshd_config \
    && sed -i 's/^#\?PermitRootLogin.*/PermitRootLogin no/' /etc/ssh/sshd_config
COPY entrypoint.sh /entrypoint.sh
COPY seed.sh /usr/local/bin/demo-seed
EXPOSE 22
ENTRYPOINT ["/entrypoint.sh"]
