*** Settings ***
Documentation        Testes de listagem de filmes na API Cinema
Resource         ../../../resources/api/movies_service.resource
Suite Setup      Log       Iniciando testes de Listagem de Filmes    console=True
Suite Teardown   Log         Testes de Listagem finalizados    console=True

*** Test Cases ***
TC_API_009 - Listar todos os filmes deve retornar status 200
    [Documentation]    Valida que é possível listar todos os filmes
    [Tags]    api    movies    list    smoke    p0
    
    
    ${response}=    Listar Todos os Filmes
    
    
    Validar Status Code    ${response}    200
    
    ${response_json}=    Set Variable    ${response.json()}
    
    
    ${is_list}=    Evaluate    isinstance($response_json, list)
    Should Be True    ${is_list}    msg=Resposta deveria ser um array de filmes
    
   
    ${movies_count}=    Get Length    ${response_json}
    Run Keyword If    ${movies_count} > 0
    ...    Validar Estrutura Do Filme    ${response_json}[0]

TC_API_010 - Buscar filme por ID valido deve retornar status 200
    [Documentation]    Valida busca de filme específico por ID
    [Tags]    api    movies    detail    p0
    
    # cria um filme para buscar
    ${movie_data}=    Gerar Dados de Filme Valido
    ${create_response}=    Criar Filme Como Admin    ${movie_data}
    Validar Status Code    ${create_response}    201
    
    ${create_json}=    Set Variable    ${create_response.json()}
    ${movie_id}=    Extrair ID Do Filme    ${create_json}
    
    # - Busca o filme criado
    ${response}=    Buscar Filme Por ID    ${movie_id}
    
    
    Validar Status Code    ${response}    200
    
    ${response_json}=    Set Variable    ${response.json()}
    Validar Estrutura Do Filme    ${response_json}
    Should Be Equal    ${response_json['_id']}    ${movie_id}
    Should Be Equal    ${response_json['title']}    ${movie_data['title']}

TC_API_011 - Buscar filme por ID invalido deve retornar status 404
    [Documentation]    Valida que IDs inexistentes retornam 404
    [Tags]    api    movies    detail    validation    p1
    
    
    ${response}=    Buscar Filme Por ID    507f1f77bcf86cd799439011
    
    
    Validar Status Code    ${response}    404

TC_API_011B - Buscar filme com ID formato invalido deve retornar erro
    [Documentation]    Valida que IDs mal formatados são rejeitados
    [Tags]    api    movies    detail    validation    p2
    

    ${response}=    Buscar Filme Por ID    id-invalido-123
    
    
    Should Be True    ${response.status_code} in [400, 404]
    ...    msg=Status esperado 400 ou 404, recebido ${response.status_code}

*** Keywords ***
Validar Estrutura Do Filme
    [Documentation]    Valida que o filme tem todos os campos esperados
    [Arguments]    ${movie}
    
    Validar Campo Nao Vazio    ${movie}    _id
    Validar Campo Nao Vazio    ${movie}    title
    Validar Campo Existe    ${movie}    genre
    Validar Campo Existe    ${movie}    duration
    Validar Campo Existe    ${movie}    rating
    
   
    ${duration}=    Get From Dictionary    ${movie}    duration
    Should Be True    ${duration} > 0    msg=Duração deve ser maior que zero
    
    ${rating}=    Get From Dictionary    ${movie}    rating
    Should Be True    ${rating} >= 0 and ${rating} <= 5
    ...    msg=Rating deve estar entre 0 e 5