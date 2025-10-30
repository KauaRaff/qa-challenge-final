# QA Challenge Final – Cinema App

## :movie_camera: Visão Geral  
Esse repositório contém o código de automação de testes (API + Web) para a aplicação “Cinema”, desafio final do processo seletivo da empresa PB.  
Ele inclui:  
- Testes de API com Robot Framework + RequestsLibrary  
- Testes web (E2E) com Browser Library / Playwright  
- Plano de testes, mapa mental e relatórios de resultados  
- Estrutura pronta para integração contínua via GitHub Actions  

## 🗂️ Estrutura do Repositório  
```
├─ cinema‑app‑automation/ # Código de automação
│ ├─ resources/api/ # Serviços/recursos da API
│ ├─ tests/api/ # Testes de API (.robot)
│ └─ tests/web/ # Testes web/E2E (se aplicável)
├─ results/ # Relatórios, screenshots, logs
├─ Planejamento‑de‑testes‑CinemaAPP.pdf # Documento de planejamento
├─ Relatorio de issue.pdf # Relatório de issues encontradas
└─ mapa mental ‑ challenge final.jpg # Imagem do mapa mental do fluxo
```


## ⚙️ Tecnologias Utilizadas  
- Robot Framework (versão 6.1+)  
- RequestsLibrary – para requisições HTTP  
- Browser Library / Playwright – para testes web  
- Git + GitHub + GitHub Actions – versionamento e CI  
- MongoDB (dependência da aplicação sob teste)  
- JWT para autenticação de API  

## 🚀 Como Executar os Testes  
1. Clone o repositório:  
   ```bash
   git clone https://github.com/KauaRaff/qa‑challenge‑final.git
   cd qa‑challenge‑final

   
   Verifique se a aplicação “Cinema” está rodando nos ambientes definidos:
   API: http://localhost:5000/api/v1
   Front‑end: http://localhost:3000


   Execute a suíte de testes de API:
   robot cinema‑app‑automation/tests/api
   robot cinema‑app‑automation/tests/web


📦 Branches & Fluxo de Trabalho

main → branch estável, pronta para entrega

skeleton → estrutura base do projeto

doc → versão de documentações e tabelas

dev, feature/* → para desenvolvimento ativo






🔹 Autor
Kaua Raffaello (NoBugs) – QA
