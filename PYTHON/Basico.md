
## Padrão de nome utilizado como entrypoint de app
`app.py`

## Gerenciador de pacotes PACKAGE.JSON do python
```
nomo do arquivo: requirements.txt

# conteudo de exemplo
# -----------------------------------------
requests==2.31.0 
flask>=2.3.3 
pandas==1.5.3 
numpy
```

## Import export 
```python

# import full trás todas as funcionalidade
import main.py


# import seletivo somente a funcao util
import main.py import util 

print(util.saudacao("Maria"))
```

## Módulos

Como o arquivo init dentro de um diretório é possível criar um modulo com N arquivos disponíveis para importar-los em outras partes do código.
```python
## Exemplo de estrutura de modulo:
## ==================================

meupacote/
│
├── __init__.py
├── modulo1.py
└── modulo2.py


## Como utilizar
## ==================================
import meupacote.modulo1
import meupacote.modulo2

```


## Disparando e tratando ERRO  com RAISE e try exception
```python


## exemplo consumindo erro do raise

try:
    # disparando erro estilo thown do js
    raise ValueError("Esta é uma mensagem de erro personalizada")
    
except ValueError as error:
    print(f"Ocorreu um erro do tipo: {type(error).__name__}")



```
## Como informar a callstack no erro  [traceback] .
```python

## precisa desse pacote
import traceback

## exemplo

try:
    resultado = 10 / 0
except Exception as e:
    print(f"Ocorreu um erro: {e}")
    print("\nDetalhes completos do traceback:")
    
    traceback.print_exc()
    # Ou você pode obter o traceback como uma string para logging
    # traceback_str = traceback.format_exc()
    # print(traceback_str)

```

## Equivalente a promise no python 

Obs: Disponível somente >= 3.5 

```python

# pacote que promise
import asyncio

async def buscar_dados():

	# travando promise
    await asyncio.sleep(1) # Simula uma operação de I/O assíncrona (espera 1 segundo)
    return {"data": "dados recebidos"}

async def main():
    dados = await buscar_dados() # Aguarda o resultado
    print(dados)

# Para executar o programa assíncrono:
asyncio.run(main())

```


## Definindo path base de um projeto
```

```