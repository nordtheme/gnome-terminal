#!/usr/bin/env bash
# Copyright (c) 2016-present Arctic Ice Studio <development@arcticicestudio.com>
# Copyright (c) 2016-present Sven Greb <code@svengreb.de>

# Project:    Nord GNOME Terminal
# Repository: https://github.com/arcticicestudio/nord-gnome-terminal
# License:    MIT

set -e

# Appends the given profile UUID to the profile list.
#
# @param $1 the UUID to be appended
# @return none
# @since 0.2.0
append_profile_uuid_to_list() {
  local uuid list
  uuid="$1"
  list=$(gsettings get "$GSETTINGS_PROFILELIST_PATH" list)
  gsettings set "$GSETTINGS_PROFILELIST_PATH" list "${list%]*}, '$uuid']"
}

# Writes the Nord GNOME Terminal theme colors and configurations as dconf key-value pairs to the target profile.
#
# @globread profile_name
# @return none
# @since 0.2.0
apply() {
  local \
    nord0="#2E3440" \
    nord1="#3B4252" \
    nord3="#4C566A" \
    nord4="#D8DEE9" \
    nord5="#E5E9F0" \
    nord6="#ECEFF4" \
    nord7="#8FBCBB" \
    nord8="#88C0D0" \
    nord9="#81A1C1" \
    nord11="#BF616A" \
    nord13="#EBCB8B" \
    nord14="#A3BE8C" \
    nord15="#B48EAD"
  local \
    nord0_rgb="rgb(46,52,64)"
    nord1_rgb="rgb(59,66,82)"
    nord4_rgb="rgb(216,222,233)"
    nord8_rgb="rgb(136,192,208)"

  _write palette "['$nord1', '$nord11', '$nord14', '$nord13', '$nord9', '$nord15', '$nord8', '$nord5', '$nord3', '$nord11', '$nord14', '$nord13', '$nord9', '$nord15', '$nord7', '$nord6']"
  log 4 "Applied Nord color palette"

  _write background-color "'$nord0'"
  _write foreground-color "'$nord4'"
  _write use-transparent-background "false"
  log 4 "Applied background- and foreground colors"

  _write bold-color "'$nord4'"
  _write bold-color-same-as-fg "true"
  log 4 "Applied bold color and configuration"

  _write use-theme-colors "false"
  _write use-theme-background "false"
  _write use-theme-transparency "false"
  log 4 "Applied system theme compability configuration"

  _write cursor-colors-set "true"
  _write cursor-foreground-color "'$nord1_rgb'"
  _write cursor-background-color "'$nord4_rgb'"
  log 4 "Applied cursor colors and configuration"

  _write highlight-colors-set "true"
  _write highlight-foreground-color "'$nord0_rgb'"
  _write highlight-background-color "'$nord8_rgb'"
  log 4 "Applied highlight colors and configuration"

  _write highlight-colors-set "true"
  _write highlight-foreground-color "'$nord0_rgb'"
  _write highlight-background-color "'$nord8_rgb'"
  log 4 "Applied highlight colors and configuration"

  _write "$NORD_GNOME_TERMINAL_VERSION_DCONF_KEY" "'$NORD_GNOME_TERMINAL_VERSION'"
  log 4 "Set Nord GNOME Terminal version key of the '$profile_name' profile"

  log 3 "Applied theme colors and configurations"
}

# Applies the Nord GNOME Terminal theme with version comparison.
#
# @param $1 the version string to compare against
# @return none
# @since 0.2.0
apply_version_compared() {
  local version
  version=$1
  case "$(vercomp "$NORD_GNOME_TERMINAL_VERSION" "$version"; echo $?)" in
    0)
      log 3 "Reinstalling Nord GNOME Terminal since the version equaled the version of the '$profile_name' profile!";
      apply;
      log 2 "Reinstalled Nord GNOME Terminal version $NORD_GNOME_TERMINAL_VERSION for the '$profile_name' profile!";
      exit 0;;
    1)
      log 4 "The script version is newer than the currently installed theme ($NORD_GNOME_TERMINAL_VERSION > $version)"
      apply;
      log 2 "The '$profile_name' profile has been updated successfully from version $version to $NORD_GNOME_TERMINAL_VERSION";
      exit 0;;
    2)
      log 1 "The detected Nord GNOME Terminal version $version of the '$profile_name' profile is greater than the version that will be applied!";
      printf "${_ctb}> [?]${_ct} Override current profile version %s with script version %s? (${_ctb}y${_cr}/${_ctb}n${_cr})" "$version" "$NORD_GNOME_TERMINAL_VERSION"
      read -r -n 1 -s confirmation;
      echo
      case $confirmation in
        [Yy]* )
          apply;
          log 2 "Nord GNOME Terminal version $NORD_GNOME_TERMINAL_VERSION has been successfully applied!";
          exit 0;;
        [Nn]* )
          log 0 "Installation canceled by user!";
          exit 1;;
        * )
          log 0 "'$confirmation' is not a valid input!";
          exit 1;;
      esac
  esac
}

# Checks the GNOME Terminal version for the required migration compability (>= 3.8).
#
# @globwrite gnome_terminal_version
# @return 0 if the version is compatible (>= 3.8), 1 otherwise
# @since 0.2.0
check_migrated_version_comp() {
  gnome_terminal_version="$(expr "$(LANGUAGE=en_US.UTF-8 gnome-terminal --version)" : '^[^[:digit:]]* \(\([[:digit:]]*\.*\)*\)')"
  if [[ ("$(echo "$gnome_terminal_version" | cut -d"." -f1)" = "3" && \
         "$(echo "$gnome_terminal_version" | cut -d"." -f2)" -ge 8) || \
         "$(echo "$gnome_terminal_version" | cut -d"." -f1)" -ge 4 ]]; then
    log 3 "Detected compatible GNOME Terminal version $gnome_terminal_version (>= 3.8 dconf migrated)"
    return 0
  else
    log 1 "Detected incompatible GNOME Terminal version $gnome_terminal_version (< 3.8)"
    return 1
  fi
}

# Cleans up the script execution by unsetting declared functions and variables.
#
# @return none
# @since 0.2.0
cleanup() {
  log 4 "Cleaning up script execution by unsetting declared functions and variables"
  unset -v _cr _ct _ctb _ct_highlight _ct_primary _ctb_error _ctb_highlight _ctb_primary _ctb_success _ctb_warning
  unset -v NORD_GNOME_TERMINAL_SCRIPT_OPTS NORD_GNOME_TERMINAL_VERSION NORD_GNOME_TERMINAL_VERSION_DCONF_KEY NORD_PROFILE_VISIBLE_NAME log_level DEPENDENCIES DCONF_PROFILE_BASE_PATH GSETTINGS_PROFILELIST_PATH gnome_terminal_version profile_name profile_uuid
  unset -f append_profile_uuid_to_list apply check_migrated_version_comp cleanup clone_default_profile get_profiles get_profile_uuid_by_name log print_help validate_dependencies vercomp _write
}

# Clones the default profile, generates and saves the new UUID and adds it to the profile list.
#
# @globwrite profile_uuid
# @since 0.2.0
clone_default_profile() {
  local uuid
  uuid="$(gsettings get "$GSETTINGS_PROFILELIST_PATH" default | tr -d \')"
  profile_uuid="$(uuidgen)"
  dconf dump "$DCONF_PROFILE_BASE_PATH"/:"$uuid"/ | dconf load "$DCONF_PROFILE_BASE_PATH"/:"$profile_uuid"/
  dconf write "$DCONF_PROFILE_BASE_PATH"/:"$profile_uuid"/visible-name "'$NORD_PROFILE_VISIBLE_NAME'"
  append_profile_uuid_to_list "$profile_uuid"
  log 3 "Cloned the default profile '$uuid' with new UUID '$profile_uuid'"
}

# Gets the current Nord GNOME Terminal version.
#
# @globread NORD_GNOME_TERMINAL_VERSION_DCONF_KEY DCONF_PROFILE_BASE_PATH
# @param $1 the UUID of the profile to check
# @since 0.2.0
get_current_version() {
  local uuid version
  uuid=$1
  version=
  printf "$(dconf read $DCONF_PROFILE_BASE_PATH/:"$uuid"/$NORD_GNOME_TERMINAL_VERSION_DCONF_KEY | tr -d "'")"
  return 0
}

# Gets the available GNOME Terminal profiles.
#
# @globwrite profiles
# @return none
# @since 0.2.0
get_profiles() {
  profiles=($(gsettings get "$GSETTINGS_PROFILELIST_PATH" list | tr -d "[]\',"))
  log 3 "Available profile UUIDs: ${profiles[*]}"
}

# Gets the UUID for the given profile name.
#
# @param $1 the name of the profile to get the UUID from
# @return the UUID of the profile, none otherwise
# @since 0.2.0
get_profile_uuid_by_name() {
  local name=$1
  for idx in "${!profiles[@]}"; do
    if [[ "$(dconf read "$DCONF_PROFILE_BASE_PATH"/:"${profiles[idx]}"/visible-name)" == "'$name'" ]]; then
      printf "%s" "${profiles[idx]}"
      return 0
    fi
  done
}

# Prints a message with a prefixed label to STDOUT/STDERR for the given log level.
#
# When no log level is specified, "DEFAULT" is used.
# The minimum log level is defined by the "log_level" global.
#
# Log Levels:
#   0 ERROR
#   1 WARNING
#   2 SUCCESS
#   3 INFO
#   4 DEBUG
#
# @globread
#   log_level
#   _cr
#   _ct
#   _ctb
#   _ctb_error
#   _ctb_highlight
#   _ctb_primary
#   _ctb_success
#   _ctb_warning
# @return none
# @since 0.2.0
log () {
  declare -a label color
  local num_regex='^[0-9]+$'
  local level=$1
  label=([0]="[ERR]" [1]="[WARN]" [2]="[SUCCESS]" [3]="[INFO]" [4]="[DEBUG]")
  color=([0]="$_ctb_error" [1]="$_ctb_warning" [2]="$_ctb_success" [3]="$_ctb_primary" [4]="$_ctb_highlight")

  if [[ $level =~ $num_regex ]]; then
    shift
    if [[ -n ${log_level} && ${log_level} -ge ${level} ]]; then
      printf "${color[$level]}${label[$level]} ${_ct}%s${_cr}\n" "$@"
    fi
  else
    printf "${_ctb}> ${_ct}%s${_cr}\n" "$@"
  fi
}

# Prints the help- and usage information.
#
# @return none
# @since 0.2.0
print_help() {
  echo -e -n "\
  \r${_ctb}Usage: ${_ct_primary}${0##*/} ${_ctb_subtle}[OPTIONS]
  ${_ctb_highlight}-h${_ct},${_ctb_highlight} --help ${_ct}
  Show the help

  ${_ctb_highlight}-l${_ct},${_ctb_highlight} --loglevel <LOG_LEVEL>${_ct},${_ctb_highlight} --loglevel=<LOG_LEVEL> ${_ct}
  Set the log level
    ${_ctb_primary}0 ${_ctb}ERROR${_cr} The script will run in silent mode, only error messages are shown
    ${_ctb_primary}1 ${_ctb}WARNING${_cr} Shows warning messages
    ${_ctb_primary}2 ${_ctb}SUCCESS${_cr} Shows success messages (default)
    ${_ctb_primary}3 ${_ctb}INFO${_cr} Shows additional information messages
    ${_ctb_primary}4 ${_ctb}DEBUG${_cr} Runs the script in debug mode showing additional debug messages

  ${_ctb_highlight}-p${_ct},${_ctb_highlight} --profile <PROFILE_NAME>${_ct},${_ctb_highlight} --profile=<PROFILE_NAME>${_ct}
  The name of the profile to install the theme to. If not specified a new profile as clone of the 'default' profile will be created.${_cr}\n"
}

# Validates all required dependencies.
#
# @param $1 array of required dependencies to validate
# @return 0 if all required dependencies are validated, 1 otherwise
# @since 0.2.0
validate_dependencies() {
  declare -a missing_deps deps=("${!1}")
  for exec in "${deps[@]}"; do
    if ! command -v "${exec}" > /dev/null 2>&1; then
      missing_deps+=(${exec})
    fi
  done
  if [ ${#missing_deps[*]} -eq 0 ]; then
    log 3 "Validated required dependencies: ${deps[*]}"
    return 0
  else
    log 1 "Missing required dependencies: ${_ct_highlight}${missing_deps[*]}${_cr}"
    return 1
  fi
}

# Compares whether the given version string is greater than, equal to or less than the given comparative version string.
#
# @param $1 the version string to be compared
# @param $2 the version string to compare against
# @return 0 if the versions are equal, 1 if the version is greater or 2 if the version is less than the comparative
# version
# @ since 0.2.0
vercomp() {
  # v1 equals v2
  if [[ "$1" == "$2" ]]; then
    return 0
  fi

  local IFS=.
  local i v1=($1) v2=($2)

  # Fill empty fields with zeros
  for ((i=${#v1[@]}; i<${#v2[@]}; i++)); do
    v1[i]=0
  done

  for ((i=0; i<${#v1[@]}; i++)); do
    if [[ -z ${v2[i]} ]]; then
     # Fill empty fields with zeros
      v2[i]=0
    fi

    # v1 is greater than v2
    if ((10#${v1[i]} > 10#${v2[i]})); then
      return 1
    fi
    # v1 is less than v2
    if ((10#${v1[i]} < 10#${v2[i]})); then
      return 2
    fi
  done
  return 0
}

# Shorthand function to write the given key-value pair to the profile.
#
# @globread DCONF_PROFILE_BASE_PATH profile_uuid
# @param $1 the profile key to be written
# @param $2 the value to be assigned to the given profile key
# @return none
# @since 0.2.0
_write() {
  local key="$1"
  local value="$2"
  dconf write "$DCONF_PROFILE_BASE_PATH/:$profile_uuid/$key" "$value"
}

# Catches terminal interrupt- and termination signals and prints a message before exiting the script execution.
#
# @return 1
# @since 0.2.0
trap 'printf "${_ctb_error}User aborted.${_cr}\n" && exit 1' SIGINT SIGTERM

# Exit hook that runs the 'cleanup' function before exiting the script.
#
# @since 0.2.0
trap cleanup EXIT

declare -a DEPENDENCIES profiles

_cr="\e[0m"
_ct="\e[0;37m"
_ctb="\e[1;37m"
_ct_highlight="\e[0;34m"
_ct_primary="\e[0;36m"
_ctb_error="\e[1;31m"
_ctb_highlight="\e[1;34m"
_ctb_primary="\e[1;36m"
_ctb_subtle="\e[1;30m"
_ctb_success="\e[1;32m"
_ctb_warning="\e[1;33m"

NORD_GNOME_TERMINAL_SCRIPT_OPTS=$(getopt -o hl:p: --long help,loglevel:,profile: -n 'nord.sh' -- "$@")
NORD_GNOME_TERMINAL_VERSION=0.1.0
NORD_GNOME_TERMINAL_VERSION_DCONF_KEY=nord-gnome-terminal-version
NORD_PROFILE_VISIBLE_NAME="Nord"
log_level=2

# List of required executable dependencies
DEPENDENCIES=(dconf expr gsettings uuidgen)

# The dconf- and GSettings paths
DCONF_PROFILE_BASE_PATH=/org/gnome/terminal/legacy/profiles:
GSETTINGS_PROFILELIST_PATH=org.gnome.Terminal.ProfilesList

# The detected GNOME Terminal version
gnome_terminal_version=

# The profile name and UUID to apply the theme on
profile_name=
profile_uuid=

eval set -- "$NORD_GNOME_TERMINAL_SCRIPT_OPTS"
while true; do
  case "$1" in
    --loglevel=* ) log_level=${1#*=}; shift ;;
    -l | --loglevel ) log_level=$2; shift ;;
    -h | --help ) print_help; exit 0; break ;;
    --profile=* ) profile_name=${1#*=}; shift ;;
    -p | --profile ) profile_name=$2; shift ;;
    -- ) shift; break ;;
    * ) break ;;
  esac
  shift
done

if validate_dependencies DEPENDENCIES[@]; then
  
  if ! check_migrated_version_comp; then
    log 0 "The installed GNOME Terminal version '$gnome_terminal_version' is not compatible with the required (dconf migrated) version >= 3.8!"
    exit 1
  fi

  # Check for available profiles and validate that at least the default profile is available
  get_profiles
  if [[ ${#profiles[*]} -eq 0 ]]; then
    log 1 "No profiles found!"
    log 0 "There must be at least one default profile!"
    exit 1
  fi

  # Validate- and resolve the UUID if a profile name has been passed
  if [[ -n $profile_name ]]; then
    profile_uuid="$(get_profile_uuid_by_name "$profile_name")"
    if [[ -n $profile_uuid ]]; then
      log 3 "Resolved profile '$profile_name' to UUID '$profile_uuid'"
      curr_ver="$(get_current_version "$profile_uuid")"
      if [[ -n $curr_ver ]]; then
        apply_version_compared "$curr_ver"
      else
        apply
        log 2 "Nord GNOME Terminal version $NORD_GNOME_TERMINAL_VERSION has been successfully applied to the '$profile_name' profile"
        exit 0
      fi
    else
      log 0 "$profile_name is not a valid profile name!";
      exit 1
    fi
  fi

  # Check for an already existing 'Nord' profile and update it
  profile_uuid="$(get_profile_uuid_by_name $NORD_PROFILE_VISIBLE_NAME)"
  if [[ -n $profile_uuid ]]; then
    profile_name="$NORD_PROFILE_VISIBLE_NAME"
    log 4 "Found already existing '$NORD_PROFILE_VISIBLE_NAME' profile with UUID '$profile_uuid'"
    log "Updating already existing '$NORD_PROFILE_VISIBLE_NAME' profile"
    apply_version_compared "$(get_current_version $profile_uuid)"
  fi

  clone_default_profile
  apply
  log 2 "Nord GNOME Terminal version $NORD_GNOME_TERMINAL_VERSION has been successfully applied to the newly created '$NORD_PROFILE_VISIBLE_NAME' profile"
  exit 0
else
  log 0 "Required dependencies were not fulfilled: ${DEPENDENCIES[*]}"
  exit 1
fi
