## Exemplo de Utilidades Genéricas

A classe [SysLibUtils](#) possui uma grande quantidade de métodos úteis para o dia a dia
do desenvolvimento em Advpl. Essa classe agiliza bastante o processo de codificação, bem
como ajuda a construir códigos mais limpos e legíveis.

```cpp
user function UtilsSample()

  local oJson            := JsonObject():new()
  local oUtils           := SysLibUtils():new()
  local cToday           := oUtils:strAnyType(dDataBase, "DD/MM/AAAA")
  local cFloatNumber     := oUtils:strAnyType(123.45)
  local lIsNullVariable  := oUtils:isNull(oJson)
  local nDefaultValue    := oUtils:whenIsNull(oJson["optionalValue"], 0)
  local lShouldWorkToday := oUtils:isWorkDay(dDataBase)
  local dDateFromJson    := oUtils:fromJsDate(oJson["date"])
  local cJsFormatDate    := oUtils:getJsDate(dDateFromJson)
  local aLines           := oUtils:strToArray("Quebre esse texto em linhas de 10 caracteres", 10)
  local cSeparateValues  := oUtils:vetorToString({"v1","v2","v3"}, "|")

return
```

Nesse exemplo mostramos apenas alguns métodos que usamos com mais frequência. Não deixe de conferir a [documentação](#)
dessa classe para explorar todos os recursos disponíveis.

<br/>

[Voltar](../index)
