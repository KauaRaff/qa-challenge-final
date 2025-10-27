*** Settings ***
Documentation    Testes de criação de reservas na API Cinema
Resource         ../../../resources/api/reservations_service.resource
Resource         ../../../resources/api/movies_service.resource
Suite Setup      Run Keywords
...              Log     Iniciando testes de Criação de Reservas    console=True
...              AND    Preparar Dados Para Testes
Suite Teardown   Log     Testes de Reservas finalizados    console=True

*** Variables ***
${SESSION_ID_VALIDO}    ${EMPTY}
${USER_TOKEN}           ${EMPTY}

*** Test Cases ***
TC_API_024 - Criar reserva para sessao disponivel deve retornar status 201
    [Documentation]    Valida criação de reserva com sucesso
    [Tags]    api    reservations    create    smoke    p0    critical
    
    
    ${reservation_data}=    Gerar Dados de Reserva Valida    ${SESSION_ID_VALIDO}    2
    
    
    ${response}=    Criar Reserva    ${USER_TOKEN}    ${reservation_data}
    
    
    Validar Status Code    ${response}    201
    
    ${response_json}=    Set Variable    ${response.json()}
    Validar Campo Nao Vazio    ${response_json}    _id
    Validar Campo Existe    ${response_json}    session
    Validar Campo Existe    ${response_json}    seats
    Validar Campo Existe    ${response_json}    user
    
    # Valida que os assentos foram reservados
    ${seats}=    Get From Dictionary    ${response_json}    seats
    ${seats_count}=    Get Length    ${seats}
    Should Be Equal As Numbers    ${seats_count}    2

TC_API_024B - Criar reserva com multiplos assentos deve funcionar
    [Documentation]    Valida reserva de múltiplos assentos
    [Tags]    api    reservations    create    p1
    
     
    ${reservation_data}=    Gerar Dados de Reserva Valida    ${SESSION_ID_VALIDO}    5
    
    
    ${response}=    Criar Reserva    ${USER_TOKEN}    ${reservation_data}
    
    
    Validar Status Code    ${response}    201
    ${response_json}=    Set Variable    ${response.json()}
    ${seats}=    Get From Dictionary    ${response_json}    seats
    ${seats_count}=    Get Length    ${seats}
    Should Be Equal As Numbers    ${seats_count}    5

TC_API_025 - Criar reserva para assento ocupado deve retornar status 400
    [Documentation]    Valida que não é possível reservar assento já ocupado
    [Tags]    api    reservations    create    validation    p0
    
    
    ${reservation_data}=    Gerar Dados de Reserva Valida    ${SESSION_ID_VALIDO}    2
    ${first_response}=    Criar Reserva    ${USER_TOKEN}    ${reservation_data}
    Validar Status Code    ${first_response}    201
    
    
    ${second_response}=    Criar Reserva    ${USER_TOKEN}    ${reservation_data}
    
    
    Validar Status Code    ${second_response}    400

TC_API_025B - Criar reserva sem autenticacao deve retornar status 401
    [Documentation]    Valida que reserva requer autenticação
    [Tags]    api    reservations    create    security    p0
    
    
    ${reservation_data}=    Gerar Dados de Reserva Valida    ${SESSION_ID_VALIDO}    1
    
    Criar Sessao da API
    ${headers}=    Criar Headers Padrao
    
    
    ${response}=    POST On Session    cinema_api    ${RESERVATIONS_ENDPOINT}
    ...    json=${reservation_data}
    ...    headers=${headers}
    ...    expected_status=any
    
    
    Validar Status Code    ${response}    401

TC_API_025C - Criar reserva sem informar assentos deve retornar erro
    [Documentation]    Valida validação de campos obrigatórios
    [Tags]    api    reservations    create    validation    p1
    
    
    ${reservation_data}=    Create Dictionary
    ...    session=${SESSION_ID_VALIDO}
    
    
    ${response}=    Criar Reserva    ${USER_TOKEN}    ${reservation_data}
    
    
    Validar Status Code    ${response}    400

TC_API_025D - Criar reserva para sessao inexistente deve retornar erro
    [Documentation]    Valida validação de sessão válida
    [Tags]    api    reservations    create    validation    p1
    
   
    ${reservation_data}=    Gerar Dados de Reserva Valida    507f1f77bcf86cd799439011    1
    
    
    ${response}=    Criar Reserva    ${USER_TOKEN}    ${reservation_data}
    
    
    Validar Status Code    ${response}    404

*** Keywords ***
Preparar Dados Para Testes
    [Documentation]    Prepara dados necessários para os testes (session_id, tokens)
    
    
    ${token}=    Login Como Usuario Comum
    Set Suite Variable    ${USER_TOKEN}    ${token}
    

    Set Suite Variable    ${SESSION_ID_VALIDO}    67890abcdef12345
    
    Log    ⚠️  ATENÇÃO: Usando session_id mockado. Em produção, crie uma sessão real.    console=True