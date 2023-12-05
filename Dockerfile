FROM ubuntu:latest

ENV DEBIAN_FRONTEND=noninteractive
# timezone setting
RUN apt-get update
RUN apt-get install -y tzdata
ENV TZ=Asia/Tokyo
RUN apt install -y make gawk curl git vim zsh sudo

# Uninstall all conflicting packages:
RUN for pkg in docker.io docker-doc docker-compose docker-compose-v2 podman-docker containerd runc; do sudo apt-get remove -y $pkg; done

# Add Docker's official GPG key:
RUN apt-get update
RUN apt-get install -y ca-certificates curl gnupg
RUN install -m 0755 -d /etc/apt/keyrings
RUN curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg
RUN chmod a+r /etc/apt/keyrings/docker.gpg

# Add the repository to Apt sources:
RUN echo \
    "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
    $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | tee /etc/apt/sources.list.d/docker.list
RUN apt-get update

# Install the latest version, run:
RUN apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin


RUN cd /root && git clone --verbose https://github.com/k5-mot/dotfiles.git && cd dotfiles && make install
# RUN docker run hello-world
# zshの実行
RUN bash
RUN zsh

# 環境変数の設定
ENV SHELL /usr/bin/zsh

RUN sed -i.bak "s|$HOME:|$HOME:$SHELL|" /etc/passwd

CMD ["/usr/bin/zsh","-l"]