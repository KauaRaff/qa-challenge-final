*** Settings ***
Documentation    Service Object base para requisições da API Cinema
Library          RequestsLibrary
Library          Collections
Library          String

*** Variables ***
${BASE_URL}              http://localhost:3000/api/v1
${CONTENT_TYPE}          application/json

*** Keywords ***
Criar Sessao da API
    [Documentation]    Cria uma sessão HTTP para a API
    Create Session    cinema_api    ${BASE_URL}    verify=False
    
Criar Headers Padrao
    [Documentation]    Cria headers padrão para requisições
    ${headers}=    Create Dictionary
    ...    Content-Type=${CONTENT_TYPE}
    RETURN    ${headers}

Criar Headers Com Token
    [Documentation]    Cria headers com token JWT de autenticação
    [Arguments]    ${token}
    ${headers}=    Create Dictionary
    ...    Content-Type=${CONTENT_TYPE}
    ...    Authorization=Bearer ${token}
    RETURN   ${headers}

Validar Status Code
    [Documentation]    Valida o status code da resposta
    [Arguments]    ${response}    ${expected_status}
    Should Be Equal As Strings    ${response.status_code}    ${expected_status}
    ...    msg=Status code esperado: ${expected_status}, recebido: ${response.status_code}

Validar Campo Existe
    [Documentation]    Valida que um campo existe no JSON de resposta
    [Arguments]    ${response_json}    ${field}
    Dictionary Should Contain Key    ${response_json}    ${field}
    ...    msg=Campo '${field}' não encontrado na resposta

Validar Campo Nao Vazio
    [Documentation]    Valida que um campo existe e não está vazio
    [Arguments]    ${response_json}    ${field}
    Validar Campo Existe    ${response_json}    ${field}
    ${value}=    Get From Dictionary    ${response_json}    ${field}
    Should Not Be Empty    ${value}    msg=Campo '${field}' está vazio

Validar Mensagem de Erro
    [Documentation]    Valida que a resposta contém uma mensagem de erro esperada
    [Arguments]    ${response_json}    ${expected_message}
    ${message}=    Get From Dictionary    ${response_json}    message
    Should Contain    ${message}    ${expected_message}    ignore_case=True
    ...    msg=Mensagem esperada '${expected_message}' não encontrada. Recebida: ${message}

Extrair Token Da Resposta
    [Documentation]    Extrai o token JWT da resposta de login/registro
    [Arguments]    ${response_json}
    ${token}=    Get From Dictionary    ${response_json}    token
    Should Not Be Empty    ${token}    msg=Token não encontrado na resposta
    RETURN        ${token}

Log Request Details
    [Documentation]    Loga detalhes da requisição para debug
    [Arguments]    ${method}    ${endpoint}    ${body}=${EMPTY}
    Log    🔵 REQUEST: ${method} ${endpoint}    console=True
    Run Keyword If    '${body}' != '${EMPTY}'    Log     Body: ${body}    console=True

Log Response Details
    [Documentation]    Loga detalhes da resposta para debug
    [Arguments]    ${response}
    Log         RESPONSE: Status ${response.status_code}    console=True
    Log         Body: ${response.text}    console=True