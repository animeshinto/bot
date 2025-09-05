# Usa una imagen oficial de Python como base
FROM python:3.12-slim

# Establece el directorio de trabajo dentro del contenedor
WORKDIR /app

# Copia los archivos del proyecto
COPY . .

# Instala dependencias desde requirements.txt
RUN pip install --upgrade pip \
    && pip install -r requirements.txt

# Define el comando que se ejecutará al iniciar el contenedor
CMD ["python", "main.py"]
