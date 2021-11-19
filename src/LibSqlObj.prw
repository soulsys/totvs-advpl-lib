#include "totvs.ch"
#include "topconn.ch"


/*/{Protheus.doc} LibSqlObj
 
Objeto para manipulacao de instrucoes SQL
  
@author soulsys:victorhugo
@since 18/09/2021
/*/
class LibSqlObj from LibAdvplObj
  
  data cAlias 
  data cLastQuery
  data cLastError
  data cDataBase	
  data aReportCells
  data nErpConnection
  data nExternalConnection			
  
  method newLibSqlObj() constructor
  
  method newAlias()
  method setDateFields()
  method setField()
  method getAlias()
  method getLastQuery()
  method getLastError()
  method getStruct()
  method aliasExists()
  method newTable()
  method close()
  method count()
  method hasRecords()
  method skip()
  method goTop()
  method isEof()
  method isNotEof()
  method notIsEof()
  method getValue()
  method execute()
  method update()	
  method insert()
  method insertInto()
  method save()
  method delete()
  method exists()
  method parseQuery()
  method exportToCsv()
  method showReport()
  method setReportCellProperty()	
  method saveQuery()
  method getFieldValue()
  method setErpConnection()
  method setExternalConnection()
  method hasExternalConnection()
  method isNullExp()
  method isSqlServer()
  method isOracle() 
  method getNextTableCode() 
  method refreshTable()
  method getInExp()
  method debugQuery()
  method getSx5Value()
  
endClass


/*/{Protheus.doc} newLibSqlObj

Construtor do objeto

@author soulsys:victorhugo
@since 18/09/2021	
/*/
method newLibSqlObj() class LibSqlObj		
  
  ::newLibAdvplObj()
  
  ::cLastQuery			    := ""
  ::cLastError			    := ""
  ::aReportCells			  := {}
  ::nErpConnection		  := AdvConnection()
  ::nExternalConnection	:= -1
  
return self


/*/{Protheus.doc} newAlias

Gera um novo alias a partir de uma consulta SQL

@author soulsys:victorhugo
@since 18/09/2021
/*/
method newAlias(cQuery) class LibSqlObj			
  
  if ::aliasExists()
    (::cAlias)->(dbCloseArea())
  endIf	
  
  while .T.
    ::cAlias := GetNextAlias()
    if (Select(::cAlias) <= 0)
      exit
    endIf
  endDo	
  
  ::cLastQuery := cQuery								
  cQuery 		   := ::parseQuery(cQuery)
  
  TCQUERY cQuery NEW ALIAS &::cAlias
      
return


/*/{Protheus.doc} setDateFields

Define campos do alias como data
  
@author soulsys:victorhugo
@since 18/11/2021
/*/
method setDateFields(aFields) class LibSqlObj
  
  local nI := 0

  for nI := 1 to Len(aFields)
    ::setField(aFields[nI], "D")
  next nI
  
return


/*/{Protheus.doc} setField

Define o tipo de dado ou precisao, para um campo/coluna do alias. Metodo equivalente a funcao TcSetField()
  
@author soulsys:victorhugo
@since 18/09/2021
/*/
method setField(cField, cType, nSize, nDecimals) class LibSqlObj
  
  local cAlias		  := ::getAlias()
  default nSize 		:= 0
  default nDecimals	:= 0
  
  if (cType == "D")
    nSize := 8
  elseIf (cType == "L")
    nSize := 1
  endIf		 	
  
  TcSetField(cAlias, cField, cType, nSize, nDecimals)
  
return


/*/{Protheus.doc} getAlias

Retorna o alias do objeto

@author soulsys:victorhugo
@since 18/09/2021
/*/
method getAlias() class LibSqlObj
return ::cAlias


/*/{Protheus.doc} getLastQuery

Retorna a ultima query definida para o objeto

@author soulsys:victorhugo
@since 18/09/2021
/*/
method getLastQuery() class LibSqlObj
return ::cLastQuery


/*/{Protheus.doc} getLastError

Retorna o ultimo erro do objeto

@author soulsys:victorhugo
@since 18/09/2021
/*/
method getLastError() class LibSqlObj
return ::cLastError


/*/{Protheus.doc} getStruct

Retorna o array de estrutura do alias

@author soulsys:victorhugo
@since 18/09/2021
/*/
method getStruct() class LibSqlObj

  local aStruct := {}
  
  if ::aliasExists()
    aStruct := (::cAlias)->(dbStruct())
  endIf

return aStruct

/*/{Protheus.doc} aliasExists

Indica se o alias do objeto existe

@author soulsys:victorhugo
@since 18/09/2021
/*/
method aliasExists() class LibSqlObj
return (Select(::cAlias) > 0)


/*/{Protheus.doc} newTable

Cria um novo alias para uma tabela. (ex.: oSql:newTable("SB1", "B1_FILIAL,B1_COD", "%SB1.XFILIAL% AND B1_COD = '"+cProduto+"'")

@author soulsys:victorhugo
@since 18/09/2021
/*/
method newTable(cTable, cFields, cWhere, cGroupBy, cOrderBy) class LibSqlObj
  
  local cQuery 		 := ""
  default cGroupBy := ""
  default cOrderBy := ""
  
  cQuery := " SELECT "+cFields+" FROM %"+cTable+".SQLNAME% "
  cQuery += " WHERE "+cWhere+" AND %"+cTable+".NOTDEL% "

  if !Empty(cGroupBy)
    cQuery += " GROUP BY "+cGroupBy
  endIf	

  if !Empty(cOrderBy)
    cQuery += " ORDER BY "+cOrderBy
  endIf
  
  ::cLastQuery := cQuery
  
  ::newAlias(cQuery)
  
return

/*/{Protheus.doc} close

Fecha o alias aberto

@author soulsys:victorhugo
@since 18/09/2021
/*/
method close() class LibSqlObj
  
  if ::aliasExists()
    (::cAlias)->(dbCloseArea())
  endIf
  
  if ::hasExternalConnection()
    ::setErpConnection()
  endIf
  
return


/*/{Protheus.doc} count

Conta os registros do alias

@author soulsys:victorhugo
@since 18/09/2021
/*/
method count() class LibSqlObj
  
  local nRegs := 0
  local aArea := GetArea()
  
  if ::aliasExists()
    dbSelectArea(::cAlias)
    count to nRegs
    ::goTop()							
  endIf
  
  RestArea(aArea)
  
return nRegs


/*/{Protheus.doc} hasRecords

Verifica se existem registros para o alias

@author soulsys:victorhugo
@since 18/09/2021
/*/
method hasRecords() class LibSqlObj	
return (::count() > 0)


/*/{Protheus.doc} skip

Avanca uma linha do alias

@author soulsys:victorhugo
@since 18/09/2021
/*/
method skip() class LibSqlObj
  
  if ::aliasExists()
    (::cAlias)->(dbSkip())
  endIf
  
return


/*/{Protheus.doc} goTop

Posiciona na primeira linha do alias

@author soulsys:victorhugo
@since 18/09/2021
/*/
method goTop() class LibSqlObj
  
  if ::aliasExists()
    (::cAlias)->(dbGoTop())
  endIf
  
return


/*/{Protheus.doc} isEof

Indica se o alias esta em fim de arquivo

@author soulsys:victorhugo
@since 18/09/2021
/*/
method isEof() class LibSqlObj
  
  local lIsEof := .T.
  
  if ::aliasExists()
    lIsEof := (::cAlias)->(eof())
  endIf
  
return lIsEof


/*/{Protheus.doc} isNotEof

Indica se o alias NAO esta em fim de arquivo. Pode ser usado para lacos, por exemplo: while oSql:isNotEof()

@author soulsys:victorhugo
@since 18/09/2021
/*/
method isNotEof() class LibSqlObj	
return !::isEof()


/*/{Protheus.doc} notIsEof

Indica se o alias NAO esta em fim de arquivo. Pode ser usado para lacos, por exemplo: while oSql:notIsEof()

@author soulsys:victorhugo
@since 18/09/2021
/*/
method notIsEof() class LibSqlObj	
return !::isEof()


/*/{Protheus.doc} getValue

Coleta o valor de um campo do registro posicionado. O valor do campo pode ser uma expressao ADVPL.

@author soulsys:victorhugo
@since 18/09/2021
/*/
method getValue(cField) class LibSqlObj
  
  local xValue := nil
  
  if ::aliasExists()
    xValue := (::cAlias)->&cField
  endIf
  
return xValue


/*/{Protheus.doc} execute

Executa uma instrucao SQL

@author soulsys:victorhugo
@since 18/09/2021
/*/	
method execute(cQuery, cRefreshAlias) class LibSqlObj
  
  local lOk             := .F.
  default cRefreshAlias := ""
  
  ::cLastQuery := cQuery
  
  cQuery := ::parseQuery(cQuery)	
  
  if (TcSqlExec(cQuery) == 0)
    lOk := .T.			
    if !Empty(cRefreshAlias)
      ::refreshTable(cRefreshAlias)		
    endIf
  else			                          
    setLastError(@self, "execute", TcSqlError())
  endIf		

return lOk


/*/{Protheus.doc} update

Executa update em uma tabela. (ex.: oSql:update("ZZ1", "ZZ1_ID = '', ZZ1_VALOR = 0", "%ZZ1.XFILIAL% AND ZZ1_DOC = '"+cDoc+"'"))

@author soulsys:victorhugo
@since 18/09/2021
/*/	
method update(cTable, cFields, cWhere) class LibSqlObj
  
  local cQuery := ""
  
  cQuery := " UPDATE "+RetSqlName(cTable)
  cQuery += " SET "+cFields
  cQuery += " WHERE "+cWhere+" AND D_E_L_E_T_ = ' ' "
  
return ::execute(cQuery, cTable)


/*/{Protheus.doc} insert

Inclusao de um registro em uma tabela (ex.: oSql:insert("SB1", aDados))

@author soulsys:victorhugo
@since 18/09/2021
/*/	
method insert(cTable, aData, nRecno) class LibSqlObj
  
  local lOk 		 := .F.
  local nI  		 := 0
  local cField	 := ""
  local xValue   := nil	
  local aArea		 := GetArea()
  default nRecno := 0
  
  dbSelectArea(cTable) 
  
  if (cTable)->(RecLock(cTable, .T.))
    for nI := 1 to Len(aData)
      cField := aData[nI,1]
      xValue := aData[nI,2]
      if (cTable)->(FieldPos(cField) > 0) .and. (ValType(xValue) != "U")
        (cTable)->&cField := xValue
      endIf	
    next nI		
    (cTable)->(MsUnlock())	
    nRecno := (cTable)->(Recno()) 
    lOk    := .T.
  endIf
  
  RestArea(aArea)	
    
return lOk	


/*/{Protheus.doc} insertInto

Inclusao de um registro em uma tabela em formato SQL

@author soulsys:victorhugo
@since 19/11/2021
/*/	
method insertInto(cTable, aData) class LibSqlObj

  local nI         := 0
  local cQuery     := ""
  local cField     := ""
  local cFields    := ""
  local cValues    := ""
  local cValType   := ""
  local cFuncToken := "%FUNC%"
  local xValue     := nil
  local oUtils     := LibUtilsObj():newLibUtilsObj()

  for nI := 1 to Len(aData)

    cField   := aData[nI, 1]
    xValue   := aData[nI, 2]
    cValType := ValType(xValue)

    if (cValType == "C")
      if (At(cFuncToken, xValue) > 0)
        xValue := StrTran(xValue, cFuncToken, "")
      else
        xValue := "'" + AllTrim(xValue) + "'"
      endIf
    else
      xValue := oUtils:strAnyType(xValue)
    endIf

    if !Empty(cFields)
      cFields += ","
    endIf

    if !Empty(cValues)
      cValues += ","
    endIf

    cFields += AllTrim(cField)
    cValues += xValue

  next nI

  cQuery := " INSERT INTO " + cTable + " (" + cFields + ") "
  cQuery += " VALUES (" + cValues + ") "

return ::execute(cQuery)


/*/{Protheus.doc} save

Salva um registro

@author soulsys:victorhugo
@since 18/09/2021
/*/	
method save(cTable, aData, nRecno) class LibSqlObj

  local lOk 		 := .F.
  local lCreate  := .T.
  local nI  		 := 0
  local cField	 := ""
  local xValue   := nil	
  local aArea		 := GetArea()
  default nRecno := 0

  if ValType(nRecno) == "C"
    nRecno := Val(nRecno)
  endIf
  
  dbSelectArea(cTable) 

  if (nRecno > 0)
    lCreate := .F.
    (cTable)->(dbGoTo(nRecno))    
  endIf
  
  if (cTable)->(RecLock(cTable, lCreate))
    for nI := 1 to Len(aData)
      cField := aData[nI,1]
      xValue := aData[nI,2]
      if (cTable)->(FieldPos(cField) > 0) .and. (ValType(xValue) != "U")
        (cTable)->&cField := xValue
      endIf	
    next nI		
    (cTable)->(MsUnlock())	
    nRecno := (cTable)->(Recno()) 
    lOk    := .T.
  endIf
  
  RestArea(aArea)	

return lOk


/*/{Protheus.doc} delete

Deleta registros de uma tabela. (ex.: oSql:delete("ZZ1", "%ZZ1.XFILIAL% AND ZZ1_DOC = '"+cDoc+"'"))

@author soulsys:victorhugo
@since 18/09/2021
/*/
method delete(cTable, cWhere, lClear) class LibSqlObj
  
  local lOk	     := .F.
  local oSql	   := LibSqlObj():newLibSqlObj()
  default lClear := .F.
  
  if lClear
    lOk := ::execute("DELETE FROM "+RetSqlName(cTable)+" WHERE "+cWhere+" AND D_E_L_E_T_ = ' ' ", cTable)
  else
    oSql:newTable(cTable, "R_E_C_N_O_ NUMREC", cWhere)
    while oSql:notIsEof()
      (cTable)->(dbGoTo(oSql:getValue("NUMREC")))
      (cTable)->(RecLock(cTable, .F.))
        (cTable)->(dbDelete())
      (cTable)->(MsUnlock())
      oSql:skip()
      lOk := .T.
    endDo
    oSql:close()
  endIf
  
return lOk


/*/{Protheus.doc} exists

Verifica se existem registros ativos em uma tabela (ex.: oSql:exists("SB1", "B1_COD = '"+cProduto+"'"))

@author soulsys:victorhugo
@since 18/09/2021
/*/	
method exists(cTable, cWhere) class LibSqlObj
  
  local oSql   := LibSqlObj():newLibSqlObj()
  local cQuery := "SELECT 1 FROM %"+cTable+".SQLNAME% WHERE "+cWhere+" AND %"+cTable+".NOTDEL% "	
  
  ::cLastQuery := cQuery
  
  oSql:newAlias(cQuery)
  
  lExists := oSql:hasRecords()
  
  oSql:close()
  
return lExists


/*/{Protheus.doc} parseQuery

Realiza o parser de uma Query

@author soulsys:victorhugo
@since 18/09/2021
/*/
method parseQuery(cQuery) class LibSqlObj
  
  local nI			   := 0
  local nPos			 := 0  
  local nSizeAlias := 3
  local cAlias		 := ""
  local cSavQuery	 := AllTrim(cQuery)		
  local aCmds			 := {"SQLNAME%","FILIAL%","XFILIAL%","NOTDEL%"} 
  
  cQuery := cSavQuery	
  
  for nI := 1 to Len(aCmds)
    
    cCmd := aCmds[nI]	
    
    while ((nPos := At("."+cCmd, cQuery)) > 0)    
      
      cAlias := SubStr(cQuery, nPos-nSizeAlias, nSizeAlias)
      
      if Empty(RetSqlName(cAlias))
        setLastError(@self, "parseQuery", "Falha ao interpretar Query: "+cSavQuery) 
        return cSavQuery
      endIf
      
      cFind := "%"+cAlias+"."+cCmd
      
      if ("SQLNAME" $ cCmd) 
        cReplace:= RetSqlName(cAlias)+" "+cAlias 
      elseIf ("FILIAL" == Left(cCmd, 6)) 
        cReplace:= xFilial(cAlias)
      elseIf ("XFILIAL" $ cCmd) 
        cReplace:= PrefixoCpo(cAlias)+"_FILIAL = '"+xFilial(cAlias)+"'"
      elseIf ("NOTDEL" $ cCmd)
        cReplace := cAlias+".D_E_L_E_T_ = ' ' "
      endIf
      
      cQuery := StrTran(cQuery, cFind, cReplace)
      
    endDo
    
  next nI		
  
return cQuery


/*/{Protheus.doc} exportToCsv

Exporta o conteudo do alias para um arquivo CSV

@author soulsys:victorhugo
@since 18/09/2021
/*/	
method exportToCsv(cFile, lShowProgress, cDelimiter) class LibSqlObj
  
  local nRecs			      := 0
  local nRecAtu		      := 0
  local lOk 			      := .F.
  local oFile			      := LibFileObj():newLibFileObj(cFile)
  default lShowProgress := .F.
  default cDelimiter    := ";"
  
  if !::aliasExists()
    return .F.
  endIf
  
  if (oFile:exists() .and. !oFile:delete())
    return .F.
  endIf
  
  if !oFile:writeLine(getCsvFields(self, cDelimiter))
    return .F.
  endIf
  
  if lShowProgress
    nRecs := ::count()
    ProcRegua(nRecs)
  endIf
  
  ::goTop()
  while ::notIsEof()		
    if !oFile:writeLine(getCsvLine(self, cDelimiter))
      return .F.		
    endIf			
    ::skip()
    if lShowProgress
      IncProc("Gravando CSV [registro "+AllTrim(Str(++nRecAtu))+" de "+AllTrim(Str(nRecs))+"] ...") 
    endIf
  endDo
  
  lOk := oFile:exists()
  
return lOk

/**
 * Coleta os campos do arquivo CSV
 */
static function getCsvFields(oObj, cDelimiter)
  
  local nI		  := 0		
  local cFields	:= ""
  local cAlias	:= oObj:getAlias()				
  local aStruct	:= (cAlias)->(dbStruct())	
    
  For nI := 1 To Len(aStruct)		
    cFields += if(!Empty(cFields), cDelimiter, "") + AllTrim(aStruct[nI,1])
  Next nI	
  
return cFields

/**
 * Coleta uma linha do arquivo CSV
 */
static function getCsvLine(oObj, cDelimiter)
  
  local nI		  := 0		
  local xValue	:= nil	
  local cField	:= ""
  local cType		:= ""     
  local cLine		:= ""
  local cStrVal	:= ""
  local cAlias	:= oObj:getAlias()				
  local aStruct	:= (cAlias)->(dbStruct())	
    
  for nI := 1 to Len(aStruct)
    
    cField := aStruct[nI,1]
    cType  := aStruct[nI,2]
    xValue := (cAlias)->&cField
    
    if (cType == "N") 
      cStrVal := AllTrim(Str(xValue))		
    elseIf (cType == "D")
      cStrVal := DtoC(xValue)		
    else
      cStrVal := AllTrim(xValue)
    endIf		 
    
    cStrVal := StrTran(cStrVal, cDelimiter, " ") 		
    cLine   += if(!Empty(cLine), cDelimiter, "") + cStrVal
      
  next nI	
    
return cLine


/*/{Protheus.doc} showReport

Exibe o conteudo de uma consulta SQL atrav�s da classe TReport

@author soulsys:victorhugo
@since 18/09/2021
/*/
method showReport(cName, cTitle, cDescription) class LibSqlObj

  local oReport		     := nil
  local cParams		     := "" 
   default cName  		   := "LibSqlObj:showReport"
   default cTitle 		   := "impressao de Consulta SQL"
   default cDescription := cTitle
  
  oReport := TReport():new(cName, cTitle, cParams, { || procReport(@self, @oReport) }, cDescription)
  oReport:printDialog()
  
return

/**
 * Processa o relatorio
 */
static function procReport(oSelf, oReport)
  
  local oSection := TRSection():new(oReport)
  
  createSection(@oSelf, @oSection)
  
  oReport:setMeter(oSelf:count())
  
  oSection:init()
  
  oSelf:goTop()
  while oSelf:notIsEof()		
    oReport:incMeter()
    oSection:printLine()		
    oSelf:skip()
  endDo                    	
  oSelf:goTop()
  
  oSection:finish()
  
return

/**
 * Criacao das secoes do relatorio
 */
static function createSection(oSelf, oSection)

    local nI         := 0
    local nScan      := 0
    local nSize      := 0
    local cId        := ""
    local cTitle     := ""
    local cPicture   := ""
    local cAlias     := oSelf:getAlias()
    local aStruct    := (cAlias)->(dbStruct())
    local cAliasSX3  := GetNextAlias()
     
    (cAliasSX3)->(dbSetOrder(2))
     
    for nI := 1 to Len(aStruct)

      cId    := aStruct[nI,1]
      nScan  := aScan(oSelf:aReportCells, {|x| x[1] == cId })
        
      if (nScan > 0)

        cTitle   := oSelf:aReportCells[nScan,2]
        cPicture := oSelf:aReportCells[nScan,3]
        nSize    := oSelf:aReportCells[nScan,4]
        
      else

        OpenSXs(,,,,cEmpAnt,cAliasSX3,"SX3",,.F.)  
        
        if (Select(cAliasSX3) > 0)
          dbSelectArea(cAliasSX3)
          (cAliasSX3)->(dbSetOrder(2))
          if (cAliasSX3)->(dbSeek(cId) .and. AllTrim(Upper(cId)) == Upper(AllTrim(&("X3_CAMPO"))))
            cTitle   := (cAliasSX3)->&("X3_TITULO")
            cPicture := (cAliasSX3)->&("X3_PICTURE")
            nSize    := (cAliasSX3)->&("X3_TAMANHO")
          else
            cTitle   := cId
            cPicture := ""
            nSize    := nil        
          endIf
        endIf

      endIf

      TRCell():new(oSection, cId, cAlias, cTitle, cPicture, nSize)
    
    next nI
     
return

/*/{Protheus.doc} setReportCellProperty

Define propriedades das celulas para geracao de relatorio de Consultas

@author soulsys:victorhugo
@since 18/09/2021
/*/
method setReportCellProperty(cId, cTitle, cPicture, nSize) class LibSqlObj
   
  local nScan := aScan(::aReportCells, {|x| x[1] == cId })
   
   if (nScan == 0)
     aAdd(::aReportCells, Array(4))
     nScan := Len(::aReportCells)
   endIf
   
   ::aReportCells[nScan,1] := cId
   ::aReportCells[nScan,2] := cTitle
   ::aReportCells[nScan,3] := cPicture
  ::aReportCells[nScan,4] := nSize
   
return


/*/{Protheus.doc} saveQuery

Salva uma query em arquivo texto
  
@author soulsys:victorhugo
@since 18/09/2021
/*/
method saveQuery(cFile, cQuery) class LibSqlObj
  
  local lOk		   := .F.
  local oFile 	 := LibFileObj():newLibFileObj(cFile)
  default cQuery := ::getLastQuery()
  
  cQuery := ::parseQuery(cQuery)
  
  if oFile:exists()
    oFile:delete()
  endIf	
  
  lOk	:= oFile:writeLine(cQuery)
  
  oFile:close()
  
return lOk


/*/{Protheus.doc} getFieldValue

Coleta o valor de um campo em um Alias
  
@author soulsys:victorhugo
@since 18/09/2021
/*/
method getFieldValue(cAlias, cField, cWhere) class LibSqlObj
  
  local xValue := nil
  local oSql   := LibSqlObj():newLibSqlObj()
  
  oSql:newTable(cAlias, cField, cWhere)
  
  xValue := oSql:getValue(cField)
  
  oSql:close()
  
return xValue



/*/{Protheus.doc} setErpConnection

Define a conexao do Objeto com o Banco de Dados do Protheus
  
@author soulsys:victorhugo
@since 18/09/2021
/*/
method setErpConnection() class LibSqlObj
  
  if ::hasExternalConnection()
    TcUnlink(::nExternalConnection)
    ::nExternalConnection := -1
  endIf
  
  TcSetConn(::nErpConnection)
  
return


/*/{Protheus.doc} setExternalConnection

Define a conexao do Objeto com um Banco de Dados Externo
  
@author soulsys:victorhugo
@since 18/09/2021
/*/
method setExternalConnection(cDriver, cDataBase, cServer, nPort) class LibSqlObj
  
  local lOk		    := .F.
  local cError	  := ""
  default cServer := "127.0.0.1"
  default nPort	  := 7890
  
  begin sequence
    
    if Empty(cDataBase)
      cError := "Configuracao do BD Externo nao definida"
      break
    endIf
    
    if ::hasExternalConnection()
      cError := "Objeto ja conectado a um BD Externo"
      break
    endIf
    
    TcConType("TCPIP")
    ::nExternalConnection := TcLink(Upper(AllTrim(cDriver))+"/"+cDatabase, cServer, nPort)
    
    if ::hasExternalConnection()
      TcSetConn(::nExternalConnection)
    else
      cError := "Falha na conexao com Banco de Dados Externo: "+cDataBase+", "+cServer+", "+AllTrim(Str(nPort))+CRLF
      cError += "Erro do DBAccess: "+AllTrim(Str(::nExternalConnection))
      break				
    endIf
    
    lOk := .T.
    
  end sequence
  
  if !Empty(cError)
    setLastError(@self, "setExternalConnection", cError)
  endIf	
  
return lOk


/*/{Protheus.doc} hasExternalConnection

Indica se existe conexao ativa com Banco de Dados Externo
  
@author soulsys:victorhugo
@since 18/09/2021
/*/
method hasExternalConnection() class LibSqlObj
return (::nExternalConnection > 0)


/**
 * Define as Mensagens de Erro do Objeto
 */
static function setLastError(oSelf, cMethod, cError)

  local oLog := LibLogObj():newLibLogObj(nil, .T., .F.)
  
  oSelf:cLastError := "[ LibSqlObj - ERRO - "+DtoC(Date())+" - "+Time()+" - "+AllTrim(cMethod)+"() ] "
  oSelf:cLastError += cError
  
  oLog:warn(oSelf:cLastError)
  
return


/*/{Protheus.doc} isNullExp

Retorna a expressao SQL para campos nulos
  
@author soulsys:victorhugo
@since 18/09/2021
 /*/
method isNullExp(cField, cAlias, cDefaultValue) class LibSqlObj
  
  local cExp 				    := ""
  default cDefaultValue	:= "' '" 
  default cAlias			  := cField

  cExp := "CASE WHEN "+cField+" IS NULL THEN "+cDefaultValue+" ELSE "+cField+" END "+cAlias 

return cExp


/*/{Protheus.doc} isSqlServer

Verifica se o Banco de Dados em uso eh o SQL Server
  
@author soulsys:victorhugo
@since 18/09/2021
/*/
method isSqlServer() class LibSqlObj
return ("MSSQL" $ Upper(AllTrim(TcGetDB())))


/*/{Protheus.doc} isOracle

Verifica se o Banco de Dados em uso eh o Oracle
  
@author soulsys:victorhugo
@since 18/09/2021
/*/
method isOracle() class LibSqlObj
return ("ORACLE" $ Upper(AllTrim(TcGetDB())))


/*/{Protheus.doc} getNextTableCode

Coleta o proximo codigo Sequencial de um campo de uma Tabela
  
@author soulsys:victorhugo
@since 18/09/2021
/*/
method getNextTableCode(cAlias, cField, cWhere) class LibSqlObj
  
  local cQuery   	 	   := ""
  local cMaxCode 		   := ""
  local cNextCode 	   := ""
  local cMacroLenField := "Len(" + AllTrim(cAlias) + "->" + AllTrim(cField) + ")"
  local nMaxCode 		   := 0
  local nLenField		   := &cMacroLenField
  local oSql     		   := LibSqlObj():newLibSqlObj()
  default cWhere		   := "" 
  
  cQuery := " SELECT MAX("+cField+") MAXCODE FROM %"+cAlias+".SQLNAME% "
  
  if Empty(cWhere)
    cQuery += " WHERE %"+cAlias+".XFILIAL% AND %"+cAlias+".NOTDEL% "
  else
    cQuery += " WHERE "+cWhere
  endIf 
  
  oSql:newAlias(cQuery)
  
  cMaxCode := oSql:getValue("MAXCODE")
  
  oSql:close()
  
  if Empty(cMaxCode)
    cNextCode := StrZero(1, nLenField)
  else
    nMaxCode := Val(cMaxCode)
    if (nMaxCode > 0)
      cNextCode := StrZero(nMaxCode + 1, nLenField)
    else
      cNextCode := Soma1(cMaxCode) 
    endIf
  endIf	
  
return cNextCode


/*/{Protheus.doc} refreshTable

Atualiza uma tabela no DBAccess
  
@author soulsys:victorhugo
@since 18/09/2021
/*/
method refreshTable(cTable) class LibSqlObj	
  TcRefresh(RetSqlName(cTable))
return


/*/{Protheus.doc} getInExp

Retorna a expressao IN a partir de um vetor de strings
  
@author soulsys:victorhugo
@since 18/09/2021
/*/
method getInExp(aStrs) class LibSqlObj
  
  local nI     := 0
  local cInExp := ""
  
  if Empty(aStrs)
    return ""
  endIf
  
  for nI := 1 to Len(aStrs)
    if !Empty(cInExp)
      cInExp += ","
    endIf
    cInExp += "'" + aStrs[nI] + "'"
  next nI

return cInExp


/*/{Protheus.doc} debugQuery

Exibe uma query no console
  
@author soulsys:victorhugo
@since 18/09/2021
/*/
method debugQuery(cQuery) class LibSqlObj

  local oLog := LibLogObj():newLibLogObj(nil, .T., .F.)
  
  oLog:info(CRLF + CRLF + ::parseQuery(cQuery) + CRLF + CRLF)

return


/*/{Protheus.doc} getSx5Value

Retorna um valor do SX5
  
@author soulsys:victorhugo
@since 18/09/2021
/*/
method getSx5Value(cTable, cKey) class LibSqlObj

  local cWhere := " %SX5.XFILIAL% AND X5_TABELA = '" + cTable + "' AND X5_CHAVE = '" + cKey + "' "

return ::getFieldValue("SX5", "X5_DESCRI", cWhere)
