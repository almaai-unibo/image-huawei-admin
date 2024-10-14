FROM alpine:latest
RUN apk add --no-cache zsh python3 py3-pip git openssh-client ansible 
# RUN apk add --no-cache zsh uuidgen
RUN ansible-galaxy collection install community.general
RUN echo 'eval $(ssh-agent -s)' >> /root/.zshrc
COPY huawei.ini /root/huawei.ini
ENV USER=gciatto
RUN mkdir /secrets
VOLUME "/secrets"
ENV PASSWORD_FILE="/secrets/password"
ENV PRIVATE_KEY_FILE="/root/.ssh/id_rsa"
RUN echo 'sed -i "s#__USER__#$USER#g" /root/huawei.ini' >> /root/.zshrc
RUN echo 'sed -i "s#__PRIVATE_KEY__#$PRIVATE_KEY_FILE#g" /root/huawei.ini' >> /root/.zshrc
RUN echo 'sed -i "s#__PASSWORD__#$(cat $PASSWORD_FILE)#g" /root/huawei.ini' >> /root/.zshrc
COPY .shell-extensions.sh /root/.shell-extensions.sh
RUN echo 'source .shell-extensions.sh' >> /root/.zshrc
RUN echo 'ssh-add $PRIVATE_KEY_FILE' >> /root/.zshrc
ENV INVENTORY_FILE="/root/huawei.ini"
WORKDIR /root
CMD ["/bin/zsh"]
