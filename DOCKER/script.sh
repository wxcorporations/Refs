SEMANA_1="Semana 1 — Conceitos Fundamentais e Instalação" && mkdir "$SEMANA_1" && cd "./$SEMANA_1";
echo . >> "O que é Docker, containers, imagens e diferença entre máquinas virtuais e containers.md"
echo . >> "Instalar Docker no seu sistema (Windows, Linux, Mac).md"
echo . >> "Criar conta no Docker Hub.md"
cd ..

SEMANA_2="Semana 2 — Comandos Básicos e Primeiros Contêineres" && mkdir "$SEMANA_2" && cd "./$SEMANA_2";
echo . >> "Comandos essenciais: docker run, docker ps, docker stop, docker rm, docker pull, docker images, docker rmi.md";
echo . >> "Executar e remover contêineres de imagens públicas (hello-world, nginx, etc).md";
echo . >> "Experiência prática rodando aplicações simples.md";
cd ..

SEMANA_3="Semana 3 — Imagens, Dockerfile e Customização" && mkdir "$SEMANA_3" && cd "./$SEMANA_3";
echo . >> "Entendendo e usando imagens.md";
echo . >> "Escrever o primeiro Dockerfile para criar uma imagem customizada.md";
echo . >> "Comandos: docker build, docker tag, docker push.md";
echo . >> "Publicar imagem no Docker Hub.md";
cd ..

SEMANA_4="Semana 4 — Volumes e Persistência de Dados" && mkdir "$SEMANA_4" && cd "./$SEMANA_4";
echo . >> "O que são volumes, bind mounts e suas utilidades.md";
echo . >> "Comandos: docker volume create, docker volume ls, docker volume inspect.md";
echo . >> "Prática: Montar volumes para persistir dados de aplicações containerizadas.md";
cd ..

SEMANA_5="Semana 5 — Redes e Comunicação entre Containers" && mkdir "$SEMANA_5" && cd "./$SEMANA_5";
echo . >> "Conceitos de redes no Docker: bridge, host, overlay.md";
echo . >> "Expor portas dos containers (-p) e conectar múltiplos containers.md";
echo . >> "Prática: Rodar dois containers que se comunicam (ex: NodeJS + MongoDB).md";
cd ..

SEMANA_6="Semana 6 — Docker Compose (Orquestração Simples)" && mkdir "$SEMANA_6" && cd "./$SEMANA_6";
echo . >> "O que é e para que serve o Docker Compose.md";
echo . >> "Escrever e executar docker-compose.yml para aplicações multicontainer.md";
echo . >> "Prática: Subir um ambiente com banco de dados e aplicação web.md";
cd ..

SEMANA_7="Semana 7 — Gerenciamento, Segurança e Deploy" && mkdir "$SEMANA_7" && cd "./$SEMANA_7";
echo . >> "Gerenciamento de imagens e containers.md";
echo . >> "Introdução à segurança: usuários, imagens trusted, boas práticas.md";
echo . >> "Deploy em ambientes de produção básicos (Docker Playground, serviços cloud).md";
cd ..

SEMANA_8="Semana 8 — Projeto Integrador Prático" && mkdir "$SEMANA_8" && cd "./$SEMANA_8";
echo . >> "Escolher um pequeno sistema (ex: uma aplicação web com backend e banco).md";
echo . >> "Documentar modelo de containers, Dockerfiles e compose.md";
echo . >> "Publicar imagens no Docker Hub.md";
echo . >> "Compartilhar o projeto e revisar aprendizados.md";
