#!/bin/ash

BIN="/usr/bin/snell-server"
CONF="/etc/snell-server.conf"

# reuse existing config when the container restarts

run_bin() {
    echo "Running snell-server with config:"
    echo ""
    cat ${CONF}

    ${BIN} --version
    ${BIN} -c ${CONF}
}

if [ -f ${CONF} ]; then
    echo "Found existing config, rm it."
    rm ${CONF}
fi

if [ -z ${PSK} ]; then
    PSK=$(tr -dc A-Za-z0-9 </dev/urandom | head -c 16)
    echo "Using generated PSK: ${PSK}"
else
    echo "Using predefined PSK: ${PSK}"
fi

if [ -z ${OBFS} ]; then
    OBFS=tls
fi

echo "Generating new config..."
echo "[snell-server]" >> ${CONF}
echo "listen = 0.0.0.0:9102" >> ${CONF}
echo "psk = ${PSK}" >> ${CONF}
echo "obfs = ${OBFS}" >> ${CONF}

run_bin
