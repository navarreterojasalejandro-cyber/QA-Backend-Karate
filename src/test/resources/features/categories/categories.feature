Feature: Categorías

  Background:
    Given url baseUrl
    * def categorySchema = read('classpath:schemas/category.schema.json')

  @categories @smoke
  Scenario: Consultar el listado de categorías
    Given path 'categories'
    When method get
    Then status 200
    And match response == '#[]'
    And match each response contains categorySchema
    And match header Content-Type contains 'application/json'

  @categories
  Scenario: Consultar una categoría existente
    Given path 'categories', 1
    When method get
    Then status 200
    And match response contains categorySchema
    And match response.id == 1

  @categories @create
  Scenario: Crear una categoría válida y eliminarla
    * def payload = read('classpath:data/category-create.json')
    * set payload.name = 'qa-category-' + java.lang.System.currentTimeMillis()
    Given path 'categories'
    And request payload
    When method post
    Then status 201
    And match response contains categorySchema
    And match response.name == payload.name
    * def categoryId = response.id
    Given path 'categories', categoryId
    When method delete
    Then status 200

  @categories @update
  Scenario: Actualizar una categoría creada para la prueba
    * def payload = read('classpath:data/category-create.json')
    * set payload.name = 'qa-category-' + java.lang.System.currentTimeMillis()
    Given path 'categories'
    And request payload
    When method post
    Then status 201
    * def categoryId = response.id
    * set payload.name = 'qa-category-updated-' + categoryId
    Given path 'categories', categoryId
    And request payload
    When method put
    Then status 200
    And match response.name == payload.name
    Given path 'categories', categoryId
    When method delete
    Then status 200

  @categories @negative
  Scenario: Rechazar la consulta de una categoría inexistente
    Given path 'categories', 2147483647
    When method get
    Then status 400
    And match response contains { name: 'EntityNotFoundError', message: '#string' }
