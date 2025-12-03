
Forma geralmente e dividido em 4 etapas 

- importa e registrar modulo e diretivas.
- definindo modelo do formulário na class
- configurando template
- service responsável pelo envio

## 1º - Importando modulo e diretivas

Para utilizar o recurso de form do angular é necessários importa e registras modulo e diretivas

**importando modulo:**
```ts
import { FormControl, FormGroup, ReactiveFormsModule } from '@angular/forms';
```


## 2º - Definindo modelo do formulário na class


1 devemos definir um form
2 definir todos os campos do formulário

```ts
  
import { Component } from '@angular/core';
// etapa 1
import { FormControl, FormGroup, ReactiveFormsModule } from '@angular/forms';

// etapa 4 - importa service
import { HousingService } from '../../../service/housing-service';

@Component({
	selector: 'app-form-test',
	templateUrl: './form-test.html',
	styleUrl: './form-test.css',
	imports: [ReactiveFormsModule], // etapa 2 - setar
})

export class FormTest {
	// etapa 2 - definindo model do formulário
	applyForm = new FormGroup({
		firstName: new FormControl(''), // definindo campo 
		lastName: new FormControl(''), // definindo campo
		email: new FormControl(''), // definindo campo
	})

	// etapa 4 registrando [ service ]
	constructor(private housingService: HousingService) { }


	submitApplication() {
		// etapa 4 utilizando [ sevice ]
		this.housingService.submitApplication(
			this.applyForm.value.firstName ?? '',
			this.applyForm.value.lastName ?? '',
			this.applyForm.value.email ?? ''
		)
	}
}
```


## 3º Configurando template

**Obs:** 
As tags deve ser setadas com as diretiva e seu valores, os valores são os memos setados nas classes 
ex: 

**formGroup** faz referencia do form com atributo da class
**formControlName**  faz referencia do input com atributo setado na classe

| Diretiva            | Class                          | Template                    |
| ------------------- | ------------------------------ | --------------------------- |
| **formGroup**       | applyForm = new FormGroup({})  | [formGroup]="applyForm"     |
| **formControlName** | firstName: new FormControl('') | formControlName="firstName" |
|                     |                                |                             |

``` html
<form action="" [formGroup]="applyForm" (submit)="submitApplication()">
	<label for="first-name">Nome</label>
	<input id="first-name" type="text" formControlName="firstName">
	
	<label for="last-name">Sobre nome</label>
	<input id="last-name" type="text" formControlName="lastName">
	
	<label for="email">E-mail</label>
	<input id="email" type="email" formControlName="email">
	
	<button type="submit"> Enviar </button>
</form>
```


## 4º Enviando dados com uma service

O service deve ser criado via CLI

``` shell
ng generate service service/userRegisterService
```

Dentro da service crie seu método de envio

``` ts
import { Injectable } from '@angular/core';

@Injectable({
	providedIn: 'root',
})

export class HousingService {

	submitApplication(name: string, lastName: string, email: string): void {
		console.log(`Name: ${name} ${lastName} - E-mail: ${email}`)
	}
}
```

