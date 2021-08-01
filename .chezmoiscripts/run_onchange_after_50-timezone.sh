#!/bin/sh

printf '\033[1;33m=> Setting timezone to local time\033[0m\n'

sudo timedatectl set-local-rtc 1
