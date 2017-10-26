#!/bin/bash
set -e

# VNC default no password
export X11VNC_AUTH="-nopw"

#touch /opt/vncpasswd
#echo "chrome" | vncpasswd -f > /opt/vncpasswd

# look for VNC password file in order (first match is used)
passwd_files=(
  /home/chrome/.vnc/passwd
  /run/secrets/vncpasswd
#  /opt/vncpasswd
)

for passwd_file in ${passwd_files[@]}; do
  if [[ -f ${passwd_file} ]]; then
    export X11VNC_AUTH="-rfbauth ${passwd_file}"
    break
  fi
done

# override above if VNC_PASSWORD env var is set (insecure!)
if [[ "$PASSWORD" != "" ]]; then
  export X11VNC_AUTH="-passwd $PASSWORD"
fi

exec "$@"
