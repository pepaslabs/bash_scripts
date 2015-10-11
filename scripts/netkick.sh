#!/usr/bin/env bash

# netkick.sh: if you can't reach the gateway, then ifdown && ifup

# put this in root's crontab:
# * * * * * root /path/to/netkick.sh


# tunables
gateway="192.168.2.1"
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


# main

if ! ping -c 1 ${gateway} >/dev/null 2>&1
then
    emit notice "Can't reach the gateway.  Resetting the network..."
    ifdown wlan0 >/dev/null 2>&1 || true
    ifup wlan0 >/dev/null 2>&1
fi

