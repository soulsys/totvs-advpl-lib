# Código limpo na prática

O conceito de código limpo (clean code) ganhou popularidade através do livro 
[Clean Code: A Handbook of Agile Software Craftsmanship](https://www.amazon.com.br/Código-limpo-Robert-C-Martin/dp/8576082675/ref=asc_df_8576082675/?tag=googleshopp00-20&linkCode=df0&hvadid=379792215563&hvpos=&hvnetw=g&hvrand=11021652961353161579&hvpone=&hvptwo=&hvqmt=&hvdev=c&hvdvcmdl=&hvlocint=&hvlocphy=9074136&hvtargid=pla-398225630878&psc=1) escrito pelo [Robert Cecil Martin](https://pt.wikipedia.org/wiki/Robert_Cecil_Martin). Martin acredita que o principal 
problema do desenvolvimento de software é a manutenção. Ele entende que normalmente desenvolvedores passam mais tempo lendo do 
que escrevendo código. Logo, códigos difíceis de entender e manter geram uma grande perda de tempo e dinheiro.

Para facilitar o entendimento desses conceitos, vamos imaginar que precisamos desenvolver uma função Advpl para cálculo de 
tarifas de táxi. A função deve ser bem simples. Recebe apenas o horário e a distância percorrida e retorna o valor da viagem.

Essa função poderia ser implementada dessa forma:

```cpp
#include "totvs.ch"

user function TaxiValue(nPar1, nPar2)

  local nRet := 0

  // Verifica se é bandeira 1 = 6h às 22h
  if (nPar1 >= 6 .and. nPar1 <= 22)
    nRet := (nPar2 * 2) // Valor da Bandeira 1: R$ 2,00
  // Bandeira 2 - 22h às 05h59
  else
    nRet := (nPar2 * 4) // Valor da Bandeira 2: R$ 4,00
  endIf

return nRet
```

Essa função funcionaria sem problemas. Mas quer ver como podemos deixar esse código bem mais fácil de entender ?

<br/><br/>
***(documentação em desenvolvimento...)***
<br/><br/>

<br/>

[Voltar](../index)