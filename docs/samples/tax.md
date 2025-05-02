## Exemplo de Cálculo de Impostos

A classe [SysLibTax](#) simplifica o cálculo de impostos em customizações do Protheus.
Esse objeto é uma abstração das funções padrões como a [MaFisIni](https://tdn.totvs.com/pages/releaseview.action?pageId=605868324) e
[MaFisRet](https://tdn.totvs.com/pages/releaseview.action?pageId=605867908).

```cpp
user function TaxSample()

  local cMsg      := ""
  local cPicture  := "@E 999,999,999.99"
  local cCustomer := "000001"
  local cUnit     := "01"
  local cProduct1 := "P00001"
  local cProduct2 := "P00002"
  local cTes      := "501"
  local nI        := 0
  local nQuantity := 1
  local nPrice    := 1000
  local aItems    := {}
  local oResult   := nil
  local oItem     := nil
  local oTax      := SysLibTax():new()
  local oUtils    := SysLibUtils():new()

  oTax:setCustomer(cCustomer, cUnit)
  oTax:setEntityType("F")
  oTax:addItem(cProduct1, cTes, nQuantity, nPrice)
  oTax:addItem(cProduct2, cTes, nQuantity, nPrice)

  oResult := oTax:calculate()
  aItems  := oResult["items"]

  cMsg := "Base ICMS: " + oUtils:strAnyType(oResult["icmsBase"], cPicture) + CRLF
  cMsg += "Valor ICMS: " + oUtils:strAnyType(oResult["icmsValue"], cPicture) + CRLF
  cMsg += "Valor NF: " + oUtils:strAnyType(oResult["invoiceValue"], cPicture) + CRLF
  cMsg += "Valor a Receber: " + oUtils:strAnyType(oResult["receivable"], cPicture) + CRLF + CRLF

  for nI := 1 to Len(aItems)
    oItem := aItems[nI]
    cMsg += "Item " + oUtils:strAnyType(nI) + CRLF
    cMsg += "- CFOP: " + oItem["cfop"] + CRLF
    cMsg += "- Base ICMS: " + oUtils:strAnyType(oItem["icmsBase"], cPicture) + CRLF
    cMsg += "- Valor ICMS: " + oUtils:strAnyType(oItem["icmsValue"], cPicture) + CRLF
    cMsg += "- Valor NF: " + oUtils:strAnyType(oItem["invoiceValue"], cPicture) + CRLF
    cMsg += "- Valor a Receber: " + oUtils:strAnyType(oItem["receivable"], cPicture) + CRLF + CRLF
  next nI

  oUtils:scrollMessage(cMsg)

return
```

<br/>

[Voltar](../index)
