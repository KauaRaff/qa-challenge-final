*** Settings ***
Documentation    Testes de listagem de sessões na API Cinema
Resource         ../../../resources/api/sessions_service.resource
Suite Setup      Log     Iniciando testes de Listagem de Sessões    console=True
Suite Teardown   Log     Testes de Listagem de Sessões finalizados    console=True

*** Test Cases ***
TC_API_017 - Listar todas as sessoes deve retornar status 200
    [Documentation]    Valida que é possivel listar todas as sessões
    [Tags]    api    sessions  
    
    
    ${response}=    Listar Todas as Sessoes
    
    
    Validar Status Code    ${response}    200
    
    ${response_json}=    Set Variable    ${response.json()}
   
    ${is_list}=    Evaluate    isinstance($response_json, list)
    Should Be True    ${is_list}    msg=Resposta deveria ser um array de sessões
    
    
    ${sessions_count}=        Get Length        ${response_json}
    Run Keyword If    ${sessions_count} > 0
    ...    Validar Estrutura Da Sessao    ${response_json}[0]

TC_API_018 - Buscar sessao por ID valido deve retornar status 200
    [Documentation]    Valida busca de sessão específica por ID
    [Tags]    api    sessions    detail  
    
    ${list_response}=    Listar Todas as Sessoes
    Validar Status Code    ${list_response}    200
    
    ${sessions}=    Set Variable    ${list_response.json()}
    ${sessions_count}=    Get Length    ${sessions}
    
    Skip If    ${sessions_count} == 0    Nenhuma sessão disponível para teste
    
    ${session_id}=    Get From Dictionary    ${sessions}[0]    _id
    
    
    ${response}=    Buscar Sessao Por ID    ${session_id}
    
    
    Validar Status Code    ${response}    200
    
    ${response_json}=    Set Variable    ${response.json()}
    Validar Estrutura Da Sessao    ${response_json}
    Should Be Equal    ${response_json['_id']}    ${session_id}

TC_API_018B - Buscar sessao por ID invalido deve retornar status 404
    [Documentation]    Valida que IDs inexistentes retornam 404
    [Tags]    api    sessions    detail    validation    p1
    
    
    ${response}=    Buscar Sessao Por ID    507f1f77bcf86cd799439011
    
    
    Validar Status Code    ${response}    404

TC_API_018C - Buscar sessao com ID formato invalido deve retornar erro
    [Documentation]    Valida que IDs mal formatados são rejeitados
    [Tags]    api    sessions    detail    validation    p2
    
    
    ${response}=    Buscar Sessao Por ID    id-invalido-123
    
    
    Should Be True    ${response.status_code} in [400, 404]
    ...    msg=Status esperado 400 ou 404, recebido ${response.status_code}

*** Keywords ***
Validar Estrutura Da Sessao
    [Documentation]    Valida que a sessão tem todos os campos esperados
    [Arguments]    ${session}
    
    Validar Campo Nao Vazio    ${session}    _id
    Validar Campo Existe    ${session}    movie
    Validar Campo Existe    ${session}    theater
    Validar Campo Existe    ${session}    date
    Validar Campo Existe    ${session}    time
    Validar Campo Existe    ${session}    price
    
    ${price}=    Get From Dictionary    ${session}    price
    Should Be True    ${price} > 0    msg=Preço deve ser maior que zero