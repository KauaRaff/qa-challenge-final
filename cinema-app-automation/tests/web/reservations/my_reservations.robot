*** Settings ***
Documentation    Testes da página de reservas do usuário
Resource         ../../../resources/web/pages/reservations_page.resource
Resource    ../../../resources/web/pages/home_page.resource
Suite Setup      Preparar Navegador E Fazer Login
Suite Teardown   Fechar Navegador

*** Variables ***
${USER_EMAIL}      test@example.com
${USER_PASSWORD}   password123

*** Test Cases ***
TC_WEB_050 - Verificar carregamento da pagina de reservas
    [Documentation]    Verifica se a página de reservas carrega corretamente
    [Tags]    web    reservations    smoke    p0
    
    Acessar Pagina De Reservas
    Validar Que Estou Na Pagina De Reservas

TC_WEB_051 - Verificar estrutura do card de reserva
    [Documentation]    Valida a estrutura completa de um card de reserva
    [Tags]    web    reservations    structure    p0
    
    Acessar Pagina De Reservas
    Validar Estrutura Do Card De Reserva    index=0

TC_WEB_052 - Validar conteudo completo da reserva
    [Documentation]    Valida todas as informações de uma reserva
    [Tags]    web    reservations    content    p0
    
    Acessar Pagina De Reservas
    Validar Reserva Completa
    ...    filme=The Avengers
    ...    data=21 de outubro de 2025
    ...    horario=12:00
    ...    teatro=Theater 1
    ...    assento=C8
    ...    preco=R$ 15.00
    ...    status=CONFIRMADA

TC_WEB_054 - Validar status da reserva
    [Documentation]    Verifica se o status da reserva está correto
    [Tags]    web    reservations    status    p1
    
    Acessar Pagina De Reservas
    Validar Status Da Reserva    index=0    status_esperado=CONFIRMADA

TC_WEB_055 - Verificar informacoes de pagamento
    [Documentation]    Valida as informações de pagamento da reserva
    [Tags]    web    reservations    payment    p1
    
    Acessar Pagina De Reservas
    Validar Preco Da Reserva    preco_esperado=R$ 15.00    index=0
    Validar Forma De Pagamento    pagamento_esperado=Cartão de Crédito    index=0

TC_WEB_057 - Navegar para pagina inicial
    [Documentation]    Testa a navegação para a página inicial
    [Tags]    web    reservations    navigation    p2
    
    Acessar Pagina De Reservas
    Clicar Voltar Para Pagina Inicial
    Validar Que Estou Na Home

TC_WEB_058 - Navegar para filmes em cartaz
    [Documentation]    Testa a navegação para a página de filmes
    [Tags]    web    reservations    navigation    p2
    
    Acessar Pagina De Reservas
    Clicar Ver Filmes Em Cartaz
    Sleep    2s

TC_WEB_060 - Validar poster do filme
    [Documentation]    Verifica se o poster do filme é exibido corretamente
    [Tags]    web    reservations    image    p2
    
    Acessar Pagina De Reservas
    Validar Poster Do Filme    imagem_esperada=avengers.jpg    index=0

TC_WEB_061 - Verificar quantidade de reservas
    [Documentation]    Valida a quantidade de reservas do usuário
    [Tags]    web    reservations    p1
    
    Acessar Pagina De Reservas
    Validar Quantidade De Reservas    quantidade_esperada=1

*** Keywords ***
Preparar Navegador E Fazer Login
    [Documentation]    Prepara navegador e faz login antes dos testes
    Abrir Navegador
    Acessar Aplicacao
    Login Como Usuario Web
    Log    🔐 Login realizado com sucesso    console=True
