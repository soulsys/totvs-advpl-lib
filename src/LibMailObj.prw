#include "totvs.ch"
#include "totvs.ch"


/*/{Protheus.doc} LibMailObj
 
Objeto para controle de envio de e-mail
  
@author soulsys:victorhugo
@since 18/09/2021
/*/   
class LibMailObj from LibAdvplObj

  data cServer
  data nPort 		
  data cAccount	    
  data cPassword	
  data cError 		
  data cFrom 			
  data lAuthenticate	
  data lConnected 	
  data lSSL 			
  data lTLS
  data lImap 			
  data nTimeOut	
  data cHtmlLayout 		
  data oMailManager	
  data oMailMsg 
  data oWfHtml 		
  data nLastError	
  
  method newLibMailObj() constructor
  
  method getServer()		
  method setServer()
  method getPort()		
  method setPort()		
  method getAccount()	
  method setAccount()	
  method getPassword()	
  method setPassword()	
  method getError()		
  method setError()		
  method getFrom()		
  method setFrom()		
  method isAuthenticate()
  method setAuthenticate() 
  method isConnected()	 
  method setConnected()	
  method isSSL()		
  method setSSL()		
  method isTLS()		
  method setTLS()
  method isImap()		
  method setImap()		
  method getTimeOut()	
  method setTimeOut()
  method getHtmlLayout()
  method setHtmlLayout()	
    
  method connect()					
  method send()						
  method disconnect()				
  method attachFile()				
  method setConfirmRead()	
  method setHtmlValue()
  method addHtmlTableValue()		
  method showProperties()			
  
endClass


/*/{Protheus.doc} newLibMailObj

Construtor

@author soulsys:victorhugo
@since 18/09/2021
/*/
method newLibMailObj(cServer, cAccount, cPassword, cFrom, lAuthenticate, lSSL, lTLS, nTimeOut, cHtml) class LibMailObj
  
  default cServer 		  := GetMV("MV_RELSERV")
  default cAccount    	:= GetMV("MV_RELACNT") 
  default cPassword		  := GetMV("MV_RELPSW")
  default cFrom			    := GetMV("MV_RELFROM") 
  default lAuthenticate := GetMV("MV_RELAUTH")
  default lSSL			    := GetMV("MV_RELSSL")
  default lTLS			    := GetMV("MV_RELTLS") 
  default nTimeOut		  := GetMV("MV_RELTIME") 	
  default cHtml			    := ""
  
  ::newLibAdvplObj()
  
  ::setPort(25)
  ::setServer(cServer) 	
  ::setAccount(cAccount)
  ::setPassword(cPassword)
  ::setFrom(cFrom)
  ::setAuthenticate(lAuthenticate)
  ::setSSL(lSSL)
  ::setTLS(lTLS)
  ::setImap(.F.)
  ::setTimeOut(nTimeOut)
  ::setConnected(.F.)	
  ::setError("")
  ::setHtmlLayout(cHtml)
  
  ::oMailManager := TMailManager():new()
      
  ::oMailMsg := TMailMessage():new()
  ::oMailMsg:clear() 
  
  if File(cHtml)
    ::oWfHtml := TWfHtml():new(cHtml)
  endIf	
                         
return


/*/{Protheus.doc} getServer

Coleta o servidor

@author soulsys:victorhugo
@since 18/09/2021
/*/
method getServer() class LibMailObj
return ::cServer


/*/{Protheus.doc} setServer

Define o Servidor

@author soulsys:victorhugo
@since 18/09/2021
/*/
method setServer(cServer) class LibMailObj
  
  local cStrPort := ""
  
  ::cServer := cServer
  
  if (":" $ cServer)
    cStrPort   := SubStr(cServer, At(":", cServer))
    ::cServer  := StrTran(cServer, cStrPort, "")
    ::nPort    := Val(StrTran(cStrPort, ":", ""))
  endIf
  
return 


/*/{Protheus.doc} getPort

Coleta a porta do servidor

@author soulsys:victorhugo
@since 18/09/2021
/*/
method getPort() class LibMailObj
return ::nPort


/*/{Protheus.doc} setPort

Define a porta do servidor

@author soulsys:victorhugo
@since 18/09/2021
/*/
method setPort(nPort) class LibMailObj
  ::nPort := nPort
return 


/*/{Protheus.doc} getAccount

Coleta a conta de e-mail

@author soulsys:victorhugo
@since 18/09/2021
/*/
method getAccount() class LibMailObj
return ::cAccount


/*/{Protheus.doc} setAccount

Define a conta de e-mail

@author soulsys:victorhugo
@since 18/09/2021
/*/
method setAccount(cAccount) class LibMailObj
  ::cAccount := cAccount
return 


/*/{Protheus.doc} getPassword

Coleta a Senha de Usuario

@author soulsys:victorhugo
@since 18/09/2021
/*/
method getPassword() class LibMailObj
return ::cPassword


/*/{Protheus.doc} setPassword

Define a Senha de Usuario

@author soulsys:victorhugo
@since 18/09/2021
/*/
method setPassword(cPassword) class LibMailObj
  ::cPassword := cPassword
return      


/*/{Protheus.doc} getError

Coleta a Mensagem de Erro

@author soulsys:victorhugo
@since 18/09/2021
/*/
method getError() class LibMailObj
return ::cError


/*/{Protheus.doc} setError

Define a Mensagem de Erro

@author soulsys:victorhugo
@since 18/09/2021
/*/
method setError(cError) class LibMailObj
  ::cError := cError
return


/*/{Protheus.doc} getFrom

Coleta o Remetente do Email

@author soulsys:victorhugo
@since 18/09/2021
/*/
method getFrom() class LibMailObj
return ::cFrom


/*/{Protheus.doc} setFrom

Define o Remetente do Email

@author soulsys:victorhugo
@since 18/09/2021
/*/
method setFrom(cFrom) class LibMailObj
  ::cFrom := cFrom
return
                        

/*/{Protheus.doc} isAuthenticate

Indica se o Servidor requer autenticacao

@author soulsys:victorhugo
@since 18/09/2021
/*/
method isAuthenticate() class LibMailObj
return ::lAuthenticate


/*/{Protheus.doc} setAuthenticate

Define se o Servidor requer autenticacao

@author soulsys:victorhugo
@since 18/09/2021
/*/
method setAuthenticate(lAuthenticate) class LibMailObj
  ::lAuthenticate := lAuthenticate
return 


/*/{Protheus.doc} isConnected

Indica se o Objeto esta conectado ao Servidor de Email

@author soulsys:victorhugo
@since 18/09/2021
/*/
method isConnected() class LibMailObj
return ::lConnected


/*/{Protheus.doc} setConnected

Define se o Objeto esta conectado ao Servidor de Email

@author soulsys:victorhugo
@since 18/09/2021
/*/
method setConnected(lConnected) class LibMailObj
  ::lConnected := lConnected
return


/*/{Protheus.doc} isSSL

Indica se o Servidor utiliza conexao SSL

@author soulsys:victorhugo
@since 18/09/2021
/*/
method isSSL() class LibMailObj
return ::lSSL


/*/{Protheus.doc} setSSL

Define se o Servidor utiliza conexao SSL

@author soulsys:victorhugo
@since 18/09/2021
/*/
method setSSL(lSSL) class LibMailObj
  ::lSSL := lSSL
return


/*/{Protheus.doc} isTLS

Indica se o Servidor utiliza conexao TLS

@author soulsys:victorhugo
@since 18/09/2021
/*/
method isTLS() class LibMailObj
return ::lTLS


/*/{Protheus.doc} setTLS

Define se o Servidor utiliza conexao TLS

@author soulsys:victorhugo
@since 18/09/2021
/*/
method setTLS(lTLS) class LibMailObj
  ::lTLS := lTLS
return


/*/{Protheus.doc} isImap

Indica se o Servidor utiliza conexao IMAP

@author soulsys:victorhugo
@since 18/09/2021
/*/
method isImap() class LibMailObj
return ::lImap


/*/{Protheus.doc} setImap

Define se o Servidor utiliza conexao IMAP

@author soulsys:victorhugo
@since 18/09/2021
/*/
method setImap(lImap) class LibMailObj
  ::lImap := lImap
return


/*/{Protheus.doc} getTimeOut

Coleta o Time-Out do Servidor SMTP

@author soulsys:victorhugo
@since 18/09/2021
/*/
method getTimeOut() class LibMailObj
return ::nTimeOut


/*/{Protheus.doc} setTimeOut

Define o Time-Out do Servidor SMTP

@author soulsys:victorhugo
@since 18/09/2021
/*/
method setTimeOut(nTimeOut) class LibMailObj
  ::nTimeOut := nTimeOut
return


/*/{Protheus.doc} getHtmlLayout

Coleta o arquivo HTML de Layout

@author soulsys:victorhugo
@since 18/09/2021
/*/
method getHtmlLayout() class LibMailObj	
return ::cHtmlLayout


/*/{Protheus.doc} setHtmlLayout

Define o arquivo HTML de Layout

@author soulsys:victorhugo
@since 18/09/2021
/*/
method setHtmlLayout(cHtml) class LibMailObj
  
  local lOk := File(cHtml)
  
  if lOk
    ::cHtmlLayout := cHtml
    ::oWfHtml 	  := TWfHtml():new(cHtml)		
  endIf
  
return lOk


/*/{Protheus.doc} connect

Conecta ao Servidor de Email

@author soulsys:victorhugo
@since 18/09/2021
/*/
method connect() class LibMailObj

  ::oMailManager:setUseSSL(::isSSL())
  ::oMailManager:setUseTLS(::isTLS())
  ::oMailManager:setSmtpTimeOut(::getTimeOut())	
  
  if ::lImap
    ::oMailManager:init(::getServer(), "", ::getAccount(), ::getPassword(), ::getPort())
    ::nLastError := ::oMailManager:imapConnect()
  else
    ::oMailManager:init("", ::getServer(), ::getAccount(), ::getPassword(), 0, ::getPort())
    ::nLastError := ::oMailManager:smtpConnect()
  endIf	
  
  if (::nLastError == 0)
    ::setConnected(.T.)	
  else
    setErrorMessage(self, "Falha ao conectar ao Servidor de Email")
  endIf
                         
return ::isConnected()


/*/{Protheus.doc} send

Envia o e-mail

@author soulsys:victorhugo
@since 18/09/2021
/*/
method send(cTo, cSubject, cBody, cAttachment, cCC, cBCC) class LibMailObj
                                                                                   
  local lSendOk 	    := .F.
  local lAuthOk		    := .T.	
  local cHtml		 	    := ::getHtmlLayout()
  local lHtml			    := (!Empty(cHtml) .and. File(cHtml))
  default cBody		    := ""		
  default cAttachment	:= ""
  default cCC			    := ""
  default cBCC		    := ""
  
  if !::isConnected()
    if !::connect()
      return .F.		
    endIf	
  endIf
  
  if ::isAuthenticate()
    ::nLastError := ::oMailManager:smtpAuth(::getAccount(), ::getPassword())
    lAuthOk := (::nLastError == 0)
  endIf	
  
  if lAuthOk
    if lHtml
      cBody := ::oWfHtml:htmlCode()
    endIf
    ::oMailMsg:cFrom 	:= ::getFrom()	
    ::oMailMsg:cTo 		:= cTo		
    ::oMailMsg:cSubject	:= cSubject	
    ::oMailMsg:cBody 	:= cBody
    if !Empty(cCC)
      ::oMailMsg:cCC := cCC
    endIf
    if !Empty(cBCC)
      ::oMailMsg:cBCC := cBCC
    endIf		
    ::attachFile(cAttachment)
    ::nLastError := ::oMailMsg:send(::oMailManager)
    lSendOk := (::nLastError == 0)
  endIf
  
  if !lSendOk
    setErrorMessage(self, "Falha ao Enviar o Email") 
  endIf     
  
  if ::isConnected()
    ::disconnect()	
  endIf
      
return lSendOk


/*/{Protheus.doc} disconnect

Desconecta do Servidor de E-mail

@author soulsys:victorhugo
@since 18/09/2021
/*/
method disconnect() class LibMailObj
  
  local lDisconnectOk := .F.
    
    if ::isConnected()				
      ::nLastError := ::oMailManager:smtpDisconnect() 
    if !(lDisconnectOk := (::nLastError == 0))
      setErrorMessage(self, "Falha ao desconectar do Servidor de Email")
    endIf		
  endIf
      
return lDisconnectOk

/**
 * Define as Mensagens de Erro
 */
static function setErrorMessage(oLibMailObj, cActionMessage) 
  
  local cErrorMsg := oLibMailObj:oMailManager:getErrorString(oLibMailObj:nLastError)
      
  oLibMailObj:setError(cActionMessage+CRLF+CRLF+cErrorMsg)
    
return


/*/{Protheus.doc} attachFile

Anexa arquivos a Mensagem

@author soulsys:victorhugo
@since 18/09/2021
/*/
method attachFile(cFile) class LibMailObj
  
  local lOk := .F.
  
  if File(cFile)
    lOk := !(::oMailMsg:attachFile(cFile) < 0) 
  endIf
  
return lOk


/*/{Protheus.doc} setConfirmRead

Define se solicita confirmacao de leitura das mensagens enviadas

@author soulsys:victorhugo
@since 18/09/2021
/*/
method setConfirmRead(lConfirm) class LibMailObj	
  ::oMailMsg:setConfirmRead(lConfirm)	
return


/*/{Protheus.doc} setHtmlValue

Define valores para o Html

@author soulsys:victorhugo
@since 18/09/2021
/*/
method setHtmlValue(cVar, xValue) class LibMailObj	
  ::oWfHtml:valByName(cVar, xValue)	
return


/*/{Protheus.doc} addHtmlTableValue

Define valores para tabelas do Html

@author soulsys:victorhugo
@since 18/09/2021
/*/
method addHtmlTableValue(cVar, xValue) class LibMailObj
  aAdd((::oWfHtml:valByName(cVar)), xValue)	
return


/*/{Protheus.doc} showProperties

Exibe as propriedades configuradas para o objeto
  
@author soulsys:victorhugo
@since 18/09/2021
/*/
method showProperties() class LibMailObj
  
  local cMsg   := ""	
  local oUtils := LibUtilsObj():newLibUtilsObj()
  
  cMsg := "Server: " + ::getServer() + CRLF
  cMsg += "Port: " + oUtils:strAnyType(::getPort()) + CRLF
  cMsg += "Account: " + ::getAccount() + CRLF
  cMsg += "Password: " + ::getPassword() + CRLF
  cMsg += "From: " + ::getFrom() + CRLF
  cMsg += "Authenticate: " + oUtils:strAnyType(::isAuthenticate()) + CRLF	
  cMsg += "SSL: " + oUtils:strAnyType(::isSSL()) + CRLF
  cMsg += "TLS: " + oUtils:strAnyType(::isTLS()) + CRLF
  cMsg += "TimeOut: " + oUtils:strAnyType(::getTimeOut()) + CRLF
  cMsg += "Protocol: " + if (::lImap, "IMAP", "SMTP")
  
  MsgInfo(cMsg)	

return
