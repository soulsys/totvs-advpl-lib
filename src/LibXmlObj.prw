#include "totvs.ch"


/*/{Protheus.doc} LibXmlObj

Objeto para manipulacao de arquivos XML

@author soulsys:victorhugo
@since 18/09/2021
/*/
class LibXmlObj from LibAdvplObj

  data oXml
  data cXml
  data cError

  method newLibXmlObj() constructor
  method setXml()  
  method parse()
  method text()
  method node()
  method list()
  method nodeToString()
  method exists()
  method getError()

endClass


/*/{Protheus.doc} newLibXmlObj

Construtor

@author soulsys:victorhugo
@since 18/09/2021
/*/
method newLibXmlObj(cXml) class LibXmlObj

  default cXml := ""

  ::newLibAdvplObj()
  ::setXml(cXml)
  
  ::cError := ""

return


/*/{Protheus.doc} setXml

Define a String ou Arquivo XML

@author soulsys:victorhugo
@since 18/09/2021
/*/
method setXml(cXml) class LibXmlObj
  
  if File(cXml)
    cXml := MemoRead(cXml)
  endIf	

  ::cXml := cXml	
  
return


/*/{Protheus.doc} parse

Realiza o parser do Xml

@author soulsys:victorhugo
@since 18/09/2021
/*/
method parse() class LibXmlObj

  local lOk      := .F.
  local cError   := ""
  local cWarning := ""
  local cXml     := EncodeUTF8(NoAcento(::cXml))

  if Empty(cXml)
    ::cError := "XML undefined"
    return .F.
  endIf

  ::cError := ""
  ::oXml 	 := XmlParser(cXml, "_", @cError, @cWarning)
  lOk      := (ValType(::oXml) == "O")

  if !lOk
    ::cError := "[ERROR] " + cError
    if !Empty(cWarning)
      ::cError += CRLF + "[WARNING] " + cWarning
    endIf
  endIf

return lOk


/*/{Protheus.doc} text

Coleta o valor de um no como string
Ex.: oXml:text("pedido:cabecalho:numero")

@author soulsys:victorhugo
@since 18/09/2021
/*/
method text(cNode, oParent) class LibXmlObj

  local xRet       := nil
  private oPrvtObj := nil
  default oParent  := ::oXml

  oPrvtObj := oParent
  cNode    := "oPrvtObj:_" + Replace(AllTrim(cNode), ":", ":_") + ":text"

  if (Type(cNode) != "U")
    xRet := &cNode
  endIf

return xRet


/*/{Protheus.doc} node

Coleta o valor de um no como objeto
Ex.: oXml:node("pedido:cabecalho")

@author soulsys:victorhugo
@since 18/09/2021
/*/
method node(cNode, oParent) class LibXmlObj

  local oNode      := nil
  private oPrvtObj := nil
  default oParent  := ::oXml

  oPrvtObj := oParent
  cNode    := "oPrvtObj:_" + Replace(AllTrim(cNode), ":", ":_")

  if (Type(cNode) != "U")
    oNode      := LibXmlObj():newLibXmlObj()        
    oNode:oXml := &cNode
  endIf

return oNode


/*/{Protheus.doc} list

Coleta o valor de um no em forma de array (lista de objetos)
Ex.: oXml:list("pedido:itens:item")

@author soulsys:victorhugo
@since 18/09/2021
/*/
method list(cNode, oParent) class LibXmlObj

  local nI         := 0
  local aValues    := {}
  local aNodes     := {}
  local oNode      := nil
  private oPrvtObj := nil
  default oParent  := ::oXml

  oPrvtObj := oParent
  cNode    := "oPrvtObj:_" + Replace(AllTrim(cNode), ":", ":_")

  if (Type(cNode) == "U")
    return {}
  endIf

  aValues := &cNode    

  if (ValType(aValues) != "A")
    aValues := { aValues }
  endIf

  for nI := 1 to Len(aValues)
    oNode      := LibXmlObj():newLibXmlObj()        
    oNode:oXml := aValues[nI]
    aAdd(aNodes, oNode)
  next nI

return aNodes
  


/*/{Protheus.doc} nodeToString

Converte um no em string

@author soulsys:victorhugo
@since 18/09/2021
/*/
method nodeToString(oNode) class LibXmlObj
  
  local cStr := ""

  cStr := XMLSaveStr(oNode, .F.)
  cStr := Replace(cStr, "\n", "")

return cStr


/*/{Protheus.doc} exists

Verifica se um no existe
Ex.: oXml:exists("pedido:cabecalho:numero")
  
@author soulsys:victorhugo
@since 18/09/2021
/*/
method exists(cNode, oParent) class LibXmlObj

  local xNode := ::node(cNode, oParent)
  local xText := ::text(cNode, oParent)

return (ValType(xNode) != "U" .or. ValType(xText) != "U")


/*/{Protheus.doc} getError

Coleta o erro do ultimo parser

@author soulsys:victorhugo
@since 18/09/2021
/*/
method getError() class LibXmlObj
return ::cError
