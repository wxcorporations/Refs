
Para utilizar o recurso de carregamento preguiçoso devemos utilizar o recurso **dinamic imports** junto como prop **loadChildren**


no arquivo de rotas da nossa aplicação devemos setar da seguinte forma

**lazy load**
``` ts

// app.router

const routes: Routes = [
  {
    path: 'items',
    // component: ItemsComponent carregamento normal. 
    loadChildren: () => import('./items/items.module').then(m => m.ItemsModule)
  }
];

```

**Observação** 

E muito semelhante ao carreamento normal o que muda que utilizando outra prop para **component** normais utilizamos a prop **component**

ex: carregamento normal.

``` ts
const routes: Routes = [
  {
    path: '',
    component: ItemsComponent
  }
];
```