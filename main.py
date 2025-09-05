def registrar_rut_virtual(url, tipo):
    options = uc.ChromeOptions()
    options.add_argument("--headless")
    options.add_argument("--no-sandbox")
    options.add_argument("--disable-dev-shm-usage")
    options.add_argument("--disable-gpu")
    options.add_argument("--window-size=1920,1080")

    # Indicar la ruta del binario de Chromium dentro del contenedor
    options.binary_location = "/usr/bin/chromium"

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
