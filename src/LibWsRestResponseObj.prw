#include "totvs.ch"
#include "rwmake.ch"


/*/{Protheus.doc} LibWsRestResponseObj

Objeto para manipulacao de retornos de webservices REST
    
@author soulsys:victorhugo
@since 18/09/2021
/*/
class LibWsRestResponseObj from LibAdvplObj

  data oRequest
  
  method newLibWsRestResponseObj() constructor
  
  method badRequest()
  method notFound()
  method unauthorized()
  method internalError()
  method send()
  method success()	
  
endClass


/*/{Protheus.doc} newLibWsRestResponseObj

Construtor
    
@author soulsys:victorhugo
@since 18/09/2021
/*/
method newLibWsRestResponseObj(oRequest) class LibWsRestResponseObj
  
  ::oRequest := oRequest
  
return self


/*/{Protheus.doc} badRequest

Retorno do erro BAD REQUEST
  
@author soulsys:victorhugo
@since 18/09/2021
/*/
method badRequest(cMessage) class LibWsRestResponseObj

  default cMessage := "Bad request"
  
  SetRestFault(400, EncodeUTF8(cMessage))

return


/*/{Protheus.doc} notFound

Retorno do erro NOT FOUND
  
@author soulsys:victorhugo
@since 18/09/2021
/*/
method notFound(cMessage) class LibWsRestResponseObj
  
  default cMessage := "Not found"
  
  SetRestFault(404, EncodeUTF8(cMessage))

return


/*/{Protheus.doc} unauthorized

Retorno do erro UNAUTHORIZED
  
@author soulsys:victorhugo
@since 18/09/2021
/*/
method unauthorized(cMessage) class LibWsRestResponseObj
  
  default cMessage := "Unauthorized"
  
  SetRestFault(401, EncodeUTF8(cMessage))

return


/*/{Protheus.doc} internalError

Retorno do erro INTERNAL ERROR
  
@author soulsys:victorhugo
@since 18/09/2021
/*/
method internalError(cMessage) class LibWsRestResponseObj
  
  default cMessage := "Internal error"
  
  SetRestFault(500, EncodeUTF8(cMessage))

return


/*/{Protheus.doc} response

Retorno sem erros
  
@author soulsys:victorhugo
@since 18/09/2021
/*/
method send(xData, cContentType) class LibWsRestResponseObj
  
  local cResponse      := ""
  default xData		     := ""
  default cContentType := "application/json"

  if (ValType(xData) == "J")
    cResponse := xData:toJson()
  else
    cResponse := xData  
  endIf

  ::oRequest:setContentType(cContentType)	
  ::oRequest:setResponse(EncodeUTF8(cResponse))

return


/*/{Protheus.doc} success

Retorna uma mensagem de sucesso
  
@author soulsys:victorhugo
@since 18/09/2021
/*/
method success(cMessage) class LibWsRestResponseObj

  default cMessage := "Operation performed"
  
  ::send('{ "success": true, "message": "' + cMessage + '" }')

return
