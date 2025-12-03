
Docker file é um arquivo de configuração, ele é bem semelhante a uma receita de bolo onde passamos o passo a passo para contrução do ambiente da nossa aplicação.


## Obs
>Ao copiar os arquivos tenha cuidado para não copiar todos seu arquivos para imagem, isso pode expor alguma configuração, chave privada.


## Bloquear copia de arquivos e pastas para imagem

### .dockerignore

O papel dele é bem semelhante ao do .gitignore podemos defir quais arquivos ou diretorios não deve ser copiados para a imagem.


Ex. docker file do projeto front-end

```yalm
# Definir a imagem base
# AS define o nome da imagem.

FROM node:20-alpine AS octoplay

  

# Definir hoot do projeto toda aplicação sera definida dentro dessa página

WORKDIR /app

  

# Copiar os arquivos de dependencia - para instalação posterior

COPY ./package*.json ./

  

# instalar dependencias na imagem

RUN npm install

  

# expor porta 3000
# Aqui estamo espondo a porta 3000

EXPOSE 3000

  

# Aqui setamos o que deve ser executado para executar nossa aplicação seja prod ou dev neste exemplo estamo executando modo dev.

CMD ["npm", "run", "start"]
```


## Criando imagem a partir do dockerfile.

[doc](https://docs.docker.com/build/)
Após ter criado o dockerfile, rodo o seguinte comando.

``` shell
# constroi a imagem sintaxe

# OBs. rode comando na mesma pasta onde o arquivo se encontra isso possibilita omitir seu nome passando somente "."
docker build -t nome-imagem [. || path-dockerfile]

#ex:
docker build -t octoplay .
```

## Executando imagem. 

Comando base
```shell

# parametros
# ------------------------------------------------
# -v = volume - sintaxe: -v path-volume-origen:path-volume-destino 
# -p = porta  - sintaxe: -p porta-origem:porta-destino

# sintaxe 
docker run -v volume:volume -p porta:porta imagem

# ex:
docker run -p 3000:3000 -v $(pwd):/app octoplay

```


## Vasculhando imagem criada.

```shell

# Ele ira carregar o modo interativo bash
docker run -it --rm octoplay /bin/bash

# ou
docker run -it --rm octoplay /bin/sh

# apos carregar o bash, qualquer comando pode ser executado tipo ls cd rm...
```