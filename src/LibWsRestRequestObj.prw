#include "totvs.ch"
#include "rwmake.ch"


/*/{Protheus.doc} LibWsRestRequestObj

Objeto para manipulacao de requisicoes de webservices REST
    
@author soulsys:victorhugo
@since 18/09/2021
/*/
class LibWsRestRequestObj from LibAdvplObj

  data oRequest
  
  method newLibWsRestRequestObj() constructor
  
  method getRoute()
  method getBody()
  
endClass


/*/{Protheus.doc} newLibWsRestRequestObj

Construtor
    
@author soulsys:victorhugo
@since 18/09/2021
/*/
method newLibWsRestRequestObj(oRequest) class LibWsRestRequestObj
  
  ::oRequest := oRequest
  
return self


/*/{Protheus.doc} getRoute

Retorna a rota de uma requisicao
  
@author soulsys:victorhugo
@since 18/09/2021
/*/
method getRoute(oRequest) class LibWsRestRequestObj
  
  local cRoute     := ""
  default oRequest := ::oRequest

  if (Len(oRequest:aURLParms) > 0)
    cRoute := oRequest:aURLParms[1]
  endIf

return AllTrim(Lower(cRoute))	


/*/{Protheus.doc} getBody

Retorna o corpo de uma requisicao em formato JSON
  
@author soulsys:victorhugo
@since 18/09/2021
/*/
method getBody(oRequest) class LibWsRestRequestObj
  
  local cContent   := ""
  local oBody      := JsonObject():new()	
  default oRequest := ::oRequest

  cContent := oRequest:getContent()

  if !Empty(cContent)
    oBody:fromJson(DecodeUTF8(cContent))
  endIf

return oBody

