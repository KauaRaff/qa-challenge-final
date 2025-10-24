*** Settings ***
Documentation    Service Object para operações de token JWT
Resource         base_api.resource
Library          FakerLibrary    locale=pt_BR

*** Variables ***
${AUTH_REGISTER}    /auth/register
${AUTH_LOGIN}       /auth/login
${AUTH_ME}          /auth/me


${ADMIN_EMAIL}      admin@example.com
${ADMIN_PASSWORD}   password123
${USER_EMAIL}       user@example.com
${USER_PASSWORD}    password123

*** Keywords ***
Gerar Dados de Usuario Valido
    [Documentation]       Gera dados aleatórios para cadastro de usuário
    ${random_num}=    Generate Random String    8    [NUMBERS]
    ${name}=    FakerLibrary.Name
    ${email}=    Set Variable    teste_${random_num}@cinema.com
    ${password}=    Set Variable    Senha@123
    
    ${user_data}=    Create Dictionary
    ...    name=${name}
    ...    email=${email}
    ...    password=${password}
    
    RETURN   ${user_data}

Registrar Usuario
    [Documentation]    Registra um novo usuário via API
    [Arguments]    ${user_data}
    
    Criar Sessao da API
    ${headers}=    Criar Headers Padrao
    
    Log Request Details    POST    ${AUTH_REGISTER}    ${user_data}
    ${response}=    POST On Session    cinema_api    ${AUTH_REGISTER}
    ...    json=${user_data}
    ...    headers=${headers}
    ...    expected_status=any
    
    Log Response Details    ${response}
    RETURN    ${response}

Fazer Login
    [Documentation]    Realiza login e retorna a resposta completa
    [Arguments]    ${email}    ${password}
    
    Criar Sessao da API
    ${credentials}=    Create Dictionary
    ...    email=${email}
    ...    password=${password}
    
    ${headers}=    Criar Headers Padrao
    
    Log Request Details    POST    ${AUTH_LOGIN}    ${credentials}
    ${response}=    POST On Session    cinema_api    ${AUTH_LOGIN}
    ...    json=${credentials}
    ...    headers=${headers}
    ...    expected_status=any
    
    Log Response Details    ${response}
    RETURN    ${response}

Obter Perfil do Usuario
    [Documentation]    Obtém dados do perfil do usuário autenticado
    [Arguments]    ${token}
    
    Criar Sessao da API
    ${headers}=    Criar Headers Com Token    ${token}
    
    Log Request Details    GET    ${AUTH_ME}
    ${response}=    GET On Session    cinema_api    ${AUTH_ME}
    ...    headers=${headers}
    ...    expected_status=any
    
    Log Response Details    ${response}
    RETURN   ${response}

Login Como Admin
    [Documentation]    Faz login com usuário admin e retorna o token
    ${response}=    Fazer Login    ${ADMIN_EMAIL}    ${ADMIN_PASSWORD}
    Should Be Equal As Strings    ${response.status_code}    200
    ${response_json}=    Set Variable    ${response.json()}
    ${token}=    Extrair Token Da Resposta    ${response_json}
    RETURN    ${token}

Login Como Usuario Comum
    [Documentation]    Faz login com usuário comum e retorna o token
    ${response}=    Fazer Login    ${USER_EMAIL}    ${USER_PASSWORD}
    Should Be Equal As Strings    ${response.status_code}    200
    ${response_json}=    Set Variable    ${response.json()}
    ${token}=    Extrair Token Da Resposta    ${response_json}
    RETURN        ${token}