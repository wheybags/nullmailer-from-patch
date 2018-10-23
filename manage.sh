#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"
cd $DIR

sendmail_path=/usr/sbin/sendmail
patched_path=`realpath ./sendmail`

installed="true"
grep -q "NULLMAILER FORCE FROM SCRIPT" $sendmail_path || installed="false"

if [ "$1" == "uninstall" ]; then
    if [ "$installed" == "false" ]; then
        echo "cannot uninstall, not installed" 1>&2
        exit 1
    fi

    mv $sendmail_path-bin $sendmail_path -f || exit 1
    echo "successfully uninstalled"

elif [ "$1" == "install" ]; then
    if [ "$installed" == "false" ]; then
        mv $sendmail_path $sendmail_path-bin -f || exit 1
        echo moved original sendmail to $sendmail_path-bin
    fi

    cp $patched_path $sendmail_path || exit 1
    echo installed to $sendmail_path
else
    echo "usage: $0 [install|uninstall]"
    exit 2
fi

exit 0
