#! /usr/bin/env bash

_ARGS=(${@})
_POSITIONAL_ARGS=()

_SSH_SERVER=$DEPLOY_SSH_SERVER
_SSH_PORT="${DEPLOY_SSH_PORT:-22}"
_REMOTE_PATH="$DEPLOY_SSH_PATH"
_LOCAL_PATH="$DEPLOY_LOCAL_PATH"
_REMOVE="$DEPLOY_SSH_PATH_REMOVE"

function _error () {
  local msg=$1
  echo "Error: ${msg}"
  exit 1
}

i=0
while (( i < ${#} ))
do
  current_arg=${_ARGS[i]}
  next_arg=${_ARGS[i + 1]}

  case "$current_arg" in
  "--server")
    if [[ -n "$next_arg" ]]
    then
      _SSH_SERVER="$next_arg"
      i=$(( i + 2 ))
    fi
    ;;
  "--port")
    if [[ -n "$next_arg" ]]
    then
      _SSH_PORT="$next_arg"
      i=$(( i + 2 ))
    fi
    ;;
  "--remote-path")
    if [[ -n "$next_arg" ]]
    then
      _REMOTE_PATH="$next_arg"
      i=$(( i + 2 ))
    fi
    ;;
  "--local-path")
    if [[ -n "$next_arg" ]]
    then
      _LOCAL_PATH="$next_arg"
      i=$(( i + 2 ))
    fi
    ;;
  "--remove")
      _REMOVE=1
      i=$(( i + 1 ))
    ;;
  "--help")
      echo "Usage: ${0} --server <server> --remote-path <remote-path> --local-path <local-path> [--port <port>] [--remove]"
      exit
    ;;
  *)
    _POSITIONAL_ARGS+=("$current_arg")
    i=$(( i + 1 ))
    ;;
  esac
done

if [[ -z "$_SSH_SERVER" ]];
then
  _error "SSH server not set!"
elif [[ -z "$_REMOTE_PATH" ]];
then
  _error "Remote path not set!"
elif [[ -z "$_LOCAL_PATH" ]];
then
  _error "Local path (to upload) not set!"
fi

if [[ -n "$_REMOVE" ]]
then
  ssh "$_SSH_SERVER" rm -rf "$_REMOTE_PATH"
fi

scp -r -P $_SSH_PORT "$_LOCAL_PATH" "$_SSH_SERVER:$_REMOTE_PATH"