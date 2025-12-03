


Exemplo online:
https://stackblitz.com/run?file=src%2Fapp%2Fad.service.ts


Neste exemplo temos duas parte 

1 Uma classe de serviço que retorna as opções de componentes a ser rederizados.
	nela temos uma lista com objetos com props:
	- **component** = referencia do componente
	- **inputs** = prop e seu valor
	

![[Pasted image 20251203001458.png]]
**ad.services.ts**
![[Pasted image 20251203001332.png]]


2 Página responsável por rederizar o componente
	- importa a diretiva **NgComponentOutlet**
	- registar no import a diretiva
	- na diretiva **ng-container** ele passa **ngComponentOutlet** com dois paramentros nome do componente e valores de input "**PROPS**"

![[Pasted image 20251203001755.png]]


Exemplo dos componente utilizados
![[Pasted image 20251203002305.png]]
![[Pasted image 20251203002315.png]]