if [ $# -eq 0 ]
  then
    echo "Please specify your Linux/MacOS redist: (u)buntu, Open(s)USE, (c)entOS, (w)SL-Ubuntu, (m)acOS."
    exit 1
fi

if [ $# -eq 2 ]
  then
    SUDO=sudo
fi

if ["$1" -eq "u"]
  then
    PACKAGE_UPDATE="apt-get update -y"
    PACKAGE_INSTALL="apt-get install -y"
elif ["$1" -eq "s"]
  then
    PACKAGE_UPDATE="yum update -y"
    PACKAGE_INSTALL="yum install -y"
elif ["$1" -eq "c"]
  then
    PACKAGE_UPDATE="yum update -y"
    PACKAGE_INSTALL="yum install -y"
elif ["$1" -eq "w"]
  then
    PACKAGE_UPDATE="apt-get update -y"
    PACKAGE_INSTALL="apt-get install -y"
elif ["$1" -eq "m"]
  then
    PACKAGE_UPDATE="brew update -y"
    PACKAGE_INSTALL="brew install -y"
else
    echo "Unsupported OS redist."
fi 

PACKAGE_UPDATE="$SUDO $PACKAGE_UPDATE"
PACKAGE_INSTALL="$SUDO $PACKAGE_INSTALL"

eval "$PACKAGE_UPDATE"
eval "$PACKAGE_INSTALL git make cmake bison flex doxygen wget python3 python3-pip"
eval "$PACKAGE_INSTALL xutils xutils-dev zlib1g-dev libglu1-mesa-dev freeglut3-dev graphviz libxi-dev libxmu-dev libpng-dev"
eval "$PACKAGE_INSTALL python-pmw python3-ply python3-numpy  python3-matplotlib"

# Install CUDA
if [ "$1" -eq "w" ]
  then
    wget https://developer.download.nvidia.com/compute/cuda/repos/wsl-ubuntu/x86_64/cuda-keyring_1.0-1_all.deb
    eval "$SUDO -i cuda-keyring_1.0-1_all.deb"
    eval "$PACKAGE_UPDATE"
    eval "$PACKAGE_INSTALL cuda"
elif [ "$1" -eq "u" ]
  then
    wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2204/x86_64/cuda-keyring_1.0-1_all.deb
    eval "$SUDO dpkg -i cuda-keyring_1.0-1_all.deb"
    eval "$PACKAGE_UPDATE"
    eval "$PACKAGE_INSTALL cuda"
else
  echo "Installation routine on selected OS is not supported yet. Please install CUDA manually."
fi

eval "$PACKAGE_INSTALL zsh gdb bear clangdb"

sh -c "$(wget https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh -O -)"
eval "$SUDO chsh -s /bin/zsh"
echo "CUDA_INSTALL_PATH=/usr/local/cuda" >> /.zshrc
