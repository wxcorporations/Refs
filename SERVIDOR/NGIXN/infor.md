## 1. Instale o Nginx

No Ubuntu/Debian, execute:

```
sudo apt update
sudo apt install nginx
```

No CentOS/RHEL:

```
sudo yum install nginx
```

## 2. Crie o diretório para seus arquivos

Aqui vamos criar uma pastas para incluir nossa aplicação. (html, json, css, js...)

Por padrão, o Nginx usa `/var/www/html`. Para separar ambientes, crie seu próprio diretório:

```
sudo mkdir -p /var/www/meusite
sudo chown -R $USER:$USER /var/www/meusite
```

## 3. Adicione um arquivo de teste (opcional)

Nesta etapa é onde iremos colocar todos nossos arquivos staticos da nossa aplicação (html, css, js...)

Crie um arquivo de teste:

```
echo "<h1>Nginx local rodando!</h1>" > /var/www/meusite/index.html
```

## 4. Configure o bloco de servidor (server block)

Crie um novo arquivo de configuração em `/etc/nginx/sites-available/meusite`:

```
server {
    listen 80;
    server_name localhost;
    root /var/www/meusite;
    index index.html index.htm;

    location / {
        try_files $uri $uri/ =404;
    }
}
```

**Crie o link simbólico:**

aqui vamos criar um atalho de **meusite** na pasta **sites-enabled**, isso informa para o nginx que o meusite esta disponível.

 **/etc/nginx/sites-available**: fica todas as config de sites disponíveis como um cardapio

**/etc/nginx/sites-enabled/**: Fica somente os sites acessíveis via servidor.

```
sudo ln -s /etc/nginx/sites-available/meusite /etc/nginx/sites-enabled/
```

Remova o default, se quiser:

```
sudo rm /etc/nginx/sites-enabled/default
```

## 5. Teste a configuração e reinicie o Nginx

```
sudo nginx -t #verifica se a config esta correta.
sudo systemctl restart nginx # reinicia servidor.
```

## 6. Acesse via navegador

Abra `http://localhost` no navegador; a página de teste deve aparecer.

## 7. Integrando dist projeto com servidor.

- crie pasta dos estáticos em /var/www
- crie um link simbólico do dist da aplicação para pasta no web server ex: **/var/www/octoplay**
  - sudo ln -s /home/wx/Documentos/REPOSITORIOS/job-frontend-developer/dist  /var/www/octoplay/
- crie config. da aplicação em /etc/nginx/sites-available/ ex: **/etc/nginx/sites-available/octoplay**
- ative domínio da aplicação fazendo link simbólico etapa 4
- teste config e restart no nginx etapa 5
- acesse url com o domínio no navegador. 











