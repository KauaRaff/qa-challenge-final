*** Settings ***
Documentation    Testes de login de usuários na API após liberação do jwt
Resource         ../../../resources/api/auth_service.resource
Suite Setup      Log     Iniciando testes de Login    console=True
Suite Teardown   Log     Testes de Login finalizados    console=True

*** Test Cases ***
TC_API_005 - Login com credenciais validas deve retornar status 200 e token JWT
    [Documentation]    Valida que é possível fazer login com credenciais corretas
    [Tags]    api    auth    login    smoke    p0    critical
    
    # Faz login com usuário pré cadastrado
    ${response}=    Fazer Login    ${ADMIN_EMAIL}    ${ADMIN_PASSWORD}
    
    
    Validar Status Code    ${response}    200
    
    ${response_json}=    Set Variable    ${response.json()}
    Validar Campo Nao Vazio    ${response_json}    token
    Validar Campo Nao Vazio    ${response_json}    user
    
   
    ${user}=    Get From Dictionary    ${response_json}    user
    Should Be Equal    ${user['email']}    ${ADMIN_EMAIL}
    Validar Campo Nao Vazio    ${user}    _id
    Validar Campo Nao Vazio    ${user}    name
    Validar Campo Existe    ${user}    role
    
    # Valida que token é uma string não vazia
    ${token}=    Get From Dictionary    ${response_json}    token
    ${token_length}=    Get Length    ${token}
    Should Be True    ${token_length} > 20    msg=Token JWT parece muito curto

TC_API_006 - Login com credenciais invalidas deve retornar status 401
    [Documentation]    Valida que login com senha incorreta é rejeitado
    [Tags]    api    auth    login    security    p0
    
    # Tenta login com senha errada
    ${response}=    Fazer Login    ${ADMIN_EMAIL}    senha_errada_123
    
    
    Validar Status Code    ${response}    401
    ${response_json}=    Set Variable    ${response.json()}
    Validar Mensagem de Erro    ${response_json}    inválid

TC_API_006B - Login com email inexistente deve retornar status 401
    [Documentation]    Valida que login com e-mail não cadastrado é rejeitado
    [Tags]    api    auth    login    security    p1
    
    
    ${response}=    Fazer Login    email_nao_existe@cinema.com    ${ADMIN_PASSWORD}
    
  
    Validar Status Code    ${response}    401

TC_API_006C - Login de usuario comum deve funcionar corretamente
    [Documentation]    Valida que usuários não-admin também conseguem fazer login
    [Tags]    api    auth    login    smoke    p0
    
    
    ${response}=    Fazer Login    ${USER_EMAIL}    ${USER_PASSWORD}
    
    
    Validar Status Code    ${response}    200
    ${response_json}=    Set Variable    ${response.json()}
    Validar Campo Nao Vazio    ${response_json}    token
    
    # Valida que o e-mail está correto
    ${user}=    Get From Dictionary    ${response_json}    user
    Should Be Equal    ${user['email']}    ${USER_EMAIL}