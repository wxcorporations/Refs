## Benefícios utilizando webpack para tratar imagens

✅ **Otimização automática** - Webpack processa e otimiza  
✅ **Cache busting** - Hash no nome previne cache antigo  
✅ **Tree shaking** - Remove imagens não utilizadas  
✅ **Base64 inline** - Imagens pequenas viram data URI  
✅ **Imports explícitos** - Código mais claro e type-safe

## Intro

**Antes do webpack 5 era comum usar:**

- [`raw-loader`](https://v4.webpack.js.org/loaders/raw-loader/)para importar um arquivo como uma string
- [`url-loader`](https://v4.webpack.js.org/loaders/url-loader/)para incorporar um arquivo no pacote como um URI de dados
- [`file-loader`](https://v4.webpack.js.org/loaders/file-loader/)para emitir um arquivo no diretório de saída

Os tipos de módulos de ativos substituem todos esses carregadores adicionando 5 novos tipos de módulos:

- `asset/resource`Emite um arquivo separado e exporta a URL. Anteriormente possível usando `file-loader`.
- `asset/inline`exporta um URI de dados do ativo. Anteriormente possível usando `url-loader`.
- `asset/source`exporta o código-fonte do ativo. Anteriormente possível usando `raw-loader`.
- `asset/bytes`exporta uma [`Uint8Array`](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Uint8Array)visão do ativo.
- `asset`Escolhe automaticamente entre exportar um URI de dados e emitir um arquivo separado. Anteriormente, era possível usar `url-loader`com limite de tamanho de ativo.

Ao usar os carregadores de ativos antigos (ou seja, `file-loader`/ `url-loader`/ `raw-loader`​​) junto com os Módulos de Ativos no Webpack 5, talvez seja necessário impedir que os Módulos de Ativos processem seus ativos novamente, pois isso resultaria em duplicação de ativos. Isso pode ser feito definindo o tipo de módulo do ativo como `'javascript/auto'`.


Como configurar o carregamento de imagens via webpack.
Este tutorial e dividido nas seguinte partes.

Obs: Este tuturial e compativel com a versão 5 do webpack.

- [[#1 Configurando assets-module]]
- [[#2 Nome de arquivo de saída personalizado]]
- [[#3 Criando alias para imports simplificado]]
- [[#4 Caso esteja utilizando Typescript]]
- [[#5 Carregando as imagens no projeto]]

## 1 Configurando assets-module

``` javascript

// webpack.config.js > module: { rules: [
{
	test: /\.(png|jpg|jpeg|gif|svg|webp)$/i,
	type: 'asset/resource',
	generator: {
		filename: 'assets/[name].[hash][ext]'
	}
}
```

## 2 Nome de arquivo de saída personalizado
Por padrão, `asset/resource`os módulos são emitidos com `[hash][ext][query]`o nome do arquivo no diretório de saída.

Você pode modificar este modelo definindo [`output.assetModuleFilename`](https://webpack.js.org/configuration/output/#outputassetmodulefilename)na configuração do seu webpack:****

Ex:
``` javascript

output: {
    //filename: 'main.js',
    //path: path.resolve(__dirname, 'dist'),
   assetModuleFilename: 'images/[hash][ext][query]', // nome de saida.
  },

```

## 3 Criando alias para imports simplificado
Aqui iremos definir os alias atalhos para imports dentro do nosso arquivos js|ts
Este alias nos possibilita abreviar os imports ex.

`import Button from @components/Buttons.tsx`

``` javascript
// webpack.config.js > resolve

resolve: {
	extensions: ['.ts', '.tsx', '.js', '.jsx'],
	alias: {
		'@': path.resolve(__dirname, 'src'),
		'@assets': path.resolve(__dirname, 'src/assets'),
		'@components': path.resolve(__dirname, 'src/components')
	}
},
```

## 4 Caso esteja utilizando Typescript
Primeiro de tudo caso esteja utilizando typescript em seu projeto vc tera que defir os tipos de arquivos de imagem, caso contrario não ira funcionar.

``` typescript
// src/types/assets.d.ts

declare module '*.png' {
const value: string;
export default value;
}


declare module '*.jpg' {
const value: string;
export default value;
}

declare module '*.jpeg' {
const value: string;
export default value;
}

declare module '*.gif' {
const value: string;
export default value;
}


declare module '*.svg' {
const value: string;
export default value;
}

declare module '*.webp' {
const value: string;
export default value;
}
```

## 5 Carregando as imagens no projeto

Para utilizar sua imagem em seu components basta utilizar o modo de import

``` typescript
import person from '@assets/person-desktop.png';

```