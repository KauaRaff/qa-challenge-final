*** Settings ***
Documentation    Page Object da página inicial (Home) com lista de filmes
Resource         base_page.resource

*** Variables ***
# Home Page
${HOME_TITLE}                  text="Welcome to Cinema App"
${FEATURES_SECTION}            main > div > div.features-section
${FEATURES_CTA_BUTTON}         main > div > div.features-section > div > a

# Movies Section
${MOVIES_SECTION}              main > div > div.featured-movies
${MOVIES_GRID}                 ${MOVIES_SECTION} > div
${MOVIE_CARD}                  main > div > div.featured-movies > div > div:nth-child(1)

# Movie Card Elements
${MOVIE_POSTER}                ${MOVIE_CARD} > div.movie-poster
${MOVIE_CLASSIFICATION}        ${MOVIE_POSTER} > div.movie-classification
${MOVIE_TITLE}                 main > div > div.featured-movies > div > div:nth-child(1) > div.movie-info > h3
${MOVIE_DURATION}              main > div > div.featured-movies > div > div:nth-child(1) > div.movie-info > div.movie-meta > span.movie-duration
${MOVIE_RELEASE}               main > div > div.featured-movies > div > div:nth-child(1) > div.movie-info > div.movie-meta > span.movie-release
${MOVIE_GENRES}                main > div > div.featured-movies > div > div:nth-child(1) > div.movie-info > div.movie-genres
${MOVIE_SYNOPSIS}              main > div > div.featured-movies > div > div:nth-child(1) > div.movie-info > p
${MOVIE_DETAILS_BUTTON}        main > div > div.featured-movies > div > div:nth-child(1) > div.movie-info > a

# Generic selectors
${MOVIE_CARDS}                 main > div > div.featured-movies > div > div
${MOVIE_CARD_BUTTON}           a.btn.btn-primary.btn-lg

*** Keywords ***
Validar Que Estou Na Home
    [Documentation]    Valida que está na página inicial
    Aguardar Carregamento
    
    ${current_url}=    Get Url
    Should Contain    ${current_url}    ${WEB_URL}
    
    Wait For Elements State    ${HOME_TITLE}    visible    timeout=5s
    
    Log    ✅ Está na Home    console=True

Validar Lista De Filmes Visivel
    [Documentation]    Valida que a lista de filmes está sendo exibida
    Aguardar Carregamento
    
    ${cards_count}=    Get Element Count    ${MOVIE_CARDS}
    Should Be True    ${cards_count} > 0    msg=Nenhum filme encontrado na página
    
    Log    ✅ ${cards_count} filmes encontrados    console=True

Clicar No Primeiro Filme
    [Documentation]    Clica no primeiro filme da lista
    Sleep    2s
    
    Wait For Elements State    ${MOVIE_CARD_BUTTON}    visible    timeout=10s
    Click    ${MOVIE_CARD_BUTTON} >> nth=0
    
    Sleep    2s
    Log    🎬 Clicou no primeiro filme    console=True

Clicar Em Filme Por Nome
    [Documentation]    Clica em um filme específico pelo nome
    [Arguments]    ${movie_name}
    
    Log    🎬 Clicando no filme: ${movie_name}    console=True
    Click    text="${movie_name}"

Validar Filme Aparece Na Lista
    [Documentation]    Valida que um filme específico aparece na lista
    [Arguments]    ${movie_name}
    
    Get Text    body    contains    ${movie_name}
    Log    ✅ Filme '${movie_name}' encontrado    console=True

Obter Quantidade De Filmes Exibidos
    [Documentation]    Retorna quantidade de filmes na tela
    Aguardar Carregamento
    ${count}=    Get Element Count    ${MOVIE_CARDS}
    RETURN    ${count}

Validar Estrutura Do Card De Filme
    [Documentation]    Verifica a estrutura completa de um card de filme
    [Arguments]    ${card_index}=0
    
    ${card}=    Set Variable    ${MOVIE_CARDS} >> nth=${card_index}
    
    Wait For Elements State    ${card}    visible    timeout=5s
    Get Element    ${card} ${MOVIE_POSTER}
    Get Element    ${card} div.movie-info > h3
    Get Element    ${card} a.btn
    
    Log    ✅ Estrutura do card validada    console=True

Clicar No Botao Ver Filmes Em Cartaz
    [Documentation]    Clica no botão CTA para ver todos os filmes
    Click    ${FEATURES_CTA_BUTTON}
    Sleep    2s
    Log    🎬 Navegou para página de filmes    console=True
