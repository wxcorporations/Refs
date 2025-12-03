# Zod

https://zod.dev/packages/zod



Lib para realizar validações de dados.



## Instalacao no projeto:

Ele é um pacote disponivel no npm então podemos importalo em qualquer 

projeto node.js



```shell
npm i zod
```



## Importando em seu script

```js
import * as zod from "zod"
```



## Criando validador:

### objeto complexo:

```js

// criando um validador de um objeto complexo.
const User = z.object({
  name: z.string(),
})

// criando validador vinculado a uma variavel do tipo primitivo "string, number..."


```

### validador simplex "primitivos string, number..."

```js
const validateFullName = zod.string().min(4).
const stringNoEmpt = zod.string().nonempty()
```



## Utilizando o validador.

**parse()**

```js
validateFullName.parse('a') // retorna um obj erro.
```


