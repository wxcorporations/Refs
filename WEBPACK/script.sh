SEMANA_1="Semana 1 — Introdução ao Webpack" && mkdir "$SEMANA_1" && cd "./$SEMANA_1";
echo . >> "O que é Webpack: Entenda o conceito de bundler de módulos e sua utilidade em projetos modernos.md";
echo . >> "Instalação: Configure o ambiente e instale o Webpack globalmente ou localmente.md";
echo . >> "Primeira configuração: Crie seu primeiro arquivo de configuração webpack.config.js.md";
cd ..

SEMANA_2="Semana 2 — Conceitos Essenciais e Empacotamento" && mkdir "$SEMANA_2" && cd "./$SEMANA_2";
echo . >> "Entradas e Saídas: Como funciona o processo de bundling (entry, output).md";
echo . >> "Comandos básicos: webpack, webpack-cli, modos de execução (development, production).md";
echo . >> "Atividade prática: Bundle de arquivos JS simples e análise do resultado.md";
cd ..

SEMANA_3="Semana 3 — Loaders: Processando Diferentes Arquivos" && mkdir "$SEMANA_3" && cd "./$SEMANA_3";
echo . >> "O que são Loaders: A importância de converter arquivos (JSX, TypeScript, CSS, imagens, etc).md";
echo . >> "Principais loaders: babel-loader, css-loader, file-loader.md";
echo . >> "Atividade prática: Adicione suporte para CSS e imagens ao projeto via loaders.md";
cd ..

SEMANA_4="Semana 4 — Plugins: Automatizando e Otimizando" && mkdir "$SEMANA_4" && cd "./$SEMANA_4";
echo . >> "O que são Plugins: Diferença entre loaders e plugins.md";
echo . >> "Plugins essenciais: HtmlWebpackPlugin, MiniCssExtractPlugin, CleanWebpackPlugin.md";
echo . >> "Otimizações: Minificação e limpeza de arquivos obsoletos.md";
echo . >> "Atividade prática: Implemente plugins para automação do build.md";
cd ..

SEMANA_5="Semana 5 — Gerenciamento de Dependências e Módulos" && mkdir "$SEMANA_5" && cd "./$SEMANA_5";
echo . >> "Importação de módulos: Módulos ES6, CommonJS, tree-shaking.md";
echo . >> "Split de código: Divisão do código por rotas ou páginas (code splitting).md";
echo . >> "Atividade prática: Separar bundles para melhorar performance.md";
cd ..

SEMANA_6="Semana 6 — Ambiente de Desenvolvimento e Produtivo" && mkdir "$SEMANA_6" && cd "./$SEMANA_6";
echo . >> "Modo development e production: Diferenças e configurações.md";
echo . >> "Servidor de desenvolvimento: webpack-dev-server.md";
echo . >> "Hot Module Replacement: Atualização automática de módulos.md";
echo . >> "Atividade prática: Configuração de ambiente dev e build para produção.md";
cd ..

SEMANA_7="Semana 7 — Integração com Frameworks e Ferramentas" && mkdir "$SEMANA_7" && cd "./$SEMANA_7";
echo . >> "React/Vue/Angular: Principais adaptações na configuração do Webpack.md";
echo . >> "Integrando Babel, PostCSS, TypeScript.md";
echo . >> "Atividade prática: Configure Webpack com um framework e transpiler.md";
cd ..

SEMANA_8="Semana 8 — Projeto Final" && mkdir "$SEMANA_8" && cd "./$SEMANA_8";
echo . >> "Desenvolvimento: Escolha uma aplicação simples (ex: landing page ou blog).md";
echo . >> "Documentação: Explique suas escolhas de carregadores, plugins e arquitetura de pastas.md";
echo . >> "Compartilhe: Suba o projeto no GitHub e elabore uma explicação do fluxo de build.md";