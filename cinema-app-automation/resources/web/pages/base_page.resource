*** Settings ***
Documentation    Page Object base com keywords comuns para testes web
Library          Browser
Resource         ../../api/auth_service.resource


*** Variables ***
${WEB_URL}                  http://localhost:3002/
${BROWSER}                  chromium
${BRAVE_PATH}               C:/Program Files/BraveSoftware/Brave-Browser/Application/brave.exe
${HEADLESS}                 False
${TIMEOUT}                  30s




*** Keywords ***
Abrir Navegador
    [Documentation]    Abre o navegador configurado (Brave ou Chrome)
    New Browser    ${BROWSER}    headless=${HEADLESS}    executablePath=${BRAVE_PATH}
    New Context    viewport={'width': 1920, 'height': 1080}
    Set Browser Timeout    ${TIMEOUT}
    Log         Navegador aberto    console=True

Fechar Navegador
    [Documentation]    Fecha o navegador
    Close Browser
    Log         Navegador fechado    console=True

Acessar Aplicacao
    [Documentation]    Navega para a home da aplicação
    New Page    ${WEB_URL}
    Log         Acessando aplicação: ${WEB_URL}    console=True

Acessar URL
    [Documentation]    Navega para uma URL específica
    [Arguments]    ${url}
    Go To    ${url}
    Log         Acessando: ${url}    console=True

Fazer Login Via API e Injetar Token
    [Documentation]    WORKAROUND: Faz login via API e injeta token no localStorage
    ...                Necessário porque login/register não funcionam no front
    [Arguments]    ${email}    ${password}
    
    Log     Fazendo login via API e injetando token...    console=True
    

    ${response}=    Fazer Login    ${email}    ${password}
    Should Be Equal As Strings    ${response.status_code}    200
    
    ${response_json}=    Set Variable    ${response.json()}
    ${data}=    Get From Dictionary    ${response_json}    data
    ${token}=    Get From Dictionary    ${data}    token
    
    # Injeta token e user no localStorage do browser
    Evaluate JavaScript    None    
    ...    window.localStorage.setItem('token', '${token}')
    
    ${user_json}=    Evaluate    json.dumps($data)    json
    Evaluate JavaScript    None    
    ...    window.localStorage.setItem('user', '${user_json}')
    
    Log     Token JWT injetado no localStorage    console=True
    
    Reload
    Sleep    1s

Login Como Admin Web
    [Documentation]    Helper para login como admin via API + injeção de token
    Fazer Login Via API e Injetar Token    ${ADMIN_EMAIL}    ${ADMIN_PASSWORD}

Login Como Usuario Web
    [Documentation]    Helper para login como usuário comum via API + injeção de token
    Fazer Login Via API e Injetar Token    ${USER_EMAIL}    ${USER_PASSWORD}

Esperar Elemento
    [Documentation]    Aguarda elemento estar visível
    [Arguments]    ${selector}    ${timeout}=${TIMEOUT}
    Wait For Elements State    ${selector}    visible    timeout=${timeout}

Clicar Em
    [Documentation]    Clica em um elemento
    [Arguments]    ${selector}
    Wait For Elements State    ${selector}    visible
    Click    ${selector}
    Log    🖱️  Clicou em: ${selector}    console=True

Preencher Campo
    [Documentation]    Preenche um campo de texto
    [Arguments]    ${selector}    ${text}
    Wait For Elements State    ${selector}    visible
    Fill Text    ${selector}    ${text}
    Log    ⌨  Preencheu '${selector}' com texto    console=True

Obter Texto
    [Documentation]    Obtém texto de um elemento
    [Arguments]    ${selector}
    Wait For Elements State    ${selector}    visible
    ${text}=    Get Text    ${selector}
    RETURN        ${text}

Elemento Deve Estar Visivel
    [Documentation]    Valida que elemento está visível
    [Arguments]    ${selector}
    Wait For Elements State    ${selector}    visible
    Log     Elemento visível: ${selector}    console=True

Elemento Deve Conter Texto
    [Documentation]    Valida que elemento contém determinado texto
    [Arguments]    ${selector}    ${expected_text}
    ${text}=    Obter Texto    ${selector}
    Should Contain    ${text}    ${expected_text}    ignore_case=True
    ...    msg=Esperava texto '${expected_text}' mas encontrou '${text}'

Pagina Deve Conter Texto
    [Documentation]    Valida que a página contém determinado texto
    [Arguments]    ${expected_text}
    Get Text    body    contains    ${expected_text}

Tirar Screenshot
    [Documentation]    Captura screenshot da página
    [Arguments]    ${filename}
    Take Screenshot    filename=${filename}
    Log     Screenshot salvo: ${filename}    console=True

Aguardar Carregamento
    [Documentation]    Aguarda indicadores de carregamento sumirem
    [Arguments]    ${timeout}=10s
    Sleep    2s    
    Run Keyword And Ignore Error    
    ...    Wait For Elements State    .loading, .spinner, [data-loading]    hidden    timeout=${timeout}