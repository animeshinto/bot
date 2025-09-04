from flask import Flask, Response
from selenium import webdriver
from selenium.webdriver.chrome.options import Options
from selenium.webdriver.common.by import By
from datetime import datetime
import time

app = Flask(__name__)
LOG_PATH = "registro.log"

def guardar_log(mensaje):
    with open(LOG_PATH, "a") as f:
        f.write(mensaje + "\n")

def registrar_rut_virtual(url, tipo):
    options = Options()
    options.add_argument("--headless")
    options.add_argument("--no-sandbox")
    options.add_argument("--disable-dev-shm-usage")
    options.add_argument("--disable-gpu")
    options.add_argument("--window-size=1920,1080")

    driver = webdriver.Chrome(options=options)
    try:
        driver.get(url)
        time.sleep(3)

        for digito in "265237371":
            selector = f"//li[@class='digits']//strong[text()='{digito}']"
            boton = driver.find_element(By.XPATH, selector)
            boton.click()
            time.sleep(0.2)

        enviar_btn = driver.find_element(By.XPATH, "//li[contains(@class, 'pad-action')]//sup[text()='Enviar']")
        enviar_btn.click()

        hora = datetime.now().strftime("%Y-%m-%d %H:%M:%S")
        mensaje = f"✅ {tipo} registrada correctamente a las {hora} CLT"
        guardar_log(mensaje)
        return mensaje
    except Exception as e:
        hora = datetime.now().strftime("%Y-%m-%d %H:%M:%S")
        mensaje = f"⚠️ Error al registrar {tipo} a las {hora}: {e}"
        guardar_log(mensaje)
        return mensaje
    finally:
        driver.quit()

@app.route("/entrada")
def entrada():
    url = "https://app.ctrlit.cl/ctrl/dial/guardarweb/nPeJwhLxFW?i=1"
    mensaje = registrar_rut_virtual(url, "Entrada")
    return Response(f"<h1>{mensaje}</h1>", mimetype="text/html")

@app.route("/salida")
def salida():
    url = "https://app.ctrlit.cl/ctrl/dial/guardarweb/nPeJwhLxFW?i=0"
    mensaje = registrar_rut_virtual(url, "Salida")
    return Response(f"<h1>{mensaje}</h1>", mimetype="text/html")

@app.route("/")
def home():
    return """
    <h2>🧠 Bot operativo</h2>
    <ul>
        <li><a href='/entrada'>Registrar entrada</a></li>
        <li><a href='/salida'>Registrar salida</a></li>
    </ul>
    """

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)