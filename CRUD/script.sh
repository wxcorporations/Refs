
SEMANA_1="Semana 1 — Conceitos Básicos e Ambiente" && mkdir "$SEMANA_1" && cd "$SEMANA_1";
echo . >> "Revisão de Node.js, arquitetura REST e diferença entre NoSQL e SQL.md";
echo . >> "Instale Node.js, VS Code, MongoDB e PostgreSQL.md";
echo . >> "Crie duas pastas: uma para o projeto com MongoDB e outra com PostgreSQL.md";
cd ..
SEMANA_2="Semana 2 — Projeto e Instalações" && mkdir "$SEMANA_2" && cd "$SEMANA_2";
echo . >> "Inicialize projetos com npm init -y nos dois ambientes.md";
echo . >> "Instale as dependências:md";
echo . >> "MongoDB: express, mongoose, dotenv.md";
echo . >> "PostgreSQL: express, pg, dotenv (ou sequelize para ORM opcional).md";
echo . >> "Configure a conexão básica com ambos os bancos (cluster no Mongo Atlas, database local ou cloud no PostgreSQL).md";
cd ..
SEMANA_3="Semana 3 — Estrutura da API e Schema Modelo" && mkdir "$SEMANA_3" && cd "$SEMANA_3";
echo . >> "MongoDB: Crie schema Mongoose para a entidade principal (ex: usuário, produto).md";
echo . >> "PostgreSQL: Crie a tabela via SQL ou ORM e modele a entidade.md";
echo . >> "PostgreSQL: Organize arquivos: app.js, rotas, controllers, models.md";
cd ..
SEMANA_4="Semana 4 — Métodos CRUD: CREATE e READ" && mkdir "$SEMANA_4" && cd "$SEMANA_4";
echo . >> "Implemente rotas POST (Create) e GET (Read) usando Express:md";
echo . >> "MongoDB: Model.create(), Model.find().md";
echo . >> "PostgreSQL: comandos SQL ORM INSERT, SELECT.md";
echo . >> "Teste os endpoints usando Postman ou Insomnia.md";
cd ..
SEMANA_5="Semana 5 — Métodos CRUD: UPDATE e DELETE" && mkdir "$SEMANA_5" && cd "$SEMANA_5";
echo . >> "Implemente rotas PUT PATCH (Update) e DELETE:md";
echo . >> "MongoDB: Model.findByIdAndUpdate(), Model.findByIdAndDelete().md";
echo . >> "PostgreSQL: comando SQL ORM UPDATE, DELETE.md";
echo . >> "Simule atualizações e remoções nos dois bancos.md";
cd ..
SEMANA_6="Semana 6 — Middlewares, Validação e Tratamento de Erros" && mkdir "$SEMANA_6" && cd "$SEMANA_6";
echo . >> "Use express.json() para JSON.md";
echo . >> "Adicione validação de dados (ex: com Joi ou validação manual).md";
echo . >> "Trate erros e envie respostas apropriadas de status.md";
cd ..
SEMANA_7="Semana 7 — Testes, Segurança e Boas Práticas" && mkdir "$SEMANA_7" && cd "$SEMANA_7";
echo . >> "Escreva testes básicos para endpoints (ex: com Jest ou Supertest).md"
echo . >> "Pratique autenticação básica (ex: JWT, permissões simples).md"
echo . >> "Revise padrões REST e boas práticas com manipulação de dados nos bancos.md"
cd ..
SEMANA_8="Semana 8 — Projeto Integração e Deploy" && mkdir "$SEMANA_8" && cd "$SEMANA_8";
echo . >> "Escolha um recurso (ex: produtos, tarefas) e elabore CRUD completo nos dois bancos.md";
echo . >> "Documente endpoints e arquitetura escolhida.md";
echo . >> "Simule deploy em serviços gratuitos (ex: Heroku, Vercel, MongoDB Atlas).md";