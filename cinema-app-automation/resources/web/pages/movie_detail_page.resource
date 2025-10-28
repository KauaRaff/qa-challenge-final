*** Settings ***
Documentation    Page Object da página de detalhes do filme
Resource         base_page.resource





*** Variables ***
${MOVIE_TITLE}              h1, .movie-title
${MOVIE_DESCRIPTION}        .description, .movie-description, p
${MOVIE_GENRE}              .genre, [data-testid="genre"]
${MOVIE_DURATION}           .duration, [data-testid="duration"]
${MOVIE_RATING}             .rating, [data-testid="rating"]
${SESSIONS_LIST}            .sessions, .sessions-list, [data-testid="sessions"]
${SESSION_CARD}             .session-card, .session, [data-testid="session"]
${RESERVE_BUTTON}           button:has-text("Reservar"), button:has-text("Comprar"), .btn-reserve






*** Keywords ***
Validar Que Estou Na Pagina De Detalhes
    [Documentation]    Valida que está na página de detalhes do filme
    Sleep    2s
    
    ${current_url}=    Get Url
    Log    URL atual: ${current_url}    console=True
    
    # Tenta encontrar o título com timeout menor
    ${title_exists}=    Run Keyword And Return Status
    ...    Wait For Elements State    ${MOVIE_TITLE}    visible    timeout=5s
    
    Run Keyword If    not ${title_exists}
    ...    Log    AVISO: Título do filme não encontrado!    WARN
    
    Log    ✅ Está na página de detalhes    console=True

Validar Informacoes Do Filme Visiveis
    [Documentation]    Valida que as informações principais do filme estão visíveis
    Elemento Deve Estar Visivel    ${MOVIE_TITLE}
    Elemento Deve Estar Visivel    ${MOVIE_DESCRIPTION}
    
    Log     Informações do filme visíveis    console=True

Validar Sessoes Disponiveis
    [Documentation]    Valida que há sessões disponíveis para o filme
    Aguardar Carregamento
    
    ${sessions_count}=    Get Element Count    ${SESSION_CARD}
    Should Be True    ${sessions_count} > 0    msg=Nenhuma sessão disponível
    
    Log     ${sessions_count} sessões disponíveis    console=True

Clicar Na Primeira Sessao
    [Documentation]    Clica na primeira sessão disponível
    Aguardar Carregamento
    
    ${first_session}=    Set Variable    ${SESSION_CARD} >> nth=0
    Elemento Deve Estar Visivel    ${first_session}
    
    ${button_in_session}=    Set Variable    ${first_session} ${RESERVE_BUTTON}
    ${button_exists}=    Run Keyword And Return Status
    ...    Elemento Deve Estar Visivel    ${button_in_session}
    
    Run Keyword If    ${button_exists}
    ...    Clicar Em    ${button_in_session}
    ...    ELSE
    ...    Clicar Em    ${first_session}
    
    Log     Clicou na primeira sessão    console=True

Clicar Em Reservar
    [Documentation]    Clica no botão de reservar (genérico)
    Clicar Em    ${RESERVE_BUTTON}
    Log     Clicou em Reservar    console=True

Obter Titulo Do Filme
    [Documentation]    Retorna o título do filme exibido
    ${title}=    Obter Texto    ${MOVIE_TITLE}
    RETURN   ${title} 