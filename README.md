# Prueba técnica QA Backend

Pruebas automáticas para la API Platzi Fake Store, hechas con Java 21, Karate y Gradle.

La suite tiene 21 escenarios: productos (5), filtros (6), categorías (5) y usuarios (5). Incluye consultas, CRUD, validación de respuestas y casos negativos.

## Ejecutar

Desde esta carpeta, en Windows:

```powershell
.\gradlew.bat compileTestJava
.\gradlew.bat test
```

El comando `test` ejecuta los escenarios y genera el reporte Cucumber. Para regenerar ese reporte a partir de los resultados existentes:

```powershell
.\gradlew.bat generateCucumberReport
```

El reporte queda en `build/reports/cucumber/cucumber-html-reports/overview-features.html`.

## Resultado

En la ejecución completa del 30 de septiembre de 2026 pasaron 20 de 21 escenarios. El filtro `price_max=10000` devolvió un producto con precio `12213`; la prueba conserva este fallo como hallazgo de la API.

Respuestas a las preguntas de la prueba: [RESPUESTAS.md](RESPUESTAS.md).
