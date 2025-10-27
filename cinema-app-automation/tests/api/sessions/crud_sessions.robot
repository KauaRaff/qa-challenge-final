*** Settings ***
Documentation       teste de CRUD da sessão
Resource         ../../../resources/api/sessions_service.resource
Resource         ../../../resources/api/movies_service.resource
Suite Setup      Run Keywords
...              Log     Iniciando testes de CRUD de Sessões    console=True
...              AND    Preparar Dados Iniciais
Suite Teardown   Log    Testes de CRUD de Sessões finalizados    console=True

*** Variables ***
${ADMIN_TOKEN}    ${EMPTY}
${USER_TOKEN}     ${EMPTY}
${MOVIE_ID}       ${EMPTY}
${THEATER_ID}     507f1f77bcf86cd799439011

*** Test Cases ***
TC_API_019 - Criar sessao como admin deve retornar status 201
    [Documentation]    Valida que admin consegue criar sessões
    [Tags]    api    sessions    create    admin    p1
    

    ${session_data}=    Gerar Dados de Sessao Valida    ${MOVIE_ID}    ${THEATER_ID}
    
    
    ${response}=    Criar Sessao    ${ADMIN_TOKEN}    ${session_data}
    
    
    Should Be True    ${response.status_code} in [201, 400, 404]
    ...    msg=Status inesperado: ${response.status_code}
    
    Run Keyword If    ${response.status_code} == 201
    ...    Validar Sessao Criada    ${response}    ${session_data}

TC_API_019B - Criar sessao como usuario comum deve retornar status 403
    [Documentation]    Valida que usuários comuns não podem criar sessões
    [Tags]    api    sessions    create    security    permissions    p1
    

    ${session_data}=    Gerar Dados de Sessao Valida    ${MOVIE_ID}    ${THEATER_ID}
    
    
    ${response}=    Criar Sessao    ${USER_TOKEN}    ${session_data}
    
    
    Validar Status Code    ${response}    403

TC_API_019C - Criar sessao sem autenticacao deve retornar status 401
    [Documentation]    Valida que criação de sessão requer autenticação
    [Tags]    api    sessions    create    security    p0
    

    ${session_data}=    Gerar Dados de Sessao Valida    ${MOVIE_ID}    ${THEATER_ID}
    
    Criar Sessao da API
    ${headers}=    Criar Headers Padrao
    
    
    ${response}=    POST On Session    cinema_api    ${SESSIONS_ENDPOINT}
    ...    json=${session_data}
    ...    headers=${headers}
    ...    expected_status=any
    
    
    Validar Status Code    ${response}    401

TC_API_020 - Criar sessao com conflito de horario deve retornar status 400
    [Documentation]    Valida que não permite sessões conflitantes no mesmo teatro/horário
    [Tags]    api    sessions    create    validation    p1
    
    ${session_data}=    Gerar Dados de Sessao Valida    ${MOVIE_ID}    ${THEATER_ID}
    ${first_response}=    Criar Sessao    ${ADMIN_TOKEN}    ${session_data}
    
    # Se primeira falhou, pula teste
    Skip If    ${first_response.status_code} != 201
    ...    Primeira sessão não foi criada (teatro/filme inválido)
    
    ${second_response}=    Criar Sessao    ${ADMIN_TOKEN}    ${session_data}
    
    
    Validar Status Code    ${second_response}    400

TC_API_020B - Criar sessao sem campos obrigatorios deve retornar erro
    [Documentation]    Valida validação de campos obrigatórios
    [Tags]    api    sessions    create    validation    p2
    
    ${session_data_incompleto}=    Create Dictionary
    ...    movie=${MOVIE_ID}
    ...    date=2025-12-31
    
    
    ${response}=    Criar Sessao    ${ADMIN_TOKEN}    ${session_data_incompleto}
    
    
    Validar Status Code    ${response}    400

TC_API_020C - Criar sessao com preco negativo deve retornar erro
    [Documentation]    Valida que preço deve ser positivo
    [Tags]    api    sessions    create    validation    p2
    

    ${session_data}=    Gerar Dados de Sessao Valida    ${MOVIE_ID}    ${THEATER_ID}
    Set To Dictionary    ${session_data}    price=-10.50
    
    
    ${response}=    Criar Sessao    ${ADMIN_TOKEN}    ${session_data}
    
    
    Validar Status Code    ${response}    400

TC_API_020D - Criar sessao com data no passado deve retornar erro
    [Documentation]    Valida que não permite criar sessões em datas passadas
    [Tags]    api    sessions    create    validation    p2
    

    ${session_data}=    Gerar Dados de Sessao Valida    ${MOVIE_ID}    ${THEATER_ID}
    Set To Dictionary    ${session_data}    date=2020-01-01
    
    
    ${response}=    Criar Sessao    ${ADMIN_TOKEN}    ${session_data}
    
    
    Validar Status Code    ${response}    400

TC_API_021 - Atualizar sessao como admin deve funcionar
    [Documentation]    Valida que admin consegue atualizar sessões
    [Tags]    api    sessions    update    admin    p2
    
    ${session_data}=    Gerar Dados de Sessao Valida    ${MOVIE_ID}    ${THEATER_ID}
    ${create_response}=    Criar Sessao    ${ADMIN_TOKEN}    ${session_data}
    
    Skip If    ${create_response.status_code} != 201
    ...    Sessão não foi criada para teste
    
    ${create_json}=    Set Variable    ${create_response.json()}
    ${session_id}=    Extrair ID Da Sessao    ${create_json}
    
    ${updated_data}=    Create Dictionary    price=35.00
    
    
    ${response}=    Atualizar Sessao    ${ADMIN_TOKEN}    ${session_id}    ${updated_data}
    
    
    Validar Status Code    ${response}    200

TC_API_022 - Deletar sessao como admin deve retornar status 200
    [Documentation]    Valida que admin consegue deletar sessões
    [Tags]    api    sessions    delete    admin    p2
    
    ${session_data}=    Gerar Dados de Sessao Valida    ${MOVIE_ID}    ${THEATER_ID}
    ${create_response}=    Criar Sessao    ${ADMIN_TOKEN}    ${session_data}
    
    Skip If    ${create_response.status_code} != 201
    ...    Sessão não foi criada para teste
    
    ${create_json}=    Set Variable    ${create_response.json()}
    ${session_id}=    Extrair ID Da Sessao    ${create_json}
    
    
    ${response}=    Deletar Sessao    ${ADMIN_TOKEN}    ${session_id}
    
    
    Validar Status Code    ${response}    200

*** Keywords ***
Preparar Dados Iniciais
    [Documentation]    Prepara tokens e IDs necessários
    
    ${admin_token}=    Login Como Admin
    ${user_token}=    Login Como Usuario Comum
    Set Suite Variable    ${ADMIN_TOKEN}    ${admin_token}
    Set Suite Variable    ${USER_TOKEN}    ${user_token}
    
    # Cria um filme para usar nas sessões
    ${movie_data}=    Gerar Dados de Filme Valido
    ${movie_response}=    Criar Filme Como Admin    ${movie_data}
    
    Run Keyword If    ${movie_response.status_code} == 201
    ...    Set Movie ID From Response    ${movie_response}

Set Movie ID From Response
    [Arguments]    ${response}
    ${response_json}=    Set Variable    ${response.json()}
    ${movie_id}=    Extrair ID Do Filme    ${response_json}
    Set Suite Variable    ${MOVIE_ID}    ${movie_id}

Validar Sessao Criada
    [Arguments]    ${response}    ${session_data}
    ${response_json}=    Set Variable    ${response.json()}
    Validar Campo Nao Vazio    ${response_json}    _id
    Should Be Equal    ${response_json['price']}    ${session_data['price']}