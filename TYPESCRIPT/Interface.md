# Interface

Interface é uma feature que possibilita criar contratos com todas as especificações de um objeto ou classe.

**Em classe:**

Para utilizar interface em classe deve utilizar a palavrar implements com a interface.

```ts
interface Iforma {
    x: number;
    y: number;
    render(): string;    
}

class Quadrado implements Iforma {
    constuctor(x:number, y:number) {
        this.x = x
        this.y = y
    }
    render() {
        //...
    }
}
```

**Em objeto:**

Garante que o objeto tenha a mesma estrutura definida na interface.

```ts
interface IDadosPessoais {
    nome: string;
    idade: number;
    attrOpicional?: boolean;
}


const pessoa: IDadosPessoais = {
    nome: "fernando",
    idade: 36,
    // attrOpicional: true
}
```

## Extensão de interface:

```ts
interface IBase {
    x: number;
    y: number;
}

interface ISomaBase extends IBase {
    calc(): number;
}


/*
ISomaBase e equivalente ao objeto abaixo.
{
    x: number;
    y: number;
    calc(): number;
}
*/
```
