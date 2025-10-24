*** Settings ***
Documentation        Testes de perfil de usuário autenticado
Resource             ../../../resources/api/auth_service.resource

*** Variables ***
${ADMIN_TOKEN}    ${EMPTY}

*** Test Cases ***
TC_API_007 - Obter perfil de usuario autenticado deve retornar status 200
    [Documentation]    Valida que usuário autenticado consegue ver seu perfil
    [Tags]    api    auth    profile    smoke    p0
    
    # Faz login e pega token
    ${token}=    Login Como Admin
    Set Suite Variable    ${ADMIN_TOKEN}    ${token}
    

    ${response}=    Obter Perfil do Usuario    ${token}
    
   
    Validar Status Code    ${response}    200
    
    ${response_json}=    Set Variable    ${response.json()}
    Validar Campo Nao Vazio    ${response_json}    _id
    Validar Campo Nao Vazio    ${response_json}    name
    Validar Campo Nao Vazio    ${response_json}    email
    Validar Campo Existe    ${response_json}    role
    
    
    Dictionary Should Not Contain Key    ${response_json}    password
    ...    msg=Senha não deve ser retornada no perfil
    
    # Valida que o e-mail é o correto
    Should Be Equal    ${response_json['email']}    ${ADMIN_EMAIL}

TC_API_008 - Obter perfil sem token deve retornar status 401
    [Documentation]    Valida que endpoint requer autenticação
    [Tags]    api    auth    profile    security    p0
    
   
    Criar Sessao da API
    ${headers}=    Criar Headers Padrao
   
    ${response}=    GET On Session    cinema_api    /auth/me
    ...    headers=${headers}
    ...    expected_status=any
    
    # Assert
    Validar Status Code    ${response}    401

TC_API_008B - Obter perfil com token invalido deve retornar status 401
    [Documentation]    Valida que tokens inválidos são rejeitados
    [Tags]    api    auth    profile    security    p1
    
    
    ${response}=    Obter Perfil do Usuario    token_fake_invalido_123
    
    
    Validar Status Code    ${response}    401

TC_API_008C - Obter perfil de usuario comum deve funcionar
    [Documentation]    Valida que usuários comuns também conseguem ver seu perfil
    [Tags]    api    auth    profile    p1
    
    
    ${token}=    Login Como Usuario Comum
    
   
    ${response}=    Obter Perfil do Usuario    ${token}
    
   
    Validar Status Code    ${response}    200
    ${response_json}=    Set Variable    ${response.json()}
    Should Be Equal    ${response_json['email']}    ${USER_EMAIL}

TC_API_008D - Token obtido no registro deve funcionar para obter perfil
    [Documentation]    Valida que token retornado no registro é válido
    [Tags]    api    auth    profile    integration    p1
    
    ${user_data}=    Gerar Dados de Usuario Valido
    ${register_response}=    Registrar Usuario    ${user_data}
    Validar Status Code    ${register_response}    201
    
    
    ${register_json}=    Set Variable    ${register_response.json()}
    ${token}=    Extrair Token Da Resposta    ${register_json}
    
    
    ${response}=    Obter Perfil do Usuario    ${token}
    
 
    Validar Status Code    ${response}    200
    ${response_json}=    Set Variable    ${response.json()}
    Should Be Equal    ${response_json['email']}    ${user_data['email']}