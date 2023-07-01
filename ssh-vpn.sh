#!/bin/bash

# Port to be used for SOCKS5 proxy by SSH
SOCKS_PORT=2222

# SSH server to be used to connect to internet can be passed on command line
# or defined uncommenting the following line
# VPN_SERVER=user@your-ssh-server


# For clients which do not support SOCKS procies (eg: iPhone, iPad)
# you can run an HTTP proxy which forwards traffic through SOCKS5
# To have an HTTP proxy install the gost tool and uncomment the HTTP_PORT variable definition
HTTP_PORT=2223

if [ $# -eq 1 ]
then
    VPN_SERVER=$1
fi

if [ "x${VPN_SERVER}x" == "xx" ]
then
    echo "Set VPN_SERVER variable to your preferred server in the script or pass it on command line as an argument, eg"
    echo ""
    echo "$0 <VPN_SERVER>"
    exit 0
fi

cleanup() {
    echo ""
    echo "Killing SSH Tunnel instances if any"
    PIDS=`ps -A | grep "ssh -D 0.0.0.0:2222" | grep -v grep | cut -d' ' -f1`
    for PID in $PIDS
    do
        echo "Kill process with PID ${PID}"
        kill $PID
    done
}

cleanup

trap cleanup EXIT

echo "Activating SOCKS5 proxy on port ${SOCKS_PORT}"

if [ -z ${HTTP_PORT}  ]
then
    echo "No HTTP Proxy required"
    ssh -D 0.0.0.0:${SOCKS_PORT} -N ${VPN_SERVER}
else
    ssh -D 0.0.0.0:${SOCKS_PORT} -N -f ${VPN_SERVER}
    gost -L "http://${HTTP_PORT}" -F "socks5://:${SOCKS_PORT}"
fi



