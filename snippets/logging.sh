#!/usr/bin/env bash

# tunables
log_facility="daemon"


# strict mode
set -eu -o pipefail

# _script: the name of this script
# _scriptdir: the directory which this script resides in
# thanks to https://github.com/kvz/bash3boilerplate/blob/master/main.sh
_script="$(basename "${BASH_SOURCE[0]}")"
_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"


# logging functions

function is_running_interactively()
{
    tty -s
}

daily_mail_lockfile="/var/tmp/${_script}.mail.daily"

function has_sent_mail_today()
{
    find "${daily_mail_lockfile}" -newermt "0:00" 2>/dev/null | grep -q "^${daily_mail_lockfile}$"
}

function log()
{
    local priority="${1}" ; shift # emerg, alert, crit, err, warning, notice, info, debug
    local message="${@}"

    local upper_priority=$(echo "${priority}" | awk '{print toupper($0)}')
    logger --priority "${log_facility}.${priority}" --tag "${_script}: ${upper_priority}" -- "${message}"
}

function console()
{
    if ! is_running_interactively && has_sent_mail_today
    then
        return
    else
        touch "${daily_mail_lockfile}"
    fi
    
    local priority="${1}" ; shift
    local message="${@}"

    local upper_priority=$(echo "${priority}" | awk '{print toupper($0)}')
    case "${priority}" in
        emerg | alert | crit | err)
            echo "${upper_priority}: ${message}" >&2
            ;;
        *)
            echo "${upper_priority}: ${message}"
            ;;
    esac
}

function emit()
{
    console "$@"
    log "$@"
}



# demo / tests

log info "this goes only to syslog"

console info "this goes only to stdout"

emit info "this goes to syslog and stdout"
emit err "this goes to syslog and stderr"

console debug "debug priority goes to stdout"
console info "info priority goes to stdout"
console notice "notice priority goes to stdout"
console warning "warning priority goes to stdout"
console err "err priority goes to stderr"
console crit "crit priority goes to stderr"
console alert "alert priority goes to stderr"
console emerg "emerg priority goes to stderr"

emit notice "You should always see these messages when running from the console, but a crontab entry should only result in one mail per day.  You can test that by putting the following entry into your crontab:"
emit notice "* * * * * ${_dir}/${_script}"
