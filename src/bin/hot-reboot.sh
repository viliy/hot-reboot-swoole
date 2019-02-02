#!/bin/bash

echo -e '\033[5;46;37m the hotfix-reload for swoole \033[0m';
echo -e '\033[5;42;30m loading..................... \033[0m';
echo -e '\033[5;33;1m';


if [ ! -f "$1" ]; then
echo -e '\033[5;33;1m you have not choice conf file'
exit
fi

while read key
do
    eval "$key"
done<$1

if [ ! -n "$APP_DIR" ]; then
    echo -e "\033[5;45;1m APP_DIR must be input \033[0m";
    exit
fi
if [ ! -n "$APP_LISTEN_DIR" ]; then
    echo -e '\033[5;41;1m APP_LISTEN_DIR must be input';
    exit
fi
if [ ! -n "$APP_RELOAD_ONE" ]; then
    echo -e '\033[5;41;1m APP_RELOAD_ONE must be input';
    exit
fi

if [ -n "$RELOAD_LOG" ]; then
    if [ ! -f "$RELOAD_LOG" ]; then
    touch "$RELOAD_LOG"
    fi
fi

if [ ! -f $RUN_LOG ]; then
    $RUN_LOG = '/dev/null';
fi

eval  "cd $APP_DIR"
eval  "$APP_STOP"
echo 'start the swoole server.....'
eval  "$APP_START"  >>  $RUN_LOG 2>&1 &


fswatch $APP_LISTEN_DIR | while read file
do
    tmp=$(echo "$file" | grep "php___jb" )
    if [[ $tmp == "" ]]; then
        if [ -f "$RELOAD_LOG" ]; then
            echo "${file:26} was modify" >> $RELOAD_LOG 2>&1 &
        fi
        echo  >> $RUN_LOG;
        eval  "cd $APP_DIR"

        if [ -n "$APP_RELOAD_TWO" ]; then
            eval $APP_RELOAD_ONE;
            eval "$APP_RELOAD_TWO"  >> $RUN_LOG 2>&1 &
        else
            eval "$APP_RELOAD_ONE"  >> $RUN_LOG 2>&1 &
        fi
        echo -e '\033[0m \033[5;41;1m app has reload \033[0m';
    fi
done

eval  "$APP_STOP"
echo 'stop';
