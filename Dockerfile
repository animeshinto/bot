FROM python:3.11-slim

ENV DEBIAN_FRONTEND=noninteractive

# Instala dependencias básicas
RUN apt-get update && apt-get install -y \
    curl unzip gnupg wget \
    fonts-liberation libnss3 libxss1 libappindicator3-1 libasound2 xdg-utils \
    libx11-xcb1 libxcomposite1 libxcursor1 libxdamage1 libxi6 libxtst6 libxrandr2 \
    libatk1.0-0 libatk-bridge2.0-0 libgbm1 libgtk-3-0 --no-install-recommends \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Instala Google Chrome estable
RUN wget -q -O - https://dl.google.com/linux/linux_signing_key.pub | apt-key add - && \
    echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" > /etc/apt/sources.list.d/google-chrome.list && \
    apt-get update && apt-get install -y google-chrome-stable

# Extrae versión de Chrome
RUN CHROME_VERSION=$(google-chrome-stable --version | awk '{print $3}' | cut -d '.' -f 1) && \
    echo "Instalando ChromeDriver para Chrome $CHROME_VERSION" && \
    wget -O /tmp/chromedriver.zip "https://storage.googleapis.com/chrome-for-testing-public/$CHROME_VERSION.0.0/linux64/chromedriver-linux64.zip" && \
    unzip /tmp/chromedriver.zip -d /usr/local/bin && \
    mv /usr/local/bin/chromedriver-linux64/chromedriver /usr/local/bin/chromedriver && \
    chmod +x /usr/local/bin/chromedriver && \
    rm -rf /tmp/chromedriver.zip /usr/local/bin/chromedriver-linux64

# Crea carpeta de trabajo
WORKDIR /app

# Copia e instala requerimientos
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY . .

EXPOSE 10000

CMD ["python", "main.py"]
