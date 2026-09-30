Feature: Usuarios

  Background:
    Given url baseUrl
    * def userSchema = read('classpath:schemas/user.schema.json')

  @users @smoke
  Scenario: Consultar el listado de usuarios
    Given path 'users'
    And param limit = 5
    When method get
    Then status 200
    And match response == '#[]'
    And match each response contains userSchema
    And match header Content-Type contains 'application/json'

  @users
  Scenario: Consultar un usuario existente
    Given path 'users'
    And param limit = 1
    When method get
    Then status 200
    And match response == '#[1]'
    * def userId = response[0].id
    Given path 'users', userId
    When method get
    Then status 200
    And match response contains userSchema
    And match response.id == userId

  @users @create
  Scenario: Crear un usuario válido y eliminarlo
    * def payload = read('classpath:data/user-create.json')
    * set payload.email = 'qa-' + java.lang.System.currentTimeMillis() + '@example.com'
    Given path 'users'
    And request payload
    When method post
    Then status 201
    And match response contains userSchema
    And match response.email == payload.email
    * def userId = response.id
    Given path 'users', userId
    When method delete
    Then status 200

  @users @update
  Scenario: Actualizar un usuario creado para la prueba
    * def payload = read('classpath:data/user-create.json')
    * set payload.email = 'qa-' + java.lang.System.currentTimeMillis() + '@example.com'
    Given path 'users'
    And request payload
    When method post
    Then status 201
    * def userId = response.id
    * set payload.name = 'qa-user-updated-' + userId
    Given path 'users', userId
    And request payload
    When method put
    Then status 200
    And match response.name == payload.name
    Given path 'users', userId
    When method delete
    Then status 200

  @users @negative
  Scenario: Rechazar la consulta de un usuario que no existe
    Given path 'users', 2147483647
    When method get
    Then status 400
    And match response contains { name: 'EntityNotFoundError', message: '#string' }
