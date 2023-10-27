# xcorp_kernel
This is an open source hybrid kernel that was created by [Frost Edson](https://edcorp844.github.io/FrostEdson) under the bachelors degree research in kampala International university in Uganda in 2023. It remains open source unitl further notice..Feel free to use it fro research work and study purposes.

## Install depandencies
* MacOs
```sh
#install homebrew first if you dont have it already installed
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

#THen Install Tools
brew install llvm nasm qemu-system-x86 mtools dosfstools
```
* Linux
  
```sh
# Ubuntu Or Debian:
sudo apt install nasm libgmp3-dev libmpc-dev libmpfr-dev texinfo wget \
                   mtools dosfstools libguestfs-tools qemu-system-x86

## Fedora:
sudo dnf install nasm libgmp3-dev libmpc-dev libmpfr-dev texinfo wget \
                   mtools dosfstools libguestfs-tools qemu-system-x86

# Arch & Arch-based:
paru -S gcc make libgmp-static libmpc mpfr texinfo nasm mtools qemu-system-x86
```
NOTE: to install all the required packages on Arch, you need an [AUR helper](https://wiki.archlinux.org/title/AUR_helpers).

## BUILDING.

```sh
$ git clone "https://github.com/Edcorp844/xcorp_kernel.git" 
$ cd xcorp_kernel
$ chmod +x debug.sh fat.sh run.sh
$ make toolchain
$ make
```
## Running.
```sh
$ ./run.sh
```
## Progress
- [X] Bootloader
- [X] Kernel
- [ ] File System

* Basically We are Still In Progress




