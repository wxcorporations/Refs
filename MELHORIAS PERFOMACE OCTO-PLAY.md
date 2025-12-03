
# Otimização dos arquivos css

Para melhor a performance do carregamento dos estilos, foi aplicado ajuste no webpack. Foi adicionado um plugin capas de remover estilos não utilizados pela aplicação garantindo um bundle menor.

nome do plugin **PurgeCSS.**

| antes | depois |                      |
| ----- | ------ | -------------------- |
| 92%   | 28%    | class não utilizadas |
| 154   | 15     | tamanho              |

> antes
![[Pasted image 20251009201827.png]]

>Depois.
![[Pasted image 20251009202048.png]]


