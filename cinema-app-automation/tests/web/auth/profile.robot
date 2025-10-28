*** Settings ***
Documentation    Testes da página de perfil do usuário
Resource         ../../../resources/web/pages/profile_page.resource
Resource         ../../../resources/web/pages/profile_page.resource
Suite Setup      Preparar Navegador E Fazer Login
Suite Teardown   Fechar Navegador

*** Variables ***
${USER_EMAIL}      test@example.com
${USER_PASSWORD}   password123
${USER_NAME}       Test User

*** Test Cases ***
TC_WEB_036 - Verificar carregamento da pagina de perfil
    [Documentation]    Verifica se a página de perfil carrega corretamente
    [Tags]    web    profile    smoke    p0
    
    Acessar Pagina De Perfil
    Validar Que Estou Na Pagina De Perfil
    Validar Abas Visiveis

TC_WEB_037 - Verificar informacoes do usuario carregadas
    [Documentation]    Verifica se as informações do usuário estão preenchidas
    [Tags]    web    profile    p0
    
    Acessar Pagina De Perfil
    Validar Campo Nome    ${USER_NAME}
    Validar Campo Email    ${USER_EMAIL}
    Validar Email Desabilitado

TC_WEB_039 - Alterar nome do usuario
    [Documentation]    Testa a funcionalidade de alteração do nome
    [Tags]    web    profile    edit    p1
    
    Acessar Pagina De Perfil
    
    ${novo_nome}=    Set Variable    Test User Updated
    Preencher Campo Nome    ${novo_nome}
    Validar Botao Salvar Habilitado
    Clicar Botao Salvar
    Sleep    2s
    
    # Restaura nome original
    Preencher Campo Nome    ${USER_NAME}
    Clicar Botao Salvar

TC_WEB_040 - Verificar secao de alteracao de senha
    [Documentation]    Verifica a presença da seção de alteração de senha
    [Tags]    web    profile    password    p1
    
    Acessar Pagina De Perfil
    Validar Secao Alterar Senha Visivel
    Validar Campos De Senha Presentes

TC_WEB_041 - Verificar botao salvar desabilitado sem alteracoes
    [Documentation]    Verifica que o botão salvar fica desabilitado sem alterações
    [Tags]    web    profile    validation    p2
    
    Acessar Pagina De Perfil
    Validar Botao Salvar Desabilitado

TC_WEB_046 - Alternar entre abas
    [Documentation]    Testa a funcionalidade de alternância entre as abas
    [Tags]    web    profile    navigation    p1
    
    Acessar Pagina De Perfil
    
    Clicar Aba Minhas Reservas
    Validar Aba Ativa    Minhas Reservas
    
    Clicar Aba Meu Perfil
    Validar Aba Ativa    Meu Perfil

TC_WEB_048 - Limpar campo nome e validar
    [Documentation]    Verifica validação ao limpar o campo nome
    [Tags]    web    profile    validation    p2
    
    Acessar Pagina De Perfil
    
    Limpar Campo Nome
    Validar Botao Salvar Habilitado
    
    # Restaura nome
    Preencher Campo Nome    ${USER_NAME}
    Clicar Botao Salvar

*** Keywords ***
Preparar Navegador E Fazer Login
    [Documentation]    Prepara navegador e faz login antes dos testes
    Abrir Navegador
    Acessar Aplicacao
    Login Como Usuario Web
    Log    🔐 Login realizado com sucesso    console=True

Acessar Pagina De Perfil
    [Documentation]    Navega para a página de perfil
    Go To    ${WEB_URL}/profile
    Sleep    2s
    Log    👤 Acessou página de perfil    console=True
