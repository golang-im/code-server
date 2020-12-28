FROM codercom/code-server:3.8.0

USER root 

RUN chsh -s /bin/bash
ENV SHELL=/bin/bash


ADD install.sh /tmp/install.sh
RUN /tmp/install.sh

ARG GOVERSION=1.15.6

# Install Go.
RUN ARCH="$(uname -m | sed 's/x86_64/amd64/; s/aarch64/arm64/')" && \
    curl -fsSL "https://dl.google.com/go/go$GOVERSION.linux-$ARCH.tar.gz" | tar -C /usr/local -xz

## kubectl
RUN curl -LO https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl && \
    chmod +x ./kubectl && \
    mv ./kubectl /usr/local/bin/kubectl

# kubectx/kubens/fzf
RUN git clone https://github.com/ahmetb/kubectx /opt/kubectx && \
    ln -s /opt/kubectx/kubectx /usr/local/bin/kubectx && \
    ln -s /opt/kubectx/kubens /usr/local/bin/kubens && \
    git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf && \
    ~/.fzf/install

# spacevim
RUN curl -sLf https://spacevim.org/cn/install.sh | bash

ENV SHELL=/bin/zsh

# install oh-my-zsh
RUN zsh -c "$(wget -O- https://github.com/deluan/zsh-in-docker/releases/download/v1.1.1/zsh-in-docker.sh)" -- \
    -t https://github.com/denysdovhan/spaceship-prompt \
    -a 'SPACESHIP_PROMPT_ADD_NEWLINE="false"' \
    -a 'SPACESHIP_PROMPT_SEPARATE_LINE="false"' \
    -p git \
    -p ssh-agent \
    -p https://github.com/zsh-users/zsh-autosuggestions \
    -p https://github.com/zsh-users/zsh-completions
# RUN git clone https://github.com/denysdovhan/spaceship-prompt.git "$ZSH_CUSTOM/themes/spaceship-prompt" --depth=1 &&\
#     ln -s "$ZSH_CUSTOM/themes/spaceship-prompt/spaceship.zsh-theme" "$ZSH_CUSTOM/themes/spaceship.zsh-theme" 



USER 1000


# install extensions
RUN code-server --install-extension golang.Go && \
    code-server --install-extension MS-CEINTL.vscode-language-pack-zh-hans && \
    code-server --install-extension waderyan.gitblame && \
    code-server --install-extension yzhang.markdown-all-in-one && \
    code-server --install-extension jebbs.plantuml && \
    code-server --install-extension ms-python.python && \
    code-server --install-extension WakaTime.vscode-wakatime && \
    code-server --install-extension bajdzis.vscode-database

ENV GOROOT /usr/local/go
ENV GOPATH /home/coder/work/go
ENV PATH $GOPATH/bin:$GOROOT/bin:$PATH

ADD ./.zshrc /home/coder/.zshrc

WORKDIR /home/coder
ENTRYPOINT ["/usr/bin/entrypoint.sh", "--bind-addr", "0.0.0.0:8080", "."]
