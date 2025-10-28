*** Settings ***
Documentation    Page Object da página de reservas do usuário
Resource         base_page.resource

*** Variables ***
# Reservations Page
${RESERVATIONS_HEADER}         .reservations-header
${RESERVATIONS_TITLE}          ${RESERVATIONS_HEADER} h1
${RESERVATIONS_LIST}           .reservations-list
${RESERVATION_CARD}            .reservation-card

# Card Elements
${CARD_HEADER}                 .reservation-header
${CARD_MOVIE_INFO}             .movie-info
${CARD_FOOTER}                 .reservation-footer
${CARD_POSTER}                 .movie-poster
${CARD_STATUS}                 .status-badge
${CARD_PRICE}                  .price
${CARD_PAYMENT}                .payment-info
${CARD_DETAIL_ITEM}            .detail-item

# Buttons
${BTN_VOLTAR}                  .btn-secondary
${BTN_VER_FILMES}              .btn-primary

*** Keywords ***
Acessar Pagina De Reservas
    [Documentation]    Navega para a página de reservas
    Click    header > div > nav > ul > li:nth-child(3) > a
    Sleep    2s
    Log    📋 Acessou página de reservas    console=True

Validar Que Estou Na Pagina De Reservas
    [Documentation]    Valida que está na página de reservas
    Wait For Elements State    ${RESERVATIONS_TITLE}    visible    timeout=5s
    Get Text    ${RESERVATIONS_TITLE}    ==    Minhas Reservas
    Log    ✅ Está na página de reservas    console=True

Validar Estrutura Do Card De Reserva
    [Documentation]    Valida a estrutura de um card de reserva
    [Arguments]    ${index}=0
    
    ${card}=    Set Variable    ${RESERVATION_CARD} >> nth=${index}
    Wait For Elements State    ${card}    visible    timeout=5s
    Get Element    ${card} ${CARD_HEADER}
    Get Element    ${card} ${CARD_MOVIE_INFO}
    Get Element    ${card} ${CARD_FOOTER}
    Log    ✅ Estrutura do card validada    console=True

Validar Quantidade De Reservas
    [Documentation]    Valida a quantidade de reservas
    [Arguments]    ${quantidade_esperada}
    
    ${count}=    Get Element Count    ${RESERVATION_CARD}
    Should Be Equal As Numbers    ${count}    ${quantidade_esperada}
    Log    ✅ ${count} reservas encontradas    console=True

Obter Primeira Reserva
    [Documentation]    Retorna o seletor da primeira reserva
    Wait For Elements State    ${RESERVATION_CARD}    visible    timeout=5s
    RETURN    ${RESERVATION_CARD}:first-child

Validar Nome Do Filme
    [Documentation]    Valida o nome do filme em uma reserva
    [Arguments]    ${filme_esperado}    ${index}=0
    
    ${card}=    Set Variable    ${RESERVATION_CARD} >> nth=${index}
    Get Text    ${card} h4    ==    ${filme_esperado}

Validar Status Da Reserva
    [Documentation]    Valida o status de uma reserva
    [Arguments]    ${index}=0    ${status_esperado}=Confirmada
    
    ${card}=    Set Variable    ${RESERVATION_CARD} >> nth=${index}
    Get Text    ${card} ${CARD_STATUS}    ==    ${status_esperado}

Validar Data Da Sessao
    [Documentation]    Valida a data da sessão
    [Arguments]    ${data_esperada}    ${index}=0
    
    ${card}=    Set Variable    ${RESERVATION_CARD} >> nth=${index}
    Get Text    ${card} ${CARD_DETAIL_ITEM}:nth-child(1) span    ==    ${data_esperada}

Validar Horario Da Sessao
    [Documentation]    Valida o horário da sessão
    [Arguments]    ${horario_esperado}    ${index}=0
    
    ${card}=    Set Variable    ${RESERVATION_CARD} >> nth=${index}
    Get Text    ${card} ${CARD_DETAIL_ITEM}:nth-child(2) span    ==    ${horario_esperado}

Validar Teatro Da Sessao
    [Documentation]    Valida o teatro da sessão
    [Arguments]    ${teatro_esperado}    ${index}=0
    
    ${card}=    Set Variable    ${RESERVATION_CARD} >> nth=${index}
    Get Text    ${card} ${CARD_DETAIL_ITEM}:nth-child(3) span    ==    ${teatro_esperado}

Validar Assento Da Reserva
    [Documentation]    Valida o assento da reserva
    [Arguments]    ${assento_esperado}    ${index}=0
    
    ${card}=    Set Variable    ${RESERVATION_CARD} >> nth=${index}
    Get Text    ${card} ${CARD_DETAIL_ITEM}:nth-child(4) span    ==    ${assento_esperado}

Validar Preco Da Reserva
    [Documentation]    Valida o preço da reserva
    [Arguments]    ${preco_esperado}    ${index}=0
    
    ${card}=    Set Variable    ${RESERVATION_CARD} >> nth=${index}
    Get Text    ${card} ${CARD_PRICE}    ==    ${preco_esperado}

Validar Forma De Pagamento
    [Documentation]    Valida a forma de pagamento
    [Arguments]    ${pagamento_esperado}    ${index}=0
    
    ${card}=    Set Variable    ${RESERVATION_CARD} >> nth=${index}
    ${texto}=    Get Text    ${card} ${CARD_PAYMENT}
    Should Contain    ${texto}    ${pagamento_esperado}

Validar Poster Do Filme
    [Documentation]    Valida o poster do filme
    [Arguments]    ${imagem_esperada}    ${index}=0
    
    ${card}=    Set Variable    ${RESERVATION_CARD} >> nth=${index}
    Get Attribute    ${card} ${CARD_POSTER}    src    contains    ${imagem_esperada}

Clicar Voltar Para Pagina Inicial
    [Documentation]    Clica no botão voltar
    Click    ${BTN_VOLTAR}
    Sleep    2s
    Log    🔙 Voltou para página inicial    console=True

Clicar Ver Filmes Em Cartaz
    [Documentation]    Clica no botão ver filmes
    Click    ${BTN_VER_FILMES}
    Sleep    2s
    Log     Navegou para filmes em cartaz    console=True

Validar Reserva Completa
    [Documentation]    Valida todos os dados de uma reserva específica
    [Arguments]    ${filme}    ${data}    ${horario}    ${teatro}    ${assento}    ${preco}    ${index}=0    ${status}=Confirmada
    
    Validar Nome Do Filme    ${filme}    ${index}
    Validar Data Da Sessao    ${data}    ${index}
    Validar Horario Da Sessao    ${horario}    ${index}
    Validar Teatro Da Sessao    ${teatro}    ${index}
    Validar Assento Da Reserva    ${assento}    ${index}
    Validar Preco Da Reserva    ${preco}    ${index}
    Validar Status Da Reserva    ${index}    ${status}
    Log    ✅ Reserva completa validada    console=True
