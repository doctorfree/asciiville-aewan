Aewan is a multi-layered ascii-art/animation editor.

**[Important Note:]** This initial release of the `asciiville-aewan` package is intended to serve as a test release for future integration with `Asciiville`. Integration with Asciiville is still in development and will not be available until Asciiville version 2 is released. To get the fully integrated features of `asciiville-aewan` at this time, install [Asciiville version 1](https://github.com/doctorfree/Asciiville/releases) rather than this package.

This release of asciiville-aewan adds support for:

* Installation as a separate standalone package on multiple platforms
* Create packaging for Arch Linux, Fedora, Ubuntu, and Raspberry Pi OS
* Integrated features and customizations from Asciiville
* Ported to Arch Linux

## Installation

Download the [latest Debian, Arch, or RPM package format release](https://github.com/doctorfree/asciiville-aewan/releases) for your platform.

Install the package on Debian based systems by executing the command:

```bash
sudo apt install ./asciiville-aewan_1.0.0-1.amd64.deb
```

or, on a Raspberry Pi:

```bash
sudo apt install ./asciiville-aewan_1.0.0-1.armhf.deb
```

Install the package on Arch Linux based systems by executing the command:

```bash
sudo pacman -U ./asciiville-aewan-v1.0.0r1-1-x86_64.pkg.tar.zst
```

Install the package on RPM based systems by executing the following command:

On Fedora Linux:

```bash
sudo yum localinstall ./asciiville-aewan_1.0.0-1.fc36.x86_64.rpm
```

### PKGBUILD Installation

To rebuild this package from sources on Arch Linux, extract `asciiville-aewan-pkgbuild-1.0.0-1.tar.gz` and use the `makepkg` command to download the sources, build the binaries, and create the installation package:

```
tar xzf asciiville-aewan-pkgbuild-1.0.0-1.tar.gz
cd asciiville-aewan
makepkg --force --log --cleanbuild --noconfirm --syncdeps
```

## Removal

Removal of the package on Debian based systems can be accomplished by issuing the command:

```bash
sudo apt remove asciiville-aewan
```

Removal of the package on RPM based systems can be accomplished by issuing the command:

```bash
sudo yum remove asciiville-aewan
```

Removal of the package on Arch Linux based systems can be accomplished by issuing the command:

```bash
sudo pacman -Rs asciiville-aewan
```

## Building asciiville-aewan from source

asciiville-aewan can be compiled, packaged, and installed from the source code repository. This should be done as a normal user with `sudo` privileges:

```
# Retrieve the source code from the repository
git clone https://github.com/doctorfree/asciiville-aewan.git
# Enter the asciiville-aewan source directory
cd asciiville-aewan
# Compile asciiville-aewan and create an installation package
./mkpkg
# Install asciiville-aewan and its dependencies
./Install
```

The `mkpkg` script detects the platform and creates an installable package in the package format native to that platform. After successfully building asciiville-aewan, the resulting installable package will be found in the `./releases/<version>/` directory.

## Changelog

Changes in version 1.0.0 release 1 include:

* Installation as a separate standalone package on multiple platforms
* Integrated features and customizations from Asciiville
* Create packaging for Arch Linux, Fedora, Ubuntu, and Raspberry Pi OS
* Ported to Arch Linux

See [CHANGELOG](https://github.com/doctorfree/asciiville-aewan/blob/master/CHANGELOG) for a full list of changes in every asciiville-aewan release
