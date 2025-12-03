

## Remove css morto da página.

Removendo css não utilizado no bundle de prod.
Para isso iremos utilizar um plugin do webpack PurgeCSS

**Instalar**
```shell
npm install --save-dev purgecss-webpack-plugin glob
```

**Importa dependência no webpack.config**
```javascript
const PurgeCSSPlugin = require('purgecss-webpack-plugin');
const glob = require('glob');
const path = require('path');

module.exports = {
  // ...outras configs...
  plugins: [
    new PurgeCSSPlugin({
      paths: glob.sync(`${path.join(__dirname, 'src')}/**/*`, { nodir: true }),
      // Ajuste o path conforme o local dos seus arquivos fonte
    }),
  ],
};

```


----
## Extraindo css critico para html 

Esta técnica possibilita melhorar o carregamento da **primeira dobra do site**. Trazendo melhor resultados para ferramenta de analise de **web vital**.

Obs: Deve ser definido para os dois dispositivos assim como no exemplo abaixo.

**instalando**
```shell
npm i --save-dev html-critical-webpack-plugin
```

**Configurando**
``` javascript

// webpack.config.js

const HtmlCriticalWebpackPlugin = require("html-critical-webpack-plugin"); 


// setar nos plugins
plugins: [
	// DEFININDO PARA MOBILE
	new HtmlCriticalWebpackPlugin(
		{ 
			base: path.join(path.resolve(__dirname), 'dist/'), 
			src: 'index.html', 
			dest: 'index.html', 
			inline: true, 
			minify: true, 
			extract: true, 
			// ira processar para este cenario ex mobile.
			width: 375,  // largura
			height: 565  // altura
		}
	),
	// DEFININDO PARA DESKTOP
	new HtmlCriticalWebpackPlugin(
		{ 
			base: path.join(path.resolve(__dirname), 'dist/'), 
			src: 'index.html', 
			dest: 'index.html', 
			inline: true, 
			minify: true, 
			extract: true, 
			// ira processar para este cenario ex mobile.
			width: 1280,  // largura
			height: 800  // altura
		}
	) 
]
```