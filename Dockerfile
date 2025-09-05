RUN apt-get update && apt-get install -y \
    paquete1 \
    paquete2 \
    ...
    && rm -rf /var/lib/apt/lists/*
