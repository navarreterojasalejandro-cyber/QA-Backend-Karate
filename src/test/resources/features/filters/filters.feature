Feature: Filtros de productos

  Background:
    Given url baseUrl

  @filters
  Scenario: Filtrar productos por categoría
    Given path 'products'
    And param categoryId = 1
    When method get
    Then status 200
    And match response == '#[]'
    And match each response[*].category.id == 1

  @filters
  Scenario: Filtrar productos por precio mínimo
    Given path 'products'
    And param price_min = 1
    When method get
    Then status 200
    And match response == '#[]'
    And match each response[*].price == '#? _ >= 1'

  @filters
  Scenario: Filtrar productos por precio máximo
    Given path 'products'
    And param price_max = 10000
    When method get
    Then status 200
    And match response == '#[]'
    And match each response[*].price == '#? _ <= 10000'

  @filters @create
  Scenario: Encontrar un producto por su título exacto
    * def payload = read('classpath:data/product-create.json')
    * set payload.title = 'qa-filter-' + java.lang.System.currentTimeMillis()
    Given path 'products'
    And request payload
    When method post
    Then status 201
    * def productId = response.id
    * def title = response.title
    Given path 'products'
    And param title = title
    When method get
    Then status 200
    And match response == '#[]'
    And match response[*].title contains title
    Given path 'products', productId
    When method delete
    Then status 200

  @filters @negative
  Scenario: Un título inexistente devuelve una lista vacía
    Given path 'products'
    And param title = 'qa-no-existe-' + java.lang.System.currentTimeMillis()
    When method get
    Then status 200
    And match response == []

  @filters @negative
  Scenario: Rechazar un identificador de categoría que no es numérico
    Given path 'products'
    And param categoryId = 'no-es-numero'
    When method get
    Then status 400
    And match response contains { error: 'Bad Request', statusCode: 400 }
