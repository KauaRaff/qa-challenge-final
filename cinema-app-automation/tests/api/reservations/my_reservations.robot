*** Settings ***
Documentation    Testes de listagem de reservas do usuário
Resource         ../../../resources/api/reservations_service.resource
Suite Setup      Run Keywords
...              Log     Iniciando testes de Minhas Reservas    console=True
...              AND    Obter Tokens
Suite Teardown   Log     Testes de Minhas Reservas finalizados    console=True

*** Variables ***
${USER_TOKEN}     ${EMPTY}
${ADMIN_TOKEN}    ${EMPTY}

*** Test Cases ***
TC_API_026 - Listar minhas reservas deve retornar status 200
    [Documentation]    Valida que usuário consegue ver suas próprias reservas
    [Tags]    api    reservations    list    smoke    p0
    
    
    ${response}=    Listar Minhas Reservas    ${USER_TOKEN}
    
    
    Validar Status Code    ${response}    200
    
    ${response_json}=    Set Variable    ${response.json()}
    
    
    ${is_list}=    Evaluate    isinstance($response_json, list)
    Should Be True    ${is_list}    msg=Resposta deveria ser um array de reservas

TC_API_026B - Listar minhas reservas sem autenticacao deve retornar status 401
    [Documentation]    Valida que endpoint requer autenticação
    [Tags]    api    reservations    list    security    p0
    
    
    Criar Sessao da API
    ${headers}=    Criar Headers Padrao
    
    
    ${response}=    GET On Session    cinema_api    ${RESERVATIONS_ENDPOINT}/me
    ...    headers=${headers}
    ...    expected_status=any
    
    
    Validar Status Code    ${response}    401

TC_API_027 - Listar todas reservas como admin deve retornar status 200
    [Documentation]    Valida que admin consegue ver todas as reservas do sistema
    [Tags]    api    reservations    list    admin    p1
    
    
    ${response}=    Listar Todas Reservas    ${ADMIN_TOKEN}
    
    
    Validar Status Code    ${response}    200
    
    ${response_json}=    Set Variable    ${response.json()}
    ${is_list}=    Evaluate    isinstance($response_json, list)
    Should Be True    ${is_list}    msg=Resposta deveria ser um array de reservas

TC_API_027B - Listar todas reservas como usuario comum deve retornar status 403
    [Documentation]    Valida que usuários comuns não podem ver todas as reservas
    [Tags]    api    reservations    list    security    permissions    p1
    
    
    ${response}=    Listar Todas Reservas    ${USER_TOKEN}
    
    
    Validar Status Code    ${response}    403

*** Keywords ***
Obter Tokens
    [Documentation]    Obtém tokens de user e admin para os testes
    ${user_token}=    Login Como Usuario Comum
    ${admin_token}=    Login Como Admin
    Set Suite Variable    ${USER_TOKEN}    ${user_token}
    Set Suite Variable    ${ADMIN_TOKEN}    ${admin_token}