export NDENV_VERSION=v0.10.36
if [ -n "${REDIS_PORT_6379_TCP}" ]; then
  export REDIS_URL=redis://${REDIS_PORT_6379_TCP_ADDR}:${REDIS_PORT_6379_TCP_PORT}/
fi
