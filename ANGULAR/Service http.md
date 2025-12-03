
## 1. Configurando o HttpClient (standalone app)

No Angular 17 (standalone), a forma recomendada é usar `provideHttpClient` no `app.config.ts`:


``` ts
// app.config.ts
import { ApplicationConfig } from '@angular/core';
import { provideHttpClient } from '@angular/common/http';

export const appConfig: ApplicationConfig = {
  providers: [
    provideHttpClient(), // HttpClient disponível na app inteira
  ],
};

```

Se quiser usar a API `fetch` em vez de `XMLHttpRequest`
```ts
import { provideHttpClient, withFetch } from '@angular/common/http';

export const appConfig: ApplicationConfig = {
  providers: [
    provideHttpClient(withFetch()),
  ],
};

```

## 2. Criando um service para chamar a API

Crie um service para isolar as chamadas HTTP:

```ts
// products.service.ts
import { Injectable, inject } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable } from 'rxjs';

export interface Product {
  id: number;
  name: string;
  price: number;
}

@Injectable({ providedIn: 'root' })
export class ProductsService {
  private http = inject(HttpClient);
  private readonly apiUrl = 'https://api.exemplo.com/products';

  getProducts(): Observable<Product[]> {
    return this.http.get<Product[]>(this.apiUrl);
  }

  getProduct(id: number): Observable<Product> {
    return this.http.get<Product>(`${this.apiUrl}/${id}`);
  }

  createProduct(data: Partial<Product>): Observable<Product> {
    return this.http.post<Product>(this.apiUrl, data);
  }

  updateProduct(id: number, data: Partial<Product>): Observable<Product> {
    return this.http.put<Product>(`${this.apiUrl}/${id}`, data);
  }

  deleteProduct(id: number): Observable<void> {
    return this.http.delete<void>(`${this.apiUrl}/${id}`);
  }
}

```

Aqui são usados os métodos `get`, `post`, `put`, `delete` do `HttpClient`, cada um retornando um `Observable` tipado.[](https://angular.dev/guide/http/making-requests)​

## 3. Consumindo o service em um componente standalone

```ts
// products.component.ts
import { Component, OnInit, inject } from '@angular/core';
import { CommonModule } from '@angular/common';
import { ProductsService, Product } from './products.service';

@Component({
  selector: 'app-products',
  standalone: true,
  imports: [CommonModule],
  template: `
    <h2>Produtos</h2>

    <ng-container *ngIf="loading; else content">
      <p>Carregando...</p>
    </ng-container>

    <ng-template #content>
      <p *ngIf="error" class="text-red-500">{{ error }}</p>

      <ul *ngIf="products.length">
        <li *ngFor="let p of products">
          {{ p.name }} - {{ p.price | currency:'BRL' }}
        </li>
      </ul>
    </ng-template>
  `,
})
export class ProductsComponent implements OnInit {
  private productsService = inject(ProductsService);

  products: Product[] = [];
  loading = false;
  error = '';

  ngOnInit(): void {
    this.loadProducts();
  }

  loadProducts() {
    this.loading = true;
    this.error = '';

    this.productsService.getProducts().subscribe({
      next: (data) => {
        this.products = data;
        this.loading = false;
      },
      error: () => {
        this.error = 'Erro ao carregar produtos.';
        this.loading = false;
      },
    });
  }
}

```


O componente injeta o service e chama getProducts(), assinando o Observable para receber os dados e tratar erros.​

4. Exemplo simples de POST com formulário
``` ts
// no service
addProduct(product: Partial<Product>) {
  return this.http.post<Product>(this.apiUrl, product);
}
ts
// no componente
add() {
  const novo = { name: 'Mouse', price: 99.9 };
  this.productsService.addProduct(novo).subscribe({
    next: (res) => console.log('Criado', res),
    error: () => console.log('Erro ao criar'),
  });
}
Isso cobre o fluxo básico: configurar HttpClient, criar um service, fazer GET/POST/PUT/DELETE e consumir em componentes standalone no Angular 17
```