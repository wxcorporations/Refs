# Certificado SSL



## Dependências

```shell
sudo apt install mkcert # cria certificados locais.
```

## Como criar um certificado local.

Após instalar as dependências, rode o seguinte comando: 

```shell
mkcert [dominio-app] localhost 127.0.0.1 ::1
```

Após rodar este comando ele ira gerar dois arquivos na raiz onde vc rodou ex:

**dominio-app.com+3.pem** = (certificado)

**dominio-app.com+3-key.pem** = (chave privada)