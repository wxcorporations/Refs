# Como disponibilizar localhost remotamente

Recurso nativo vc deve setar a porta do projeto, no exemplo abaixo estamos usando a 3000

```shell
ssh -R 80:localhost:3000 nokey@localhost.run
```
