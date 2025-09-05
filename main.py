from flask import Flask, Response
from datetime import datetime
import requests

app = Flask(__name__)
LOG_PATH = "registro.log"

def guardar_log(mensaje):
    with open(LOG_PATH, "a", encoding="utf-8") as f:
        f.write(f"[{datetime.now()}] {mensaje}\n")

def registrar_rut_virtual(url, tipo):
    try:
        response = requests.get(url, timeout=10)
        if response.status_code == 200:
            mensaje = f"✅ {tipo} registrada correctamente"
        else:
            mensaje = f"⚠️ Error HTTP {response.status_code} al registrar {tipo}"
    except Exception as e:
        mensaje = f"❌ Error al registrar {tipo}: {e}"
    guardar_log(mensaje)
    return mensaje

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
    <h2>🧠 Bot operativo sin navegador</h2>
    <ul>
        <li><a href='/entrada'>Registrar entrada</a></li>
        <li><a href='/salida'>Registrar salida</a></li>
    </ul>
    """

@app.route("/debug")
def debug():
    try:
        response = requests.get("https://app.ctrlit.cl", timeout=5)
        return f"✅ Sitio accesible: {response.status_code}"
    except Exception as e:
        return f"❌ Error al acceder al sitio: {str(e)}"
