FROM ubuntu:22.04
ENV DEBIAN_FRONTEND=noninteractive

# Instala dependencias del sistema y Python
RUN apt-get update && apt-get install -y \
    wget unzip curl gnupg ca-certificates python3 python3-pip \
    fonts-liberation libnss3 libxss1 libappindicator3-1 libasound2 \
    xdg-utils libgtk-3-0 libx11-xcb1 libxcomposite1 libxcursor1 \
    libxdamage1 libxi6 libxtst6 libxrandr2 libatk1.0-0 \
    libatk-bridge2.0-0 libgbm1 --no-install-recommends && \
    rm -rf /var/lib/apt/lists/*

# Instala Google Chrome estable
RUN wget -q -O /tmp/chrome.deb https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb && \
    apt-get update && apt-get install -y /tmp/chrome.deb && \
    rm /tmp/chrome.deb && rm -rf /var/lib/apt/lists/*

# Descarga la última versión compatible de ChromeDriver para la versión instalada de Chrome
RUN CHROME_VERSION=$(google-chrome-stable --version | awk '{print $3}' | cut -d '.' -f 1) && \
    echo "Chrome version major: $CHROME_VERSION" && \
    DRIVER_URL=$(curl -sSL "https://googlechromelabs.github.io/chrome-for-testing/last-known-good-versions-with-downloads.json" | \
        python3 -c "import sys,json; data=json.load(sys.stdin); print([d['url'] for d in data['channels']['Stable']['downloads']['chromedriver'] if str($CHROME_VERSION) in d['url']][0])") && \
    echo "Downloading chromedriver from: $DRIVER_URL" && \
    wget -q -O /tmp/chromedriver.zip "$DRIVER_URL" && \
    unzip /tmp/chromedriver.zip -d /usr/local/bin && \
    chmod +x /usr/local/bin/chromedriver && \
    rm /tmp/chromedriver.zip


WORKDIR /app

# Instala dependencias de Python
COPY requirements.txt .
RUN pip3 install --no-cache-dir -r requirements.txt

# Copia el resto del código
COPY . .

EXPOSE 10000

CMD ["python3", "main.py"]
