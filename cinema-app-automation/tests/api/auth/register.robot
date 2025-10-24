*** Settings ***
Documentation            Testes de registro de usuários no Cinema APP
Resource             ../../../resources/api/auth_service.resource
Suite Setup          Log    Iniciando testes de Registro    console=True
Suite Teardown       Log     Testes de Registro finalizados    console=True

*** Test Cases ***
TC_API_001 - Registrar usuario com dados validos deve retornar status 201
    [Documentation]    Valida que é possível registrar um novo usuário com dados válidos
    [Tags]    api    auth    register    
    
    #gera dados válidos
    ${user_data}=    Gerar Dados de Usuario Valido
    
    #registra o usuário
    ${response}=    Registrar Usuario    ${user_data}
    

    Validar Status Code    ${response}    201
    
    ${response_json}=    Set Variable    ${response.json()}
    Validar Campo Nao Vazio    ${response_json}    token
    Validar Campo Nao Vazio    ${response_json}    user
    
    # Valida dados do usuário retornado
    ${user}=    Get From Dictionary    ${response_json}    user
    Should Be Equal    ${user['email']}    ${user_data['email']}
    Should Be Equal    ${user['name']}    ${user_data['name']}
    Dictionary Should Not Contain Key    ${user}    password    
    ...    msg=Senha não deve ser retornada na resposta

TC_API_002 - Registrar usuario com email duplicado deve retornar status 400
    [Documentation]    Valida que não é possível registrar usuário com e-mail já cadastrado
    [Tags]    api    auth    register    validation    p0
    
    # Arrange - Registra um usuário primeiro
    ${user_data}=    Gerar Dados de Usuario Valido
    ${first_response}=    Registrar Usuario    ${user_data}
    Validar Status Code    ${first_response}    201
    
    # Act - Tenta registrar novamente com mesmo e-mail
    ${second_response}=    Registrar Usuario    ${user_data}
    
    # Assert - Valida que retorna erro
    Validar Status Code    ${second_response}    400

TC_API_003 - Registrar usuario com email invalido deve retornar status 400
    [Documentation]    Valida que e-mails inválidos são rejeitados
    [Tags]    api    auth    register    validation    p1
    
    ${user_data}=    Create Dictionary
    ...    name=Usuario Teste
    ...    email=email_sem_arroba.com
    ...    password=Senha@123
    
   
    ${response}=    Registrar Usuario    ${user_data}
    

    Validar Status Code    ${response}    400

TC_API_004 - Registrar usuario sem campos obrigatorios deve retornar status 400
    [Documentation]    Valida que todos os campos obrigatórios são validados
    [Tags]    api    auth    register    validation    p1

    ${user_data_sem_name}=    Create Dictionary
    ...    email=teste@cinema.com
    ...    password=Senha@123
    
    ${response}=    Registrar Usuario    ${user_data_sem_name}
    Validar Status Code    ${response}    400
    
    ${user_data_sem_email}=    Create Dictionary
    ...    name=Usuario Teste
    ...    password=Senha@123
    
    ${response}=    Registrar Usuario    ${user_data_sem_email}
    Validar Status Code    ${response}    400
    
    ${user_data_sem_password}=    Create Dictionary
    ...    name=Usuario Teste
    ...    email=teste2@cinema.com
    
    ${response}=    Registrar Usuario    ${user_data_sem_password}
    Validar Status Code    ${response}    400

TC_API_004B - Registrar usuario com senha curta deve retornar erro
    [Documentation]    Valida que senhas muito curtas são rejeitadas
    [Tags]    api    auth    register    validation    p2
    
    # Arrange
    ${user_data}=    Gerar Dados de Usuario Valido
    Set To Dictionary    ${user_data}    password=123
    
    # Act
    ${response}=    Registrar Usuario    ${user_data}
    
    # Assert
    Validar Status Code    ${response}    400

TC_API_004C - Registrar usuario com nome vazio deve retornar erro
    [Documentation]    Valida validação de nome obrigatório
    [Tags]    api    auth    register    validation    p2
    
    # Arrange
    ${user_data}=    Create Dictionary
    ...    name=${EMPTY}
    ...    email=teste_vazio@cinema.com
    ...    password=Senha@123
    
    # Act
    ${response}=    Registrar Usuario    ${user_data}
    
    # Assert
    Validar Status Code    ${response}    400