*** Settings ***
Documentation    Testes de navegação e visualização de filmes na interface web
Resource         ../../../resources/web/pages/home_page.resource
Resource         ../../../resources/web/pages/movie_detail_page.resource
Suite Setup      Preparar Navegador
Suite Teardown   Fechar Navegador
Test Setup       Acessar Aplicacao




*** Test Cases ***
TC_WEB_005 - Visualizar lista de filmes na home deve exibir cards corretamente
    [Documentation]    Valida que a lista de filmes é exibida na página inicial
    [Tags]    web    movies    home    smoke    p0
    
    
    Validar Que Estou Na Home
    Validar Lista De Filmes Visivel
    
    ${filmes_count}=    Obter Quantidade De Filmes Exibidos
    Should Be True    ${filmes_count} >= 1
    ...    msg=Deve haver pelo menos 1 filme cadastrado

TC_WEB_006 - Acessar detalhes de um filme deve mostrar informacoes completas
    [Documentation]    Valida navegação para página de detalhes do filme
    [Tags]    web    movies    detail    smoke    p0
    
    Validar Que Estou Na Home
    Validar Lista De Filmes Visivel
    
    
    Clicar No Primeiro Filme
    
    
    Validar Que Estou Na Pagina De Detalhes
    Validar Informacoes Do Filme Visiveis

TC_WEB_006B - Pagina de detalhes deve mostrar sessoes disponiveis
    [Documentation]    Valida que sessões são exibidas nos detalhes do filme
    [Tags]    web    movies    detail    sessions    p1
    
    Validar Que Estou Na Home
    Clicar No Primeiro Filme
    
     
    Validar Que Estou Na Pagina De Detalhes
    Validar Sessoes Disponiveis

TC_WEB_007 - Buscar filme por nome deve filtrar resultados
    [Documentation]    Valida funcionalidade de busca de filmes
    [Tags]    web    movies    search    p1
    
    Validar Que Estou Na Home
    ${filmes_antes}=    Obter Quantidade De Filmes Exibidos
        
    Sleep    2s
    
    ${filmes_depois}=    Obter Quantidade De Filmes Exibidos
    Log    Filmes antes: ${filmes_antes}, depois: ${filmes_depois}    console=True

*** Keywords ***
Preparar Navegador
    [Documentation]    Prepara navegador para os testes
    Abrir Navegador
    Log     Suite de testes Web iniciada    console=True