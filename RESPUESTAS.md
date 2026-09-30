# Respuestas

**a. ¿Cuáles fueron los principales desafíos?**

La API es pública y sus datos pueden cambiar. Un producto con ID `1` ya no estaba disponible, así que hice que la prueba obtuviera un producto existente antes de consultar su detalle. También encontré que la API no aplica el filtro `price_max` como se esperaba.

**b. ¿Qué técnicas de prueba y enfoque se usaron?**

Usé pruebas funcionales positivas y negativas, consultas de filtros y escenarios CRUD. Organicé los casos con Gherkin por productos, filtros, categorías y usuarios, y dejé los datos y esquemas en archivos reutilizables.

**c. ¿Cómo se validaron los datos y la estructura JSON?**

Cada escenario comprueba el estado HTTP y valida los campos y tipos de la respuesta con esquemas Karate. También se revisan headers y valores importantes, como el título, precio o identificador.

**d. ¿Qué aprendí?**

Aprendí a convertir el comportamiento esperado de una API en escenarios automáticos y a distinguir un error de la prueba de una discrepancia del servicio. El caso de `price_max` muestra que un resultado fallido también puede aportar evidencia útil para QA.
