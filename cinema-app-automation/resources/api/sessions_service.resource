*** Settings ***
Documentation    Service Object para operações de sessões de cinema
Resource         base_api.resource
Resource         auth_service.resource
Library          DateTime

*** Variables ***
${SESSIONS_ENDPOINT}        /sessions

*** Keywords ***
Gerar Dados de Sessao Valida
    [Documentation]        Gera dados aleatórios para criação de sessão
    [Arguments]        ${movie_id}    ${theater_id}
        
    
    ${tomorrow}=    Get Current Date    increment=1 day
    ${date}=    Convert Date    ${tomorrow}    result_format=%Y-%m-%d
    ${time}=    Set Variable    20:00
    
    ${price}=    Evaluate    random.uniform(20.0, 50.0)    random
    ${price_rounded}=    Evaluate    round(${price}, 2)
    
    ${session_data}=    Create Dictionary
    ...    movie=${movie_id}
    ...    theater=${theater_id}
    ...    date=${date}
    ...    time=${time}
    ...    price=${price_rounded}
    
    RETURN    ${session_data}

Listar Todas as Sessoes
    [Documentation]        Lista todas as sessões disponíveis
    
    Criar Sessao da API
    ${headers}=    Criar Headers Padrao
    
    Log Request Details    GET    ${SESSIONS_ENDPOINT}
    ${response}=    GET On Session    cinema_api    ${SESSIONS_ENDPOINT}
    ...    headers=${headers}
    ...    expected_status=any
    
    Log Response Details    ${response}
    RETURN    ${response}

Buscar Sessao Por ID
    [Documentation]    Busca uma sessão por ID
    [Arguments]    ${session_id}
    
    Criar Sessao da API
    ${headers}=    Criar Headers Padrao
    
    ${endpoint}=    Set Variable        ${SESSIONS_ENDPOINT}/${session_id}
    Log Request Details        GET        ${endpoint}
    ${response}=    GET On Session    cinema_api    ${endpoint}
    ...    headers=${headers}
    ...    expected_status=any
    
    Log Response Details    ${response}
    RETURN    ${response}

Criar Sessao
    [Documentation]    Cria uma nova sessão (requer autenticação admin)
    [Arguments]    ${token}    ${session_data}
    
    Criar Sessao da API
    ${headers}=    Criar Headers Com Token    ${token}
    
    Log Request Details    POST    ${SESSIONS_ENDPOINT}    ${session_data}
    ${response}=    POST On Session    cinema_api    ${SESSIONS_ENDPOINT}
    ...    json=${session_data}
    ...    headers=${headers}
    ...    expected_status=any
    
    Log Response Details    ${response}
    RETURN    ${response}

Atualizar Sessao
    [Documentation]    Atualiza uma sessão ja criada
    [Arguments]    ${token}    ${session_id}    ${session_data}
    
    Criar Sessao da API
    ${headers}=    Criar Headers Com Token    ${token}
    
    ${endpoint}=    Set Variable    ${SESSIONS_ENDPOINT}/${session_id}
    Log Request Details    PUT    ${endpoint}    ${session_data}
    ${response}=    PUT On Session    cinema_api    ${endpoint}
    ...    json=${session_data}
    ...    headers=${headers}
    ...    expected_status=any
    
    Log Response Details    ${response}
    RETURN    ${response}

Deletar Sessao
    [Documentation]    Deleta uma sessão
    [Arguments]        ${token}        ${session_id}
    
    Criar Sessao da API
    ${headers}=    Criar Headers Com Token    ${token}
    
    ${endpoint}=    Set Variable    ${SESSIONS_ENDPOINT}/${session_id}
    Log Request Details    DELETE    ${endpoint}
    ${response}=    DELETE On Session    cinema_api    ${endpoint}
    ...    headers=${headers}
    ...    expected_status=any
    
    Log Response Details    ${response}
    RETURN    ${response}

Extrair ID Da Sessao
    [Documentation]    pega o ID da sessão
    [Arguments]    ${response_json}
    ${session_id}=    Get From Dictionary    ${response_json}    _id
    Should Not Be Empty    ${session_id}    msg=ID da sessão não encontrado
    RETURN    ${session_id}