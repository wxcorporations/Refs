# Estilização de componentes

As duas principais forma de lidar com estilização de componetes no react são:

- css module

- style component

## Vantagens

**css module:** 

Escopo local, sintaxe nativa do css, simplicidade na hora de gerar os bundle já que ferramentas como webpack vite já fazem por padrão.

**style component:**

Maior possibilidade de interação, como tudo é realizado no javascript possibilita maior dinâmismo.

## Desvantagem

**css module:**

Menos flexibilidade, não permite utilizar lógica complexa.

**style component:**

Dependência de biblioteca, um pouco mais pesado comparado a abordagem do css nativo.

[Doc css module](./css.module.md)

[Doc style component](./style.components.md)

## Estilos globais

Por padrão eles são importado no arquivo de entrepoint ex

index.js, main.js, app.js.

Nele podemos carregar nossas bibliotecas de terceiros e estilos comum entre os componentes.
