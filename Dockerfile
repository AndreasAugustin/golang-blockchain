#######################################
# image for dev build environment
######################################
FROM golang:1.16.12-alpine as DEV

ARG USERNAME=dev
ARG USER_UID=1000
ARG USER_GID=1000

# Create the user
RUN addgroup -S -g $USER_GID $USERNAME \
    && adduser -S -D -u $USER_UID -G $USERNAME $USERNAME

# install packages
RUN apk add --update --no-cache bash make git zsh curl tmux

# Make zsh your default shell for tmux
RUN echo "set-option -g default-shell /bin/zsh" >> /home/$USERNAME/.tmux.conf

USER $USER

# install oh-my-zsh
RUN ZSH="/home/$USERNAME/.oh-my-zsh" sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)" \
    && cp /root/.zshrc /home/$USERNAME/.zshrc

WORKDIR /app

#######################################
# image for creating the documentation
######################################

FROM node:21.6.2-alpine as DOCS

# install packages
RUN apk add --update --no-cache bash make git zsh curl tmux

# Make zsh your default shell for tmux
RUN echo "set-option -g default-shell /bin/zsh" >> /root/.tmux.conf

# install oh-my-zsh
RUN sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

# install quality gate
RUN npm install -g markdownlint-cli

WORKDIR /app
