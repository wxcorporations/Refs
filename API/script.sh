SEMANA_1="Semana 1 — Introdução, Ambiente e Conceitos Básicos" && mkdir "$SEMANA_1" && cd "./$SEMANA_1";
echo . >> "Conceitos: O que é Node.js, o que é Express, arquitetura REST.md";
echo . >> "Instalar Node.js e npm.md";
echo . >> "Instalar editor de código (VS Code recomendado).md";
echo . >> "Criação da pasta do projeto e inicialização com npm init -y.md";
cd ..
SEMANA_2="Semana 2 — Primeiros Passos com Express" && mkdir "$SEMANA_2" && cd "./$SEMANA_2";
echo . >> "Instalar o Express: npm install express.md";
echo . >> "Criar arquivo principal (app.js ou index.js).md";
echo . >> "Implementar servidor básico e rota GET na raiz (/).md";
echo . >> "Executar e testar localmente no navegador ou Insomnia/Postman.md";
cd ..
SEMANA_3="Semana 3 — Rotas e Métodos HTTP" && mkdir "$SEMANA_3" && cd "./$SEMANA_3";
echo . >> "Implementar rotas GET, POST, PUT e DELETE.md";
echo . >> "Receber e enviar dados em JSON.md";
echo . >> "Entender request e response.md";
echo . >> "Atividade: Criar rotas para um recurso (“produtos”, “usuários”, etc.) com simulação em array.md";
cd ..
SEMANA_4="Semana 4 — Middlewares e Estrutura do Projeto" && mkdir "$SEMANA_4" && cd "./$SEMANA_4";
echo . >> "O que são middlewares.md";
echo . >> "Usar o express.json() para receber JSON.md";
echo . >> "Estruturar o projeto: separar arquivos de rotas, controllers, models.md";
echo . >> "Atividade: Refatorar API para usar controladores e rotas separadas.md";
cd ..
SEMANA_5="Semana 5 — Persistência de Dados" && mkdir "$SEMANA_5" && cd "./$SEMANA_5";
echo . >> "Escolher um banco de dados (Ex: MongoDB ou SQLite).md";
echo . >> "Instalar dependências (ex: mongoose para MongoDB).md";
echo . >> "Integrar banco à API: CRUD completo.md";
echo . >> "Atividade: Persistir dados reais e testar operações.md";
cd ..
SEMANA_6="Semana 6 — Validação e Tratamento de Erros" && mkdir "$SEMANA_6" && cd "./$SEMANA_6";
echo . >> "Implementar validação de dados usando bibliotecas (ex: Joi, express-validator).md";
echo . >> "Tratar erros: enviar mensagens apropriadas e status de resposta corretos.md";
echo . >> "Atividade: Simular erros e corrigi-los.md";
cd ..
SEMANA_7="Semana 7 — Autenticação e Segurança" && mkdir "$SEMANA_7" && cd "./$SEMANA_7";
echo . >> "Implementar autenticação com JWT (jsonwebtoken).md";
echo . >> "Criar rotas protegidas.md";
echo . >> "Definir permissões básicas.md";
echo . >> "Atividade: Criar fluxo de login, registro e acesso restrito.md";
cd ..
SEMANA_8="Semana 8 — Testes Básicos e Deploy" && mkdir "$SEMANA_8" && cd "./$SEMANA_8";
echo . >> "Testes de rotas com ferramentas como Jest ou Supertest.md";
echo . >> "Validar funcionamento completo da API.md";
echo . >> "Documentar endpoints usando Swagger ou README.md";
echo . >> "Simular deploy local ou em serviços gratuitos (ex: Heroku, Vercel).md";