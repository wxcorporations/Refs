# Como adicionar certificado SSL.

Muitos recursos necessitam do certificado para seu devido funcionamento.



## Ambiente de DEV

**1 Instalar e gerar certificado.** [Tutorial](../SERVIDOR/Certificado SSL.md)

**2 Configurando Webpack**

Dentro no bloco devServer inclua key server com o seguinte valor exemplo abaixo.

```js
devServer: {
	server: {
		type: 'https',
		options: {
			key: 'hash da chave',
			cert: 'hash do certificado'
		}
	}
}
```

3 inclua o **dominio** na prop webpack.config na prop **allowedHosts** como no exemplo abaixo.

```js
devServer: {
	allowedHosts: [
		'.meudominio.com' // ponto no inicio permite subdominio tambem.
	]
}
```

4 Importe certificado no seu navegador.

Cada navegador possui uma forma, porem bem semelhante.



exemplo real.

```js
devServer: {
        historyApiFallback: true,
        host: 'octoplay.com',
        port: 3000,
        allowedHosts: [
            '.octoplay.com'
        ],
        server: {
            type: 'https',
            options: {
                key: readFileSync(path.resolve(__dirname, './key/octoplay.com+3-key.pem')),
                cert: readFileSync(path.resolve(__dirname, './key/octoplay.com+3.pem')),
            }
        },
        hot: true,
        open: true,
        static: {
            directory: path.join(__dirname, 'public')
        },
    },
```

![[Pasted image 20251013143805.png]]