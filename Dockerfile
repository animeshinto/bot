# Usa una imagen base oficial de Python (puedes cambiar la versión si quieres)
FROM python:3.11-slim

# Cambiar a bash como shell predeterminado para evitar problemas con comandos RUN
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# Actualizar repositorios e instalar dependencias necesarias para librerías, navegador, etc.
RUN apt-get update && apt-get install -y \
    wget \
    gnupg2 \
    python3-distutils \
    unzip \
    curl \
    fonts-liberation \
    libnss3 \
    libxss1 \
    libappindicator3-1 \
    libasound2 \
    xdg-utils \
    libx11-xcb1 \
    libxcomposite1 \
    libxcursor1 \
    libxdamage1 \
    libxi6 \
    libxtst6 \
    libxrandr2 \
    libatk1.0-0 \
    libatk-bridge2.0-0 \
    libgbm1 \
    libgtk-3-0 \
    --no-install-recommends && \
    rm -rf /var/lib/apt/lists/*

# Crear y establecer el directorio de trabajo dentro del contenedor
WORKDIR /app

# Copiar el archivo de requerimientos para instalar dependencias Python
COPY requirements.txt .

# Instalar las dependencias de Python
RUN pip install --no-cache-dir -r requirements.txt

# Copiar todo el contenido del proyecto al contenedor
COPY . .

# Comando por defecto para ejecutar tu bot (ajusta según el punto de entrada de tu app)
CMD ["python", "bot.py"]
