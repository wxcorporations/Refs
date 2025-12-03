
No angular temos um pacote que possibilita realizar validações em nosso inputs.
Ele trabalha junto com **formGroup e formControl**


**Etapas**
	1 - setar os validator
	2 - pegar referencia do input

## Configurando os validadores

``` ts
import { Component } from '@angular/core';
import { FormControl, FormGroup, ReactiveFormsModule, Validators } from '@angular/forms';
import { HousingService } from '../../../service/housing-service';

@Component({
  selector: 'app-form-test',
  templateUrl: './form-test.html',
  styleUrl: './form-test.css',
  imports: [ReactiveFormsModule],
})
export class FormTest {

  form = new FormGroup({
    firstName: new FormControl('', [
	    Validators.required,          // setando validador requirido 
	    Validators.minLength(5)       // setando validador minimo 5 char
	]),
  });

  constructor(private housingService: HousingService) {}
}
```
## Utilizando validadores

**Como verificar se form possui erro.**
``` ts
// retorna boolean caso algum field setando no objeto passado 
// via argumento no FormGroup ele ira retornar true
this.form.invalid  // boolean
```

**Checando field**
```ts
// Voce tera que busca o field em form via metodo get passando o nome dele
// ele ira retorna um objeto do tipo formControl

// criando referencia ao field firstName
fieldName = this.form.get('firstName');

// retorna se o campo e válido
fieldName.invalid

```

## Notificação erros nos fields

- criar uma referencia ao field
- criar de validação do campo 
- criar função que gerencia o retorno de erro no template
- aplica logica no template


**Fn retorna referencia do input do formGroup**
``` ts
// referencia do field
  get fieldFirstName() {
    return this.form.get('firstName');
  }
```

**Fn que ira controlar exibição do erro no template**
``` ts
  // valida se o campo e valido em caso de algum erro retorn true
  get validateFirstName() {
    return this.fieldFirstName?.touched && this.fieldFirstName?.invalid;
  }	
```

**FN gerenciadora retorno de erro a ser exibido no template**
```ts

handleErrorFristName(): string {
    if (!this.fieldFirstName || !this.fieldFirstName.errors) return '';

    if (this.fieldFirstName.errors['required']) return 'Nome é obrigatório.';
    if (this.fieldFirstName.errors['minLength']) return 'Nome deve possuir mais de 5 char';

    return 'Valor inválido.';
  }
```

**Aplicando logica no template**
``` html
<form action="" [formGroup]="form" (submit)="submitApplication()">
    <label for="first-name">Nome</label>
    <input id="first-name" type="text" formControlName="firstName" (blur)="activeSubmit()" />

    @if (validateFirstName) {
    <span class="text-red-500 text-sm"> {{ handleErrorFristName() }} </span>
    }
    
    <button
        type="submit"
        [disabled]="disable"
        class="p-4 m-3 bg-green-500 text-white font-bold hover:bg-green-200 disabled:bg-gray-200"
    >
        Enviar
    </button>
</form>
```



## Exemplo completo

class
```ts
import { Component } from '@angular/core';
import { FormControl, FormGroup, ReactiveFormsModule, Validators } from '@angular/forms';
import { HousingService } from '../../../service/housing-service';

@Component({
  selector: 'app-form-test',
  templateUrl: './form-test.html',
  styleUrl: './form-test.css',
  imports: [ReactiveFormsModule],
})
export class FormTest {
  // data form
  // ============================================
  form = new FormGroup({
    firstName: new FormControl('', [
	    Validators.required, 
	    Validators.minLength(5)
	]),
  });

  // data view
  // ============================================
  disable = false;

  constructor(private housingService: HousingService) {}


  // referencia do field
  get fieldFirstName() {
    return this.form.get('firstName');
  }

  // validador no template
  get validateFirstName() {
    return this.fieldFirstName?.touched && this.fieldFirstName?.invalid;
  }

  // tratando erros do fields
  handleErrorFristName(): string {
    if (!this.fieldFirstName || !this.fieldFirstName.errors) return '';

    if (this.fieldFirstName.errors['required']) return 'Nome é obrigatório.';
    if (this.fieldFirstName.errors['minLength']) return 'Nome deve possuir mais de 5 char';

    return 'Valor inválido.';
  }
}

```