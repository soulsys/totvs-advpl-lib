## Exemplo de Leitura de Arquivo XML

O principal objetivo da classe [LibXmlObj](#) é facilitar a leitura de arquivos XML, permitindo a 
criação de códigos menos suscetíveis a erros.

```cpp
user function XmlSample()

  local nI      := 0
  local nTotal  := 0
  local aItems  := {}
  local cNumber := ""
  local cFile   := "C:\temp\nfe.xml"  
  local oItem   := nil
  local oProd   := nil  
  local oXml    := LibXmlObj():newLibXmlObj(cFile)

  if !oXml:parse()	
    return Alert(oXml:getError())
  endIf

  cNumber := oXml:text("nfeProc:NFe:infNFe:ide:nNF")
  aItems  := oXml:list("nfeProc:NFe:infNFe:det")

  if Empty(cNumber)
    return Alert("O XML não é uma NFe")
  endIf

  for nI := 1 to Len(aItems)
    oItem  := aItems[nI]
    oProd  := oItem:node("prod")
    nTotal += Val(oProd:text("vProd"))
  next nI

  MsgInfo("O valor total da NF " + cNumber + " é " + AllTrim(Str(nTotal)))

return
```

<br/>

[Voltar](../index)