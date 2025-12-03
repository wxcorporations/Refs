
Loaders são tradutores! Eles pegam um formato especifico  ex: **css** e converte para javascript de forma que o webpack possa processá-los.

## Loaders:

[[Loaders  sass - css]]
## Definir ou restringir arquivos a serem carregados.

**Vantagens:**
Pode tornar o build e bundle mais rápidos. Evitando processar arquivos desnecessários.

**OBS: Estas props são presente para todos os loaders.**

**include**: 
Define onde ira carregar os arquivos a serem traduzidos.

**exclude**
Define qual diretórios será ignorado.

``` javascript
// webpack.config.js

module: {
	rules: [
		{
			test: /\.tsx?$/,
			use: 'ts-loader',
			include: include: path.resolve(__dirname, 'src/'),
			exclude: include: path.resolve(__dirname, 'node_modules/')
		}
	]
}
```

### Outras props
- `test`: Expressão regular ou função para identificar arquivos que a regra deve processar.
    
- `include`: Caminho(s) ou condição para incluir arquivos/diretórios específicos nessa regra.
    
- `exclude`: Caminho(s) ou condição para excluir arquivos/diretórios dessa regra.
    
- `use`: Loader ou array de loaders a serem aplicados nos arquivos que passaram no teste acima.
    
- `loader`: Forma alternativa para especificar um loader único (preferível usar `use`).
    
- `options`: Objeto com opções a serem passadas para o loader.
    
- `type`: Define o tipo de módulo a ser gerado (ex: `asset/resource`, `javascript/auto`, `css`).
    
- `issuer`: Define quem está importando o arquivo, útil para regras condicionais mais avançadas.
    
- `parser`: Opções para parsing, como limitar tamanho de assets inline.
    
- `generator`: Configura como ativos do tipo asset serão emitidos.
    
- `oneOf`: Array de regras alternativas, só a primeira que casar será usada (otimiza performance).