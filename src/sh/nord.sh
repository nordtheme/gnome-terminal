#!/usr/bin/env bash
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# title      Nord GNOME Terminal                                    +
# project    nord-gnome-terminal                                    +
# repository https://github.com/arcticicestudio/nord-gnome-terminal +
# author     Arctic Ice Studio                                      +
# email      development@arcticicestudio.com                        +
# copyright  Copyright (C) 2016                                     +
# +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
[[ -z "$PROFILE_NAME" ]] && PROFILE_NAME="Nord"
[[ -z "$PROFILE_SLUG" ]] && PROFILE_SLUG="nord"
[[ -z "$DCONF" ]] && DCONF=dconf
[[ -z "$UUIDGEN" ]] && UUIDGEN=uuidgen

NORD_GNOME_TERMINAL_VERSION=0.1.0

dset() {
  local key="$1"; shift
  local val="$1"; shift
  
  if [[ "$type" == "string" ]]; then
    val="'$val'"
  fi
  
  "$DCONF" write "$PROFILE_KEY/$key" "$val"
}

dlist_append() {
  local key="$1"; shift
  local val="$1"; shift
  
  local entries="$(
  {
    "$DCONF" read "$key" | tr -d '[]' | tr , "\n" | fgrep -v "$val"
    echo "'$val'"
  } | head -c-1 | tr "\n" ,
  )"
  
  "$DCONF" write "$key" "[$entries]"
}

if which "$DCONF" > /dev/null 2>&1; then
  [[ -z "$BASE_KEY_NEW" ]] && BASE_KEY_NEW=/org/gnome/terminal/legacy/profiles:
  
  if [[ -n "`$DCONF list $BASE_KEY_NEW/`" ]]; then
    if which "$UUIDGEN" > /dev/null 2>&1; then
      PROFILE_SLUG=`uuidgen`
    fi
    
    if [[ -n "`$DCONF read $BASE_KEY_NEW/default`" ]]; then
      DEFAULT_SLUG=`$DCONF read $BASE_KEY_NEW/default | tr -d \'`
    else
      DEFAULT_SLUG=`$DCONF list $BASE_KEY_NEW/ | grep '^:' | head -n1 | tr -d :/`
    fi
    
    DEFAULT_KEY="$BASE_KEY_NEW/:$DEFAULT_SLUG"
    PROFILE_KEY="$BASE_KEY_NEW/:$PROFILE_SLUG"
    
    $DCONF dump "$DEFAULT_KEY/" | $DCONF load "$PROFILE_KEY/"
    dlist_append $BASE_KEY_NEW/list "$PROFILE_SLUG"
    
    dset visible-name "'$PROFILE_NAME'"
    dset palette "['#3B4252', '#BF616A', '#A3BE8C', '#EBCB8B', '#81A1C1', '#B48EAD', '#88C0D0', '#E5E9F0', '#4C566A', '#BF616A', '#A3BE8C', '#EBCB8B', '#81A1C1', '#B48EAD', '#8FBCBB', '#ECEFF4']"
    dset background-color "'#2E3440'"
    dset foreground-color "'#D8DEE9'"
    dset bold-color "'#D8DEE9'"
    dset bold-color-same-as-fg "true"
    dset use-theme-colors "false"
    dset use-theme-background "false"
    
    unset PROFILE_NAME
    unset PROFILE_SLUG
    unset DCONF
    unset UUIDGEN
    exit 0
  fi
fi

[[ -z "$GCONFTOOL" ]] && GCONFTOOL=gconftool
[[ -z "$BASE_KEY" ]] && BASE_KEY=/apps/gnome-terminal/profiles

PROFILE_KEY="$BASE_KEY/$PROFILE_SLUG"

gset() {
  local type="$1"; shift
  local key="$1"; shift
  local val="$1"; shift
  
  "$GCONFTOOL" --set --type "$type" "$PROFILE_KEY/$key" -- "$val"
}

glist_append() {
  local type="$1"; shift
  local key="$1"; shift
  local val="$1"; shift
  
  local entries="$(
  {
    "$GCONFTOOL" --get "$key" | tr -d '[]' | tr , "\n" | fgrep -v "$val"
    echo "$val"
  } | head -c-1 | tr "\n" ,
  )"
  
  "$GCONFTOOL" --set --type list --list-type $type "$key" "[$entries]"
}

glist_append string /apps/gnome-terminal/global/profile_list "$PROFILE_SLUG"

gset string visible_name "$PROFILE_NAME"
gset string palette "#3B4252:#BF616A:#A3BE8C:#EBCB8B:#81A1C1:#B48EAD:#88C0D0:#E5E9F0:#4C566A:#BF616A:#A3BE8C:#EBCB8B:#81A1C1:#B48EAD:#8FBCBB:#ECEFF4"
gset string background_color "#2E3440"
gset string foreground_color "#D8DEE9"
gset string bold_color "#D8DEE9"
gset bool bold_color_same_as_fg "true"
gset bool use_theme_colors "false"
gset bool use_theme_background "false"

unset PROFILE_NAME
unset PROFILE_SLUG
unset DCONF
unset UUIDGEN
unset NORD_GNOME_TERMINAL_VERSION
