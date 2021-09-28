#include "totvs.ch"
#include "tcbrowse.ch"
#include "rwmake.ch"

#define HEADER_TITLE		  1 
#define HEADER_FIELD		  2
#define HEADER_PICTURE	  3
#define HEADER_SIZE			  4
#define HEADER_DECIMALS	  5
#define HEADER_VALID		  6
#define HEADER_USED			  7 
#define HEADER_TYPE			  8
#define HEADER_F3			    9
#define HEADER_CONTEXT	  10
#define HEADER_CBOX			  11
#define HEADER_RELATION	  12
#define HEADER_INIBRW		  13
#define HEADER_BROWSE		  14
#define HEADER_VISUAL		  15
#define HEADER_COLUMNS	  15

#define BMP_MARK			  "LBOK"
#define BMP_UNMARK			"LBNO"

#define DEFAULT_LINE_POS	if(::isCreated(), ::oGrid:nAt, Len(::aLines))
#define DELETED_COL_POS		if(Len(::aColumns) > 0, Len(::aColumns)+1, 0)


/*/{Protheus.doc} LibGridObj

Objeto para manipulacao de Grids

@author soulsys:victorhugo
@since 18/09/2021
/*/
class LibGridObj from LibAdvplObj

  data nCol
  data nRow
  data nWidth
  data nHeight
  data oWnd
  data oGrid
  data aColumns
  data aLines
  data aOldLines
  data bOnChange
  data bOnMark
  data bOnMarkAll
  data lReadOnly
  data nAccessMode
  data cLinesValidation
  data cDeleteValidation
  data lMarkOne
  data lFiltered
  data lFreeze
  data lCreated
  data aUpdateFields
  data cMarkImage
  data cUnMarkImage
  
  method newLibGridObj() constructor

  method getCol()
  method setCol()
  method getRow()
  method setRow()
  method getWidth()
  method setWidth()
  method getHeight()
  method setHeight()
  method getWnd()
  method setWnd()
  method getGrid()
  method getColumns()
  method getLines()
  method getOnChange()
  method setOnChange()
  method getOnMark()
  method setOnMark()
  method getOnMarkAll()
  method setOnMarkAll()
  method isReadOnly()
  method setReadOnly()
  method getAccessMode()
  method setAccessMode()
  method getLinesValidation()
  method setLinesValidation()
  method getDeleteValidation()
  method setDeleteValidation()
  method isMarkOne()
  method setMarkOne()
  method isFiltered()
  method setFiltered()
  method isFreeze()
  method setFreeze()
  method isCreated()	  
  method getUpdateFields()	
  method setUpdateFields()
  method setMarkImage()
  method getMarkImage()
  method setUnMarkImage()
  method getUnMarkImage()

  method addColumn()
  method addSqlColumns()
  method getColumn()
  method addMarkColumn()
  method addBmpColumn()
  method getColumnPosition()
  method getMarkColumnPosition()
  method newLine()
  method removeLine()
  method setValue()
  method getValue()
  method create()
  method clear()
  method markAll()
  method hasMarkColumn()
  method setMarkedLine()
  method isMarkedLine()
  method hasMarkedLines()
  method setDeletedLine()
  method isDeletedLine()
  method isValidLine()
  method setBmpValue()
  method refresh()
  method length()
  method filter()
  method clearFilter()
  method getCursorLine()
  method recordValues()
  method chkRequiredFields()

endClass


/*/{Protheus.doc} newLibGridObj

Construtor

@author soulsys:victorhugo
@since 18/09/2021
/*/
method newLibGridObj(nCol, nRow, nWidth, nHeight, oWnd) class LibGridObj

  default nCol 	  := 0
  default nRow 	  := 0
  default nWidth	:= 0
  default nHeight	:= 0
  default oWnd	  := oMainWnd

  ::newLibAdvplObj()

  ::aColumns	:= {}
  ::aLines	  := {}
  ::aOldLines	:= {}
  ::oGrid		  := nil
  ::lCreated	:= .F.

  ::setCol(nCol)
  ::setRow(nRow)
  ::setWidth(nWidth)
  ::setHeight(nHeight)
  ::setWnd(oWnd)
  ::setOnChange({|| Sleep(0) })
  ::setOnMark({|| Sleep(0) })
  ::setOnMarkAll({|| Sleep(0) })
  ::setReadOnly(.F.)
  ::setAccessMode("insert", "delete", "update")
  ::setLinesValidation("AllwaysTrue()")
  ::setDeleteValidation("AllwaysTrue()")
  ::setMarkOne(.F.)
  ::setFiltered(.F.)
  ::setFreeze(.F.)	
  ::setUpdateFields()
  ::setMarkImage(BMP_MARK)
  ::setUnMarkImage(BMP_UNMARK)

return


/*/{Protheus.doc} getCol

Coleta a coluna do objeto

@author soulsys:victorhugo
@since 18/09/2021
/*/
method getCol() class LibGridObj
return ::nCol


/*/{Protheus.doc} setCol

Define a coluna do objeto

@author soulsys:victorhugo
@since 18/09/2021
/*/
method setCol(nCol) class LibGridObj
  ::nCol := nCol
return


/*/{Protheus.doc} getRow

Coleta a linha do objeto

@author soulsys:victorhugo
@since 18/09/2021
/*/
method getRow() class LibGridObj
return ::nRow


/*/{Protheus.doc} setRow

Define a linha do objeto

@author soulsys:victorhugo
@since 18/09/2021
/*/
method setRow(nRow) class LibGridObj
  ::nRow := nRow
return


/*/{Protheus.doc} getWidth

Coleta a largura do objeto

@author soulsys:victorhugo
@since 18/09/2021
/*/
method getWidth() class LibGridObj
return ::nWidth


/*/{Protheus.doc} setWidth

Define a largura do objeto

@author soulsys:victorhugo
@since 18/09/2021
/*/
method setWidth(nWidth) class LibGridObj
  ::nWidth := nWidth
return


/*/{Protheus.doc} getHeight

Coleta a altura do objeto

@author soulsys:victorhugo
@since 18/09/2021
/*/
method getHeight() class LibGridObj
return ::nHeight


/*/{Protheus.doc} setHeight

Define a altura do objeto

@author soulsys:victorhugo
@since 18/09/2021
/*/
method setHeight(nHeight) class LibGridObj
  ::nHeight := nHeight
return


/*/{Protheus.doc} getWnd

Coleta o objeto pai do grid

@author soulsys:victorhugo
@since 18/09/2021
/*/
method getWnd() class LibGridObj
return ::oWnd


/*/{Protheus.doc} setWnd

Define o objeto pai do grid

@author soulsys:victorhugo
@since 18/09/2021
/*/
method setWnd(oWnd) class LibGridObj
  ::oWnd := oWnd
return


/*/{Protheus.doc} getGrid

Coleta o objeto de grid

@author soulsys:victorhugo
@since 18/09/2021
/*/
method getGrid() class LibGridObj
return ::oGrid


/*/{Protheus.doc} getColumns

Coleta o array de colunas

@author soulsys:victorhugo
@since 18/09/2021
/*/
method getColumns() class LibGridObj
return ::aColumns


/*/{Protheus.doc} getLines

Coleta o array de linhas

@author soulsys:victorhugo
@since 18/09/2021
/*/
method getLines() class LibGridObj
return ::aLines


/*/{Protheus.doc} getOnMark

Coleta o bloco de codigo a ser executado quando um registro for marcado

@author soulsys:victorhugo
@since 18/09/2021
/*/
method getOnMark() class LibGridObj
return ::bOnMark


/*/{Protheus.doc} setOnChange

Define o bloco de codigo a ser executado quando o grid sofrer alteracoes

@author soulsys:victorhugo
@since 18/09/2021
/*/
method setOnChange(bOnChange) class LibGridObj
  ::bOnChange := bOnChange
return


/*/{Protheus.doc} getOnChange

Coleta o bloco de codigo a ser executado quando o grid sofrer alteracoes

@author soulsys:victorhugo
@since 18/09/2021
/*/
method getOnChange() class LibGridObj
return ::bOnChange


/*/{Protheus.doc} setOnMark

Define o bloco de codigo a ser executado quando um registro for marcado

@author soulsys:victorhugo
@since 18/09/2021
/*/
method setOnMark(bOnMark) class LibGridObj
  ::bOnMark := bOnMark
return


/*/{Protheus.doc} getOnMarkAll

Coleta o bloco de codigo a ser executado quando todos os registros forem marcados

@author soulsys:victorhugo
@since 18/09/2021
/*/
method getOnMarkAll() class LibGridObj
return ::bOnMarkAll


/*/{Protheus.doc} setOnMarkAll

Define o bloco de codigo a ser executado quando todos os registros forem marcados

@author soulsys:victorhugo
@since 18/09/2021
/*/
method setOnMarkAll(bOnMarkAll) class LibGridObj
  ::bOnMarkAll := bOnMarkAll
return


/*/{Protheus.doc} isReadOnly

Indica se o grid eh somente visualizacao

@author soulsys:victorhugo
@since 18/09/2021
/*/
method isReadOnly() class LibGridObj
return ::lReadOnly


/*/{Protheus.doc} setReadOnly

Define se o grid eh somente visualizacao

@author soulsys:victorhugo
@since 18/09/2021
/*/
method setReadOnly(lReadOnly) class LibGridObj
  ::lReadOnly := lReadOnly
  if lReadOnly
    ::nAccessMode := 0
  endIf
return


/*/{Protheus.doc} getAccessMode

Coleta o modo de acesso ao grid

@author soulsys:victorhugo
@since 18/09/2021
/*/
method getAccessMode() class LibGridObj
return ::nAccessMode


/*/{Protheus.doc} setAccessMode

Define o modo de acesso ao grid.
Exemplo para todos os acessos: oGrid:setAccessMode("insert", "delete", "update")
Exemplo para nao permitir inclusao: oGrid:setAccessMode("delete", "update")

@author soulsys:victorhugo
@since 18/09/2021
/*/
method setAccessMode(cMode1, cMode2, cMode3) class LibGridObj

  default cMode1 := ""
  default cMode2 := ""
  default cMode3 := ""

  ::nAccessMode := 0

  setGdAccessMode(cMode1, @self)
  setGdAccessMode(cMode2, @self)
  setGdAccessMode(cMode3, @self)

return

/**
 * Define o modo de acesso de acordo com as constantes do MsNewGetDados
 */
static function setGdAccessMode(cMode, oGrid)

  cMode := Lower(AllTrim(cMode))

  if (cMode == "insert")
    oGrid:nAccessMode += GD_INSERT
  elseIf (cMode == "delete")
    oGrid:nAccessMode += GD_DELETE
  elseIf (cMode == "update")
    oGrid:nAccessMode += GD_UPDATE
  endIf

return


/*/{Protheus.doc} getLinesValidation

Coleta a validacao ao trocar de linhas

@author soulsys:victorhugo
@since 18/09/2021
/*/
method getLinesValidation() class LibGridObj
return ::cLinesValidation


/*/{Protheus.doc} setLinesValidation

Define a validacao ao trocar de linhas

@author soulsys:victorhugo
@since 18/09/2021
/*/
method setLinesValidation(cLinesValidation) class LibGridObj
  ::cLinesValidation := cLinesValidation
return


/*/{Protheus.doc} getDeleteValidation

Coleta a validacao ao deletar linhas

@author soulsys:victorhugo
@since 18/09/2021
/*/
method getDeleteValidation() class LibGridObj
return ::cDeleteValidation


/*/{Protheus.doc} setDeleteValidation

Define a validacao ao deletar linhas

@author soulsys:victorhugo
@since 18/09/2021
/*/
method setDeleteValidation(cDeleteValidation) class LibGridObj
  ::cDeleteValidation := cDeleteValidation
return


/*/{Protheus.doc} isMarkOne

Indica se Marca somente um registro do grid

@author soulsys:victorhugo
@since 18/09/2021
/*/
method isMarkOne() class LibGridObj
return ::lMarkOne


/*/{Protheus.doc} setMarkOne

Define se Marca somente um registro do grid

@author soulsys:victorhugo
@since 18/09/2021
/*/
method setMarkOne(lMarkOne) class LibGridObj
  ::lMarkOne := lMarkOne
return


/*/{Protheus.doc} isFiltered

Indica se o Grid esta filtrado

@author soulsys:victorhugo
@since 18/09/2021
/*/
method isFiltered() class LibGridObj
return ::lFiltered


/*/{Protheus.doc} setFiltered

Define se o Grid esta filtrado

@author soulsys:victorhugo
@since 18/09/2021
/*/
method setFiltered(lFiltered) class LibGridObj
  ::lFiltered := lFiltered
return


/*/{Protheus.doc} isCreated

Indica se o Grid foi criado

@author soulsys:victorhugo
@since 18/09/2021
/*/
method isCreated() class LibGridObj
return ::lCreated


/*/{Protheus.doc} getUpdateFields

Retorna Array com os Campos que podem ser Alterados na Grid, quando Grid com opcao de alteracao

@author soulsys:victorhugo
@since 18/09/2021
/*/
method getUpdateFields() class LibGridObj
return (::aUpdateFields)


/*/{Protheus.doc} setUpdateFields

Define Array com os Campos que podem ser Alterados na Grid, quando Grid com opcao de alteracao

@author soulsys:victorhugo
@since 18/09/2021
/*/
method setUpdateFields(aUpdateFields) class LibGridObj

  default aUpdateFields := Nil
  
  ::aUpdateFields := aUpdateFields
  
  setPropertyReadOnly(self)

return
      

/*/{Protheus.doc} getMarkImage

Recupera o Nome do Recurso de Imagem para representacao da Coluna Mark Marcada

@author soulsys:victorhugo
@since 18/09/2021
/*/
method getMarkImage() class LibGridObj
return (::cMarkImage)
             

/*/{Protheus.doc} setMarkImage

Define o Nome do Recurso de Imagem para representacao da Coluna Mark Marcada

@author soulsys:victorhugo
@since 18/09/2021
/*/
method setMarkImage(cMarkImage) class LibGridObj
  default cMarkImage := BMP_MARK 
  ::cMarkImage := cMarkImage
return


/*/{Protheus.doc} getUnMarkImage

Recupera o Nome do Recurso de Imagem para representacao da Coluna Mark Desmarcada

@author soulsys:victorhugo
@since 18/09/2021
/*/
method getUnMarkImage() class LibGridObj
return (::cUnMarkImage)


/*/{Protheus.doc} setUnMarkImage

Define o Nome do Recurso de Imagem para representacao da Coluna Mark Desmarcada

@author soulsys:victorhugo
@since 18/09/2021
/*/
method setUnMarkImage(cUnMarkImage) class LibGridObj
  default cUnMarkImage := BMP_UNMARK
  ::cUnMarkImage := cUnMarkImage
return


/*/{Protheus.doc} isFreeze

Indica se Congela a primeira coluna

@author soulsys:victorhugo
@since 18/09/2021
/*/
method isFreeze() class LibGridObj
return ::lFreeze


/*/{Protheus.doc} setFreeze

Define se Congela a primeira coluna

@author soulsys:victorhugo
@since 18/09/2021
/*/
method setFreeze(lFreeze) class LibGridObj
  ::lFreeze := lFreeze
return


/*/{Protheus.doc} addColumn

Adiciona uma coluna do browse. Pode receber uma String com um campo contido no SX3 ou um objeto LibColumnObj.

@author soulsys:victorhugo
@since 18/09/2021
/*/
method addColumn(xColumn) class LibGridObj

  local oCol := nil

  if (ValType(xColumn) == "C")
    oCol := LibColumnObj():newLibColumnObj(xColumn)
  else
    oCol := xColumn
  endIf
  
  setPropertyReadOnly(self,oCol)

  aAdd(::aColumns, oCol)

return oCol


/*/{Protheus.doc} addSqlColumns

Adiciona colunas no browse a partir de uma query SQL

@author soulsys:victorhugo
@since 18/09/2021
/*/
method addSqlColumns(cQuery, lFill, aSetField) class LibGridObj

  local nI          := 0
  local oSql 		    := LibSqlObj():newLibSqlObj()
  default lFill	    := .T.
  default aSetField := {}

  oSql:newAlias(cQuery)

  for nI := 1 to Len(aSetField)
    oSql:setField(aSetField[nI, 1], aSetField[nI, 2])
  next nI

  createSqlColumns(@self, oSql)

  if lFill
    fillLinesFromSql(@self, oSql)
  endIf

  oSql:close()

return

/**
 * Cria as colunas a partir do objeto LibSqlObj
 */
static function createSqlColumns(oGrid, oSql)

  local nI		  := 0
  local nSize  	:= 0
  local cField	:= ""
  local cType		:= ""
  local oCol		:= nil
  local aStruct	:= oSql:getStruct()

  for nI := 1 to Len(aStruct)
    cField	:= aStruct[nI,1]
    cType	:= aStruct[nI,2]
    nSize	:= aStruct[nI,3]
    oCol 	:= LibColumnObj():newLibColumnObj(cField)
    if !oCol:isSx3()
      oCol:setTitle(Capital(cField))
      oCol:setType(cType)
      oCol:setSize(nSize)
    endIf
    oGrid:addColumn(oCol)
  next nI

return

/**
 * Preenche as linhas do grid a partir de um objeto LibSqlObj
 */
static function fillLinesFromSql(oGrid, oSql)

  local cField  := ""
  local aStruct := oSql:getStruct()
  local nI      := 0

  while !oSql:isEof()
    oGrid:newLine()
    if oGrid:hasMarkColumn()
      oGrid:setMarkedLine(.F.)
    endIf
    for nI := 1 to Len(aStruct)
      cField := aStruct[nI,1]
      oGrid:setValue(cField, oSql:getValue(cField))
    next nI
    oSql:skip()
  endDo

return


/*/{Protheus.doc} getColumn

Coleta uma coluna do grid

@author soulsys:victorhugo
@since 18/09/2021
/*/
method getColumn(cId) class LibGridObj

  local oCol := nil
  local nPos := ::getColumnPosition(cId)

  if (nPos > 0)
    oCol := ::aColumns[nPos]
  endIf

return oCol


/*/{Protheus.doc} addMarkColumn

Adiciona uma coluna de sele��o de registros

@author soulsys:victorhugo
@since 18/09/2021
/*/
method addMarkColumn(bOnMark, bOnMarkAll) class LibGridObj

  default bOnMark 	 := {|| Sleep(0) }
  default bOnMarkAll := {|| Sleep(0) }

  ::setOnMark(bOnMark)
  ::setOnMarkAll(bOnMarkAll)

  ::addColumn(LibColumnObj():newLibColumnObj("@mark"))

  checkMarkColumn(@self)

return

/**
 * Ajusta a coluna de marcacao
 */
static function checkMarkColumn(oGrid)

  local nI		   := 0
  local oMarkCol := nil
  local aNewCols := {}
  local aCols 	 := oGrid:getColumns()

  for nI := 1 to Len(aCols)
    if (aCols[nI]:isMarkColumn())
      oMarkCol := aCols[nI]
      exit
    endIf
  next nI

  if (ValType(oMarkCol) != "O")
    return
  endIf

  aAdd(aNewCols, oMarkCol)

  for nI := 1 to Len(aCols)
    if (aCols[nI]:isMarkColumn())
      loop
    endIf
    aAdd(aNewCols, aCols[nI])
  next nI

  oGrid:aColumns := aNewCols

return


/*/{Protheus.doc} addBmpColumn

Cria uma coluna tipo bitmap

@author soulsys:victorhugo
@since 18/09/2021
/*/
method addBmpColumn(cId) class LibGridObj
  ::addColumn(LibColumnObj():newLibColumnObj("@bmp", cId))
return


/*/{Protheus.doc} getColumnPosition

Coleta a posicao de uma coluna

@author soulsys:victorhugo
@since 18/09/2021
/*/
method getColumnPosition(cId) class LibGridObj

  local nI 	 := 0
  local nPos := 0

  for nI := 1 to Len(::aColumns)
    if (AllTrim(::aColumns[nI]:getId()) == AllTrim(cId))
      nPos := nI
      exit
    endIf
  next nI

return nPos


/*/{Protheus.doc} getMarkColumnPosition

Coleta a posicao de uma coluna tipo marcacao

@author soulsys:victorhugo
@since 18/09/2021
/*/
method getMarkColumnPosition() class LibGridObj

  local nI 	  := 0
  local nPos 	:= 0
  local aCols	:= ::getColumns()

  for nI := 1 to Len(aCols)
    if aCols[nI]:isMarkColumn()
      nPos := nI
      exit
    endIf
  next nI

return nPos


/*/{Protheus.doc} newLine

Adiciona uma nova linha no browse

@author soulsys:victorhugo
@since 18/09/2021
/*/
method newLine() class LibGridObj

  local nCols 	:= Len(::aColumns)
  local nPosDel	:= (nCols + 1)
  local nI      := 1

  if (nCols == 0)
    return
  endIf

  aAdd(::aLines, Array(nCols + 1))
  aTail(::aLines)[nPosDel] := .F.

  for nI := 1 to nCols
    aTail(::aLines)[nI] := ::aColumns[nI]:getEmptyValue()
  next nI

  if (ValType(::oGrid) == "O")
    ::oGrid:nAt 	:= Len(::aLines)
    ::oGrid:aCols	:= ::aLines
  endIf

return


/*/{Protheus.doc} removeLine

Remove linhas do grid

@author soulsys:victorhugo
@since 18/09/2021
/*/
method removeLine(nLine) class LibGridObj

  local nI 		    := 0
  local aNewLines	:= {}
  default nLine	  := DEFAULT_LINE_POS

  for nI := 1 to Len(::aLines)
    if (nI != nLine)
      aAdd(aNewLines, ::aLines[nI])
    endIf
  next nI

  ::aLines := aNewLines

  if (ValType(::oGrid) == "O")
    ::oGrid:aCols	:= ::aLines
  endIf	

  ::refresh()

return


/*/{Protheus.doc} setValue

Define valores para as linhas do browse

@author soulsys:victorhugo
@since 18/09/2021
/*/
method setValue(cId, xValue, nLine) class LibGridObj

  local nColPos	:= ::getColumnPosition(cId)
  default nLine	:= DEFAULT_LINE_POS

  if (nColPos > 0 .and. nLine > 0 .and. Len(::aLines) >= nLine)
    ::aLines[nLine,nColPos] := xValue
  endIf

  if (ValType(::oGrid) == "O")    
    ::oGrid:aCols	:= ::aLines
  endIf  

return


/*/{Protheus.doc} getValue

Coleta valores das linhas do browse

@author soulsys:victorhugo
@since 18/09/2021
/*/
method getValue(cId, nLine, lOldValue) class LibGridObj

  local xValue 	 	  := nil
  local cMemVar 	  := "M->"+cId
  local nColPos		  := ::getColumnPosition(cId)
  default nLine		  := DEFAULT_LINE_POS
  default lOldValue	:= .F.  

  if (nColPos > 0 .and. nLine > 0)
    if (!lOldValue .and. Type(cMemVar) != "U" .and. nLine == DEFAULT_LINE_POS)
      xValue := &cMemVar
    elseif (Len(::aLines) >= nLine)
      xValue := ::aLines[nLine,nColPos]
    endIf
  endIf

return xValue


/*/{Protheus.doc} create

Cria o objeto de grid. Deve ser invocado apos a criacao das colunas e linhas.

@author soulsys:victorhugo
@since 18/09/2021
/*/
method create() class LibGridObj

  local nI			      := 0
  local nFreeze		    := if(::isFreeze(), 1, 0)
  local nMax			    := 999
  local nOpc			    := ::getAccessMode()
  local cLinOk		    := ::getLinesValidation()
  local cDelOk		    := ::getDeleteValidation()
  local cTudoOk		    := "AllwaysTrue()"
  local cFieldOk		  := "AllwaysTrue()"
  local cIniCpos		  := nil
  local cSuperDel		  := nil
  local oCol			    := nil
  local aHeader		    := {}
  local lHasMarkCol 	:= .F.

  // Para inibir erros malucos da GetDados :(
  public A := .T.
  public V := .T.
  public N := .T.

  for nI := 1 to Len(::aColumns)
    oCol	:= ::aColumns[nI]
    fillHeader(@aHeader, oCol)
    if oCol:isMarkColumn()
      lHasMarkCol := .T.
    endIf
    If !oCol:isReadOnly()
      addUpdateField(@self,oCol:getID())
    Endif
  next nI

  if (Len(::aLines) == 0)
    ::newLine()
  endIf

  ::oGrid  := MsNewGetDados():new(::nRow, ::nCol, ::nHeight, ::nWidth, nOpc, cLinOk, cTudoOk, cIniCpos, ::aUpdateFields, nFreeze, nMax, cFieldOk, cSuperDel, cDelOk, ::oWnd, aHeader, aClone(::aLines))
  ::aLines := ::oGrid:aCols

  ::oGrid:bChange := ::getOnChange()

  if lHasMarkCol
    ::oGrid:oBrowse:blDblClick := {|| onDoubleClick(@self) }
  endIf

  ::lCreated := .T.

return


/*/{Protheus.doc} clear

Limpa todos os registros do grid

@author soulsys:victorhugo
@since 18/09/2021
/*/
method clear() class LibGridObj

  ::aLines := {}

  if (ValType(::oGrid) == "O")
    ::oGrid:aCols := {}
  endIf

  ::setFiltered(.F.)
  ::refresh()

return


/**
 * Trata o duplo click nas linhas do grid
 */
static function onDoubleClick(oObj)

  local oGrid 	 := oObj:oGrid
  local nI		   := 0
  local nAt		   := oGrid:nAt
  local nColMark := oObj:getMarkColumnPosition()
  local bOnMark	 := oObj:getOnMark()

  if (oObj:length() == 0) .or. (Len(oObj:oGrid:aCols) == 0)
    return
  endIf

  if oObj:isMarkOne()
    for nI := 1 to Len(oGrid:aCols)
      oObj:setMarkedLine(.F., nI)
    next nI
  endIf

  oGrid:editCell()
  oGrid:aCols[nAt,nColMark] := if(oGrid:aCols[nAt,nColMark] == oObj:getMarkImage(), oObj:getUnMarkImage(), oObj:getMarkImage())
  
  Eval(bOnMark)

  oObj:refresh()

return

/*/{Protheus.doc} chkRequiredFields

Valida os campos obrigatorios

@author soulsys:victorhugo
@since 18/09/2021
/*/
method chkRequiredFields() class LibGridObj

   local lOk			      := .T.
  local nI 			      := 0
  local nLine			    := ::oGrid:nAt
  local aLines 		    := ::oGrid:aCols
  local aCols			    := ::getColumns()
  local lReadOnly		  := ::isReadOnly()
  local nPosCol		    := 0
  local nPosDel		    := Len(aCols)+1
  local xEmptyValue 	:= nil
  local cEmptyFields	:= ""
    
  if (Len(aLines) == 0)
    return .T.
  endIf
                     
   if !lReadOnly    
       
    if Len(aLines) >= nLine .And. aLines[nLine,nPosDel]
      return .T.
    endif
    
    for nI := 1 to Len(aCols)
      if !aCols[nI]:isRequired()
        loop
      endIf
      xEmptyValue := aCols[nI]:getEmptyValue()
      nPosCol	   := ::getColumnPosition(aCols[nI]:getId())
      if (aLines[nLine,nPosCol] == xEmptyValue)
        if !Empty(cEmptyFields)
          cEmptyFields += ", "
        endIf
        cEmptyFields += aCols[nI]:getTitle()
      endIf
    next nI
  
    if !Empty(cEmptyFields)
      lOk := .F.
      MsgBox("Campos obrigatorios nao preenchidos: "+CRLF+CRLF+cEmptyFields, "Atencao", "ALERT")
    endIf

   endif
   
return lOk 

/**
 * Preenche o aHeader
 */
static function fillHeader(aHeader, oCol)

  aAdd(aHeader, Array(HEADER_COLUMNS))
  aTail(aHeader)[HEADER_FIELD] 	:= oCol:getId()
  aTail(aHeader)[HEADER_TITLE] 	:= oCol:getTitle()
  aTail(aHeader)[HEADER_PICTURE] 	:= oCol:getPicture()
  aTail(aHeader)[HEADER_SIZE] 	:= oCol:getSize()
  aTail(aHeader)[HEADER_TYPE] 	:= oCol:getType()
  aTail(aHeader)[HEADER_VISUAL] 	:= if(oCol:isReadOnly(), "V", "A")

  if (oCol:isMarkColumn() .or. oCol:isBmpColumn())
    aTail(aHeader)[HEADER_VISUAL] := "S"
  endIf

  aTail(aHeader)[HEADER_DECIMALS]	:= oCol:getDecimals()
  aTail(aHeader)[HEADER_VALID]	:= oCol:getValidation()
  aTail(aHeader)[HEADER_F3]		:= oCol:getF3()
  aTail(aHeader)[HEADER_CBOX]		:= oCol:getComboBox()
  aTail(aHeader)[HEADER_RELATION]	:= oCol:getInitializer()
  aTail(aHeader)[HEADER_CONTEXT]	:= oCol:getContext()
  aTail(aHeader)[HEADER_INIBRW]	:= oCol:getBrowseInitializer()
  aTail(aHeader)[HEADER_BROWSE]	:= oCol:getShowOnBrowse()
  aTail(aHeader)[HEADER_USED]		:= ""

return


/*/{Protheus.doc} markAll

Seleciona todos os registros do grid caso exista a coluna de marcacao

@author soulsys:victorhugo
@since 18/09/2021
/*/
method markAll() class LibGridObj

  local nI 		   := 0
  local nMarks	 := 0
  local nPosMark := 0
  local lMark		 := .F.

  if !::hasMarkColumn()
    return
  endIf

  nPosMark := ::getMarkColumnPosition()

  for nI := 1 to Len(::aLines)
    if ::isMarkedLine(nI)
      nMarks++
    endIf
  next nI

  lMark := (nMarks < Len(::aLines))

  for nI := 1 to Len(::aLines)
    ::setMarkedLine(lMark, nI)
  next nI

  if (ValType(::oGrid) == "O")
    ::oGrid:aCols	:= ::aLines
  endIf	

  Eval(::bOnMarkAll)

  ::refresh()

return


/*/{Protheus.doc} hasMarkColumn

Verifica se existe uma coluna de marcacao no grid

@author soulsys:victorhugo
@since 18/09/2021
/*/
method hasMarkColumn() class LibGridObj

  local nPosMark			 := ::getMarkColumnPosition()
  local lHasMarkColumn := (nPosMark > 0)

return lHasMarkColumn


/*/{Protheus.doc} setMarkedLine

Define se a linha do grid esta marcada

@author soulsys:victorhugo
@since 18/09/2021
/*/
method setMarkedLine(lMark, nLine) class LibGridObj

  local nPosMark	:= ::getMarkColumnPosition()
  local cBmp	 	  := if(lMark, ::getMarkImage(), ::getUnMarkImage())
  default nLine 	:= DEFAULT_LINE_POS

  if (nPosMark > 0 .and. nLine > 0 .and. nLine <= Len(::aLines))
    ::aLines[nLine,nPosMark] := cBmp
  endIf

return


/*/{Protheus.doc} isMarkedLine

Verifica se a linha do grid esta marcada

@author soulsys:victorhugo
@since 18/09/2021
/*/
method isMarkedLine(nLine) class LibGridObj

  local lIsMarked := .F.
  default nLine   := DEFAULT_LINE_POS

  if !::hasMarkColumn()
    return .F.
  endIf

  lIsMarked := (::aLines[nLine,::getMarkColumnPosition()] == ::getMarkImage() )

return lIsMarked


/*/{Protheus.doc} hasMarkedLines

Verifica se existe ao menos uma linha selecionada no grid
  
@author soulsys:victorhugo
@since 18/09/2021
/*/
method hasMarkedLines(lDeleted) class LibGridObj
  
  local nLine			      := 0
  local lHasMarkedLines := .F.
  default lDeleted	    := .F.
  
  for nLine := 1 to ::length()
    if ::isMarkedLine(nLine)
      lHasMarkedLines := .T.	
      if ::isDeletedLine(nLine) .and. !lDeleted
        lHasMarkedLines := .F.
      endIf
    endIf 
    if lHasMarkedLines
      exit
    endIf
  next nLine
  
return lHasMarkedLines


/*/{Protheus.doc} setDeletedLine

Define uma linha como deletada

@author soulsys:victorhugo
@since 18/09/2021
/*/
method setDeletedLine(lDeleted, nLine) class LibGridObj

  local nPosDel	:= DELETED_COL_POS
  default nLine	:= DEFAULT_LINE_POS

  if (nPosDel > 0 .and. Len(::aLines) > 0)
    ::aLines[nLine,nPosDel] := lDeleted
  endIf

return


/*/{Protheus.doc} isDeletedLine

Indica se a linha esta deletada

@author soulsys:victorhugo
@since 18/09/2021
/*/
method isDeletedLine(nLine) class LibGridObj

  local nPosDel	 := DELETED_COL_POS
  local lDeleted := .F.
  default nLine	 := DEFAULT_LINE_POS

  if (nPosDel > 0 .and. Len(::aLines) > 0)
    lDeleted := ::aLines[nLine,nPosDel]
  endIf

return lDeleted


/*/{Protheus.doc} isValidLine

Indica se a linha eh valida

@author soulsys:victorhugo
@since 18/09/2021
/*/
method isValidLine(nLine) class LibGridObj

  ::refresh()

return (!::isDeletedLine(nLine) .and. !lineHasEmptyRequiredFields(self, nLine))

/**
 * Verifica se uma linha possui campos obrigatorios nao preenchidos
 */
static function lineHasEmptyRequiredFields(oSelf, nLine)
  
  local nI       := 0
  local cId      := ""
  local oCol     := nil
  local xValue   := nil
  local aColumns := oSelf:getColumns()

  for nI := 1 to Len(aColumns)
    
    oCol   := aColumns[nI]
    cId    := oCol:getId()
    xValue := oSelf:getValue(cId, nLine)

    if oCol:isRequired() .and. Empty(xValue)
      return .T.
    endIf

  next nI  

return .F.


/*/{Protheus.doc} setBmpValue

Define o valor de um bitmap do grid

@author soulsys:victorhugo
@since 18/09/2021
/*/
method setBmpValue(cId, cBmp, nLine) class LibGridObj

  local nI		  := 0
  local nPosBmp	:= 0
  default nLine	:= DEFAULT_LINE_POS

  for nI := 1 to Len(::aColumns)
    if (::aColumns[nI]:isBmpColumn() .and. ::aColumns[nI]:getBmpId() == cId)
      nPosBmp := nI
      exit
    endIf
  next nI

  if (nPosBmp > 0 .and. nLine > 0 .and. nLine <= Len(::aLines))
    ::aLines[nLine,nPosBmp] := cBmp
  endIf

return


/*/{Protheus.doc} refresh

Atualizacao do grid

@author soulsys:victorhugo
@since 18/09/2021
/*/
method refresh(lForce) class LibGridObj

  default lForce := .F.

  if (ValType(::oGrid) == "O")	    
    if lForce
      ::aLines := ::oGrid:aCols
    endIf
    ::oGrid:oBrowse:refresh()
  endIf

return


/*/{Protheus.doc} length

Retorna o numero de linhas do grid

@author soulsys:victorhugo
@since 18/09/2021
/*/
method length() class LibGridObj

  ::refresh(.T.)

return Len(::aLines)


/*/{Protheus.doc} filter

Filtra o grid. Permitido somente se o grid for somente leitura ( oGrid:setReadOnly(.T.) ).

@author soulsys:victorhugo
@since 18/09/2021
/*/
method filter(cFilter, xColumns) class LibGridObj

  local nI		 	       := 0
  local aLines		     := {}
  local aFilteredLines := {}
  default xColumns 	   := ""

  if !::isReadOnly()
    MsgBox("Nao e possivel filtrar um LibGridObj editavel", "Atencao", "ALERT")
    return
  endIf

  if Empty(cFilter)
    ::clearFilter()
    return
  endIf

  if (Len(::aOldLines) == 0)
    ::aOldLines := aClone(::aLines)
  endIf

  aLines := aClone(::aOldLines)

  for nI := 1 to Len(aLines)
    if validFilter(@self, cFilter, xColumns, aLines[nI])
      aAdd(aFilteredLines, aLines[nI])
    endIf
  next nI

  ::aLines 	  	:= aClone(aFilteredLines)
  ::oGrid:aCols 	:= ::aLines

  ::setFiltered(.T.)
  ::refresh()

return

/**
 * Valida o Filtro para uma Linha do grid
 */
static function validFilter(oGrid, cFilter, xColumns, aLine)

  local nI		   := 0
  local cColId	 := ""
  local cValue	 := ""
  local aCols		 := oGrid:getColumns()
  local cColumns := getFilterColumns(xColumns)
  local oCol		 := nil
  local oUtils	 := LibUtilsObj():newLibUtilsObj()

  cFilter := Upper(AllTrim(cFilter))

  for nI := 1 to Len(aCols)
    oCol   := aCols[nI]
    cColId := oCol:getId()
    if !(oCol:isMarkColumn() .or. oCol:isBmpColumn()) .and. !Empty(cColumns) .and. !(cColId $ cColumns)
      loop
    endIf
    cValue := Upper(oUtils:strAnyType(aLine[nI]))
    if (cFilter $ cValue) .or. (cFilter == cValue)
      return .T.
    endIf
  next nI

return .F.

/**
 * Define as colunas a serem filtradas
 */
static function getFilterColumns(xColumns)

  local nI	 := 0
  local cRet := ""

  if Empty(xColumns)
    return cRet
  endIf

  if (ValType(xColumns) == "C")
    cRet := xColumns
  elseIf (ValType(xColumns) == "A")
    for nI := 1 to Len(xColumns)
      cRet += if(Empty(cRet), "", ",")
      cRet += xColumns[nI]
    next nI
  endIf

return cRet


/*/{Protheus.doc} clearFilter

Limpa o ultimo filtro aplicado

@author soulsys:victorhugo
@since 18/09/2021
/*/
method clearFilter() class LibGridObj

  if !::isFiltered()
    return
  endIf

  ::aLines 		  := aClone(::aOldLines)
  ::oGrid:aCols := ::aLines
  ::aOldLines 	:= {}

  ::setFiltered(.F.)
  ::refresh()

return


/*/{Protheus.doc} getCursorLine

Retorna a linha posicionada

@author soulsys:victorhugo
@since 18/09/2021
/*/
method getCursorLine() class LibGridObj

  local nLine := 0

  if ::isCreated()
    nLine := ::oGrid:nAt
  endIf

return nLine
                
/*    
  Atualiza a Propriedade ReadOnly das colunas conforme o Atributos aUpdateFields
*/
static function setPropertyReadOnly(oObj,oCol)
  
  local nField	:= 0  
  local cField	:= ""
  default oCol	:= Nil
  
  If ValType(oObj:aUpdateFields) == "A" .And. Len(oObj:aUpdateFields) > 0
    If ValType(oCol) == "O"
      cField := oCol:getId()
      If isUpdateField(self,cField)
        oCol:getColumn(cField):setReadOnly(.F.)
      Endif
    ElseIf oCol == Nil
      For nField:= 1 To Len(oObj:aUpdateFields)
        cField 	:= oObj:aUpdateFields[nField]
        oObj:getColumn(cField):setReadOnly(.F.)
      Next nField
    Endif
  Endif

return
        
/*
  Verifica se o Campo faz parte dos campos editaveis
*/
static function isUpdateField(oObj,cField)
  
  local nField := 0                
  local lRet	 := .F.
  
  For nField:= 1 to Len(oObj:aUpdateFields)
    If Upper(AllTrim(oObj:aUpdateFields[nField])) == Upper(AllTrim(cField))
      lRet := .T.
    Endif
  Next nField
  
return (lRet)
                                   
/*
  Atualiza o Array aUpdateFields de acordo com o Campo informado
*/
static function addUpdateField(oObj,cID)

  local nPos := 0
  
  nPos := aScan( oObj:aUpdateFields , {|Record| Upper(AllTrim(Record)) == Upper(AllTrim(cID)) } )
  If nPos == 0
    If ValType(oObj:aUpdateFields) <> "A"
      oObj:aUpdateFields := {}
    Endif
    aAdd( oObj:aUpdateFields , cID )
  Endif
  
return
