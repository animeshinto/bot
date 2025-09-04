from flask import Flask, Response
from datetime import datetime
import time
import undetected_chromedriver as uc
from selenium.webdriver.common.by import By

app = Flask(__name__)
LOG_PATH = "registro.log"

def guardar_log(mensaje):
    with open(LOG_PATH, "a", encoding="utf-8") as f:
        f.write(f"[{datetime.now()}] {mensaje}\n")

def registrar_rut_virtual(url, tipo):
    options = uc.ChromeOptions()
    options.add_argument("--headless")
    options.add_argument("--no-sandbox")
    options.add_argument("--disable-dev-shm-usage")
    options.add_argument("--disable-gpu")
    options.add_argument("--window-size=1920,1080")

    driver = uc.Chrome(options=options)
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

        mensaje = f"✅ {tipo} registrada correctamente"
        guardar_log(mensaje)
        return mensaje
    except Exception as e:
        mensaje = f"⚠️ Error al registrar {tipo}: {e}"
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

@app.route("/debug")
def debug():
    try:
        import undetected_chromedriver
        return "✅ undetected-chromedriver está instalado y el bot está activo"
    except Exception as e:
        return f"❌ Error: {str(e)}"
