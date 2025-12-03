


## forma mais simples.

Importe service no **compoente** e passe ele no contrutor do componente.

``` ts
export class ListaUsuariosComponent {
  constructor(private usuarioService: UsuarioService) {}
}
```



**Nova forma**

```shell
ng generate service services/usuario
# ou
ng g s services/usuario

```

Isso gera algo como:

``` ts
import { Injectable } from '@angular/core';

@Injectable({
  providedIn: 'root', // singleton global
})
export class UsuarioService {
  private usuarios = ['Ana', 'João'];

  getUsuarios() {
    return this.usuarios;
  }

  addUsuario(nome: string) {
    this.usuarios.push(nome);
  }
}

```

`providedIn: 'root'` faz o Angular criar **uma única instância** para a app inteira e torná-la disponível em qualquer lugar, com tree-shaking se não for usada.[](https://angular.dev/guide/di/creating-and-using-services)​

## 2. Injetando o service em um componente (standalone)

Jeito moderno com `inject()`:


``` ts
import { Component, inject } from '@angular/core';
import { UsuarioService } from './services/usuario.service';

@Component({
  selector: 'app-lista-usuarios',
  standalone: true,
  template: `
    <h3>Usuários</h3>
    <ul>
      <li *ngFor="let u of usuarios">{{ u }}</li>
    </ul>
    <button (click)="adicionar()">Adicionar</button>
  `,
})
export class ListaUsuariosComponent {
  private usuarioService = inject(UsuarioService);

  usuarios = this.usuarioService.getUsuarios();

  adicionar() {
    this.usuarioService.addUsuario('Novo usuário');
    this.usuarios = this.usuarioService.getUsuarios();
  }
}

```

O `inject(UsuarioService)` pede a instância do service ao sistema de DI do Angular.[](https://angular.dev/guide/di)​

Se preferir o estilo antigo, também funciona:

``` ts
export class ListaUsuariosComponent {
  constructor(private usuarioService: UsuarioService) {}
}
```
## 3. Injetando service em outro service


``` ts
import { Injectable, inject } from '@angular/core';
import { UsuarioService } from './usuario.service';

@Injectable({ providedIn: 'root' })
export class LogService {
  private usuarioService = inject(UsuarioService);

  logUsuarios() {
    console.log(this.usuarioService.getUsuarios());
  }
}

```

Um service pode depender de outro normalmente, via DI.[](https://v17.angular.io/tutorial/tour-of-heroes/toh-pt4)​

## 4. Services com escopo diferente (não-root)

Se quiser uma instância específica por componente (escopo local), não use `providedIn: 'root'` e forneça no `providers` do componente:

ts

``` ts
@Injectable()
export class FiltroService {
  // ...
}

@Component({
  selector: 'app-tabela',
  standalone: true,
  providers: [FiltroService], // nova instância por componente
  template: `...`,
})
export class TabelaComponent {
  private filtro = inject(FiltroService);
}
```

Assim cada `TabelaComponent` tem seu próprio `FiltroService`.[](https://angular.dev/guide/di/defining-dependency-providers)​

Se quiser, dá para montar um exemplo com `HttpClient` (service para chamar API REST) já no padrão Angular 17 + standalone.