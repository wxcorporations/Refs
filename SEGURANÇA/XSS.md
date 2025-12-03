# XSS DOM LOAD

Carregamento de conteúdo via script malicioso.

Forma de previnir.

- setando meta tag - menos seguro
- setando no cabeçalho no carregamento da página.



## via meta tag

```html
 <meta http-equiv="Content-Security-Policy" content="default-src 'self'; script-src 'self'; img-src 'self' data:;">
```

