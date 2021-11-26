## Exemplo de Tela de Parâmetros

A classe [LibParamBoxObj](#) facilita a criação de telas de parâmetros.

```cpp
user function ParamsSample()

  local cMsg      := ""
  local oParam    := nil
  local oParamBox := LibParamBoxObj():newLibParamBoxObj("ParamBoxId")
  local oUtils    := LibUtilsObj():newLibUtilsObj()

  oParamBox:setTitle("LibParamBoxObj - Exemplo")
  oParamBox:setValidation({|| ApMsgYesNo("Confirma parâmetros ?")})

  oParam := LibParamObj():newLibParamObj("productCode", "get", "Produto", "C", 60, Len(SB1->B1_COD))
  oParam:setF3("SB1")
  oParam:setValidation("Vazio() .or. ExistCpo('SB1')")
  oParam:setRequired(.T.)
  oParamBox:addParam(oParam)

  oParam := LibParamObj():newLibParamObj("value", "get", "Valor R$", "N", 60)
  oParam:setPicture("@E 999,999,999.99") 
  oParam:setValidation("Positivo()")  
  oParamBox:addParam(oParam)

  oParam := LibParamObj():newLibParamObj("option", "combo", "Atualizar", "C", 60)
  oParam:setValues({"1=Preço","2=Custo"})    
  oParamBox:addParam(oParam)

  if !oParamBox:show()
    return
  endIf

  cMsg := "Código: " + oParamBox:getValue("productCode") + CRLF
  cMsg += "Valor R$: " + oUtils:strAnyType(oParamBox:getValue("value")) + CRLF
  cMsg += "Opção: " + if ( oParamBox:getValue("option") == "1", "Preço", "Custo" )

  MsgInfo(cMsg)

return
```

<br/>

[Voltar](../index)