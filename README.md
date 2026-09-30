# Prueba técnica QA Backend

Preparé pruebas automáticas para la API Platzi Fake Store usando Java, Karate y Gradle.

Se probaron productos (5 escenarios), filtros (6), categorías (5) y usuarios (5), incluyendo consultas, CRUD y casos de error.

## Cómo ejecutarlo

Se necesita Java 21. Desde esta carpeta, en Windows, ejecuta:

```powershell
.\gradlew.bat test
```

Al terminar, Gradle genera el reporte Cucumber en `build/reports/cucumber/cucumber-html-reports/overview-features.html`.

## Resultado

En la ejecución del 30 de septiembre de 2026 pasaron 20 de 21 escenarios. El que falló fue el filtro de precio máximo: al pedir productos de hasta `10000`, la API devolvió uno con precio `12213`. Dejé la validación para registrar esa diferencia en la respuesta del servicio.
