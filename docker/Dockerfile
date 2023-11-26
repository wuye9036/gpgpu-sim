FROM ubuntu:jammy-20231004

# Set the timezone.
RUN ln -snf /usr/share/zoneinfo/$CONTAINER_TIMEZONE /etc/localtime && echo $CONTAINER_TIMEZONE > /etc/timezone

# Install dependencies
RUN set -xue \
    && apt-get update -y \
    && apt-get install -y git make cmake bison flex doxygen wget python3 python3-pip \
    && apt-get install -y xutils xutils-dev zlib1g-dev libglu1-mesa-dev freeglut3-dev graphviz libxi-dev libxmu-dev libpng-dev \
    && apt-get install -y python-pmw python3-ply python3-numpy  python3-matplotlib \
    && apt-get install -y nvidia-cuda-toolkit

# Install CUDA
RUN set -xue \
    && wget https://developer.download.nvidia.com/compute/cuda/repos/wsl-ubuntu/x86_64/cuda-keyring_1.1-1_all.deb \
    && dpkg -i cuda-keyring_1.1-1_all.deb \
    && apt-get update \
    && apt-get -y install cuda-toolkit-11-8

# Install ZSH
RUN set -xue \
    && apt-get update -y \
    && apt-get install -y zsh sudo openssh-client gdb bear clangd

# Cleanup
RUN rm -rf /var/lib/apt/lists/*

ENV CUDA_INSTALL_PATH=/usr/local/cuda

# Create user
ARG USERNAME=dev
ARG USER_UID=1000
ARG USER_GID=$USER_UID
RUN useradd -rm -d /home/$USERNAME -s /bin/zsh -g root -G sudo -u $USER_UID $USERNAME

# Make user default sudo
RUN echo "$USERNAME ALL=(ALL) NOPASSWD:ALL" | sudo tee /etc/sudoers.d/$USERNAME
USER $USERNAME
WORKDIR /home/$USERNAME
RUN sh -c "$(wget https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh -O -)" \
    && sudo chsh -s /bin/zsh

ADD bootstrap.sh /etc/bootstrap.sh
RUN sudo chown $USERNAME:sudo /etc/bootstrap.sh
RUN chmod 700 /etc/bootstrap.sh
CMD ["/etc/bootstrap.sh", "-d"]