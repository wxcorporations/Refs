# Namespace

Este padrão é utilizado amplamente me projetos legados

É uma otima opção para projetos pequenos.

Ele possibilita a organização do código em contextos lógico. Isso garante que colisão de variaveis não ocoram.

Todos mebros pertencente ao namespace pode ser acessivel localmente com a notação de ponto

**O que seria mebros**

tudo que for definido dentro do namespace [**variaveis, funções, interfaces, constantes, class**] 

Caso queira acessar algum membro em um arquivo externo tera que setar o menbro com o **export**

Ex.

```ts
namespaceTeste.funcionalidade()
namespaceTeste.Card()
```

Sintaxe

```ts
// src/component/formas.ts

namespace Formas {

    // acessivel somente no arquivo localmente
    const valor:string = "teste";

    // acessivel por outros modulos
    export interface IQuadrado = {
        x: string,
        y: string
    } 

    // metodo visivel somente localmente
    function quadrado(data: IQuadrado):any {
        //...
    }

    // metodo acessivel per modulos externos.
    export function circulo(raio:number) {
        //....
    }
}


namespace Calculo {
    export function soma(x:number, y:number): number {
        //...
    }
}

// acessando menbro local.
console.log(Fomas.valor)
```

Exemplo acesso via modulo externo

```ts
import { Forma } from "src/component/formas.ts";


Forma.quadrado({x: 10, y: 20});
Forma.circulo(10);

// nao é acessivel.
// Forma.valor
```
