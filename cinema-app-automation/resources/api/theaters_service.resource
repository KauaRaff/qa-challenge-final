*** Settings ***
Documentation    Service Object para operações de teatros/salas de cinema
Resource         base_api.resource
Resource         auth_service.resource

*** Variables ***
${THEATERS_ENDPOINT}    /theaters

*** Keywords ***
Gerar Dados de Teatro Valido
    [Documentation]    Gera dados aleatórios para criação de teatro
    ${random_num}=    Generate Random String    3    [NUMBERS]
    ${types}=    Create List    2D    3D    IMAX    4DX    VIP
    ${random_type}=    Evaluate    random.choice($types)    random
    ${capacity}=    Evaluate    random.randint(50, 200)    random
    
    ${theater_data}=    Create Dictionary
    ...    name=Sala ${random_num}
    ...    capacity=${capacity}
    ...    type=${random_type}
    
    RETURN    ${theater_data}

Listar Todos os Teatros
    [Documentation]    Lista todos os teatros cadastrados
    
    Criar Sessao da API
    ${headers}=    Criar Headers Padrao
    
    Log Request Details    GET    ${THEATERS_ENDPOINT}
    ${response}=    GET On Session    cinema_api    ${THEATERS_ENDPOINT}
    ...    headers=${headers}
    ...    expected_status=any
    
    Log Response Details    ${response}
    RETURN    ${response}

Buscar Teatro Por ID
    [Documentation]    Busca um teatro específico por ID
    [Arguments]    ${theater_id}
    
    Criar Sessao da API
    ${headers}=    Criar Headers Padrao
    
    ${endpoint}=    Set Variable    ${THEATERS_ENDPOINT}/${theater_id}
    Log Request Details    GET    ${endpoint}
    ${response}=    GET On Session    cinema_api    ${endpoint}
    ...    headers=${headers}
    ...    expected_status=any
    
    Log Response Details    ${response}
    RETURN    ${response}

Criar Teatro
    [Documentation]    Cria um novo teatro (requer autenticação admin)
    [Arguments]    ${token}    ${theater_data}
    
    Criar Sessao da API
    ${headers}=    Criar Headers Com Token    ${token}
    
    Log Request Details    POST    ${THEATERS_ENDPOINT}    ${theater_data}
    ${response}=    POST On Session    cinema_api    ${THEATERS_ENDPOINT}
    ...    json=${theater_data}
    ...    headers=${headers}
    ...    expected_status=any
    
    Log Response Details    ${response}
    RETURN    ${response}

Atualizar Teatro
    [Documentation]    Atualiza um teatro existente (requer autenticação admin)
    [Arguments]    ${token}    ${theater_id}    ${theater_data}
    
    Criar Sessao da API
    ${headers}=    Criar Headers Com Token    ${token}
    
    ${endpoint}=    Set Variable    ${THEATERS_ENDPOINT}/${theater_id}
    Log Request Details    PUT    ${endpoint}    ${theater_data}
    ${response}=    PUT On Session    cinema_api    ${endpoint}
    ...    json=${theater_data}
    ...    headers=${headers}
    ...    expected_status=any
    
    Log Response Details    ${response}
    RETURN    ${response}

Deletar Teatro
    [Documentation]    Deleta um teatro (requer autenticação admin)
    [Arguments]    ${token}    ${theater_id}
    
    Criar Sessao da API
    ${headers}=    Criar Headers Com Token    ${token}
    
    ${endpoint}=    Set Variable    ${THEATERS_ENDPOINT}/${theater_id}
    Log Request Details    DELETE    ${endpoint}
    ${response}=    DELETE On Session    cinema_api    ${endpoint}
    ...    headers=${headers}
    ...    expected_status=any
    
    Log Response Details    ${response}
    RETURN    ${response}

Extrair ID Do Teatro
    [Documentation]    Extrai o ID do teatro da resposta
    [Arguments]    ${response_json}
    ${theater_id}=    Get From Dictionary    ${response_json}    _id
    Should Not Be Empty    ${theater_id}    msg=ID do teatro não encontrado
    RETURN    ${theater_id}
