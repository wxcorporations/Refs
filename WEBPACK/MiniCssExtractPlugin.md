
https://webpack.js.org/plugins/mini-css-extract-plugin/

``` shell
npm install --save-dev mini-css-extract-plugin
```

``` javascript

const path = require('path');

// carregar plugin
const MiniCssExtractPlugin = require('mini-css-extract-plugin');

module.exports = {
	module: {
		rules: [
			{
				test: /\.(scss|sass|css)$/i,
				exclude: /node_modules/,
				use: [
					// definindo plugin nos loader
					MiniCssExtractPlugin.loader,
					'css-loader',
					'sass-loader',
				],
			}
		]
	},
	plugins: [
		// setar plugin
		new MiniCssExtractPlugin({ filename: '[name].[contenthash].css' }),
	]
};
```