*** Settings ***
Documentation    Testes de listagem de teatros/salas de cinema
Resource         ../../../resources/api/theaters_service.resource
Suite Setup      Log    🎬 Iniciando testes de Listagem de Teatros    console=True
Suite Teardown   Log    ✅ Testes de Listagem de Teatros finalizados    console=True

*** Test Cases ***
TC_API_021 - Listar todos os teatros deve retornar status 200
    [Documentation]    Valida que é possível listar todos os teatros
    [Tags]    api    theaters    list    smoke    p1
    
    
    ${response}=    Listar Todos os Teatros
    
    
    Validar Status Code    ${response}    200
    
    ${response_json}=    Set Variable    ${response.json()}
    
    ${is_list}=    Evaluate    isinstance($response_json, list)
    Should Be True    ${is_list}    msg=Resposta deveria ser um array de teatros
    
    ${theaters_count}=    Get Length    ${response_json}
    Run Keyword If    ${theaters_count} > 0
    ...    Validar Estrutura Do Teatro    ${response_json}[0]

TC_API_021B - Buscar teatro por ID valido deve retornar status 200
    [Documentation]    Valida busca de teatro específico por ID
    [Tags]    api    theaters    detail    p1
    
    ${list_response}=    Listar Todos os Teatros
    Validar Status Code    ${list_response}    200
    
    ${theaters}=    Set Variable    ${list_response.json()}
    ${theaters_count}=    Get Length    ${theaters}
    
    Skip If    ${theaters_count} == 0    Nenhum teatro disponível para teste
    
    ${theater_id}=    Get From Dictionary    ${theaters}[0]    _id
    
    
    ${response}=    Buscar Teatro Por ID    ${theater_id}
    
    
    Validar Status Code    ${response}    200
    
    ${response_json}=    Set Variable    ${response.json()}
    Validar Estrutura Do Teatro    ${response_json}
    Should Be Equal    ${response_json['_id']}    ${theater_id}

TC_API_021C - Buscar teatro por ID invalido deve retornar status 404
    [Documentation]    Valida que IDs inexistentes retornam 404
    [Tags]    api    theaters    detail    validation    p2
    
    
    ${response}=    Buscar Teatro Por ID    507f1f77bcf86cd799439011
    
    
    Validar Status Code    ${response}    404

*** Keywords ***
Validar Estrutura Do Teatro
    [Documentation]    Valida que o teatro tem todos os campos esperados
    [Arguments]    ${theater}
    
    Validar Campo Nao Vazio    ${theater}    _id
    Validar Campo Nao Vazio    ${theater}    name
    Validar Campo Existe    ${theater}    capacity
    Validar Campo Existe    ${theater}    type
    
    # Valida capacidade
    ${capacity}=    Get From Dictionary    ${theater}    capacity
    Should Be True    ${capacity} > 0    msg=Capacidade deve ser maior que zero