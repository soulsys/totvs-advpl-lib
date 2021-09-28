#include "totvs.ch"		

 
/*/{Protheus.doc} LibParamObj
 
Objeto que representa uma parametro da classe LibParamBoxObj
  
@author soulsys:victorhugo
@since 18/09/2021
/*/
class LibParamObj from LibAdvplObj	
  
  data cId
  data cType
  data cDataType
  data cDescription
  data cInitializer
  data cPicture
  data cValidation
  data cF3
  data cWhen
  data nWidth
  data nSize
  data lRequired
  data aValues
  data cFileTypes
  data cFileStartDirectory
  data nFileParams
  data cFilterAlias
  data cFilterWhen
  data nHeight
  data lBold			
  
  method newLibParamObj() constructor	
  
  method getId()
  method setId()
  method getType()
  method setType()
  method getDataType()
  method setDataType()
  method getDescription()
  method setDescription()
  method getInitializer()
  method setInitializer()
  method getPicture()
  method setPicture()
  method getValidation()
  method setValidation()
  method getF3()
  method setF3()
  method getWhen()
  method setWhen()
  method getWidth()
  method setWidth()
  method getSize()
  method setSize()
  method isRequired()
  method setRequired()
  method getValues()
  method setValues()
  method getFileTypes()
  method setFileTypes()	
  method getFileStartDirectory()
  method setFileStartDirectory()
  method getFileParams()
  method setFileParams()
  method getFilterAlias()
  method setFilterAlias()
  method getFilterWhen()
  method setFilterWhen()
  method getHeight()
  method setHeight()	
  method isBold()
  method setBold()
  
  method toArray()
  
endClass


/*/{Protheus.doc} newLibParamObj

Construtor

@author soulsys:victorhugo
@since 18/09/2021
/*/
method newLibParamObj(cId, cType, cDescription, cDataType, nWidth, nSize) class LibParamObj	
  
  default cId 			   := ""
  default cType 			 := "get"
  default cDescription := ""
  default cDataType		 := getDefDataType(cType)
  default nWidth			 := 10
  default nSize			   := 10
  
  ::newLibAdvplObj()
  
  if (cDataType == "D")
    nWidth := 60
    nSize  := 8
  endIf
  
  ::setId(cId)
  ::setType(cType)
  ::setDescription(cDescription)
  ::setDataType(cDataType)
  ::setWidth(nWidth)	
  ::setSize(nSize)
  ::setInitializer(getDefInitializer(cType, cDataType, nSize))
  ::setPicture("")
  ::setValidation("") 
  ::setF3("")
  ::setWhen("")
  ::setRequired(.F.)
  ::setValues({"novalues"})
  ::setFileTypes("")
  ::setFileStartDirectory("")
  ::setFileParams(0)
  ::setFilterAlias("")
  ::setFilterWhen("")
  ::setHeight(10)
  ::setBold(.F.)
          
return	

/**
 * Coleta o tipo de dados padrao de acordo com o tipo de parametro
 */
static function getDefDataType(cType)
  
  local cDataType := ""
  
  cType := Lower(AllTrim(cType))
  
  if (cType $ "combo,radio")
    cDataType := "N"
  elseIf (cType == "checkbox")
    cDataType := "L"
  else
    cDataType := "C"		
  endIf
  
return cDataType

/**
 * Coleta o inicializador padrao de acordo com o tipo de parametro e o tipo de dados
 */
static function getDefInitializer(cType, cDataType, nSize)
  
  local xDefInit := nil
  
  cType := Lower(AllTrim(cType))
  
  if (cDataType == "N")
    if (cType $ "combo,radio")
      xDefInit := 1
    else
      xDefInit := 0
    endIf	
  elseIf (cDataType == "D")
    xDefInit := CtoD("")
  elseIf (cDataType == "L")
    xDefInit := .F.
  else
    if (cType != "get")
      nSize := 500
    endIf		 
    xDefInit := Space(nSize)
  endIf 
  
return xDefInit


/*/{Protheus.doc} getId

Coleta o Id do parametro
  
@author soulsys:victorhugo
@since 18/09/2021
/*/
method getId() class LibParamObj
return ::cId


/*/{Protheus.doc} setId

Define o Id do parametro
  
@author soulsys:victorhugo
@since 18/09/2021
/*/
method setId(cId) class LibParamObj
  ::cId := cId
return


/*/{Protheus.doc} getType

Coleta o Tipo do parametro. Valores aceitos: "get","combo","radio","checkbox","file","filter","password","say","range","memo" e "user_filter"
  
@author soulsys:victorhugo
@since 18/09/2021
/*/
method getType() class LibParamObj
return ::cType


/*/{Protheus.doc} setType

Define o Tipo do parametro
  
@author soulsys:victorhugo
@since 18/09/2021
/*/
method setType(cType) class LibParamObj
  ::cType := Lower(AllTrim(cType))
return


/*/{Protheus.doc} getDataType

Coleta o Tipo de dados do parametro
  
@author soulsys:victorhugo
@since 18/09/2021
/*/
method getDataType() class LibParamObj
return ::cDataType


/*/{Protheus.doc} setDataType

Define o Tipo de dados do parametro
  
@author soulsys:victorhugo
@since 18/09/2021
/*/
method setDataType(cDataType) class LibParamObj
  ::cDataType := cDataType
return


/*/{Protheus.doc} getDescription

Coleta a descricao do parametro
  
@author soulsys:victorhugo
@since 18/09/2021
/*/
method getDescription() class LibParamObj
return ::cDescription


/*/{Protheus.doc} setDescription

Define a descricao do parametro
  
@author soulsys:victorhugo
@since 18/09/2021
/*/
method setDescription(cDescription) class LibParamObj
  ::cDescription := cDescription
return


/*/{Protheus.doc} getInitializer

Coleta o Inicializador padrao
  
@author soulsys:victorhugo
@since 18/09/2021
/*/
method getInitializer() class LibParamObj
return ::cInitializer


/*/{Protheus.doc} setInitializer

Define o Inicializador padrao
  
@author soulsys:victorhugo
@since 18/09/2021
/*/
method setInitializer(cInitializer) class LibParamObj
  ::cInitializer := cInitializer
return


/*/{Protheus.doc} getPicture

Coleta a Picture
  
@author soulsys:victorhugo
@since 18/09/2021
/*/
method getPicture() class LibParamObj
return ::cPicture


/*/{Protheus.doc} setPicture

Define a Picture
  
@author soulsys:victorhugo
@since 18/09/2021
/*/
method setPicture(cPicture) class LibParamObj
  ::cPicture := cPicture
return


/*/{Protheus.doc} getValidation

Coleta a validacao
  
@author soulsys:victorhugo
@since 18/09/2021
/*/
method getValidation() class LibParamObj
return ::cValidation


/*/{Protheus.doc} setValidation

Define a validacao
  
@author soulsys:victorhugo
@since 18/09/2021
/*/
method setValidation(cValidation) class LibParamObj
  ::cValidation := cValidation
return


/*/{Protheus.doc} getF3

Coleta a Consulta F3
  
@author soulsys:victorhugo
@since 18/09/2021
/*/
method getF3() class LibParamObj
return ::cF3


/*/{Protheus.doc} setF3

Define a Consulta F3
  
@author soulsys:victorhugo
@since 18/09/2021
/*/
method setF3(cF3) class LibParamObj
  ::cF3 := cF3
return


/*/{Protheus.doc} getWhen

Coleta a validacao When
  
@author soulsys:victorhugo
@since 18/09/2021
/*/
method getWhen() class LibParamObj
return ::cWhen


/*/{Protheus.doc} setWhen

Define a validacao When
  
@author soulsys:victorhugo
@since 18/09/2021
/*/
method setWhen(cWhen) class LibParamObj
  ::cWhen := cWhen
return


/*/{Protheus.doc} getWidth

Coleta a Largura do parametro
  
@author soulsys:victorhugo
@since 18/09/2021
/*/
method getWidth() class LibParamObj
return ::nWidth


/*/{Protheus.doc} setWidth

Define o Largura do parametro
  
@author soulsys:victorhugo
@since 18/09/2021
/*/
method setWidth(nWidth) class LibParamObj
  ::nWidth := nWidth
return


/*/{Protheus.doc} getSize

Coleta o Tamanho de parametros tipo "get"
  
@author soulsys:victorhugo
@since 18/09/2021
/*/
method getSize() class LibParamObj
return ::nSize


/*/{Protheus.doc} setSize

Define o Tamanho de parametros tipo "get"
  
@author soulsys:victorhugo
@since 18/09/2021
/*/
method setSize(nSize) class LibParamObj
  ::nSize := nSize
return


/*/{Protheus.doc} isRequired

Indica se parametro eh obrigatorio
  
@author soulsys:victorhugo
@since 18/09/2021
/*/
method isRequired() class LibParamObj
return ::lRequired


/*/{Protheus.doc} setRequired

Define se parametro eh obrigatorio
  
@author soulsys:victorhugo
@since 18/09/2021
/*/
method setRequired(lRequired) class LibParamObj
  ::lRequired := lRequired
return


/*/{Protheus.doc} getValues

Coleta Valores para parametros tipo Combo ou Radio
  
@author soulsys:victorhugo
@since 18/09/2021
/*/
method getValues() class LibParamObj
return ::aValues


/*/{Protheus.doc} setValues

Define o Valores para parametros tipo Combo ou Radio
  
@author soulsys:victorhugo
@since 18/09/2021
/*/
method setValues(aValues) class LibParamObj
  ::aValues := aValues
return


/*/{Protheus.doc} getFileTypes

Coleta os Tipos de arquivos para parametros tipo "file"
  
@author soulsys:victorhugo
@since 18/09/2021
/*/
method getFileTypes() class LibParamObj
return ::cFileTypes


/*/{Protheus.doc} setFileTypes

Define os Tipos de arquivos para parametros tipo "file"
  
@author soulsys:victorhugo
@since 18/09/2021
/*/
method setFileTypes(cFileTypes) class LibParamObj
  ::cFileTypes := cFileTypes
return


/*/{Protheus.doc} getFileStartDirectory

Coleta o diretorio inicial para parametros tipo "file"
  
@author soulsys:victorhugo
@since 18/09/2021
/*/
method getFileStartDirectory() class LibParamObj
return ::cFileStartDirectory


/*/{Protheus.doc} setFileStartDirectory

Define o diretorio inicial para parametros tipo "file"
  
@author soulsys:victorhugo
@since 18/09/2021
/*/
method setFileStartDirectory(cFileStartDirectory) class LibParamObj
  ::cFileStartDirectory := cFileStartDirectory
return


/*/{Protheus.doc} getFileParams

Coleta os Parametros de objetos tipo "file"
  
@author soulsys:victorhugo
@since 18/09/2021
/*/
method getFileParams() class LibParamObj
return ::nFileParams


/*/{Protheus.doc} setFileParams

Define os Parametros de objetos tipo "file"
  
@author soulsys:victorhugo
@since 18/09/2021
/*/
method setFileParams(nFileParams) class LibParamObj
  ::nFileParams := nFileParams
return


/*/{Protheus.doc} getFilterAlias

Coleta o Alias para parametros tipo "filter"
  
@author soulsys:victorhugo
@since 18/09/2021
/*/
method getFilterAlias() class LibParamObj
return ::cFilterAlias


/*/{Protheus.doc} setFilterAlias

Define o Alias para parametros tipo "filter"
  
@author soulsys:victorhugo
@since 18/09/2021
/*/
method setFilterAlias(cFilterAlias) class LibParamObj
  ::cFilterAlias := cFilterAlias
return


/*/{Protheus.doc} getFilterWhen

Coleta a validacao When de parametros tipo "filter"
  
@author soulsys:victorhugo
@since 18/09/2021
/*/
method getFilterWhen() class LibParamObj
return ::cFilterWhen


/*/{Protheus.doc} setFilterWhen

Define a validacao When de parametros tipo "filter"
  
@author soulsys:victorhugo
@since 18/09/2021
/*/
method setFilterWhen(cFilterWhen) class LibParamObj
  ::cFilterWhen := cFilterWhen
return


/*/{Protheus.doc} getHeight

Coleta a Altura de parametros tipo "say"
  
@author soulsys:victorhugo
@since 18/09/2021
/*/
method getHeight() class LibParamObj
return ::nHeight


/*/{Protheus.doc} setHeight

Define a Altura de parametros tipo "say"
  
@author soulsys:victorhugo
@since 18/09/2021
/*/
method setHeight(nHeight) class LibParamObj
  ::nHeight := nHeight
return


/*/{Protheus.doc} isBold

Indica se o parametro tipo "say" sera exibido em negrito
  
@author soulsys:victorhugo
@since 18/09/2021
/*/
method isBold() class LibParamObj
return ::lBold


/*/{Protheus.doc} setBold

Define se o parametro tipo "say" sera exibido em negrito
  
@author soulsys:victorhugo
@since 18/09/2021
/*/
method setBold(lBold) class LibParamObj
  ::lBold := lBold
return


/*/{Protheus.doc} toArray

Converte o parametro em Array para a funcao ParamBox
  
@author soulsys:victorhugo
@since 18/09/2021
/*/
method toArray() class LibParamObj
  
  local aArray	:= {}
  local cType		:= Lower(AllTrim(::getType()))
  
  if (cType == "get")
    aArray := {1, ::getDescription(), ::getInitializer(), ::getPicture(), ::getValidation(), ::getF3(), ::getWhen(), ::getWidth(), ::isRequired()}
  elseIf (cType == "combo") 
    aArray := {2, ::getDescription(), ::getInitializer(), ::getValues(), ::getWidth(), ::getValidation(), ::isRequired()}
  elseIf (cType == "radio")
    aArray := {3, ::getDescription(), ::getInitializer(), ::getValues(), ::getWidth(), ::getValidation(), ::isRequired(), ::getWhen()}
  elseIf (cType == "checkbox")
    aArray :=	 {4, ::getDescription(), ::getInitializer(), nil, ::getWidth(), ::getValidation(), ::isRequired()}
  elseIf (cType == "file")
    aArray := {6, ::getDescription(), ::getInitializer(), ::getPicture(), ::getValidation(), ::getWhen(), ::getWidth(), ::isRequired(), ::getFileTypes(), ::getFileStartDirectory(), ::getFileParams()}
  elseIf (cType == "filter")
    aArray := {7, ::getDescription(), ::getFilterAlias(), ::getInitializer(), ::getFilterWhen()}
  elseIf (cType == "password")
    aArray := {8, ::getDescription(), ::getInitializer(), ::getPicture(), ::getValidation(), ::getF3(), ::getWhen(), ::getWidth(), ::isRequired()}
  elseIf (cType == "say")
    aArray := {9, ::getDescription(), ::getWidth(), ::getHeight(), ::isBold()}
  elseIf (cType == "range")
    aArray := {10, ::getDescription(), ::getInitializer(), ::getF3(), ::getWidth(), ::getDataType(), 500, ::getWhen()}
  elseIf (cType == "memo")
    aArray := {11, ::getDescription(), ::getInitializer(), ::getValidation(), ::getWhen(), ::isRequired()}
  elseIf (cType == "user_filter")
    aArray := {12, ::getDescription(), ::getFilterAlias(), ::getInitializer(), ::getWhen()}
  endIf
  
return aArray
