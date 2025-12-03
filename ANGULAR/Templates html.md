
## Forma de vincular um template ao componente

### Via url

Deve passar o path do arquivo .html para prop **templateUrl**
``` ts
@Component({
  selector: 'app-component-overview',
  templateUrl: './component-overview.component.html',
})
```

### Incorporado no decorate

Deve passar um template string para prop template.
indicado para componente simples.
``` ts
@Component({
  selector: 'app-component-overview',
  template: `
    <h1>Hello World!</h1>
    <p>This template definition spans multiple lines.</p>
  `
})
```