#!/usr/bin/env bash

_list_name_options () {
  awesome list -v | grep 'Name:' | cut -d ':' -f 2 | sort -u
}

_awesome_main() {
  local commands="
  set
  initialize
  list
  "

  local boolean_options="
  --verbose -v
  --debug -d
  --version
  --help
  --usb
  --uav
  "

  local options_with_args="
  -m --name
  --cool-arg
  "

  # generate options list
  options=($options_with_args $boolean_options)
  for i in "${!options[@]}";
  do
    if [[ "${COMP_WORDS[@]}" =~ "${options[i]}" ]]; then
      unset 'options[i]'
    fi
  done;
  options=$(echo "${options[@]}")

  # This part will check if it is currently completing a flag
  local previous=$3
  local cur="${COMP_WORDS[COMP_CWORD]}"

  case "$previous" in
    --cool-arg)
      COMPREPLY=($(compgen -W "abc xyz" -- "$cur"))
      return
      ;;
    --name | -m )
      COMPREPLY=($(compgen -W "$(_list_name_options)" -- "$cur"))
      return
      ;;
  esac

  # This will handle auto completing arguments even if they are given at the end of the command
  case "$cur" in
    -*)
      COMPREPLY=($(compgen -W "$options" -- "$cur"))
      return
      ;;
  esac

  local i=1 cmd

  # find the subcommand - first word after the flags
  while [[ "$i" -lt "$COMP_CWORD" ]]
  do
    local s="${COMP_WORDS[i]}"
    case "$s" in
      --help | --version)
        COMPREPLY=()
        return
        ;;
      -*) ;;
      initialize | list | set )
        cmd="$s"
        break
        ;;
    esac
    (( i++ ))
  done

  # return early if we're still completing the 'current' command
  if [[ "$i" -eq "$COMP_CWORD" ]]
  then
    COMPREPLY=($(compgen -W "$commands $options" -- "$cur"))
    return
  fi

  # we've completed the 'current' command and now need to call the next completion function
  # subcommands have their own completion functions
  case "$cmd" in
    list)       COMPREPLY=""         ;;
    initialize) COMPREPLY=""         ;;
    set)        _awesome_set_command ;;
    *)                               ;;
  esac
}

_awesome_set_command ()
{
  local i=1 subcommand_index=0

  # find the sub command (either a fan or an led to set)
  while [[ $i -lt $COMP_CWORD ]]; do
    local s="${COMP_WORDS[i]}"
    case "$s" in
      led[1-2] | led)
        subcommand_index=$i
        break
        ;;
    esac
    (( i++ ))
  done

  # check if it is an LED that is being set
  if [[ "$subcommand_index" -ne "0" ]]
  then
    _awesome_set_led
  else
    # no trailing space here so that the fan number can be appended
    compopt -o nospace
    # possibly use some command here to get a list of all the possible channels from awesome
    local cur="${COMP_WORDS[COMP_CWORD]}"
    COMPREPLY=($(compgen -W "led led1 led2" -- "$cur"))
  fi
}


_awesome_set_led ()
{
  local i=1 found=0

  # find the sub command (either a fan or an led to set)
  while [[ $i -lt $COMP_CWORD ]]; do
    local s="${COMP_WORDS[i]}"
    if [[ "$s" = "color" ]]; then
      found=1
      break
    fi

    (( i++ ))
  done

  # check if it is a fan or an LED that is being set
  if [[ $found = 1 ]]; then
    COMPREPLY=""
  else
    COMPREPLY="color"
  fi
}

complete -F _awesome_main awesome