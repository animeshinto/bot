FROM ubuntu:22.04
ENV DEBIAN_FRONTEND=noninteractive

# Instala dependencias essenciais y Python
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

# Descarga el ChromeDriver compatible con la versión instalada
RUN CHROME_VER=$(google-chrome-stable --version | awk '{print $3}' | cut -d '.' -f 1) && \
    DRIVER_URL=$(curl -sSL "https://googlechromelabs.github.io/chrome-for-testing/last-known-good-versions-with-downloads.json" | \
    python3 -c "import sys, json; print(json.load(sys.stdin)['channels']['Stable']['downloads']['chromedriver'][0]['url'])") && \
    wget -q -O /tmp/chromedriver.zip "$DRIVER_URL" && \
    unzip /tmp/chromedriver.zip -d /usr/local/bin && chmod +x /usr/local/bin/chromedriver && \
    rm /tmp/chromedriver.zip

WORKDIR /app

# Copia e instala dependencias Python
COPY requirements.txt .
RUN pip3 install --no-cache-dir -r requirements.txt

COPY . .

EXPOSE 10000

CMD ["python3", "main.py"]
