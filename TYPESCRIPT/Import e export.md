# Impot

**sintaxe:**

```js
// import default
import Card from "/src/components/card";

// -----------------------------------------------

// import com destruturacao
import { RenderCard } from "/src/components/card";
```

# Export

**sintaxe:**

```js
export default class Card {
    //...
}

// -----------------------------------------------

export function RenderCard(data) {
    //...
}
```

# AS alias

Ele possibilita criar um alias ao modulo carregado.

**sintaxe:**

```js
// import default
import Card as MeuCard from "/src/components/card";

const _card = new MeuCard();

// -----------------------------------------------

// import com destruturacao
import { RenderCard as CriarCard } from "/src/components/card";

const _gerandorCard = new CriarCard(); 
```
