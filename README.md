## Aewan - multi-layered ascii-art/animation editor

Aewan is a curses-based program that allows for the creation and editing of
ascii art. The native installation packages are customized for integration with
[Asciiville](https://github.com/doctorfree/Asciiville).

The `asciiville-aewan` package gets installed as part of the `Asciiville`
initialization process. See the
[Asciiville README](https://github.com/doctorfree/Asciiville#readme)
for more information.

Many of the [Doctorfree projects](https://github.com/doctorfree) are designed
to integrate with each other including
[Asciiville](https://github.com/doctorfree/Asciiville#readme),
[MirrorCommand](https://github.com/doctorfree/MirrorCommand#readme),
[MusicPlayerPlus](https://github.com/doctorfree/MusicPlayerPlus#readme), and
[RoonCommandLine](https://github.com/doctorfree/RoonCommandLine#readme).

## Table of Contents

1. [Overview](#overview)
1. [Requirements](#requirements)
1. [Installation](#installation)
1. [Removal](#removal)
1. [Quick start](#quick-start)
1. [Asking for help](#asking-for-help)
1. [Building aewan from source](#building-aewan-from-source)
1. [Contributing](#contributing)

## Overview

Aewan is a curses-based program that allows for the creation and
editing of ascii art. The user is able to move the cursor around the screen by
means of the arrow keys and 'paint' characters by pressing the corresponding
keys. There are dialog boxes that allow the user to choose foreground and
background colors, as well as bold and blink attributes. The user may also
select rectangular areas of the canvas in order to move, copy and paste them.
Aewan also supports 'intelligent' horizontal and vertical flipping (e.g.
converts '\' to '/', etc).

What sets Aewan apart from similar projects is the fact that it can work with
multiple layers, and has the ability to turn transparency and visibility on and
off for each layer. A layer dialog is provided through which the user can
change the order of the layers. Thus, each layer can be edited independently in
order to generate a composite drawing. Instead of using the layers for
compositing, it is also possible to use the layers as frames for an animation,
thus enabling the user to create ascii animations with Aewan (note: to be fully
implemented next release).

The file format is easy to parse, so it is easy to write a terminal-based
application that uses the Aewan files to display onscreen. Currently it has
been tested on the Linux terminal, rxvt, xterm, the Cygwin terminal and the
FreeBSD console. Although it is already quite stable (I am already using it on
some projects of mine), it is a little rough on the edges, but that can be
worked out in the near future.

[![License: GPL v2](https://img.shields.io/badge/License-GPLv2-blue.svg)](https://www.gnu.org/licenses/gpl-2.0)

## Requirements

Asciiville-Aewan is compiled and packaged for installation on:

- Arch Linux (x86_64)
- Fedora Linux (x86_64)
- Raspberry Pi OS (armhf)
- Ubuntu Linux (amd64)

## Installation

Asciiville-Aewan v1.0.0 and later can be installed on Linux systems using
the Arch packaging format, the Debian packaging format, or the Red Hat
Package Manager (RPM).

### Supported platforms

Asciiville-Aewan has been tested successfully on the following platforms:

- **Arch Linux 2022.07.01**
    - `asciiville-aewan_<version>-<release>-x86_64.pkg.tar.zst`
- **Ubuntu Linux 20.04**
    - `asciiville-aewan_<version>-<release>.amd64.deb`
- **Fedora Linux 36**
    - `asciiville-aewan_<version>-<release>.x86_64.rpm`
- **Raspberry Pi OS**
    - `asciiville-aewan_<version>-<release>.armhf.deb`

### Debian package installation

Many Linux distributions, most notably Ubuntu and its derivatives, use the
Debian packaging system.

To tell if a Linux system is Debian based it is usually sufficient to
check for the existence of the file `/etc/debian_version` and/or examine the
contents of the file `/etc/os-release`.

To install on a Debian based Linux system, download the latest Debian format
package from the
[asciiville-aewan Releases](https://github.com/doctorfree/asciiville-aewan/releases).

Install the asciiville-aewan package by executing the command

```console
sudo apt install ./asciiville-aewan_<version>-<release>.amd64.deb
```
or
```console
sudo dpkg -i ./asciiville-aewan_<version>-<release>.amd64.deb
```

**NOTE:** In some cases you may see a warning message when installing the
Debian package. The message:

Repository is broken: asciiville-aewan:amd64 (= <version-<release>) has no Size
information can safely be ignored. This is an issue with the Debian packaging
system and has no effect on the installation.

### RPM Package installation

Red Hat Linux, SUSE Linux, and their derivatives use the RPM packaging
format. RPM based Linux distributions include Fedora, AlmaLinux, CentOS,
openSUSE, OpenMandriva, Mandrake Linux, Red Hat Linux, and Oracle Linux.

To install on an RPM based Linux system, download the latest RPM format
package from the
[asciiville-aewan Releases](https://github.com/doctorfree/asciiville-aewan/releases).

Install the asciiville-aewan package by executing the command

```console
sudo yum localinstall ./asciiville-aewan_<version>-<release>.x86_64.rpm
```
or
```console
sudo rpm -i ./asciiville-aewan_<version>-<release>.x86_64.rpm
```

### Arch Package installation

Arch Linux, Manjaro, and other Arch Linux derivatives use the Pacman packaging
format. In addition to Arch Linux, Arch based Linux distributions include
ArchBang, Arch Linux, Artix Linux, ArchLabs, Asahi Linux, BlackArch,
Chakra Linux, EndeavourOS, Frugalware Linux, Garuda Linux,
Hyperbola GNU/Linux-libre, LinHES, Manjaro, Parabola GNU/Linux-libre,
SteamOS, and SystemRescue.

To install on an Arch based Linux system, download the latest Pacman format
package from the
[asciiville-aewan Releases](https://github.com/doctorfree/asciiville-aewan/releases).

Install the asciiville-aewan package by executing the command

```console
sudo pacman -U ./asciiville-aewan_<version>-<release>-x86_64.pkg.tar.zst
```

## Removal

On Debian based Linux systems where the asciiville-aewan package was installed
using the asciiville-aewan Debian format package, remove the asciiville-aewan
package by executing the command:

```console
    sudo apt remove asciiville-aewan
```
or
```console
    sudo dpkg -r asciiville-aewan
```

On RPM based Linux systems where the asciiville-aewan package was installed
using the asciiville-aewan RPM format package, remove the asciiville-aewan
package by executing the command:

```console
    sudo yum remove asciiville-aewan
```
or
```console
    sudo rpm -e asciiville-aewan
```

On Arch based Linux systems where the asciiville-aewan package was installed
using the asciiville-aewan Pacman format package, remove the asciiville-aewan
package by executing the command:

```console
    sudo pacman -Rs asciiville-aewan
```

The asciiville-aewan package can be removed by executing the "Uninstall"
script in the asciiville-aewan source directory:

```console
    git clone https://github.com/doctorfree/asciiville-aewan.git
    cd asciiville-aewan
    ./Uninstall
```

## Building aewan from source

Aewan can be compiled, packaged, and installed from the source code
repository. This should be done as a normal user with `sudo` privileges:

```
# Retrieve the source code from the repository
git clone https://github.com/doctorfree/asciiville-aewan.git
# Enter the asciiville-aewan source directory
cd asciiville-aewan
# Compile the asciiville-aewan components and create an installation package
./mkpkg
# Install asciiville-aewan and its dependencies
./Install
```

These steps are detailed below.

### Clone asciiville-aewan repository

```
git clone https://github.com/doctorfree/asciiville-aewan.git
cd asciiville-aewan
```

**[Note:]** The `mkpkg` script in the top level of the asciiville-aewan
repository can be used to build an installation package on all supported
platforms. After cloning, `cd asciiville-aewan` and `./mkpkg`. The resulting
installation package(s) will be found in `./releases/<version>/`.

### Install packaging dependencies

asciiville-aewan components have packaging dependencies on the following:

On Debian based systems like Ubuntu Linux, install packaging dependencies via:

```
sudo apt install dpkg
```

On RPM based systems like Fedora Linux, install packaging dependencies via:

```
sudo dnf install rpm-build rpm-devel rpmlint rpmdevtools
```

### Build and package asciiville-aewan

To build and package asciiville-aewan, execute the command:

```
./mkpkg
```

On Debian based systems like Ubuntu Linux, the `mkpkg` scripts executes
`scripts/mkdeb.sh`.

On RPM based systems like Fedora Linux, the `mkpkg` scripts executes
`scripts/mkrpm.sh`.

On PKGBUILD based systems like Arch Linux, the `mkpkg` scripts executes
`scripts/mkaur.sh`.

### Install asciiville-aewan from source build

After successfully building and packaging asciiville-aewan with either
`./mkpkg`, install the asciiville-aewan package with the command:

```
./Install
```

## Contributing

There are a variety of ways to contribute to the asciiville-aewan project.
All forms of contribution are appreciated and valuable. Also, it's fun to
collaborate. Here are a few ways to contribute to the further improvement
and evolution of asciiville-aewan:

### Testing and Issue Reporting

asciiville-aewan is fairly complex with many components, features, options,
configurations, and use cases. Although currently only supported on
Linux platforms, there are a plethora of Linux platforms on which
asciiville-aewan can be deployed. Testing all of the above is time consuming
and tedious. If you have a Linux platform on which you can install
asciiville-aewan and you have the time and will to put it through its paces,
then issue reports on problems you encounter would greatly help improve the
robustness and quality of asciiville-aewan. Open issue reports at
[https://github.com/doctorfree/asciiville-aewan/issues](https://github.com/doctorfree/asciiville-aewan/issues)

### Sponsor asciiville-aewan

asciiville-aewan is completely free and open source software. All of the
asciiville-aewan components are freely licensed and may be copied, modified,
and redistributed freely. Nobody gets paid, nobody is making any money,
it's a project fully motivated by curiousity and love of music. However,
it does take some money to procure development and testing resources.
Right now asciiville-aewan needs a multi-boot test platform to extend support
to a wider variety of Linux platforms and potentially Mac OS X.

If you have the means and you would like to sponsor asciiville-aewan development,
testing, platform support, and continued improvement then your monetary
support could play a very critical role. A little bit goes a long way
in asciiville-aewan. For example, a bootable USB SSD device could serve as a 
means of porting and testing support for additional platforms. Or, a
decent cup of coffee could be the difference between a bug filled
release and a glorious musical adventure.

Sponsor the asciiville-aewan project at
[https://github.com/sponsors/doctorfree](https://github.com/sponsors/doctorfree)

### Contribute to Development

If you have programming skills and find the management and ease-of-use of
digital music libraries to be an interesting area, you can contribute to
asciiville-aewan development through the standard Github "fork, clone,
pull request" process. There are many guides to contributing to Github hosted
open source projects on the Internet. A good one is available at
[https://www.dataschool.io/how-to-contribute-on-github/](https://www.dataschool.io/how-to-contribute-on-github/). Another short succinct guide is at
[https://gist.github.com/MarcDiethelm/7303312](https://gist.github.com/MarcDiethelm/7303312).

Once you have forked and cloned the asciiville-aewan repository, it's time to
setup a development environment. Although many of the asciiville-aewan commands
are Bash shell scripts, there are also applicatons written in C and C++ along
with documentation in Markdown format, configuration files in a variety of
formats, examples, screenshots, video demos, build scripts, packaging, and more.

To compile `asciiville-aewan` from source, run the command:

```
./build aewan
```

On Debian (e.g. Ubuntu), PKGBUILD (e.g. Arch) and RPM (e.g. Fedora) based
systems the asciiville-aewan installation package can be created with the
`mkpkg` scripts. The `mkpkg` script determines which platform it is on
and executes the appropriate build and packaging script in the `scripts/`
directory. These scripts invoke the build scripts for each of the projects
included with asciiville-aewan, populate a distribution tree, and call the
respective packaging utilities. Packages are saved in the
`./releases/<version>/` folder. Once a package has been created
it can be installed with the `Install` script.

It's not necessary to have C/C++ expertise to contribute to asciiville-aewan
development. Many of the asciiville-aewan commands are Bash scripts and require
no compilaton. Script commands reside in the `bin` and `share/scripts`
directories. To modify a shell script, install asciiville-aewan and edit the
`bin/<script>` or `share/scripts/<script.sh>` you wish to improve.
After making your changes simply copy the revised script to `/usr/bin`
or `/usr/share/asciiville-aewan/scripts` and test your changes.

Feel free to email me at github@ronrecord.com with questions or comments.

