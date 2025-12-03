
link de acesso do dashboard:
https://analytics.google.com/analytics/web/?pli=1#/a197701243p273345234/realtime/pages?params=_u..nav%3Dmaui

## Crie a propriedade GA4

- Acesse o painel do Google Analytics e crie uma nova propriedade GA4 para seu site/app.[](https://support.google.com/analytics/answer/9304153?hl=pt)​
    
- Copie o “ID de Medição” gerado (formato: G-XXXXXXXXXX).
    

## 2. Instalação Manual no HTML (todos frameworks)

No HTML principal (geralmente o template do webpack, public/index.html, ou similar):

xml


``` html

`<!-- Google tag (gtag.js) --> <script async src="https://www.googletagmanager.com/gtag/js?id=G-XXXXXXXXXX"></script> <script>   window.dataLayer = window.dataLayer || [];   function gtag(){dataLayer.push(arguments);}   gtag('js', new Date());   gtag('config', 'G-XXXXXXXXXX'); </script>`
```

## Tipos de eventos no GA4

- **Eventos coletados automaticamente:** page_view, session_start, first_visit, etc. São disparados pelo GA4 sem necessidade de configuração.
    
- **Eventos de medição otimizada:** scroll, click (saída), file_download, view_search_results, video_start, video_progress, video_complete, form_start, form_submit. Esses eventos podem ser ativados/desativados rapidamente pela interface.
    
- **Eventos recomendados:** Usam nomes definidos pelo Google, como purchase, sign_up, login, add_to_cart, etc. Devem ser implementados seguindo a documentação oficial para obter relatórios avançados.
    
- **Eventos personalizados:** Quando nenhuma das opções anteriores atende à necessidade, é possível criar eventos próprios, como newsletter_signup ou contato_whatsapp, com parâmetros definidos por você.
## Como disparar eventos no frontend

- **Via gtag.js (HTML/JavaScript):**
    
    js
    
    `gtag('event', 'nome_do_evento', {   param1: 'valor1',   param2: 'valor2' });`
    
    Exemplo de evento de “cadastro”:
    
    js
    
    `gtag('event', 'sign_up', {   method: 'Google' });`
    
- **Via bibliotecas em frameworks (React, Vue):**
    
    - Com `react-ga4`:
        
        js
        
        `import ReactGA from "react-ga4"; ReactGA.event({   category: "button",   action: "click",   label: "Inscrição Newsletter" });`
        
    - Com `gtag.js` manual em SPA, acione o comando nos handlers ou hooks dos componentes ao ocorrer a ação de interesse.[](https://pt.semrush.com/blog/google-analytics-4-events/)​
        
- **Via Google Tag Manager:**
    
    - No GTM, crie uma “Tag de Evento GA4” e configure o nome e parâmetros do evento. Escolha um Trigger adequado (ex: clique em botão, envio de formulário).
        

## Regras e recomendações

- Prefira sempre os nomes de eventos recomendados do Google (em inglês).
    
- Use parâmetros relevantes para enriquecer a informação coletada.
    
- Evite criar eventos personalizados desnecessários, pois eles exigem configuração manual dos relatórios.[](https://reportei.com/eventos-no-ga4/)​
    

Com esses tipos e métodos, você coleta dados abrangentes de navegação e comportamento do usuário no seu frontend de forma padronizada e flexível.