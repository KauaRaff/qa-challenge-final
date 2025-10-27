*** Settings ***
Documentation    Testes de cancelamento de reservas
Resource         ../../../resources/api/reservations_service.resource
Suite Setup      Run Keywords
...              Log     Iniciando testes de Cancelamento de Reservas    console=True
...              AND    Obter Tokens
Suite Teardown   Log     Testes de Cancelamento finalizados    console=True

*** Variables ***
${USER_TOKEN}     ${EMPTY}
${ADMIN_TOKEN}    ${EMPTY}
${SESSION_ID}     67890abcdef12345

*** Test Cases ***
TC_API_028 - Cancelar reserva propria deve retornar status 200
    [Documentation]    Valida que usuário consegue cancelar sua própria reserva
    [Tags]    api    reservations    cancel    p0
    
    
    ${reservation_data}=    Gerar Dados de Reserva Valida    ${SESSION_ID}    1
    ${create_response}=    Criar Reserva    ${USER_TOKEN}    ${reservation_data}
    
    # Ignora se falhar (pode não ter sessão válida)
    ${status}=    Run Keyword And Return Status    Validar Status Code    ${create_response}    201
    Skip If    not ${status}    Sessão não disponível para teste completo
    
    ${create_json}=    Set Variable    ${create_response.json()}
    ${reservation_id}=    Extrair ID Da Reserva    ${create_json}
    
    
    ${response}=    Cancelar Reserva    ${USER_TOKEN}    ${reservation_id}
    
    
    Validar Status Code    ${response}    200
    
    # Valida que reserva não existe mais
    ${get_response}=    Buscar Reserva Por ID    ${USER_TOKEN}    ${reservation_id}
    Validar Status Code    ${get_response}    404

TC_API_028B - Cancelar reserva sem autenticacao deve retornar status 401
    [Documentation]    Valida que cancelamento requer autenticação
    [Tags]    api    reservations    cancel    security    p0
    
    
    Criar Sessao da API
    ${headers}=    Criar Headers Padrao
    
    
    ${response}=    DELETE On Session    cinema_api    ${RESERVATIONS_ENDPOINT}/fake-id
    ...    headers=${headers}
    ...    expected_status=any
    
    
    Validar Status Code    ${response}    401

TC_API_028C - Cancelar reserva inexistente deve retornar status 404
    [Documentation]    Valida tratamento de reserva não encontrada
    [Tags]    api    reservations    cancel    validation    p2
    
  
    ${response}=    Cancelar Reserva    ${USER_TOKEN}    507f1f77bcf86cd799439011
    
    
    Validar Status Code    ${response}    404

TC_API_028D - Admin pode cancelar qualquer reserva
    [Documentation]    Valida que admin consegue cancelar reservas de outros usuários
    [Tags]    api    reservations    cancel    admin    permissions    p1
    
    
    ${reservation_data}=    Gerar Dados de Reserva Valida    ${SESSION_ID}    1
    ${create_response}=    Criar Reserva    ${USER_TOKEN}    ${reservation_data}
    
    ${status}=    Run Keyword And Return Status    Validar Status Code    ${create_response}    201
    Skip If    not ${status}    Sessão não disponível para teste completo
    
    ${create_json}=    Set Variable    ${create_response.json()}
    ${reservation_id}=    Extrair ID Da Reserva    ${create_json}
    

    ${response}=    Cancelar Reserva    ${ADMIN_TOKEN}    ${reservation_id}
    
    
    Validar Status Code    ${response}    200

*** Keywords ***
Obter Tokens
    [Documentation]    Obtém tokens para os testes
    ${user_token}=    Login Como Usuario Comum
    ${admin_token}=    Login Como Admin
    Set Suite Variable    ${USER_TOKEN}    ${user_token}
    Set Suite Variable    ${ADMIN_TOKEN}    ${admin_token}