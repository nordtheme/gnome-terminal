<p align="center"><img src="https://cdn.rawgit.com/arcticicestudio/nord-gnome-terminal/develop/assets/nord-gnome-terminal-banner.svg"/></p>

<p align="center"><a href="https://github.com/arcticicestudio/nord-gnome-terminal/releases/latest"><img src="https://img.shields.io/github/v/release/arcticicestudio/nord-gnome-terminal.svg?style=flat-square&color=88C0D0&label=Release"/></a> <a href="https://github.com/arcticicestudio/nord/releases/tag/v0.2.0"><img src="https://img.shields.io/badge/Nord-v0.2.0-88C0D0.svg?style=flat-square"/></a></p>

<p align="center">An arctic, north-bluish clean and elegant <a href="https://wiki.gnome.org/Apps/Terminal">GNOME Terminal</a> color theme.</p>

<p align="center">Designed for a fluent and clear workflow.<br>
Based on the <a href="https://github.com/arcticicestudio/nord">Nord</a> color palette.</p>

---

<p align="center"><img src="https://raw.githubusercontent.com/arcticicestudio/nord-gnome-terminal/develop/assets/scrot-colortest.png"/><blockquote>Font: <a href="https://adobe-fonts.github.io/source-code-pro">Source Code Pro</a> 12px.</blockquote></p>

## Getting started

### Requirements

The installation script requires [`dconf`][dconf] and `uuidgen` ([`util-linux`][util-linux]) to be available on your *PATH* to create a new profile and generate a random profile UUID.

Some distributions may require additional package(s):

* `dconf-tools` - transitional package for `dconf-cli` and `dconf-editor` ([Debian][debian-dconf-tools], [Mint][mint-dconf-tools], [Ubuntu][ubuntu-dconf-tools])
* `dconf-gsettings-backend` to ensure *GSettings* compatibility ([Debian][debian-dconf-gsettings-backend], [Mint][mint-dconf-gsettings-backend], [Ubuntu][ubuntu-dconf-gsettings-backend])
* `dconf-cli` to ensure full CLI support ([Debian][debian-dconf-cli], [Mint][mint-dconf-cli], [Ubuntu][ubuntu-dconf-cli])
* `dconf-service`  to ensure D-Bus support for the *GSettings* backend ([Debian][debian-dconf-service], [Mint][mint-dconf-service], [Ubuntu][ubuntu-dconf-service])
* `uuid-runtime` to provide runtime components for the Universally Unique ID library ([Debian][debian-uuid-runtime], [Mint][mint-uuid-runtime], [Ubuntu][ubuntu-uuid-runtime])

The packages should be available for all distributions using the GNOME Terminal by default.

### Installation



1. Clone this repository 
    ```sh
    git clone https://github.com/arcticicestudio/nord-gnome-terminal.git
    cd nord-gnome-terminal/src
    ```

2. Run the [`nord.sh`](https://github.com/arcticicestudio/nord-gnome-terminal/blob/develop/src/nord.sh) shell script to start the automated installation.

A list of available options can be shown with `-h`, `--help`.

```sh
./nord.sh --help
```

**Usage**: `nord.sh [OPTIONS]`

* `-h`, `--help` - Shows the help
* `-l`, `--loglevel <LOG_LEVEL>`, `--loglevel=<LOG_LEVEL>` - Set the log level
  * `0` *ERROR*
  * `1` *WARNING*
  * `2` *SUCCESS* (default)
  * `3` *INFO*
  * `4` *DEBUG*
* `-p`, `--profile <PROFILE_NAME>`, `--profile=<PROFILE_NAME>` - The name of the profile to install the theme to. If not specified a new profile as clone of the *default* profile will be created.

<!-- TODO: It will create a `Nord` GNOME Terminal profile. -->

### Profile Handling

The script detects available profiles and

* **clones the default profile if no specific profile has been specified** - this ensures that no custom profile colors are overriden
* **allows to install the theme for a specific profile** - the name of the profile the theme should be installed to can be passed using the `-p`/`--profile` option
* **handles already existing Nord profiles via version comparison** - if the *Nord* profile already exists and the script version is less than the installed version a confirmation is shown whether to override the theme of abort the installation, otherwise the profile will be
  * **updated** if the script version is **greater than** the installed version
  * **reinstalled** if the installed version is **equal to** the script version

### Log Level

The script provides a `-l`/`--loglevel` option to allow to define the log level. Available levels are

* `0` *ERROR* - The script will run in *silent mode*, only error messages are shown
* `1` *WARNING* - Shows *warning* messages
* `2` *SUCCESS* (default) - Shows *success* messages
* `3` *INFO* - Shows additional *information* messages
* `4` *DEBUG* - Runs the script in *debug mode* showing additional debug messages

### Activation

#### Set as default profile
  1. Open the *Preferences*
  2. Switch to the *Profiles* tab
  3. Select `Nord` from the drop-down menu labeled with *Profile used when launching a new terminal*

![][scrot-readme-default-profile]

#### Lazy profile change
  1. Right-click anywhere inside the terminal window to open the context menu
  2. Hover over *Profiles* and select `Nord`

![][scrot-readme-lazy-profile-change]

## Screenshots
<p align="center"><strong>htop</strong><br><img src="https://raw.githubusercontent.com/arcticicestudio/nord-gnome-terminal/develop/assets/scrot-htop.png"/></p>

## Development
[![](https://img.shields.io/badge/Changelog-0.1.0-81A1C1.svg?style=flat-square)](https://github.com/arcticicestudio/nord-gnome-terminal/blob/v0.1.0/CHANGELOG.md) [![](https://img.shields.io/badge/Workflow-gitflow--branching--model-81A1C1.svg?style=flat-square)](http://nvie.com/posts/a-successful-git-branching-model) [![](https://img.shields.io/badge/Versioning-ArcVer_0.8.0-81A1C1.svg?style=flat-square)](https://github.com/arcticicestudio/arcver)

### Contribution
Please report issues/bugs, feature requests and suggestions for improvements to the [issue tracker](https://github.com/arcticicestudio/nord-gnome-terminal/issues).

<p align="center"><img src="https://raw.githubusercontent.com/arcticicestudio/nord-docs/develop/assets/images/nord/repository-footer-separator.svg?sanitize=true" /></p>

<p align="center">Copyright &copy; 2016-present Arctic Ice Studio</p>

<p align="center"><a href="https://github.com/arcticicestudio/nord-gnome-terminal/blob/develop/LICENSE.md"><img src="https://img.shields.io/badge/License-MIT-5E81AC.svg?style=flat-square"/></a> <a href="https://creativecommons.org/licenses/by-sa/4.0"><img src="https://img.shields.io/badge/License-CC_BY--SA_4.0-5E81AC.svg?style=flat-square"/></a></p>

[dconf]: https://wiki.gnome.org/Projects/dconf
[debian-dconf-cli]: https://packages.debian.org/search?keywords=dconf-cli
[debian-dconf-gsettings-backend]: https://packages.debian.org/search?keywords=dconf-gsettings-backend
[debian-dconf-service]: https://packages.debian.org/search?keywords=dconf-service
[debian-dconf-tools]: https://packages.debian.org/search?keywords=dconf-tools
[debian-uuid-runtime]: https://packages.debian.org/search?keywords=uuid-runtime
[mint-dconf-cli]: https://community.linuxmint.com/software/view/dconf-cli
[mint-dconf-gsettings-backend]: https://community.linuxmint.com/software/view/dconf-gsettings-backend
[mint-dconf-service]: https://community.linuxmint.com/software/view/dconf-service
[mint-dconf-tools]: https://community.linuxmint.com/software/view/dconf-tools
[mint-uuid-runtime]: https://community.linuxmint.com/software/view/uuid-runtime
[scrot-readme-default-profile]: https://raw.githubusercontent.com/arcticicestudio/nord-gnome-terminal/develop/assets/scrot-readme-default-profile.png
[scrot-readme-lazy-profile-change]: https://raw.githubusercontent.com/arcticicestudio/nord-gnome-terminal/develop/assets/scrot-readme-lazy-profile-change.png
[ubuntu-dconf-cli]: https://packages.ubuntu.com/search?keywords=dconf-cli
[ubuntu-dconf-gsettings-backend]: https://packages.ubuntu.com/search?keywords=dconf-gsettings-backend
[ubuntu-dconf-service]: https://packages.ubuntu.com/search?keywords=dconf-service
[ubuntu-dconf-tools]: https://packages.ubuntu.com/search?keywords=dconf-tools
[ubuntu-uuid-runtime]: https://packages.ubuntu.com/search?keywords=uuid-runtime
[util-linux]: https://www.kernel.org/pub/linux/utils/util-linux
