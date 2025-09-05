FROM python:3.11-slim

# Evita prompts interactivos en apt (aunque no usarás apt en Render)
ENV DEBIAN_FRONTEND=noninteractive

# Instala Chromium y dependencias
RUN apt-get update && apt-get install -y \
    chromium \
    chromium-driver \
    curl \
    unzip \
    fonts-liberation \
    libnss3 \
    libxss1 \
    --no-install-recommends && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Copia y instala dependencias Python
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copia el resto del código
COPY . .

# Expón el puerto que usará Flask (o UDP si corresponde)
EXPOSE 10000

# Ejecuta tu aplicación
CMD ["python", "main.py"]
