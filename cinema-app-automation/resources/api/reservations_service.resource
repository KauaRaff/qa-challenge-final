*** Settings ***
Documentation        Service Object para operações de reservas
Resource             base_api.resource
Resource             auth_service.resource

*** Variables ***
${RESERVATIONS_ENDPOINT}    /reservations

*** Keywords ***
Criar Reserva
    [Documentation]    Cria uma nova reserva de ingressos
    [Arguments]    ${token}    ${reservation_data}
    
    Criar Sessao da API
    ${headers}=    Criar Headers Com Token    ${token}
    
    Log Request Details    POST    ${RESERVATIONS_ENDPOINT}    ${reservation_data}
    ${response}=    POST On Session    cinema_api    ${RESERVATIONS_ENDPOINT}
    ...    json=${reservation_data}
    ...    headers=${headers}
    ...    expected_status=any
    
    Log Response Details    ${response}
    RETURN    ${response}

Listar Minhas Reservas
    [Documentation]    Lista reservas do usuário autenticado
    [Arguments]    ${token}
    
    Criar Sessao da API
    ${headers}=    Criar Headers Com Token    ${token}
    
    ${endpoint}=    Set Variable    ${RESERVATIONS_ENDPOINT}/me
    Log Request Details    GET    ${endpoint}
    ${response}=    GET On Session    cinema_api    ${endpoint}
    ...    headers=${headers}
    ...    expected_status=any
    
    Log Response Details    ${response}
    RETURN    ${response}

Listar Todas Reservas
    [Documentation]    Lista todas as reservas
    [Arguments]    ${token}
    
    Criar Sessao da API
    ${headers}=    Criar Headers Com Token    ${token}
    
    Log Request Details    GET    ${RESERVATIONS_ENDPOINT}
    ${response}=    GET On Session    cinema_api    ${RESERVATIONS_ENDPOINT}
    ...    headers=${headers}
    ...    expected_status=any
    
    Log Response Details    ${response}
    RETURN    ${response}

Buscar Reserva Por ID
    [Documentation]        Busca uma reserva específica por ID
    [Arguments]    ${token}    ${reservation_id}
    
    Criar Sessao da API
    ${headers}=    Criar Headers Com Token    ${token}
    
    ${endpoint}=    Set Variable    ${RESERVATIONS_ENDPOINT}/${reservation_id}
    Log Request Details    GET    ${endpoint}
    ${response}=    GET On Session    cinema_api    ${endpoint}
    ...    headers=${headers}
    ...    expected_status=any
    
    Log Response Details    ${response}
    RETURN    ${response}

Cancelar Reserva
    [Documentation]        deleta uma reserva
    [Arguments]    ${token}    ${reservation_id}
    
    Criar Sessao da API
    ${headers}=    Criar Headers Com Token    ${token}
    
    ${endpoint}=    Set Variable    ${RESERVATIONS_ENDPOINT}/${reservation_id}
    Log Request Details    DELETE    ${endpoint}
    ${response}=    DELETE On Session    cinema_api    ${endpoint}
    ...    headers=${headers}
    ...    expected_status=any
    
    Log Response Details    ${response}
    RETURN    ${response}

Gerar Dados de Reserva Valida
    [Documentation]    Gera dados para criação de reserva
    [Arguments]    ${session_id}    ${seats_count}=2
    
    # Gera lista de assentos
    ${seats}=    Create List
    FOR    ${i}    IN RANGE    1    ${seats_count + 1}
        Append To List    ${seats}    ${i}
    END
    
    ${reservation_data}=    Create Dictionary
    ...    session=${session_id}
    ...    seats=${seats}
    
    RETURN    ${reservation_data}

Extrair ID Da Reserva
    [Documentation]    Extrai o ID da reserva da resposta
    [Arguments]    ${response_json}
    ${reservation_id}=    Get From Dictionary    ${response_json}    _id
    Should Not Be Empty    ${reservation_id}    msg=ID da reserva não encontrado
    RETURN    ${reservation_id}