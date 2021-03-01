# Projeto Final - Etapa 01 - TreinaDev

## Work in progress! :warning:
<p>
<img src="https://img.shields.io/badge/Ruby-2.7.0-red">
<img src="https://img.shields.io/badge/Rails-6.1.3-red">
<img src="https://img.shields.io/badge/sqlite3-1.4-blue">
<img src="https://img.shields.io/badge/rspec-4.0.2-lightgrey">
</p>

### Tópicos 

:small_blue_diamond: [Descrição do projeto](#descrição-do-projeto)

:small_blue_diamond: [TODO List do projeto](#todo-list-do-projeto)

:small_blue_diamond: [Ferramentas necessárias](#ferramentas-necessárias)

:small_blue_diamond: [Trello](#trello)

:small_blue_diamond: [Db Designer](#db-designer)


## Descrição do projeto
<p align="justify"> Este projeto consiste em uma aplicação Web para conectar empresas e pessoas através de vagas de emprego. </p>


## TODO List do projeto 
- [x] Setup configurado 
- [x] Visitante acessa o site
- [x] Visitante se cadastra como Colaborador (employee)
- [x] Colaborador cadastra sua empresa
- [x] Colaborador gerencia os dados de sua empresa
- [x] Colaborador cadastra uma nova vaga de emprego
- [X] Colaborador gerencia as vagas de emprego de sua empresa
- [x] Visitante visualiza empresas
- [X] Visitante cria sua conta como candidato
- [X] Visitante se candidata para uma vaga
- [X] Colaboradores recebem as candidaturas
- [X] Colaboradores declinam ou fazem propostas para candidatos 
- [X] Candidato acompanha suas candidaturas
- [X] Candidato aceita/recusa uma proposta
- [] Vaga é desativada automaticamente devido sua data

## Ferramentas necessárias:
- Ruby Versão 2.7.0
- Rails Versão ~>6.1.1
- Rspec Versão ~> 4.0.2
- Capybara
- Devise


## Como rodar a aplicação
No terminal, clone o projeto:
```
git clone https://github.com/chrisleo-usa/final_project_fase1_td5.git
```

entre na pasta do projeto:
```
cd final_project_fase1_td5
```

Rode o comando:
```
bin/setup
```

Execute o comando abaixo para criar o banco de dados:
```
rails db:migrate
```

Execute o comando abaixo para popular o Banco de Dados com os dados que estão no arquivo *db/seeds.rb*:
```
rails db:seed
```

Execute a aplicação:
```
rails server
```

Para rodar os testes execute o comando rspec
```
rspec
```

## Dados para teste

## **Candidatos**
* Christopher - Email: `chris@gmail.com`, senha: `123456`
* Susan - Email: `susan@yahoo.com.br`, senha: `123456`

## **Empresas**
* Campus Code
* TreinaDev

## **Colaboradores das Empresas**
* Campus Code - João (Admin) - email: `joao@campuscode.com`, senha: `123456`
* Campus Code - Henrique - email: `henrique@campuscode.com`, senha: `123456`

* TreinaDev - Fred (Admin) - email: `fred@treinadev.com.br`, senha: `123456`
* TreinaDev - Jonata - email: `fred@treinadev.com.br`, senha: `123456`

## **Vagas de empregos**
* Campus Code - `Ruby on Rails Developer Jr`
* Campus Code - `Back End Developer`

* TreinaDev - `Javascript Developer Pl`
* TreinaDev - `Front End Developer Jr`


## Trello
Para a construção deste projeto a Campus Code encaminhou todas as informações e funcionalidades que deveriam conter nele e para uma melhor organização estou utilizando a plataforma Trello. Para acompanhar meu raciocínio, você pode visitar o meu quadro no Trello com o link abaixo: 

[https://trello.com/b/khSFsuqm/projeto-final-treinadev](https://trello.com/b/khSFsuqm/projeto-final-treinadev)

## Db Designer
Para auxiliar no entendimento do banco de dados utilizei o Db designer, uma ferramenta de modelagem do banco de dados. 

[https://dbdesigner.page.link/WjZ4qQ1BqhDPPeNM6](https://dbdesigner.page.link/WjZ4qQ1BqhDPPeNM6)

#### Tenho como objetivo finalizar o projeto antes da 2ª data de entrega (01/03/2021), definitivamente avançar para a 2ª etapa e conseguir uma vaga em uma das empresas patrocinadoras será um divisor de águas em minha trajetória profissional. 

:copyright: 2021 - Projeto Final - Etapa 1 - TreinaDev - Christopher Leonardo Alves
