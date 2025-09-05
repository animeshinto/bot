FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

# Instala dependencias útiles y herramientas comunes
RUN apt-get update && apt-get install -y \
  wget unzip curl gnupg ca-certificates \
  fonts-liberation libnss3 libxss1 libappindicator3-1 libasound2 xdg-utils \
  libx11-xcb1 libxcomposite1 libxcursor1 libxdamage1 libxi6 libxtst6 libxrandr2 \
  libatk1.0-0 libatk-bridge2.0-0 libgbm1 libgtk-3-0 && \
  rm -rf /var/lib/apt/lists/*

# Instala Google Chrome estable
RUN wget -q -O /tmp/chrome.deb https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb && \
  apt-get update && apt-get install -y /tmp/chrome.deb && \
  rm /tmp/chrome.deb && rm -rf /var/lib/apt/lists/*

# Instala ChromeDriver correspondiente automáticamente al número mayor de versión de Chrome
RUN CHROME_VER=$(google-chrome-stable --version | cut -d ' ' -f 3 | cut -d '.' -f 1) && \
  echo "Chrome versión principal: $CHROME_VER" && \
  wget -q -O /tmp/chromedriver.zip \
    https://edgedl.me.gvt1.com/edgedl/chrome/chrome-for-testing/LATEST_RELEASE_${CHROME_VER} && \
  wget -q -O /tmp/chromedriver.zip \
    https://edgedl.me.gvt1.com/edgedl/chrome/chrome-for-testing/${CHROME_VER}.0.0/linux64/chromedriver-linux64.zip && \
  unzip /tmp/chromedriver.zip -d /usr/local/bin && \
  chmod +x /usr/local/bin/chromedriver && \
  rm /tmp/chromedriver.zip

WORKDIR /app

# Copia archivos e instala dependencias Python
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY . .

EXPOSE 10000

CMD ["python", "main.py"]
