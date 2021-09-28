#include "totvs.ch"
 
 
/*/{Protheus.doc} LibColumnObj
 
Colunas do objeto LibGridObj
  
@author soulsys:victorhugo
@since 18/09/2021
/*/
class LibColumnObj from LibAdvplObj	
  
  data cId
  data cBmpId
  data cTitle
  data cType
  data nSize
  data cPicture
  data nDecimals
  data cValidation
  data cF3
  data cComboBox
  data cInitializer
  data lReadOnly	
  data cContext
  data cBrowseInitializer
  data cShowOnBrowse
  data lMarkColumn
  data lBmpColumn
  data lSx3
  data lRequired
  
  method newLibColumnObj() constructor	
  
  method getId()
  method setId()
  method getBmpId()
  method setBmpId()
  method getTitle()
  method setTitle()
  method getType()
  method setType()
  method getSize()
  method setSize()
  method getPicture()
  method setPicture()
  method getDecimals()
  method setDecimals()
  method getValidation()
  method setValidation()
  method getF3()
  method setF3()
  method getComboBox()
  method setComboBox()
  method getInitializer()
  method setInitializer()
  method isReadOnly()
  method setReadOnly()
  method getContext()
  method setContext()
  method getBrowseInitializer()
  method setBrowseInitializer()
  method getShowOnBrowse()
  method setShowOnBrowse()
  method isMarkColumn()
  method isBmpColumn()
  method isSx3()
  method isRequired()
  method setRequired()
  
  method getEmptyValue()
  
endClass


/*/{Protheus.doc} newLibColumnObj

Construtor

@author soulsys:victorhugo
@since 18/09/2021
/*/
method newLibColumnObj(cId, cTitle, cType, nSize, nDecimals, cPicture) class LibColumnObj	
  
  default cId			  := ""
  default cTitle 		:= ""
  default cType  		:= "C"
  default nSize	 	  := 10
  default nDecimals	:= 0
  default cPicture	:= ""	
  
  ::newLibAdvplObj()
  
  ::cId := cId

  ::setBmpId("")
  ::setTitle(cTitle)
  ::setType(cType)
  ::setSize(nSize)
  ::setDecimals(nDecimals)
  ::setPicture(cPicture)
  ::setValidation("")
  ::setF3("")
  ::setComboBox("")
  ::setInitializer("")
  ::setReadOnly(.F.)
  ::setContext("V")    	
  ::setBrowseInitializer("")
  ::setShowOnBrowse("S")
  ::setRequired(.F.)
  
  ::lMarkColumn	:= .F.
  ::lBmpColumn 	:= .F.
  ::lSx3			  := .F.
  
  checkMarkBmp(@self)
  checkSx3(@self)
  
return	

/**
 * Verifica se a coluna eh um mark ou bitmap
 */
static function checkMarkBmp(oCol)
  
  local cId 	:= Lower(AllTrim(oCol:getId()))
  local lMark	:= (Left(cId, 5) == "@mark")
  local lBmp	:= (Left(cId, 4) == "@bmp")
  
  if (lMark .or. lBmp)
    oCol:setId("CHECKBOL")
    oCol:setBmpId(oCol:getTitle()) 
    oCol:setTitle("")
    oCol:setPicture("@BMP")
    oCol:setSize(10)
    oCol:setType("C") 
    oCol:setContext("V")
    oCol:setBrowseInitializer(if(lMark, "mark", "legenda"))
    oCol:setShowOnBrowse("V")
    oCol:setReadOnly(.T.)
    oCol:lMarkColumn := lMark
    oCol:lBmpColumn  := lBmp		
  endIf
  
return

/**
 * Verifica se o campo existe no SX3
 */
static function checkSx3(oCol)
  
  local cId       := oCol:getId()
  local cAliasSX3 := GetNextAlias()
  
  if (Empty(cId) .or. "@" $ cId)
    return
  endIf

  OpenSXs(,,,,cEmpAnt,cAliasSX3,"SX3",,.F.)  
      
  if Select(cAliasSX3) > 0

    dbSelectArea(cAliasSX3)
    (cAliasSX3)->(dbSetOrder(2))
    
    if (cAliasSX3)->(dbSeek(cId))
      fillSx3Data(cAliasSX3, @oCol)
    endIf
    
    (cAliasSX3)->(DbCloseArea())

  endIf
  
return

/**
 * Popula as propriedades da coluna de acordo com o SX3
 */
static function fillSx3Data(cAliasSX3, oCol)

  local cValidation       := ""
  local cSystemValidation := (cAliasSX3)->&("X3_VALID")
  local cUserValidation   := (cAliasSX3)->&("X3_VLDUSER")

  if !Empty(cSystemValidation)
    cValidation := "(" + cSystemValidation + ")"
  endIf

  if !Empty(cUserValidation)
    if !Empty(cValidation)
      cValidation += " .and. "
    endIf
    cValidation += "(" + cUserValidation + ")"
  endIf

  oCol:setTitle((cAliasSX3)->&("X3_TITULO"))
  oCol:setType((cAliasSX3)->&("X3_TIPO"))
  oCol:setSize((cAliasSX3)->&("X3_TAMANHO"))
  oCol:setPicture((cAliasSX3)->&("X3_PICTURE"))
  oCol:setDecimals((cAliasSX3)->&("X3_DECIMAL"))
  oCol:setValidation(cValidation)
  oCol:setF3((cAliasSX3)->&("X3_F3"))
  oCol:setComboBox((cAliasSX3)->&("X3_CBOX"))
  oCol:setInitializer((cAliasSX3)->&("X3_RELACAO"))
  oCol:setReadOnly((cAliasSX3)->&("X3_VISUAL") == "V")    
  oCol:setRequired(X3Obrigat((cAliasSX3)->&("X3_CAMPO")))
  oCol:lSx3 := .T.

return


/*/{Protheus.doc} getId

Coleta o ID da coluna
  
@author soulsys:victorhugo
@since 18/09/2021
/*/
method getId() class LibColumnObj
return ::cId


/*/{Protheus.doc} setId

Define o ID da coluna
  
@author soulsys:victorhugo
@since 18/09/2021
/*/
method setId(cId) class LibColumnObj
  ::cId := cId
  checkMarkBmp(@self)
  checkSx3(@self)
return


/*/{Protheus.doc} getBmpId

Coleta o ID de Bitmap da coluna
  
@author soulsys:victorhugo
@since 18/09/2021

@return String ID de Bitmap
/*/
method getBmpId() class LibColumnObj
return ::cBmpId


/*/{Protheus.doc} setBmpId

Define o ID de Bitmap da coluna
  
@author soulsys:victorhugo
@since 18/09/2021

@param cId, String, ID de Bitmap
/*/
method setBmpId(cBmpId) class LibColumnObj
  ::cBmpId := cBmpId
return


/*/{Protheus.doc} getTile

Coleta o titulo da coluna
  
@author soulsys:victorhugo
@since 18/09/2021
/*/
method getTitle() class LibColumnObj
return ::cTitle


/*/{Protheus.doc} setTitle

Define o titulo da coluna
  
@author soulsys:victorhugo
@since 18/09/2021
/*/
method setTitle(cTitle) class LibColumnObj
  ::cTitle := cTitle
return


/*/{Protheus.doc} getType

Coleta o Tipo da coluna
  
@author soulsys:victorhugo
@since 18/09/2021
/*/
method getType() class LibColumnObj	
return ::cType


/*/{Protheus.doc} setType

Define o Tipo da coluna
  
@author soulsys:victorhugo
@since 18/09/2021
/*/
method setType(cType) class LibColumnObj
  ::cType := cType
return


/*/{Protheus.doc} getSize

Coleta o Tamanho da coluna
  
@author soulsys:victorhugo
@since 18/09/2021
/*/
method getSize() class LibColumnObj
return ::nSize


/*/{Protheus.doc} setSize

Define o Tamanho da coluna
  
@author soulsys:victorhugo
@since 18/09/2021
/*/
method setSize(nSize) class LibColumnObj
  ::nSize := nSize
return


/*/{Protheus.doc} getPicture

Coleta a Picture da coluna
  
@author soulsys:victorhugo
@since 18/09/2021
/*/	
method getPicture() class LibColumnObj
return ::cPicture


/*/{Protheus.doc} setPicture

Define a Picture da coluna
  
@author soulsys:victorhugo
@since 18/09/2021
/*/
method setPicture(cPicture) class LibColumnObj
  ::cPicture := cPicture
return


/*/{Protheus.doc} getDecimals

Coleta os Decimais da coluna
  
@author soulsys:victorhugo
@since 18/09/2021
/*/
method getDecimals() class LibColumnObj
return ::nDecimals


/*/{Protheus.doc} setDecimals

Define os Decimais da coluna
  
@author soulsys:victorhugo
@since 18/09/2021
/*/
method setDecimals(nDecimals) class LibColumnObj
  ::nDecimals := nDecimals
return 


/*/{Protheus.doc} getValidation

Coleta a validacao da coluna
  
@author soulsys:victorhugo
@since 18/09/2021
/*/	
method getValidation() class LibColumnObj
return ::cValidation


/*/{Protheus.doc} setValidation

Define a validacao da coluna
  
@author soulsys:victorhugo
@since 18/09/2021
/*/
method setValidation(cValidation) class LibColumnObj
  ::cValidation := cValidation
return


/*/{Protheus.doc} getF3

Coleta a consulta F3 da coluna
  
@author soulsys:victorhugo
@since 18/09/2021
/*/
method getF3() class LibColumnObj
return ::cF3


/*/{Protheus.doc} setF3

Define a Consulta F3 da coluna
  
@author soulsys:victorhugo
@since 18/09/2021
/*/
method setF3(cF3) class LibColumnObj
  ::cF3 := cF3
return


/*/{Protheus.doc} getComboBox

Coleta o ComboBox da coluna
  
@author soulsys:victorhugo
@since 18/09/2021
/*/
method getComboBox() class LibColumnObj
return ::cComboBox


/*/{Protheus.doc} setComboBox

Define o ComboBox da coluna
  
@author soulsys:victorhugo
@since 18/09/2021
/*/
method setComboBox(cComboBox) class LibColumnObj
  ::cComboBox := cComboBox
return


/*/{Protheus.doc} getInitializer

Coleta o Inicializador padrao da coluna
  
@author soulsys:victorhugo
@since 18/09/2021
/*/
method getInitializer() class LibColumnObj
return ::cInitializer


/*/{Protheus.doc} setInitializer

Define o Inicializador padrao da coluna
  
@author soulsys:victorhugo
@since 18/09/2021
/*/
method setInitializer(cInitializer) class LibColumnObj
  ::cInitializer := cInitializer
return


/*/{Protheus.doc} isReadOnly

Indica se a coluna eh somente visualizacao
  
@author soulsys:victorhugo
@since 18/09/2021
/*/
method isReadOnly() class LibColumnObj
return ::lReadOnly


/*/{Protheus.doc} setReadOnly

Define se a coluna eh somente visualizacao
  
@author soulsys:victorhugo
@since 18/09/2021
/*/
method setReadOnly(lReadOnly) class LibColumnObj
  ::lReadOnly := lReadOnly
return

/*/{Protheus.doc} getContext

Coleta o contexto do campo ("R"=Real, "V"=Virtual)
  
@author soulsys:victorhugo
@since 18/09/2021
/*/
method getContext() class LibColumnObj
return ::cContext


/*/{Protheus.doc} setContext

Define o contexto do campo ("R"=Real, "V"=Virtual)
  
@author soulsys:victorhugo
@since 18/09/2021
/*/
method setContext(cContext) class LibColumnObj
  ::cContext := cContext
return


/*/{Protheus.doc} getBrowseInitializer

Coleta o inicializador do browse
  
@author soulsys:victorhugo
@since 18/09/2021
/*/
method getBrowseInitializer() class LibColumnObj
return ::cBrowseInitializer


/*/{Protheus.doc} setBrowseInitializer

Define o inicializador do browse
  
@author soulsys:victorhugo
@since 18/09/2021
/*/
method setBrowseInitializer(cBrowseInitializer) class LibColumnObj
  ::cBrowseInitializer := cBrowseInitializer
return


/*/{Protheus.doc} getShowOnBrowse

Indica se exibe a coluna em Browses ("S","N")
  
@author soulsys:victorhugo
@since 18/09/2021
/*/
method getShowOnBrowse() class LibColumnObj 
return ::cShowOnBrowse


/*/{Protheus.doc} setShowOnBrowse

Define se exibe a coluna em Browses ("S"/"N")
  
@author soulsys:victorhugo
@since 18/09/2021
/*/
method setShowOnBrowse(cShowOnBrowse) class LibColumnObj
  ::cShowOnBrowse := cShowOnBrowse
return
  

/*/{Protheus.doc} isMarkColumn

Indica se � uma coluna de selecao de registros
  
@author soulsys:victorhugo
@since 18/09/2021
/*/
method isMarkColumn() class LibColumnObj	
return ::lMarkColumn


/*/{Protheus.doc} isBmpColumn

Indica se � uma coluna tipo bitmap
  
@author soulsys:victorhugo
@since 18/09/2021
/*/
method isBmpColumn() class LibColumnObj	
return ::lBmpColumn 


/*/{Protheus.doc} isSx3

Indica se a coluna foi criada a partir do SX3
  
@author soulsys:victorhugo
@since 18/09/2021
/*/
method isSx3() class LibColumnObj	
return ::lSx3 


/*/{Protheus.doc} isRequired

Indica se � um campo de preenchimento obrigatorio
  
@author soulsys:victorhugo
@since 18/09/2021
/*/
method isRequired() class LibColumnObj
return ::lRequired


/*/{Protheus.doc} setRequired

Define se � um campo de preenchimento obrigatorio
  
@author soulsys:victorhugo
@since 18/09/2021
/*/
method setRequired(lRequired) class LibColumnObj
  ::lRequired := lRequired
return


/*/{Protheus.doc} getEmptyValue

Retorna um valor para uma coluna vazia
  
@author soulsys:victorhugo
@since 18/09/2021
/*/
method getEmptyValue() class LibColumnObj
  
  local xValue 	:= nil
  local cType  	:= ::getType()
  local nSize		:= ::getSize()
  
  if ::isSx3()
    xValue := CriaVar(::getId(), .T.)
  else
    if (cType $ "C,M")
      xValue := Space(nSize)	
    elseIf (cType == "N")
      xValue := 0
    elseIf (cType == "D")
      xValue := CtoD("")
    elseIf (cType == "L")
      xValue := .F.			
    endIf
  endIf		
  
return xValue
