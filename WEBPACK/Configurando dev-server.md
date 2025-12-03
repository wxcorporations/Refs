


```js
module.exports = {
    
	devServer: {
        historyApiFallback: true, // rotas react
        host: '0.0.0.0', // ip
        port: 3000, // porta
        allowedHosts: 'all', // define domain possiveis acessar.
        hot: true, // hotreload
        open: true, 
        static: { // statico
            directory: path.join(__dirname, 'public')
        },
    },    
    
}

```

