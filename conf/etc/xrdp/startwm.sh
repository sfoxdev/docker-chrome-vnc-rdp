#!/bin/sh

if [ -r /etc/default/locale ]; then
  . /etc/default/locale
  export LANG LANGUAGE
fi

#fluxbox
. /etc/X11/Xsession
#startxfce4
#/opt/google/chrome/chrome --user-data-dir --no-sandbox --window-position=0,0 --window-size=1024,768 --force-device-scale-factor=1
