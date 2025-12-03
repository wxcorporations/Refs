

## Intalação


## Criando uma rota

```python
@app.route("/dashboard")
def dashboard():
	return f"<p>Hello, Página dashboard!</p> {escape(uuid.uuid4())}"
```

## configurando postman

![[Pasted image 20251107185540.png]]

## Pegando valor da request

### Exemplo upload de arquivo e nome id

este exemplo estamos pegando um arquivo enviado via post nome e um id

```python
  
import os
import uuid
from pathlib import Path
from flask import Flask, flash, request, redirect, url_for
from markupsafe import escape
from werkzeug.utils import secure_filename

UPLOAD_FOLDER = '../uploads/'
ALLOWED_EXTENSIONS = {'.csv'}

app = Flask(__name__)
app.config['UPLOAD_FOLDER'] = UPLOAD_FOLDER
app.secret_key = 'MINHA KEY AQUI KKKKKK'

@app.route("/report", methods=['POST'])
def upload_file():	
	if request.method == 'POST':
	
		# pegando valor do payload ou form name = nome
		print(request.form.get('nome'))
		
		# pegando valor do payload ou form name = id
		print(request.form.get('id'))
	
		if 'file' not in request.files:
			flash('No file part')
			return redirect(request.url)
		
		file = request.files['file']
		
		if not file or file.filename == '':
			flash('No selected file')
			return redirect(request.url)
		
		
		if allowed_file(file.filename):
			filename = secure_filename(file.filename)
			file.save(os.path.join(app.config['UPLOAD_FOLDER'], filename))
			return redirect(url_for('dashboard', name=filename))

```


### Manipulando arquivos enviados na request

- texto
- arquivo

```python

# Este metodo captura os valor setado no payload ou do form name do valor [id]
# server para inputs do tipo text
request.form.get('id')

# Este metodo captura os valor setado no payload ou do form name do valor [file]
# server para inputs do file

# Em files pode haver 0 ou N arquivos.
# para pegar o arquivo deve ser passado a key ou valor attr name do input file
request.files

# Exemplo pegando o arquivo nomeado como file.
request.files['file']


```