# Css module

## CSS NATIVO

### Instalação

```shell
npm install sass --save-dev
```

### Integração

Só é preciso criar arquivo com o nome do componento com sufixo .module.css

Criar o arquivo css na mesma raiz do componente.

```css
/* Padrão de nome: src/components/button.module.scss */

.button {
    padding: 10px;
    background: #bbb;
    border: 1px solid #eee;
}

.buttonLabel {
    font-size: 16px;
    color: white;
}
```

Importar o style no javascript.

```js
// src/components/button.js

import style from "./button.module.scss";
```

### Como usar

```javascript
// src/components/button.js
import style from "./button.module.scss";

export const button(props) => {
    return (<>
        <div className={style.button}>
            <span className={style.buttonLabel}></span>
        </div>
    </>)
}
```

**Ex: button.module.scss**

Podemos utilizar todas as features que o preprocessador nos possibilita.
