# React Router

Lib em react que possibilita o gerenciamento de rotas em aplicações spa 

**single page aplication**

## Repositoiros e docs

[NPM](https://www.npmjs.com/package/react-router)  -  [GITHUB](https://github.com/remix-run/react-router)   -  [SITE-OFICIAL](https://reactrouter.com/home)

## Instalação

```shell
npm i react-router
```

## Modos

A lib possui 3 formas diferentes de utilização:

**[Declarativa doc >](./01.2 - Modo-declarativo.md)**

```ts
import { BrowserRouter } from "react-router";

ReactDOM.createRoot(root).render(
  <BrowserRouter>
    <App />
  </BrowserRouter>,
);
```

**[Dados doc >](./01.1 - Modo-data.md)**

```ts
import {
  createBrowserRouter,
  RouterProvider,
} from "react-router";

let router = createBrowserRouter([
  {
    path: "/",
    Component: Root,
    loader: loadRootData,
  },
]);

ReactDOM.createRoot(root).render(
  <RouterProvider router={router} />,
);
```

**[Framework doc >](./01.3 - Modo-framework.md)**

```ts
import { index, route } from "@react-router/dev/routes";

export default [
  index("./home.tsx"),
  route("products/:pid", "./product.tsx"),
];
```

## Mercado.

Atualmente o modo declarativo é o mais utilizado, por ser mais simples e facil na manutenção.

## Resumo:

**BrowserRouter:**

Seria equivalente ao wrapper global da aplicação onde será gerenciado as rotas.

**Routers:**

Agrupa um conjuto de rotas **Route**.

**Route:**

Gerencia qual rota determinado elemento irá renderizar, com base nos dados definidos em **element** e **path** .

- Element: Componente que sera rederizado.

- Path: rota url

**Outilet:**

Corresponde a um wrapper onde os templates iram ser renderizados como um placeholder.
