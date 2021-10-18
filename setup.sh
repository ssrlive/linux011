#!/bin/bash
export OSLAB_PATH=$(cd $(dirname "${BASH_SOURCE[0]}") >/dev/null && pwd)

debianSetup() {
    sudo dpkg --add-architecture i386
    sudo apt update
    sudo apt-get install -y binutils curl
    sudo apt-get install -y binutils-common
    sudo apt-get install -y build-essential bin86 manpages-dev libc6-dev-i386 zlib1g:i386 libncurses5:i386 libsm-dev:i386 libx11-dev:i386 libxpm-dev:i386 libexpat1:i386

    sudo apt-get install -y libncurses5
    curl -L http://cz.archive.ubuntu.com/ubuntu/pool/main/r/readline/libreadline7_7.0-3_amd64.deb -o /tmp/libreadline.deb
    sudo dpkg -i /tmp/libreadline.deb

    cp ${OSLAB_PATH}/gcc-3.4-ubuntu.tar.gz /tmp
    tar zxvf /tmp/gcc-3.4-ubuntu.tar.gz -C /tmp/
    cd /tmp/gcc-3.4
    sudo ./inst.sh amd64
    cd ${OSLAB_PATH}
    ${OSLAB_PATH}/reset.sh
}

archSetup() {
    echo "Please make sure you've added the archlinuxcn source!(Y or n)"
    read res
    if [ $res = "N" -o $res = "n" ]; then
        echo "Please add archlinuxcn source first!"
    else
        sudo pacman -U *.pkg.tar.xz
        sudo pacman -S gcc bin86 base-devel lib32-ncurses5-compat-libs
        ${OSLAB_PATH}/reset.sh
    fi
}

function main() {
    if [ $# -lt 1 ]; then
        echo "Please add your distro name(debian, archlinux) as the first argument!"
    elif [ $1 = "debian" ]; then
        debianSetup
    elif [ $1 = "archlinux" ]; then
        archSetup
    else
        echo "This distro is not supported!(debian and archlinux is supported at present)"
    fi
}

main $@
