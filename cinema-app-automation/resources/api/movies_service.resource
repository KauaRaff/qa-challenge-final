*** Settings ***
Documentation        Service Object para operações de filmes
Resource             base_api.resource
Resource             auth_service.resource
Library              FakerLibrary

*** Variables ***
${MOVIES_ENDPOINT}    /movies

*** Keywords ***
Gerar Dados de Filme Valido
    [Documentation]        Gera dados aleatórios para criação de filme, com o faker
    ${random_num}=        Generate Random String        4        [NUMBERS]
    ${title}=        FakerLibrary.Sentence    nb_words=3
    ${genres}=        Create List    Ação    Drama    Comédia    Terror    Ficção    Romance
    ${random_genre}=        Evaluate    random.choice($genres)    random
    ${duration}=        Evaluate    random.randint(90, 180)    random
    ${rating}=        Evaluate    round(random.uniform(3.0, 5.0), 1)    random
    
    ${movie_data}=    Create Dictionary
    ...    title=Filme Teste ${random_num}
    ...    genre=${random_genre}
    ...    duration=${duration}
    ...    rating=${rating}
    ...    description=Filme criado automaticamente para testes
    
    RETURN    ${movie_data}

Listar Todos os Filmes
    [Documentation]    Lista todos os filmes cadastrados
    
    Criar Sessao da API
    ${headers}=    Criar Headers Padrao
    
    Log Request Details    GET    ${MOVIES_ENDPOINT}
    ${response}=    GET On Session    cinema_api    ${MOVIES_ENDPOINT}
    ...    headers=${headers}
    ...    expected_status=any
    
    Log Response Details    ${response}
    RETURN    ${response}

Buscar Filme Por ID
    [Documentation]    Busca um filme específico por ID
    [Arguments]    ${movie_id}
    
    Criar Sessao da API
    ${headers}=    Criar Headers Padrao
    
    ${endpoint}=    Set Variable    ${MOVIES_ENDPOINT}/${movie_id}
    Log Request Details    GET    ${endpoint}
    ${response}=    GET On Session    cinema_api    ${endpoint}
    ...    headers=${headers}
    ...    expected_status=any
    
    Log Response Details    ${response}
    RETURN    ${response}

Criar Filme
    [Documentation]    Cria um novo filme (requer autenticação admin)
    [Arguments]    ${token}    ${movie_data}
    
    Criar Sessao da API
    ${headers}=    Criar Headers Com Token    ${token}
    
    Log Request Details    POST    ${MOVIES_ENDPOINT}    ${movie_data}
    ${response}=    POST On Session    cinema_api    ${MOVIES_ENDPOINT}
    ...    json=${movie_data}
    ...    headers=${headers}
    ...    expected_status=any
    
    Log Response Details    ${response}
    RETURN    ${response}

Atualizar Filme
    [Documentation]    Atualiza um filme existente (requer autenticação admin)
    [Arguments]    ${token}    ${movie_id}    ${movie_data}
    
    Criar Sessao da API
    ${headers}=    Criar Headers Com Token    ${token}
    
    ${endpoint}=    Set Variable    ${MOVIES_ENDPOINT}/${movie_id}
    Log Request Details    PUT    ${endpoint}    ${movie_data}
    ${response}=    PUT On Session    cinema_api    ${endpoint}
    ...    json=${movie_data}
    ...    headers=${headers}
    ...    expected_status=any
    
    Log Response Details    ${response}
    RETURN    ${response}

Deletar Filme
    [Documentation]    Deleta um filme (requer autenticação admin)
    [Arguments]    ${token}    ${movie_id}
    
    Criar Sessao da API
    ${headers}=    Criar Headers Com Token    ${token}
    
    ${endpoint}=    Set Variable    ${MOVIES_ENDPOINT}/${movie_id}
    Log Request Details    DELETE    ${endpoint}
    ${response}=    DELETE On Session    cinema_api    ${endpoint}
    ...    headers=${headers}
    ...    expected_status=any
    
    Log Response Details    ${response}
    RETURN    ${response}

Criar Filme Como Admin
    [Documentation]    Helper que faz login admin e cria filme
    [Arguments]    ${movie_data}=${None}
    
    # Se não passar dados, gera automaticamente
    ${movie_data}=    Run Keyword If    ${movie_data} == ${None}
    ...    Gerar Dados de Filme Valido
    ...    ELSE    Set Variable    ${movie_data}
    
    # Faz login como admin
    ${token}=    Login Como Admin
    
    # Cria o filme
    ${response}=    Criar Filme    ${token}    ${movie_data}
    
    RETURN    ${response}

Extrair ID Do Filme
    [Documentation]    Extrai o ID do filme da resposta
    [Arguments]    ${response_json}
    ${movie_id}=    Get From Dictionary    ${response_json}    _id
    Should Not Be Empty    ${movie_id}    msg=ID do filme não encontrado
    RETURN    ${movie_id}
