
## Suas rotas não funcional no ngix com react

Aplicaçoes single page aplication podem ter probrema de execução com servidor NGINX na configuração default.

Para o sistemas de rotas como REACT ROUTER funcionar corretamente devemos setar nas configurações do nginx para disponibilizar o mesmo arquivos html para todas as rotas.

configuração

/etc
``` shell

# /etc/nginx/sites-available/seu-arquivo-configuracao

server {
    listen 80;
    server_name your_domain.com;
    root /path/to/your/react/app/build; # Caminho para a pasta build da sua aplicação React
    index index.html index.htm;

    location / {
        try_files $uri $uri/ /index.html;
    }
}

```