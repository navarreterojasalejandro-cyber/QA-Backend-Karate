Feature: Productos

  Background:
    Given url baseUrl
    * def productSchema = read('classpath:schemas/product.schema.json')

  @products @smoke
  Scenario: Consultar el listado de productos
    Given path 'products'
    And param limit = 5
    When method get
    Then status 200
    And match response == '#[]'
    And match each response contains productSchema
    And match header Content-Type contains 'application/json'

  @products
  Scenario: Consultar un producto existente
    Given path 'products'
    When method get
    Then status 200
    And match response == '#[]'
    And assert response.length > 0
    * def productId = response[0].id
    Given path 'products', productId
    When method get
    Then status 200
    And match response contains productSchema
    And match response.id == productId

  @products @create
  Scenario: Crear un producto válido y eliminarlo al terminar
    * def payload = read('classpath:data/product-create.json')
    * set payload.title = 'qa-product-' + java.lang.System.currentTimeMillis()
    Given path 'products'
    And request payload
    When method post
    Then status 201
    And match response contains productSchema
    And match response.title == payload.title
    * def productId = response.id
    Given path 'products', productId
    When method delete
    Then status 200

  @products @update
  Scenario: Actualizar un producto creado para la prueba
    * def payload = read('classpath:data/product-create.json')
    * set payload.title = 'qa-product-' + java.lang.System.currentTimeMillis()
    Given path 'products'
    And request payload
    When method post
    Then status 201
    * def productId = response.id
    * set payload.title = 'qa-product-updated-' + productId
    Given path 'products', productId
    And request payload
    When method put
    Then status 200
    And match response.title == payload.title
    Given path 'products', productId
    When method delete
    Then status 200

  @products @negative
  Scenario: Rechazar la consulta de un producto que no existe
    Given path 'products', 2147483647
    When method get
    Then status 400
    And match response contains { name: 'EntityNotFoundError', message: '#string' }
