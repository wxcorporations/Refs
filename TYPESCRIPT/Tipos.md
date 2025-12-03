# Tipos no typescript

**Temos tipos primitivos:**

- string: texto

- number: numeros em geral

- boolean: true ou false

- bigint: Numeros inteiros com precisão 

- symbol: Usado para criar identificadores únicos

- null: Ausencia intencional de valor

- undefined: Variavel criada sem valor definido.

**Tipos estruturais:**

- object: qualquer valor que não seja primitivo

- Array: lista de valores do mesmo tipo.

- Tuple: Array com tamanho fixo.

- enum: Agrupamento de constantes.

**Tipos especiais**

- any: qualquer valor.

- unknown: Similar a any porem mais seguro.
  
  - vc tera que validar o valor antes de utilizalo 

- void: Indicar que não possui um retorno

- never: Retorno de função que possa retornar uma excessão ou loop infinito.

**unknown**

```typescript
let nome: unknown = 'fernando'

console.log(nome.toUpperCase()) // erro

if (typeof nome === 'string') {
    console.log(nome.toUpperCase() // FERNANDO   
}
```

**tuple**

```typescript
let item = [string, number, boolean?] 
item = ['fernando', 10, false]
```
