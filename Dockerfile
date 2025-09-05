FROM python:3.11-slim

ENV DEBIAN_FRONTEND=noninteractive

# Instala herramientas necesarias, Chrome y dependencias
RUN apt-get update && apt-get install -y \
    wget curl unzip gnupg ca-certificates \
    fonts-liberation libnss3 libxss1 libappindicator3-1 libasound2 \
    xdg-utils libx11-xcb1 libxcomposite1 libxcursor1 libxdamage1 \
    libxi6 libxtst6 libxrandr2 libatk1.0-0 libatk-bridge2.0-0 libgbm1 \
    libgtk-3-0 && rm -rf /var/lib/apt/lists/*

# Instala Google Chrome estable
RUN wget -q -O /tmp/chrome.deb https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb && \
    apt-get update && apt-get install -y /tmp/chrome.deb && \
    rm /tmp/chrome.deb && rm -rf /var/lib/apt/lists/*

# Instala ChromeDriver según versión de Chrome
RUN CHROME_VER=$(google-chrome-stable --version | awk '{print $3}' | cut -d '.' -f 1) && \
    DRIVER_VER=$(curl -sSL https://chromedriver.storage.googleapis.com/LATEST_RELEASE_$CHROME_VER) && \
    wget -q -O /tmp/chromedriver.zip https://chromedriver.storage.googleapis.com/${DRIVER_VER}/chromedriver_linux64.zip && \
    unzip /tmp/chromedriver.zip -d /usr/local/bin && chmod +x /usr/local/bin/chromedriver && rm /tmp/chromedriver.zip

WORKDIR /app

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY . .

EXPOSE 10000
CMD ["python3", "main.py"]
