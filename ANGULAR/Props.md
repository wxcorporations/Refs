
Criar um prop devemos carregar o decorator **Input** **de angular/core**
setar um atributo da classe como **@Input()**
este atributo ira passar ser reconhecido como **PROP de entrada** no componente pai


Componente filho **app-card-usuario**
``` ts
import { Component, Input } from '@angular/core';

@Component({
  selector: 'app-card-usuario',
  template: `
    <div>
      <h3>{{ nome }}</h3>
      <p>Idade: {{ idade }}</p>
    </div>
  `,
  standalone: true,
})
export class CardUsuarioComponent {
  @Input() nome = '';        // prop com valor default
  @Input() idade?: number;   // prop opcional
}

```

componente pai

aqui podemos ver que as duas propriedades do componente **nome** e **idade** se tronaram **PROPS**
``` ts
@Component({
  selector: 'app-root',
  template: `
    <app-card-usuario
      [nome]="'João'"  // prop
      [idade]="30">    // prop 
    </app-card-usuario>
  `,
  standalone: true,
  imports: [CardUsuarioComponent],
})
export class AppComponent {}

```