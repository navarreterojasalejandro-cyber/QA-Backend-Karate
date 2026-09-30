# Automatización QA Backend - Platzi Fake Store API

Este repositorio contiene una práctica guiada para validar servicios REST con **Karate**, escenarios legibles en **Gherkin** y construcción con **Gradle**. Las pruebas revisan códigos HTTP, encabezados, contenido y estructura de respuestas JSON.

## Requisitos

- JDK 21 (el proyecto fija Java 21 para que todos ejecuten con la misma versión).
- Git.
- Conexión a Internet para que Gradle descargue su distribución y las dependencias desde Maven Central.

No hace falta instalar Gradle globalmente: `gradlew.bat` usa la versión 8.14.4 declarada en el proyecto.

## Ejecutar en Windows

Desde una terminal abierta en la carpeta del proyecto:

```powershell
.\gradlew.bat test
```

El proceso ejecuta las pruebas y genera automáticamente el reporte HTML de Cucumber. Para regenerar el reporte desde los JSON existentes:

```powershell
.\gradlew.bat generateCucumberReport
```

El reporte queda en `build/reports/cucumber`. Karate también deja su reporte propio en `build/karate-reports`.

Para ejecutar solo escenarios con una etiqueta:

```powershell
.\gradlew.bat test -Dkarate.options="--tags @products"
```

## Estructura

- `build.gradle`: dependencias, versión de Java y tareas de ejecución/reporte.
- `settings.gradle`: nombre del proyecto Gradle.
- `gradlew.bat`, `gradlew` y `gradle/wrapper`: wrapper que fija Gradle 8.14.4.
- `src/test/java/runner`: runner JUnit 5 que inicia Karate.
- `src/test/java/report`: conversor de JSON Cucumber a reporte HTML.
- `src/test/resources/karate-config.js`: URL base y configuración común.
- `src/test/resources/features`: escenarios Gherkin por dominio.
- `src/test/resources/data`: cuerpos JSON de prueba reutilizables.
- `src/test/resources/schemas`: esquemas para validar respuestas.

## Cómo leer un escenario

Los pasos usan el patrón **Given - When - Then**:

- **Given** prepara la solicitud, como la URL y la ruta.
- **When** envía el método HTTP (`GET`, `POST`, `PUT` o `DELETE`).
- **Then** comprueba el estado, encabezados o JSON que devolvió el servicio.

Karate interpreta los pasos directamente, por lo que para las pruebas normales no se necesita escribir código Java de pegamento.

## API

- Documentación: <https://api.escuelajs.co/docs>
- URL base: `https://api.escuelajs.co/api/v1`

La API es pública y compartida. Las pruebas de creación, actualización y eliminación deben trabajar con registros identificables y borrar los que creen.

## Ruta de aprendizaje y cobertura

1. **Entender el contrato:** revisar en Swagger la ruta, el método, los parámetros y el cuerpo esperado.
2. **Preparar lo común:** `karate-config.js` evita repetir la URL y los encabezados en cada archivo.
3. **Escribir un escenario:** `Given` prepara, `When` envía la petición y `Then` valida el resultado.
4. **Validar estructura y valores:** los archivos de `schemas` describen tipos y campos; los de `data` guardan solicitudes que se reutilizan.
5. **Cubrir casos positivos y negativos:** probar datos válidos, errores previsibles y respuestas vacías.
6. **Leer resultados:** Karate genera su reporte de ejecución y Cucumber convierte el JSON en un resumen HTML.
7. **Versionar:** Git conserva los cambios localmente; GitHub permite compartir el repositorio público que pide la evaluación.

### Conceptos básicos que conviene aprender

- **HTTP:** `GET` consulta, `POST` crea, `PUT` actualiza y `DELETE` elimina.
- **Status code:** resume el resultado de la petición. Por ejemplo, `200` indica éxito, `201` creación y `400` solicitud inválida o recurso inexistente según esta API.
- **JSON:** formato de los cuerpos de solicitud y respuesta. Se valida que campos como `id` sean números y `title` sea texto.
- **Gherkin:** lenguaje legible que organiza cada caso como `Given / When / Then`.
- **Aserción:** comprobación explícita; por ejemplo, `Then status 200` o `match response.id == 1`.
- **Esquema Karate:** un JSON con marcadores como `#number` y `#string` para validar tipos sin fijar datos que cambian.
- **Gradle Wrapper:** scripts del repositorio que descargan la versión fijada de Gradle, evitando que cada persona tenga que instalarla por separado.

### Casos incluidos

- Productos: 5 escenarios.
- Filtros de productos: 6 escenarios, incluyendo un filtro inválido.
- Categorías: 5 escenarios.
- Usuarios: 5 escenarios.

En la API consultada, buscar un ID inexistente devolvió `400` con `EntityNotFoundError`; por eso esos escenarios comprueban esa respuesta. La prueba de filtro inválido también espera `400`.

Los escenarios de creación, actualización y borrado son pruebas activas: al ejecutarlos envían solicitudes a la API pública. Cada escenario crea datos con nombres o correos únicos y luego intenta eliminarlos.

### Hallazgo observado en la API

En la ejecución del 30 de septiembre de 2026, `GET /products?limit=200&price_max=10000` devolvió también productos con precio superior a `10000` (el mayor observado fue `12345`). La prueba `Filtrar productos por precio máximo` conserva esta validación porque representa el comportamiento que el filtro promete; si vuelve a fallar, el resultado documenta una discrepancia de la API pública, no un problema de compilación del proyecto.
