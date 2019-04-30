function log
{
  echo "$1"
}

function error
{
  log "Error: $1"
  exit 2
}

function is_ok
{
  if [[ $1 -ne 0 ]];then
    error "$2"
  fi
}

function is_set
{
  if [[ -z "${1}" ]];then
    error "$2"
  fi
}
