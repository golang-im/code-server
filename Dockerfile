FROM codercom/code-server:3.8.0

USER root 

# Golang
COPY --from=golang /usr/local/go /usr/local/go
COPY install.sh .
RUN  ./install.sh

# ## kubectl
# RUN curl -LO https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl && \
#     chmod +x ./kubectl && \
#     mv ./kubectl /usr/local/bin/kubectl

# kubectx/kubens/fzf
RUN git clone https://github.com/ahmetb/kubectx /opt/kubectx && \
    ln -s /opt/kubectx/kubectx /usr/local/bin/kubectx && \
    ln -s /opt/kubectx/kubens /usr/local/bin/kubens && \
    git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf && \
    ~/.fzf/install


USER 1000

ENV GOROOT /usr/local/go
ENV GOPATH /home/coder/work/go
ENV PATH $GOPATH/bin:$GOROOT/bin:$PATH


WORKDIR /home/coder
ENTRYPOINT ["/usr/bin/entrypoint.sh", "--bind-addr", "0.0.0.0:8080", "."]