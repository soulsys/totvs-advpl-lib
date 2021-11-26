#include "totvs.ch"
#include "rwmake.ch"


/*/{Protheus.doc} LibUtilsObj

Objeto com funcionalidades genericas

@author soulsys:victorhugo
@since 18/09/2021
/*/
class LibUtilsObj from LibAdvplObj

  method newLibUtilsObj() constructor
  
  method canDelete()
  method checkAdvplCode()
  method concatDirectory()
  method consoleLog()
  method debugMsg()
  method endsWith()
  method existVar()
  method formatCgc()
  method formatCurrency()
  method formatDate()
  method formatInteger()
  method formatZipCode()
  method fromJsDate()
  method getAge()
  method getCompanyName()
  method getDefaultValue()
  method getErroAuto()
  method getJsDate()
  method getWhenMessage()
  method getObjectProperty()
  method getRemoteDirectory()
  method getUserName() 
  method hasOnlyNumbers()
  method isCashPayment()
  method isInJob()
  method isNull()
  method isNotNull()
  method isOnServer()
  method isWorkDay()
  method msgRun()
  method noAccent()
  method padrSx3()
  method restAreas()
  method saveAreas()
  method scrollMessage()
  method showArrayAuto()
  method showHelp()
  method startsWith()
  method strAnyType()
  method strToArray()		
  method vetorToString()
  method weekOfMonth()  
  method whenIsNull()

endClass


/*/{Protheus.doc} newLibUtilsObj

Construtor

@author soulsys:victorhugo
@since 18/09/2021
/*/
method newLibUtilsObj() class LibUtilsObj
  ::newLibAdvplObj()
return


/*/{Protheus.doc} canDelete

Verifica se um registro pode ser excluido a partir do ID do mesmo e a lista
de tabelas relacionadas
  
@author soulsys:victorhugo
@since 20/08/2021
/*/
method canDelete(cId, aRelation, lShowMsg) class LibUtilsObj

  local nI         := 0
  local lOk        := .T.
  local cMsg       := ""
  local cAlias     := ""
  local cField     := ""
  local oSql       := LibSqlObj():newLibSqlObj()
  default lShowMsg := .T.

  for nI := 1 to Len(aRelation)
    cAlias := aRelation[nI,1]
    cField := aRelation[nI,2]
    if oSql:exists(cAlias, "%" + cAlias + ".XFILIAL% AND " + cField + " = '" + cId + "'")
      lOk := .F.
      cMsg += CRLF + cAlias + " - " + oSql:getFieldValue("SX2", "X2_NOME", "X2_CHAVE = '" + cAlias + "'")
    endIf
  next nI

  if !lOk .and. lShowMsg
    MsgAlert("Esse registro nao pode ser excluido pois esta relacionado com as seguintes tabelas: " + CRLF + cMsg)
  endIf

return lOk


/*/{Protheus.doc} checkAdvplCode

Validacao de expressoes Advpl

@author soulsys:victorhugo
@since 18/09/2021
/*/
method checkAdvplCode(cCode) class LibUtilsObj

  local lOk		  := .T.
  local bError 	:= ErrorBlock({ |oError| MsgBox(cCode+CRLF+CRLF+oError:Description, "expressao Invalida", "ALERT"), lOk := .F. })
  default cCode	:= &(ReadVar())

  &(AllTrim(cCode))

  ErrorBlock(bError)

return lOk


/*/{Protheus.doc} concatDirectory

Concatena uma string com o diretorio de um arquivo

@author soulsys:victorhugo
@since 18/09/2021
/*/
method concatDirectory(cDirectory, cFile) class LibUtilsObj

  local cRet := ""
  local cBar := ""	
  
  if ("/" $ cDirectory)
    cBar := "/"
  elseIf ("\" $ cDirectory)
    cBar := "\"
  endIf	

  cDirectory := AllTrim(cDirectory)
  
  if Empty(cBar)
    cDirectory := "\"+cDirectory+"\"
  else
    if (Right(cDirectory, 1) != cBar)
      cDirectory += cBar
    endIf
  endIf	

  cRet := cDirectory+AllTrim(cFile)

return cRet


/*/{Protheus.doc} consoleLog

Exibe um valor no console
  
@author soulsys:victorhugo
@since 18/09/2021
/*/
method consoleLog(xValue, lShowMsg, nSleep) class LibUtilsObj
  
  local nI   	     := 0
  local cStr 	     := ""
  local cFile      := nil
  local lConsole   := .T.
  local lWriteFile := .F.
  local oLog       := LibLogObj():newLibLogObj(cFile, lConsole, lWriteFile)
  default lShowMsg := .F.
  default nSleep   := 0
  
  if (ValType(xValue) == "A")		
    for nI := 1 to Len(xValue)
      if !Empty(cStr)
        cStr += " " 
      endIf
      cStr += ::strAnyType(xValue[nI])
    next nI	
  else
    cStr := ::strAnyType(xValue)
  endIf

  oLog:debug(cStr)
  
  if lShowMsg	
    MsgInfo(cStr)		
  elseIf (nSleep > 0)	
    Sleep(nSleep)		
  endIf

return


/*/{Protheus.doc} debugMsg

Exibe uma mensagem de debug
  
@author soulsys:victorhugo
@since 18/09/2021
/*/
method debugMsg(cVar, xValue, lConsole, nSleep) class LibUtilsObj

  local oLog       := nil
  local cMsg       := AllTrim(cVar) + " => " + ::strAnyType(xValue)
  default lConsole := ::isInJob()
  default nSleep   := 0

  if !lConsole
    return Alert("[DEBUG] - " + cMsg)
  endIf  

  oLog := LibLogObj():newLibLogObj()
  oLog:setConsole(.T.)  
  oLog:setShowCompany(.T.)
  oLog:setShowThreadId(.T.)
  oLog:setWriteFile(.F.)
  oLog:debug(cMsg)
  
  if (nSleep > 0)
    Sleep(nSleep)
  endIf

return


/*/{Protheus.doc} endsWith

Verifica se uma string finaliza com um caracter

@author soulsys:victorhugo
@since 18/09/2021
/*/
method endsWith(cStr, cChr, lStrTrim) class LibUtilsObj

  default lStrTrim := .T.

  if lStrTrim
    cStr := AllTrim(cStr)
    cChr := AllTrim(cChr)
  endIf

return (Right(cStr, 1) == cChr)


/*/{Protheus.doc} existVar

Verifica se uma variavel existe
  
@author soulsys:victorhugo
@since 18/09/2021
/*/
method existVar(cVar) class LibUtilsObj
return (Type(cVar) != "U")


/*/{Protheus.doc} formatCgc

Formata CNPJ/CPF
  
@author soulsys:victorhugo
@since 18/09/2021
/*/
method formatCgc(cCgc) class LibUtilsObj
  
  local cPicture := "@R 99.999.999/9999-99"

  cCgc := AllTrim(cCgc)
  
  if Empty(cCgc)
    return ""
  endIf
  
  if (Len(cCgc) < 14)
    cPicture := "@R 999.999.999-99"
  endIf	

return AllTrim(Transform(cCgc, cPicture))


/*/{Protheus.doc} formatCurrency

Formata Valores Monetï¿½rios
  
@author soulsys:victorhugo
@since 18/09/2021
/*/
method formatCurrency(nValue) class LibUtilsObj	
return AllTrim(Transform(nValue, "@E 999,999,999.99"))


/*/{Protheus.doc} formatDate

Formata Datas
  
@author soulsys:victorhugo
@since 18/09/2021
/*/
method formatDate(dDate) class LibUtilsObj	

  local nDay   := 0
  local nMonth := 0
  local nYear  := 0

  if Empty(dDate)
    return ""
  endIf

  nDay   := Day(dDate)
  nMonth := Month(dDate)
  nYear  := Year(dDate)

return StrZero(nDay, 2) + "/" + StrZero(nMonth, 2) + "/" + AllTrim(Str(nYear))


/*/{Protheus.doc} formatInteger

Formata Valores Inteiros
  
@author soulsys:victorhugo
@since 18/09/2021
/*/
method formatInteger(nValue) class LibUtilsObj	
return AllTrim(Transform(nValue, "@E 999,999,999,999"))


/*/{Protheus.doc} formatZipCode

Formata CEP
  
@author soulsys:waldiresmerio
@since 08/10/2021
/*/
method formatZipCode(cZipCode) class LibUtilsObj
  
  local cPicture := "@R 99999-999"

  cZipCode := AllTrim(StrTran(cZipCode, "-", ""))
  
  if Empty(cZipCode)
    return ""
  endIf

return AllTrim(Transform(cZipCode, cPicture))


/*/{Protheus.doc} fromJsDate

Converte uma Data JSON para Date
  
@author soulsys:victorhugo
@since 18/09/2021
/*/
method fromJsDate(cJsDate) class LibUtilsObj

  local cYear  := ""
  local cMonth := ""
  local cDay   := ""
  
  if (ValType(cJsDate) == "D")
    return cJsDate
  endIf
  
  if Empty(cJsDate)
    return CtoD("")
  endIf  
  
  cYear  := Left(cJsDate, 4)
  cMonth := SubStr(cJsDate, 6, 2)
  cDay   := SubStr(cJsDate, 9, 2)

  if (cYear == "0000")
    return CtoD("")
  endIf

return StoD(cYear + cMonth + cDay)


/*/{Protheus.doc} getAge

Coleta Idade a partir de uma Data de Nascimento
  
@author soulsys:victorhugo
@since 18/09/2021
/*/
method getAge(dBirth, dDateRef) class LibUtilsObj
  
  local nAge       := 0
  local nDay		   := Day(dBirth)
  local nMonth	   := Month(dBirth)
  local dAux		   := (dBirth + 1)
  default dDateRef := dDataBase
  
  while (dAux <= dDateRef)
    if (Day(dAux) == nDay .and. Month(dAux) == nMonth)
      nAge++
    endIf               
    dAux++
  endDo
  
return nAge


/*/{Protheus.doc} getCompanyName

Coleta o Nome de uma Empresa/Filial
  
@author soulsys:victorhugo
@since 18/09/2021
/*/
method getCompanyName(cCompany, cBranch) class LibUtilsObj
  
  local cName		   := "" 
  local aAreaSM0 	 := SM0->(GetArea())
  default cCompany := SM0->M0_CODIGO
  default cBranch  := SM0->M0_CODFIL
  
  if SM0->(dbSeek(cCompany+cBranch))
    cName := SM0->(Capital(AllTrim(M0_NOME))+" / "+Capital(AllTrim(M0_FILIAL))) 
  endIf
  
  RestArea(aAreaSM0)

return cName


/*/{Protheus.doc} getDefaultValue

Coleta o Valor padrao de acordo com o tipo de dados. Ex.: C="", N=0, D=CtoD(""), L=.F., O=nil
  
@author soulsys:victorhugo
@since 18/09/2021
/*/
method getDefaultValue(cValType) class LibUtilsObj

  local xValue     := nil
  default cValType := ""
  
  if (cValType == "C")
    xValue := ""
  elseIf (cValType == "N")
    xValue := 0
  elseIf (cValType == "D")
    xValue := CtoD("")
  elseIf (cValType == "L")
    xValue := .F.
  elseIf (cValType == "O")
    xValue := nil
  endIf
  
return xValue


/*/{Protheus.doc} getErroAuto

Coleta erros de rotinas automaticas a partir dos arquivos gerados no servidor

@author soulsys:victorhugo
@since 18/09/2021
/*/
method getErroAuto(lHtml) class LibUtilsObj

  local cErroAuto := ""
  local cFile     := NomeAutoLog()
  default lHtml	  := .F.

  if !Empty(cFile) .and. File(cFile)
    cErroAuto := MemoRead(cFile)
    FErase(cFile)
  endIf
  
  if lHtml
    cErroAuto := Replace(cErroAuto, CRLF, "<br/>") 
  endIf

return cErroAuto


/*/{Protheus.doc} getJsDate

Retorna uma data no formato Javascript
  
@author soulsys:victorhugo
@since 18/09/2021
/*/
method getJsDate(xDate, xDefDate) class LibUtilsObj

  local dDate  := nil
  local cDate	 := ""
  local cDay	 := ""
  local cMonth := ""
  local cYear	 := ""
  
  if Empty(xDate)
    xDate := xDefDate
  endIf

  if Empty(xDate)
    return ""
  endIf
  
  if (ValType(xDate) == "C")
    
    xDate := AllTrim(xDate)
    
    if (Len(xDate) == 8)
      dDate := StoD(xDate)
    else
      dDate := CtoD(xDate)
    endIf 			
    
  else
  
    dDate := xDate
  
  endIf
  
  cDate  := DtoS(dDate)	
  cDay	 := Right(cDate, 2)
  cMonth := SubStr(cDate, 5, 2)
  cYear	 := Left(cDate, 4)	

return cYear + "-" + cMonth + "-" + cDay + "T00:00:00"


/*/{Protheus.doc} getWhenMessage

Coleta uma Mensagem sobre quando ocorreu uma Evento a partir de uma Data e Hora
  
@author soulsys:victorhugo
@since 18/09/2021
/*/
method getWhenMessage(dDate, cTime, lEnglish) class LibUtilsObj
  
  local nDays   	 := 0
  local cWhen	  	 := ""
  default dDate 	 := dDataBase
  default cTime 	 := Left(Time(), 5)	
  default lEnglish := .F.
  
  if (dDate == dDataBase)
    cWhen := if(lEnglish, "Today at "+cTime, "Hoje às " + cTime)
  else
    nDays := (dDataBase - dDate)
    if (nDays == 1)
      cWhen := if(lEnglish, "Yesterday at "+cTime, "Ontem às " + cTime)
    else
      cWhen := if(lEnglish, AllTrim(Str(nDays))+" days ago", "Há " + AllTrim(Str(nDays)) + " dias") 
    endIf
  endIf

return cWhen


/*/{Protheus.doc} getObjectProperty

Coleta propriedades de um objeto testando sua existï¿½ncia
  
@author soulsys:victorhugo
@since 18/09/2021
/*/
method getObjectProperty(oObject, cProperty) class LibUtilsObj
  
  local xValue  := nil
  local cMacro  := ""
  private _oObj := oObject
  
  cMacro := "_oObj:"+cProperty
  
  if (Type(cMacro) != "U")
    xValue := &cMacro
  endIf
  
return xValue


/*/{Protheus.doc} getRemoteDirectory

Coleta o diretorio do Smartclient
  
@author soulsys:victorhugo
@since 18/09/2021
/*/
method getRemoteDirectory() class LibUtilsObj
  
  local oIniFile := LibFileObj():newLibFileObj(GetRemoteIniName())
  
return oIniFile:getDirectory()


/*/{Protheus.doc} getUserName

Retorna o nome de um usuario do Protheus
  
@author soulsys:victorhugo
@since 18/09/2021
/*/
method getUserName(cUserId) class LibUtilsObj
  
  local cName	    := "" 
  local aArea		  := GetArea()
  default cUserId := __cUserId
  
  if Empty(cUserId)
    return "" 
  endIf
  
  PswOrder(1)
  if PswSeek(cUserId)
    cName := PswRet(1)[1][2]
  endIf
  
  RestArea(aArea)
  
return cName


/*/{Protheus.doc} hasOnlyNumbers

Verifica se uma string possui apenas numeros

@author soulsys:victorhugo
@since 18/09/2021
/*/
method hasOnlyNumbers(cString) class LibUtilsObj

  local nI		   	   := 0
  local cChr		   	 := ""
  local cNumbers		 := "0123456789"
  local lOnlyNumbers := .T.

  cString := AllTrim(cString)

  for nI := 1 to Len(cString)
    cChr := SubStr(cString, nI, 1)
    if !(cChr $ cNumbers)
      lOnlyNumbers := .F.
      exit
    endIf
  next nI

return lOnlyNumbers


/*/{Protheus.doc} isCashPayment

Verifica se uma condicao de pagamento eh a vista
  
@author soulsys:victorhugo
@since 18/09/2021
/*/
method isCashPayment(cPayCond, nDays) class LibUtilsObj
    
  local lIsCashPayment := .F.
  local dFirstDate	   := CtoD("")
  local aValues		     := Condicao(100, cPayCond)
  default nDays		     := 1
  
  if (Len(aValues) == 1)
    dFirstDate   := aValues[1,1]
    lIsCashPayment := ((dFirstDate - dDataBase) <= nDays)
  endIf

return lIsCashPayment


/*/{Protheus.doc} isInJob

Verifica se esta executando em Job (sem interface de usuario)

@author soulsys:victorhugo
@since 18/09/2021
/*/
method isInJob() class LibUtilsObj
return (Type("oMainWnd") <> "O")


/*/{Protheus.doc} isNull

Verifica se uma variavel eh nula (igual a nil)
  
@author soulsys:victorhugo
@since 18/09/2021
/*/
method isNull(xVar) class LibUtilsObj
return (ValType(xVar) == "U")


/*/{Protheus.doc} isNotNull

Verifica se uma variavel nao eh nula (diferente a nil)
  
@author soulsys:victorhugo
@since 18/09/2021
/*/
method isNotNull(xVar) class LibUtilsObj	
return (ValType(xVar) != "U") 


/*/{Protheus.doc} isOnServer

Indica se um recurso esta no Servidor do Protheus (rootpath)
  
@author soulsys:victorhugo
@since 18/09/2021
/*/
method isOnServer(cSrc) class LibUtilsObj
  
  local lServer 		  := .F.
  local lWindowsLocal	:= .F.
  
  if (ValType(cSrc) != "C")
    return .F.				
  endIf
  
  cSrc 		      := AllTrim(cSrc)	
  lWindowsLocal := (SubStr(cSrc, 2, 1) == ":") 
  lUnixLocal	  := ("/" $ cSrc)
  lServer 	    := (!lWindowsLocal .and. !lUnixLocal)
        
return lServer


/*/{Protheus.doc} isWorkDay

Verifica se eh dia util em determinada data

@author soulsys:victorhugo
@since 18/09/2021
/*/
method isWorkDay(dDate) class LibUtilsObj

  local lNextDay     := .T.
  local dNextWorkDay := DataValida(dDate, lNextDay)

return (dNextWorkDay == dDate)


/*/{Protheus.doc} msgRun

Exibe um dialog de processamento
  
@author soulsys:victorhugo
@since 18/09/2021
/*/
method msgRun(bCodeBlock, cText, cTitle) class LibUtilsObj
  
  default cText  := "Processando..."
  default cTitle := "Aguarde"
  
  FwMsgRun(nil, bCodeBlock, cTitle, cText)

return


/*/{Protheus.doc} noAccent

Remove acentos ou caracteres especiais de uma string

@author soulsys:victorhugo
@since 18/09/2021
/*/
method noAccent(cString) class LibUtilsObj

  Local cChar  := ""
  Local nX     := 0 
  Local nY     := 0
  Local cVogal := "aeiouAEIOU"
  Local cAgudo := "ï¿½ï¿½ï¿½ï¿½ï¿½"+"ï¿½ï¿½ï¿½ï¿½ï¿½"
  Local cCircu := "ï¿½ï¿½ï¿½ï¿½ï¿½"+"ï¿½ï¿½ï¿½ï¿½ï¿½"
  Local cTrema := "ï¿½ï¿½ï¿½ï¿½ï¿½"+"ï¿½ï¿½ï¿½ï¿½ï¿½"
  Local cCrase := "ï¿½ï¿½ï¿½ï¿½ï¿½"+"ï¿½ï¿½ï¿½ï¿½ï¿½" 
  Local cTio   := "ï¿½ï¿½ï¿½ï¿½"
  Local cCecid := "ï¿½ï¿½"
  Local cMaior := "&lt;"
  Local cMenor := "&gt;"
  
  For nX:= 1 To Len(cString)
    cChar:=SubStr(cString, nX, 1)
    IF cChar$cAgudo+cCircu+cTrema+cCecid+cTio+cCrase
      nY:= At(cChar,cAgudo)
      If nY > 0
        cString := StrTran(cString,cChar,SubStr(cVogal,nY,1))
      EndIf
      nY:= At(cChar,cCircu)
      If nY > 0
        cString := StrTran(cString,cChar,SubStr(cVogal,nY,1))
      EndIf
      nY:= At(cChar,cTrema)
      If nY > 0
        cString := StrTran(cString,cChar,SubStr(cVogal,nY,1))
      EndIf
      nY:= At(cChar,cCrase)
      If nY > 0
        cString := StrTran(cString,cChar,SubStr(cVogal,nY,1))
      EndIf		
      nY:= At(cChar,cTio)
      If nY > 0          
        cString := StrTran(cString,cChar,SubStr("aoAO",nY,1))
      EndIf		
      nY:= At(cChar,cCecid)
      If nY > 0
        cString := StrTran(cString,cChar,SubStr("cC",nY,1))
      EndIf
    Endif
  Next
  
  If cMaior$ cString 
    cString := strTran( cString, cMaior, "" ) 
  EndIf
  If cMenor$ cString 
    cString := strTran( cString, cMenor, "" )
  EndIf
  
  cString := StrTran( cString, CRLF, " " )
  
  For nX:=1 To Len(cString)
    cChar:=SubStr(cString, nX, 1)
    If (Asc(cChar) < 32 .Or. Asc(cChar) > 123) .and. !cChar $ '|' 
      cString:=StrTran(cString,cChar,".")
    Endif
  Next nX

Return cString


/*/{Protheus.doc} padrSx3

Coloca espacos a direita em uma String conforme um campo do SX3

@author soulsys:victorhugo
@since 18/09/2021
/*/
method padRSx3(cString, cField) class LibUtilsObj

  local cAliasSX3 := GetNextAlias()

  OpenSXs(,,,,cEmpAnt,cAliasSX3,"SX3",,.F.)  
      
  if (Select(cAliasSX3) > 0)

    dbSelectArea(cAliasSX3)
    (cAliasSX3)->(dbSetOrder(2))

    if (cAliasSX3)->(dbSeek(cField))
      cString := PadR(AllTrim(cString), (cAliasSX3)->&("X3_TAMANHO"))
    endIf

    (cAliasSX3)->(DbCloseArea())

  endIf

return cString


/*/{Protheus.doc} saveAreas

Salva varias areas de aliases

@author soulsys:victorhugo
@since 18/09/2021
/*/
method saveAreas(aAreas) class LibUtilsObj

  local nI		   := 0
  local aSave  	 := {}
  local cAlias	 := ""
  default aAreas := {}

  for nI := 1 to Len(aAreas)
    cAlias := aAreas[nI]
    aAdd(aSave, (cAlias)->(GetArea()))
  next nI

  aAdd(aSave, GetArea())

return aSave


/*/{Protheus.doc} restAreas

Restaura varias areas de aliases

@author soulsys:victorhugo
@since 18/09/2021
/*/
method restAreas(aAreas) class LibUtilsObj

  local nI 		   := 0
  default aAreas := {}

  for nI := 1 to Len(aAreas)
    RestArea(aAreas[nI])
  next nI

return


/*/{Protheus.doc} scrollMessage

Exibe uma mensagem com barra de rolagem
  
@author soulsys:victorhugo
@since 18/09/2021
/*/
method scrollMessage(cText, cHeader, cTitle, aButtons) class LibUtilsObj

  default cText    := ""
  default cHeader	 := ""
  default cTitle   := "Scroll Message"
  default aButtons := {"Ok"} 

return Aviso(cTitle, cText, aButtons, 3, cHeader)


/*/{Protheus.doc} showArrayAuto

Exibe o conteudo de um array de rotinas automaticas

@author soulsys:victorhugo
@since 18/09/2021
/*/
method showArrayAuto(aExecAuto) class LibUtilsObj

  local nI     := 0
  local cStr   := ""
  local oLog   := LibLogObj():newLibLogObj()
  local oUtils := LibUtilsObj():newLibUtilsObj()

  for nI := 1 to Len(aExecAuto)
    cStr += aExecAuto[nI, 1] + ": "
    cStr += oUtils:strAnyType(aExecAuto[nI, 2])
    cStr += " ( " + ValType(aExecAuto[nI, 2]) + " )" + CRLF
  next nI

  if ::isInJob()
    oLog:setConsole(.T.)
    oLog:setWriteFile(.F.)
    oLog:debug(CRLF + "ExecAuto" + CRLF + cStr + CRLF)
  else
    Aviso("ExecAuto", cStr, {"Ok"}, 3)
  endIf  

return


/*/{Protheus.doc} showHelp

Exibe um dialogo de help

@author soulsys:victorhugo
@since 18/09/2021
/*/
method showHelp(cTitle, cProblem, cSolution) class LibUtilsObj

  local aProblem    := {}
  local aSolution   := {}
  default cTitle    := "LibUtilsObj():showHelp()"
  default cProblem  := ""
  default cSolution := ""

  aProblem  := getHelpVetor(cProblem)
  aSolution := getHelpVetor(cSolution)

  ShowHelpDlg(cTitle, aProblem, Len(aProblem), aSolution, Len(aSolution))

return

/**
 * Retorna os vetores para o mï¿½todo showHelp()
 */
static function getHelpVetor(cText)

  local nLin    := 0
  local nMaxCol := 42
  local aVetor  := {}

  for nLin := 1 to MlCount(cText, nMaxCol)
    aAdd(aVetor, MemoLine(cText, nMaxCol, nLin))
  next nI

return aVetor


/*/{Protheus.doc} startsWith

Verifica se uma string inicia com um caracter

@author soulsys:victorhugo
@since 18/09/2021
/*/
method startsWith(cStr, cChr, lStrTrim) class LibUtilsObj

  default lStrTrim := .T.

  if lStrTrim
    cStr := AllTrim(cStr)
    cChr := AllTrim(cChr)
  endIf

return (Left(cStr, 1) == cChr)


/*/{Protheus.doc} strAnyType

Converte qualquer valor para String. Ex.: oUtils:strAnyType(dData, "DDMMAA"), oUtils:strAnyType(nValor, "@E 999,999,999.99")

@author soulsys:victorhugo
@since 18/09/2021
/*/
method strAnyType(xValue, cPicture) class LibUtilsObj

  local cString 	 := ""
  local cType   	 := ValType(xValue)
  default cPicture := ""

  if (cType == "C")
    cString := AllTrim(xValue)
  elseIf (cType == "N")
    cString := if(Empty(cPicture), AllTrim(Str(xValue)), AllTrim(Transform(xValue, cPicture)))
  elseIf (cType == "D")
    cString := strData(xValue, cPicture)
  elseIf (cType == "L")
    cString := if(xValue, "true", "false")
  elseIf (cType == "O")
    cString := "object"
  elseIf (cType == "A")
    cString := "array"
  endIf

return cString

/**
 * Conversao de datas
 */
static function strData(xValue, cPicture)

  local nScan		:= 0
  local cString	:= ""
  local aPics		:= {}
  local cDate  	:= DtoS(xValue)
  local cDay		:= Right(cDate, 2)
  local cMonth 	:= SubStr(cDate, 5, 2)
  local cYear4	:= Left(cDate, 4)
  local cYear2	:= Right(cYear4, 2)

  if Empty(cPicture)
    return DtoC(xValue)
  endIf

  cPicture := Upper(AllTrim(cPicture))

  aAdd(aPics, {"DDMMAA", cDay+cMonth+cYear2})
  aAdd(aPics, {"DDMMAAAA", cDay+cMonth+cYear4})
  aAdd(aPics, {"DD/MM/AA", cDay+"/"+cMonth+"/"+cYear2})
  aAdd(aPics, {"DD/MM/AAAA", cDay+"/"+cMonth+"/"+cYear4})

  aAdd(aPics, {"MMDDAA", cMonth+cDay+cYear2})
  aAdd(aPics, {"MMDDAAAA", cMonth+cDay+cYear4})
  aAdd(aPics, {"MM/DD/AA", cMonth+"/"+cDay+"/"+cYear2})
  aAdd(aPics, {"MM/DD/AAAA", cMonth+"/"+cDay+"/"+cYear4})

  aAdd(aPics, {"AAMMDD", cYear2+cMonth+cDay})
  aAdd(aPics, {"AAAAMMDD", cYear4+cMonth+cDay})
  aAdd(aPics, {"AA/MM/DD", cYear2+"/"+cMonth+"/"+cDay})
  aAdd(aPics, {"AA-MM-DD", cYear2+"-"+cMonth+"-"+cDay})
  aAdd(aPics, {"AAAA/MM/DD", cYear4+"/"+cMonth+"/"+cDay})
  aAdd(aPics, {"AAAA-MM-DD", cYear4+"-"+cMonth+"-"+cDay})

  nScan := aScan(aPics, {|x| x[1] == cPicture})

  if (nScan > 0)
    cString := aPics[nScan, 2]
  endIf

return cString


/*/{Protheus.doc} strToArray

Converte uma String para um array, considerando um tamanho maximo de caracteres
  
@author soulsys:victorhugo
@since 18/09/2021
/*/
method strToArray(cString, nMaxCol, lBlankLines) class LibUtilsObj
  
  local nLin	    	  := 0			
  local aVetor    	  := {}
  default nMaxCol 	  := 20
  default lBlankLines := .F.
  
  if Empty(cString)
    if lBlankLines
      return {" "}
    else	
      return {}
    endIf
  endIf
  
  For nLin := 1 To MlCount(cString, nMaxCol)		                            
    aAdd(aVetor, MemoLine(cString, nMaxCol, nLin))			
  Next nI			
    
return aVetor


/*/{Protheus.doc} vetorToString

Converte um vetor para uma string
  
@author soulsys:victorhugo
@since 18/09/2021
/*/
method vetorToString(aVetor, cSeparator) class LibUtilsObj
  
  local nI		       := 0
  local cString	     := ""
  default cSeparator := ", "

  for nI := 1 to Len(aVetor)
  
    if (nI > 1)
      cString += cSeparator
    endIf
    
    cString += ::strAnyType(aVetor[nI])
  
  next nI

return cString


/*/{Protheus.doc} weekOfMonth

Retorna o numero da semana do mes de determinada data

@author soulsys:victorhugo
@since 18/09/2021
/*/
method weekOfMonth(dDate) class LibUtilsObj

  local aMonth		     := {}
  local nScan			     := 0
  local nDayOfWeek	   := 0
  local nWeekOfMonth   := 0
  local nWeek			     := 1
  local nSunday		     := 1
  local nMonday		     := 2
  local nSaturday		   := 7
  local nFirstMonthDay := DoW(FirstDay(dDate))
  local dDay			     := FirstDay(dDate)
  local dLastDay		   := LastDay(dDate)

  if (nFirstMonthDay == nMonday .or. nFirstMonthDay == nSaturday .or. nFirstMonthDay == nSunday)
    nWeek := 0
  endIf

  while (dDay <= dLastDay)
    nDayOfWeek := DoW(dDay)
    if (nDayOfWeek == nMonday)
      nWeek++
    endIf
    aAdd(aMonth, {dDay,nWeek})
    dDay++
  endDo

  nScan 		   := aScan(aMonth, {|x| x[1] == dDate})
  nWeekOfMonth := aMonth[nScan,2]

  if (nWeekOfMonth == 0)
    nWeekOfMonth := 1
  endIf

return nWeekOfMonth


/*/{Protheus.doc} whenIsNull

Retorna um valor quando dada variavel for nula (igual a nil)
  
@author soulsys:victorhugo
@since 18/09/2021
/*/
method whenIsNull(xVar, xDefValue) class LibUtilsObj	
return if ( ::isNull(xVar), xDefValue, xVar )
