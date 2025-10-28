*** Settings ***
Documentation    Page Object da página de perfil do usuário
Resource         base_page.resource

*** Variables ***
# Profile Page
${PROFILE_HEADER}              main > div > div > div.profile-header
${PROFILE_TITLE}               ${PROFILE_HEADER} > h1
${PROFILE_DESCRIPTION}         ${PROFILE_HEADER} > p

# Tabs
${PROFILE_TABS}                main > div > div > div.profile-tabs
${TAB_MEU_PERFIL}              ${PROFILE_TABS} > div:nth-child(1)
${TAB_MINHAS_RESERVAS}         ${PROFILE_TABS} > div:nth-child(2)
${TAB_ACTIVE}                  ${PROFILE_TABS} .tab.active

# Form Fields
${INPUT_NAME}                  input[name="name"]
${INPUT_EMAIL}                 input[name="email"]
${INPUT_CURRENT_PASSWORD}      input[name="currentPassword"]
${INPUT_NEW_PASSWORD}          input[name="newPassword"]
${INPUT_CONFIRM_PASSWORD}      input[name="confirmNewPassword"]

# Buttons
${BTN_SALVAR}                  .btn-primary:not([disabled])
${BTN_SALVAR_DISABLED}         .btn-primary[disabled]

# Sections
${PASSWORD_SECTION}            .password-section
${RESERVATIONS_SECTION}        .reservations-section
${RESERVATION_CARD}            .reservation-card

*** Keywords ***
Validar Que Estou Na Pagina De Perfil
    [Documentation]    Valida que está na página de perfil
    Wait For Elements State    ${PROFILE_TITLE}    visible    timeout=5s
    Get Text    ${PROFILE_TITLE}    ==    Meu Perfil
    Log    ✅ Está na página de perfil    console=True

Validar Abas Visiveis
    [Documentation]    Valida que as abas estão visíveis
    Wait For Elements State    ${PROFILE_TABS}    visible    timeout=5s
    Get Element Count    ${PROFILE_TABS} > div    ==    2
    Get Text    ${TAB_MEU_PERFIL}    ==    Meu Perfil
    Get Text    ${TAB_MINHAS_RESERVAS}    ==    Minhas Reservas
    Log    ✅ Abas validadas    console=True

Validar Campo Nome
    [Documentation]    Valida o campo nome
    [Arguments]    ${nome_esperado}
    ${nome_atual}=    Get Attribute    ${INPUT_NAME}    value
    Should Be Equal    ${nome_atual}    ${nome_esperado}

Validar Campo Email
    [Documentation]    Valida o campo email
    [Arguments]    ${email_esperado}
    ${email_atual}=    Get Attribute    ${INPUT_EMAIL}    value
    Should Be Equal    ${email_atual}    ${email_esperado}

Validar Email Desabilitado
    [Documentation]    Valida que o campo email está desabilitado
    ${disabled}=    Get Attribute    ${INPUT_EMAIL}    disabled
    Should Not Be Empty    ${disabled}

Preencher Campo Nome
    [Documentation]    Preenche o campo nome
    [Arguments]    ${novo_nome}
    Fill Text    ${INPUT_NAME}    ${novo_nome}
    Log    ✏️ Nome preenchido: ${novo_nome}    console=True

Limpar Campo Nome
    [Documentation]    Limpa o campo nome
    Clear Text    ${INPUT_NAME}
    Log    🧹 Campo nome limpo    console=True

Clicar Botao Salvar
    [Documentation]    Clica no botão salvar
    Click    ${BTN_SALVAR}
    Sleep    1s
    Log    💾 Clicou em Salvar    console=True

Validar Botao Salvar Habilitado
    [Documentation]    Valida que o botão salvar está habilitado
    Wait For Elements State    ${BTN_SALVAR}    visible    timeout=5s

Validar Botao Salvar Desabilitado
    [Documentation]    Valida que o botão salvar está desabilitado
    Wait For Elements State    ${BTN_SALVAR_DISABLED}    visible    timeout=5s

Validar Secao Alterar Senha Visivel
    [Documentation]    Valida que a seção de alterar senha está visível
    Wait For Elements State    ${PASSWORD_SECTION}    visible    timeout=5s

Validar Campos De Senha Presentes
    [Documentation]    Valida que os campos de senha estão presentes
    Wait For Elements State    ${INPUT_CURRENT_PASSWORD}    visible    timeout=5s
    Wait For Elements State    ${INPUT_NEW_PASSWORD}    visible    timeout=5s
    Wait For Elements State    ${INPUT_CONFIRM_PASSWORD}    visible    timeout=5s

Clicar Aba Minhas Reservas
    [Documentation]    Clica na aba Minhas Reservas
    Click    ${TAB_MINHAS_RESERVAS}
    Sleep    1s
    Log    📋 Clicou em Minhas Reservas    console=True

Clicar Aba Meu Perfil
    [Documentation]    Clica na aba Meu Perfil
    Click    ${TAB_MEU_PERFIL}
    Sleep    1s
    Log    👤 Clicou em Meu Perfil    console=True

Validar Aba Ativa
    [Documentation]    Valida qual aba está ativa
    [Arguments]    ${aba_esperada}
    Wait For Elements State    ${TAB_ACTIVE} >> text="${aba_esperada}"    visible    timeout=5s

Validar Secao Minhas Reservas Visivel
    [Documentation]    Valida que a seção de reservas está visível
    Wait For Elements State    ${RESERVATIONS_SECTION}    visible    timeout=5s

Validar Quantidade De Reservas
    [Documentation]    Valida a quantidade de reservas
    [Arguments]    ${quantidade_esperada}
    ${count}=    Get Element Count    ${RESERVATION_CARD}
    Should Be Equal As Numbers    ${count}    ${quantidade_esperada}

Obter Primeira Reserva
    [Documentation]    Retorna o seletor da primeira reserva
    Wait For Elements State    ${RESERVATION_CARD}    visible    timeout=5s
    RETURN    ${RESERVATION_CARD}:first-child

Validar Filme Da Reserva
    [Documentation]    Valida o filme de uma reserva
    [Arguments]    ${seletor_reserva}    ${filme_esperado}
    Get Text    ${seletor_reserva} h3    ==    ${filme_esperado}

Validar Status Da Reserva
    [Documentation]    Valida o status de uma reserva
    [Arguments]    ${seletor_reserva}    ${status_esperado}
    Get Text    ${seletor_reserva} .status-badge    ==    ${status_esperado}

Validar Preco Da Reserva
    [Documentation]    Valida o preço de uma reserva
    [Arguments]    ${seletor_reserva}    ${preco_esperado}
    Get Text    ${seletor_reserva} .price    ==    ${preco_esperado}
