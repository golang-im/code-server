FROM codercom/code-server:3.8.0

USER root 

# RUN chsh -s /bin/bash
# ENV SHELL=/bin/bash
ADD ./.zshrc /home/root/.zshrc

ADD install.sh /tmp/install.sh
RUN /tmp/install.sh

RUN chsh -s /bin/zsh
ENV SHELL=/bin/zsh

ARG GOVERSION=1.15.6

# Install Go.
RUN ARCH="$(uname -m | sed 's/x86_64/amd64/; s/aarch64/arm64/')" && \
    curl -fsSL "https://dl.google.com/go/go$GOVERSION.linux-$ARCH.tar.gz" | tar -C /usr/local -xz

## kubectl
RUN curl -LO https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl && \
    chmod +x ./kubectl && \
    mv ./kubectl /usr/local/bin/kubectl

# kubectx/kubens
RUN git clone https://github.com/ahmetb/kubectx /opt/kubectx && \
    ln -s /opt/kubectx/kubectx /usr/local/bin/kubectx && \
    ln -s /opt/kubectx/kubens /usr/local/bin/kubens 
# spacevim
RUN curl -sLf https://spacevim.org/cn/install.sh | bash



USER 1000

ENV SHELL=/bin/zsh

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


#Install zsh
RUN sudo su && sh -c "$(wget https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh -O -)"
RUN npm install -g spaceship-prompt
ADD ./.zshrc /home/coder/.zshrc
RUN sudo ln -s $HOME/.oh-my-zsh /root/.oh-my-zsh && sudo ln -s $HOME/.zshrc  /root/.zshrc


WORKDIR /home/coder
ENTRYPOINT ["/usr/bin/entrypoint.sh", "--bind-addr", "0.0.0.0:8080", "."]
