# Instalação tailwindcss sem vite

`npm install -D tailwindcss@3 postcss autoprefixer`

**Passo 3:** Reconfigurar:

bash

`npx tailwindcss init -p`

**Passo 4:** Configure o `tailwind.config.js`:

javascript

`module.exports = {   content: [    "./src/**/*.{js,jsx,ts,tsx}",  ],  theme: {    extend: {},  },  plugins: [], }`

**Passo 5:** Configure o `postcss.config.js`:

javascript

`module.exports = {   plugins: {    tailwindcss: {},    autoprefixer: {},  }, }`

**Passo 6:** No `src/index.css`:

css

`@tailwind base; @tailwind components; @tailwind utilities;`



## Doc do styles

[Text Color - Tailwind CSS](https://v3.tailwindcss.com/docs/text-color)










