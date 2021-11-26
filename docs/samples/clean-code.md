# Código limpo na prática

O conceito de código limpo (clean code) ganhou popularidade através do livro 
[Clean Code: A Handbook of Agile Software Craftsmanship](https://www.amazon.com.br/Código-limpo-Robert-C-Martin/dp/8576082675/ref=asc_df_8576082675/?tag=googleshopp00-20&linkCode=df0&hvadid=379792215563&hvpos=&hvnetw=g&hvrand=11021652961353161579&hvpone=&hvptwo=&hvqmt=&hvdev=c&hvdvcmdl=&hvlocint=&hvlocphy=9074136&hvtargid=pla-398225630878&psc=1) escrito pelo [Robert Cecil Martin](https://pt.wikipedia.org/wiki/Robert_Cecil_Martin). Martin acredita que o principal 
problema do desenvolvimento de software é a manutenção. Ele entende que normalmente desenvolvedores passam mais tempo lendo do 
que escrevendo código. Logo, códigos difíceis de entender e manter geram uma grande perda de tempo e dinheiro.

Para facilitar o entendimento desses conceitos, vamos imaginar que precisamos desenvolver uma função Advpl para cálculo de 
tarifas de táxi. A função deve ser bem simples. Recebe apenas o horário e a distância percorrida e retorna o valor da viagem.

Poderíamos implementar dessa forma:

```cpp
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

Essa função funcionaria sem problemas. Mas quer ver como podemos deixar esse código bem mais fácil de entender e alterar ?

<br/>

## Características de um código limpo

É difícil definir o que exatamente torna um código limpo. Aqui vamos focar em três aspectos que consideramos os 
principais: ***Expressividade***, ***Flexibilidade*** e ***Coesão***.


### Expressividade

Muitas vezes sentimos a necessidade de escrever comentários em nossos códigos para explicar uma lógica um pouco mais complexa. 
No caso do nosso exemplo, temos comentários sobre os horários e valores das bandeiras. Esses comentários foram adicionados porque 
os nomes das variáveis *nPar1* e *nPar2* não ***expressam*** com clareza as suas finalidades.

Pensando nisso, podemos refatorar nosso exemplo da seguinte forma:

```cpp
user function TaxiValue(nStartTime, nDistance)

  local nValue      := 0
  local nFlag1Value := 2
  locan nFlag2Value := 4

  if (nStartTime >= 6 .and. nStartTime <= 22)
    nValue := (nDistance * nFlag1Value)
  else
    nValue := (nDistance * nFlag2Value)
  endIf

return nValue
```

Repare que agora não temos mais a necessidade de escrever comentários visto que o próprio código 
passou a expressar suas intenções de forma clara.


### Flexibilidade

Nossa função funciona e está mais legível. Mas vamos imaginar que agora precisamos desenvolver um relatório 
de viagens, separando os registros por tipos de bandeira (1 ou 2). Nesse caso, precisaríamos ***reescrever a 
regra de negócio*** referente às bandeiras.

Para resolver esse problema, podemos criar uma classe que encapsula essa regra de negócio, deixando nossa base 
de código mais ***flexível***.

Vamos criar uma classe que representa um taxímetro:

```cpp
class Taximeter

  data nStartTime
  data nDistance

  method newTaximeter()

  method isFlag1()
  method isFlag2()
  method calculate()

endClass
```

Podemos definir o horário inicial e a distância no construtor:

```cpp
method newTaximeter(nStartTime, nDistance) class Taximeter
  ::nStartTime := nStartTime
  ::nDistance  := nDistance
return
```

Os métodos *isFlag1()* e *isFlag2()* permitem verificar qual a bandeira do horário informado:

```cpp
method isFlag1() class Taximeter
return (::nStartTime >= 6 .and. ::nStartTime <= 22)

method isFlag2() class Taximeter
return !::isFlag1()
```

Por fim, o método *calculate()* calcula o valor da viagem com base nos dados fornecidos:

```cpp
method calculate() class Taximeter 

  local nValue      := 0
  local nFlag1Value := 2
  locan nFlag2Value := 4

  if ::isFlag1()
    nValue := (::nDistance * nFlag1Value)
  else
    nValue := (::nDistance * nFlag2Value)
  endIf
  
return nValue
```

Agora além de calcular o valor de uma corrida também temos condições de verificar qual bandeira foi utilizada:

```cpp
user function TaxiMsg(nStartTime, nDistance)

  local oTaximeter := Taximeter():newTaximeter(nStartTime, nDistance)
  local nValue     := oTaximeter:calculate()  
  local cMessage   := "O valor da viagem é R$ " + AllTrim(Str(nValue))

  if oTaximeter:isFlag1()
    cMessage += " (bandeira 1)"
  else
    cMessage += " (bandeira 2)"
  endIf

  MsgInfo(cMessage)

return
```

Dessa forma nosso código ficou bem mais flexível, visto que as regras de negócios relacionadas 
às bandeiras podem ser reutilizadas em qualquer parte do sistema.


### Coesão

Agora temos uma base de código mais legível e flexível. Foi uma grande evolução até aqui!

Mas temos um ponto fraco em nossa lógica. Os valores das bandeiras estão fixos no código. Ou seja, quando esses valores 
forem reajustados será necessário alterar e recompilar a classe *Taximeter*. 

Para remover essa fragilidade podemos definir os valores das bandeiras em parâmetros, além de implementar um novo método 
que verifica qual valor deve ser considerado:

```cpp
method getFlagValue() class Taximeter 

  local nValue := 0

  if ::isFlag1()
    nValue := GetMv("ZZ_VLBAND1")
  else
    nValue := GetMv("ZZ_VLBAND2")
  endIf
  
return nValue
```

E alterar o método *calculate()* para obter o valor da bandeira através do novo método:

```cpp
method calculate() class Taximeter   
return (::nDistance * ::getFlagValue())
```

Agora o método de cálculo do valor da corrida ficou mais ***coeso*** e com uma responsabilidade mais bem definida. 
Ele não precisa mais saber como obter o valor da bandeira. Essa responsabilidade foi transferida para o método *getFlagValue()*.

<br/>

## Conclusão

Que legal que você chegou até aqui! Esperamos que esse simples exemplo tenha contribuído para que você entenda melhor 
os conceitos de clean code e também a nossa motivação para desenvolvimento dessa biblioteca de componentes. 

Agora é só pegar mais um café, baixar os fontes desse repositório e começar a aplicar essas técnicas no Advpl! 🚀

<br/>

[Voltar](../index)