#include "totvs.ch"
#include "rwmake.ch"		

 
/*/{Protheus.doc} LibParamBoxObj
 
Objeto para apresentacao de uma tela de parametros
  
@author soulsys:victorhugo
@since 18/09/2021
/*/
class LibParamBoxObj from LibAdvplObj	
  
  data cId
  data cTitle
  data aParams	
  data bValidation
  data lCanSave
  data lUserSave
  data lCentered 
  data cSomething
  data aValues
  data aMvs 
  
  method newLibParamBoxObj() constructor	
  
  method getId()
  method setId()
  method getTitle()
  method setTitle()
  method getParams()
  method getValidation()
  method setValidation()
  method isCanSave()
  method setCanSave()
  method isUserSave()
  method setUserSave()
  method isCentered()
  method setCentered()
  
  method addParam()	
  method show()
  method getValue()
  
endClass


/*/{Protheus.doc} newLibParamBoxObj

Construtor

@author soulsys:victorhugo
@since 18/09/2021
/*/
method newLibParamBoxObj(cId, cTitle, bValidation) class LibParamBoxObj	
  
  default cId 		    := ""
  default cTitle		  := "LibParamBoxObj"
  default bValidation	:= {|| .T. }
  
  ::newLibAdvplObj()
  
  ::aParams := {}
  ::aValues := {}
  ::aMvs	  := {}
  
  ::setId(cId)
  ::setTitle(cTitle)
  ::setValidation(bValidation)
  ::setCanSave(.T.)
  ::setUserSave(.T.)
  ::setCentered(.T.)
    
return	

/*/{Protheus.doc} getId

Coleta o ID do objeto
  
@author soulsys:victorhugo
@since 18/09/2021
/*/
method getId() class LibParamBoxObj
return ::cId


/*/{Protheus.doc} setId

Define o ID do objeto
  
@author soulsys:victorhugo
@since 18/09/2021
/*/
method setId(cId) class LibParamBoxObj
  ::cId := cId
return


/*/{Protheus.doc} getTitle

Coleta o Titulo da tela de parametros
  
@author soulsys:victorhugo
@since 18/09/2021
/*/
method getTitle() class LibParamBoxObj
return ::cTitle


/*/{Protheus.doc} setTitle

Define o Titulo da tela de parametros
  
@author soulsys:victorhugo
@since 18/09/2021
/*/
method setTitle(cTitle) class LibParamBoxObj
  ::cTitle := cTitle
return


/*/{Protheus.doc} getParams

Coleta os parametros do objeto
  
@author soulsys:victorhugo
@since 18/09/2021
/*/
method getParams() class LibParamBoxObj
return ::aParams


/*/{Protheus.doc} getValidation

Coleta a validacao ao clicar no botao OK da tela de parametros
  
@author soulsys:victorhugo
@since 18/09/2021
/*/
method getValidation() class LibParamBoxObj
return ::bValidation


/*/{Protheus.doc} setValidation

Define o validacao ao clicar no botao OK da tela de parametros
  
@author soulsys:victorhugo
@since 18/09/2021
/*/
method setValidation(bValidation) class LibParamBoxObj
  ::bValidation := bValidation
return


/*/{Protheus.doc} isCanSave

Indica se pode salvar as respostas dos parametros
  
@author soulsys:victorhugo
@since 18/09/2021
/*/
method isCanSave() class LibParamBoxObj
return ::lCanSave


/*/{Protheus.doc} setCanSave

Define se pode salvar as respostas dos parametros
  
@author soulsys:victorhugo
@since 18/09/2021
/*/
method setCanSave(lCanSave) class LibParamBoxObj
  ::lCanSave := lCanSave
return


/*/{Protheus.doc} isUserSave

Indica se o usuario comum pode salvar as repostas dos parametros
  
@author soulsys:victorhugo
@since 18/09/2021
/*/
method isUserSave() class LibParamBoxObj
return ::lUserSave


/*/{Protheus.doc} setUserSave

Define se o usuario comum pode salvar as repostas dos parametros
  
@author soulsys:victorhugo
@since 18/09/2021
/*/
method setUserSave(lUserSave) class LibParamBoxObj
  ::lUserSave := lUserSave
return


/*/{Protheus.doc} isCentered

Indica se exibe a tela de parametros centralizada
  
@author soulsys:victorhugo
@since 18/09/2021

@return Logico Indica se exibe a tela de parametros centralizada
/*/
method isCentered() class LibParamBoxObj
return ::lCentered


/*/{Protheus.doc} setCentered

Define o Indica se exibe a tela de parametros centralizada
  
@author soulsys:victorhugo
@since 18/09/2021

@param lCentered, Logico, Indica se exibe a tela de parametros centralizada
/*/
method setCentered(lCentered) class LibParamBoxObj
  ::lCentered := lCentered
return


/*/{Protheus.doc} addParams

Adiciona parametros tipo LibParamObj
  
@author soulsys:victorhugo
@since 18/09/2021
/*/
method addParam(oParam) class LibParamBoxObj
  
  local nI	  	:= 0
  local lExists	:= .F.
  
  if (ValType(oParam) != "O")
    return
  endIf
  
  for nI := 1 to Len(::aParams)
    if (::aParams[nI]:getId() == oParam:getId())
      ::aParams[nI] := oParam
      lExists := .T.
      exit
    endIf
  next nI
  
  if !lExists
    aAdd(::aParams, oParam)
  endIf
  
return


/*/{Protheus.doc} show

Exibicao da tela de parametros. Nao afeta o conteudo das variaveis publicas MV_PARs.
  
@author soulsys:victorhugo
@since 18/09/2021
/*/	 
method show() class LibParamBoxObj
  
  local lOk			    := .F.		
  local aRet			  := {}
  local aParamBox		:= {}
  local cLoad			  := ::getId()
  local lCanSave		:= ::isCanSave()
  local lUserSave 	:= ::isUserSave()
  local lCentered 	:= ::isCentered()	            
  local bVldParams	:= ::getValidation()
  private cCadastro	:= ::getTitle()
  
  if Empty(cLoad)
    MsgBox("Id do grupo de parametros nao definido", "LibParamBoxObj", "ALERT")
    return
  endIf
  
  saveMvs(@self:aMvs)
  
  fillParamBoxArray(self, @aParamBox)
  
  if ParamBox(aParamBox, "parametros", @aRet, bVldParams, nil, lCentered, nil, nil, nil, cLoad, lCanSave, lUserSave)
    lOk := .T.
    saveMvs(@self:aValues)
    restoreMvs(@self)
  endIf
  
return lOk

/**
 * Salva as variaveis publicas de parametros em um vetor
 */
static function saveMvs(aValues)
  
  local nI 	   := 0
  local cMvPar := ""
  
  aValues := {}
  
  for nI := 1 to 99	
    cMvPar := "MV_PAR" + StrZero(nI,2)	
    if (chkType(cMvPar) != "U")
      aAdd(aValues, &cMvPar)
    else
      aAdd(aValues, nil)
    endIf
  next nI 

return

/**
 * Popula o array da funcao ParamBox
 */
static function fillParamBoxArray(oParObj, aParamBox)
  
  local nI 		  := 0
  local aParams	:= oParObj:getParams()
  
  aParamBox := {}
  
  for nI := 1 to Len(aParams)
    aAdd(aParamBox, aParams[nI]:toArray())
  next nI
  
return 

/**
 * Restaura as variaveis publicas de parametros
 */
static function restoreMvs(oObj)
  
  local nI 	   := 0
  local xValue := nil
   
  for nI := 1 to Len(oObj:aMvs)
    cMvPar := "MV_PAR" + StrZero(nI,2)
    xValue := oObj:aMvs[nI]
    if (chkType(cMvPar) != "U" .or. ValType(xValue) != "U")
      &cMvPar := xValue
    endIf	
  next nI
  
return

/*/{Protheus.doc} getValue

Coleta o valor de um parametro informado pelo usuario
  
@author soulsys:victorhugo
@since 18/09/2021
/*/
method getValue(cParamId, lMemory) class LibParamBoxObj
  
  local nI		     := 0
  local xValue 	   := nil
  local oParam	   := nil
  local cMvPar	   := ""
  local lHasValues := (Len(::aValues) > 0) 
  local oUtils     := LibUtilsObj():newLibUtilsObj()
  default lMemory  := .F.
  
  if !lHasValues
    lHasValues := loadLastValues(@self)
  endIf
  
  for nI := 1 to Len(::aParams)
    oParam := ::aParams[nI]	
    if (oParam:getId() == cParamId)
      if lMemory
        cMvPar := "MV_PAR"+StrZero(nI, 2)
        xValue := &cMvPar
      elseIf lHasValues
        xValue := ::aValues[nI]			
        if (oParam:getType() $ "combo,radio")
          xValue := getComboValue(xValue, oParam)
        endIf	
      else
        xValue := oUtils:getDefaultValue(oParam:getDataType())
      endIf		
      exit
    endIf
  next nI	
  
return xValue

/**
 * Carrega as ultimas respostas do usuario
 */
static function loadLastValues(oSelf)
  
  local oFile	    := nil
  local xValue    := nil
  local cLoad	    := oSelf:getId()
  local cPrbFile  := ""
  local cValType  := ""
  local cStrValue := ""
  
  if Empty(cLoad)
    return .F.
  endIf
  
  cPrbFile := "\profile\"+__cUserId+"_"+cLoad+".prb"
  oFile    := LibFileObj():newLibFileObj(cPrbFile)
  
  if !oFile:exists()
    return .F.
  endIf
  
  oSelf:aValues := {}
  
  oFile:goTop()
  oFile:skipLine()
  
  while oFile:notIsEof()
    
    xValue	  := nil
    cValType  := oFile:readLine(1, 1)
    cStrValue := oFile:readLine(2)		
    
    if (cValType == "C")
      xValue := cStrValue
    elseIf (cValType == "N")
      xValue := Val(cStrValue)
    elseIf (cValType == "D")
      xValue := CtoD(cStrValue)
    elseIf (cValType == "L")
      xValue := if("F" $ cStrValue, .F., .T.)
    endIf 
    
    aAdd(oSelf:aValues, xValue)
    
    oFile:skipLine()
  endDo
  
  oFile:close()
  
return (Len(oSelf:aValues) > 0)

/**
 * Coleta o valor de parametros tipo "combo"
 */
static function getComboValue(xMvValue, oParam)
  
  local xValue	  := nil
  local cDataType	:= oParam:getDataType()
  local aValues	  := oParam:getValues()
  
  if (ValType(xMvValue) == "N") 
    if (cDataType == "N") 
      xValue := xMvValue	
    else
      xValue := aValues[xMvValue]		
    endIf		
  elseIf (ValType(xMvValue) == "C") 
    if (cDataType == "N")
      xValue := aScan(aValues, xMvValue)
    else
      xValue := xMvValue
    endIf		
  endIf
  
  if (ValType(xValue) == "C")
    xValue := AllTrim(xValue)
  endIf
  
return xValue

/**
* Static function criada para contornar validacao do TOTVS CodeAnalysis
*/
static function chkType(cVar)
return Type(cVar)
