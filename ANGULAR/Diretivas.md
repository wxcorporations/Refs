Diretivas são classes que adicionam comportamento extra a elementos em sua aplicação angular.

## Tipos de diretivas

- Componente
- diretivas de Atributos
- diretirvas estruturais
### Componente
utilizada com um modelo é a mais comum

### Diretiva de atributo
Altera aparência ou comportamento de um elemento. componente ou outra diretiva

Mais comum.
**ngClass** -> definir **classes css dinamicas** 
**ngStyle** -> definir **css inline** 
**ngModel** -> permite a mudaça de dados bidirecional **two way data bind**


#### ngClass - css dinamico

neste exemplo a class css special será adicionada caso isSpecial seja verdadeiro. 
``` ts
import {CommonModule} from '@angular/common';
/* . . . */
@Component({
  standalone: true,
  /* . . . */
  imports: [
    CommonModule, // <-- import into the component
    /* . . . */
    template: `
	    <!-- toggle the "special" class on/off with a property -->
		<div [ngClass]="isSpecial ? 'special' : ''">This div is special</div>  
    `
  ],
})
export class AppComponent implements OnInit {
  /* . . . */
}
```

Utilizando método para adicionar multiplas class css.
neste exemplo temos um metodo que ira retornar um objeto onde cada key correponde a uma classe css. Somente se o valor for verdadeiro ela ira ser adicionada . 

``` ts
// src/app/app.component.ts

currentClasses: Record<string, boolean> = {};
/* . . . */
setCurrentClasses() {
  // CSS classes: added/removed per current state of component properties
  this.currentClasses = {
    saveable: this.canSave,  // true
    modified: !this.isUnchanged,  // false
    special: this.isSpecial,  // true
  };
}

```

aplicando no template.
``` ts
// src/app/app.component.html

<div [ngClass]="currentClasses">template com classe css dinamicas.</div>

// interpretado

<div class="saveable special">template com classe css dinamicas.</div>

```


---

#### ngStyle - css inline na tag html

``` ts
// src/app/app.component.ts

currentStyles: Record<string, string> = {};
/* . . . */
setCurrentStyles() {
  // CSS styles: set per current state of component properties
  this.currentStyles = {
    'font-style': this.canSave ? 'italic' : 'normal',  // true
    'font-weight': !this.isUnchanged ? 'bold' : 'normal', // false
    'font-size': this.isSpecial ? '24px' : '12px', // false
  };
}

```

``` ts
// src/app/app.component.html

<div [ngStyle]="currentStyles">
  This div is initially italic, normal weight, and extra large (24px).
</div>

// interpretado
<div style="font-style:italic; font-weight:normal; font-size:12px">...</div
```

---

#### ngModel - two way data bind

possibilita iteração bidirecional qual alteração seja na model ou no template ela ira refletir em ambos lugares

``` ts

// src/app/app.component.ts (FormsModule import)

import {FormsModule} from '@angular/forms'; // <--- JavaScript import from Angular
/* . . . */
@Component({
  standalone: true,
  /* . . . */
  imports: [
    CommonModule, // <-- import into the component
    FormsModule, // <--- import into the component
    /* . . . */
  ],
})
export class AppComponent implements OnInit {
  /* . . . */
}
```

``` ts
// src/app/app.component.html

<label for="example-ngModel">[(ngModel)]:</label>
<input [(ngModel)]="currentItem.name" id="example-ngModel">

```
### Diretrizes estruturais 
Altere o layout do DOM adicionando e removendo elementos DOM

- **ngIF**  - permite adicionar ou remove um elemento a partir de uma validação condicional
- **ngSwitch** - parecido com switch do js porem ele ira renderizar um elemento correpondente ao valor do switch.
- **ngFor** - intera um compoente com base em uma lista de elementos.
 


#### ngIf

``` ts
<app-item-detail *ngIf="isActive" [item]="item"></app-item-detail>
```

#### ngSwitch

``` ts

<div [ngSwitch]="currentItem.feature"> // stout

  // item que sera rederizado
  <app-stout-item *ngSwitchCase="'stout'" [item]="currentItem"></app-stout-item>
  <app-device-item *ngSwitchCase="'slim'" [item]="currentItem"></app-device-item>
  <app-lost-item *ngSwitchCase="'vintage'"[item]="currentItem"></app-lost-item>
  <app-best-item *ngSwitchCase="'bright'" [item]="currentItem"></app-best-item>

  // caso valore não corresponda a nenhuma das opções
  <app-unknown-item *ngSwitchDefault [item]="currentItem"></app-unknown-item>
</div>

```

#### ngFor

``` ts

<div *ngFor="let item of items">{{item.name}}</div>

ou 

<app-item-detail *ngFor="let item of items" [item]="item"></app-item-detail>

ou 

<div *ngFor="let item of items; let i=index">{{i + 1}} - {{item.name}}</div>

```

#### ng-container

Faz a mesma coisa que: o 
**framents**  do React  
**template**  do vue

```ts
<p>
  I turned the corner
  <ng-container *ngIf="hero">
    and saw {{hero.name}}. I waved
  </ng-container>
  and continued on my way.
</p>
```