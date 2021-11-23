#include "totvs.ch"		

 
/*/{Protheus.doc} LibLogObj
 
Objeto para controle de Log
  
@author soulsys:victorhugo
@since 18/09/2021
/*/
class LibLogObj from LibFileObj	

  data lConsole
  data lWriteFile
  data lShowCompany
  data lShowThreadId
  data lCache
  data aLogs
  
  method newLibLogObj() constructor	
  
  method setConsole()
  method setWriteFile()  
  method info()
  method warn()
  method error()
  method debug()
  method lineBreak()  
  method setShowCompany()
  method setShowThreadId()
  method setCache()
  method getCachedLogs()
  method clearCache()
  
endClass


/*/{Protheus.doc} newLibLogObj

Construtor

@author soulsys:victorhugo
@since 18/09/2021
/*/
method newLibLogObj(cFile, lConsole, lWriteFile, lShowCompany, lShowThreadId) class LibLogObj	
  
  ::newLibFileObj(cFile)
  
  ::lConsole      := .F.
  ::lWriteFile    := .T.
  ::lShowCompany  := .F.
  ::lShowThreadId := .F.
  ::lCache        := .F.
  ::aLogs         := {}

  if (ValType(lConsole) == "L")
    ::lConsole := lConsole
  endIf

  if (ValType(lWriteFile) == "L")
    ::lWriteFile := lWriteFile
  endIf

  if (ValType(lShowCompany) == "L")
    ::lShowCompany := lShowCompany
  endIf

  if (ValType(lShowThreadId) == "L")
    ::lShowThreadId := lShowThreadId
  endIf
    
return


/*/{Protheus.doc} setConsole

Define se deve exibir os logs no console
  
@author soulsys:victorhugo
@since 18/09/2021
/*/
method setConsole(lConsole) class LibLogObj	
  ::lConsole := lConsole
return


/*/{Protheus.doc} setWriteFile

Define se deve gravar o log em disco
  
@author soulsys:victorhugo
@since 18/09/2021
/*/
method setWriteFile(lWriteFile) class LibLogObj	
  ::lWriteFile := lWriteFile
return


/*/{Protheus.doc} info

Grava uma mensagem de informacao no arquivo de log
  
@author soulsys:victorhugo
@since 18/09/2021
/*/
method info(cMessage) class LibLogObj	
return libLog(self, "INFO", cMessage)

  
/*/{Protheus.doc} warn

Grava uma mensagem de alerta no arquivo de log
  
@author soulsys:victorhugo
@since 18/09/2021
/*/
method warn(cMessage) class LibLogObj	
return libLog(self, "WARN", cMessage)


/*/{Protheus.doc} error

Grava uma mensagem de erro no arquivo de log
  
@author soulsys:victorhugo
@since 18/09/2021
/*/
method error(cMessage) class LibLogObj	
return libLog(self, "ERROR", cMessage)


/*/{Protheus.doc} debug

Grava uma mensagem de debug no arquivo de log
  
@author soulsys:victorhugo
@since 18/09/2021
/*/
method debug(cMessage) class LibLogObj	
return libLog(self, "DEBUG", cMessage)

/**
 * Grava linhas no arquivo texto de log
 */
static function libLog(oSelf, cSeverity, cMessage)

  local lOk       := .T.
  local cText     := "" 
  local cCompany  := ""
  local cThreadId := ""  
  local cDateTime := DtoC(Date()) + " " + Time()	

  if oSelf:lShowCompany .and. (Type("cEmpAnt") == "C")
    cCompany := " | COMPANY: " + AllTrim(cEmpAnt) + "/" + AllTrim(cFilAnt)
  endIf

  if oSelf:lShowThreadId
    cThreadId := " | THREAD: " + AllTrim(Str(ThreadId()))
  endIf
  
  cText := "[ " + cDateTime + " | " + cSeverity + " " + cThreadId + " " + cCompany + " ] " + cMessage

  if oSelf:lConsole
    FwLogMsg(cSeverity, /*cTransactionId*/, "LibUtilsObj", /*cCategory*/, /*cStep*/, /*cMsgId*/, cText + CRLF, /*nMensure*/, /*nElapseTime*/, /*aMessage*/)
  endIf

  if oSelf:lWriteFile
    lOk := oSelf:writeLine(cText)
  endIf

  if oSelf:lCache
    aAdd(oSelf:aLogs, cMessage)
  endIf

return lOk


/*/{Protheus.doc} lineBreak

Grava quebras de linha
  
@author soulsys:victorhugo
@since 18/09/2021
/*/
method lineBreak(nLines) class LibLogObj
  
  local cText    := ""
  default nLines := 0
  
  if (nLines > 0)
    cText := Replicate(CRLF, (nLines - 1))
  endIf		
  
  ::writeLine(cText)	
  
return


/*/{Protheus.doc} setShowCompany

Define se deve exibir a empresa/filial
  
@author soulsys:victorhugo
@since 18/09/2021
/*/
method setShowCompany(lShow) class LibLogObj
  ::lShowCompany := lShow  
return


/*/{Protheus.doc} setShowThreadId

Define se deve exibir o numero da thread
  
@author soulsys:victorhugo
@since 18/09/2021
/*/
method setShowThreadId(lShow) class LibLogObj
  ::lShowThreadId := lShow  
return


/*/{Protheus.doc} setCache

Define se deve salvar os logs na memoria
  
@author soulsys:victorhugo
@since 18/09/2021
/*/
method setCache(lCache) class LibLogObj	
  ::lCache := lCache
return


/*/{Protheus.doc} getCachedLogs

Retorna os logs salvos em cache
  
@author soulsys:victorhugo
@since 18/09/2021
/*/
method getCachedLogs() class LibLogObj	
return ::aLogs


/*/{Protheus.doc} clearCache

Limpa os logs salvos em cache
  
@author soulsys:victorhugo
@since 18/09/2021
/*/
method clearCache() class LibLogObj	
  ::aLogs := {}
return
