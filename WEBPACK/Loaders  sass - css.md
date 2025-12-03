

```shell

# sass loader
npm install sass-loader sass webpack --save-dev

# css loader
npm install --save-dev css-loader

```

``` javascript

module.exports = {
	module: {
		rules: [
			{
				test: /\.(scss|sass|css)$/i,
				exclude: /node_modules/,
				use: [
					//Obs: deve seguir essa ordem dos loader css > sass
					'css-loader',
					'sass-loader',
				],
			}
		]
	}
};
```