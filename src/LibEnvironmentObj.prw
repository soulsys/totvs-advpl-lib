#include "totvs.ch"	
#include "tbiconn.ch"	
#include "rwmake.ch"	

#define SAVE_COMPANY		  1
#define SAVE_BRANCH		 	  2
#define SAVE_APP			    3
#define SAVE_MODULE_CODE	4
#define SAVE_MODULE_ID		5 
#define SAVE_INTERNET		  6
#define SAVE_USER_ID		  7 
 
 
/*/{Protheus.doc} LibEnvironmentObj
 
Objeto para manipulacao do Ambiente Protheus
  
@author soulsys:victorhugo
@since 18/09/2021
/*/
class LibEnvironmentObj from LibAdvplObj	
  
  data cCompany
  data cBranch
  data cNameCompany
  data cNameBranch
  data cUserName
  data cUserPassword
  data cTables
  data cModule
  data lCreateMainWindow
  data lPreparedEnvironment
  data aSave
  
  method newLibEnvironmentObj() constructor	
  
  method getCompany()
  method setCompany()
  method getBranch()
  method setBranch()
  method getNameCompany()
  method getNameBranch()
  method getUserName()
  method setUserName()
  method getUserPassword()
  method setUserPassword()
  method getTables()
  method setTables()
  method getModule()
  method setModule()
  method isCreateMainWindow()
  method setCreateMainWindow()
  
  method load()
  method close()
  method getCompanies()
  method hasMainWindow()
  method save()
  method restore()
  method inputCompanyScreen()
  
endClass


/*/{Protheus.doc} newLibEnvironmentObj

Construtor

@author soulsys:victorhugo
@since 18/09/2021
/*/
method newLibEnvironmentObj(cCompany, cBranch, cUsrName, cUserPassword, cTables, cModule, lCreateMainWindow) class LibEnvironmentObj	
  
  default cCompany 			    := if(Type("cEmpAnt") == "C", cEmpAnt, "")
  default cBranch 			    := if(Type("cFilAnt") == "C", cFilAnt, "")
  default cUsrName 			    := if(Type("cUserName") == "C", cUserName, "Administrador") 
  default cUserPassword     := ""
  default cTables				    := ""
  default cModule				    := "SIGAFAT"
  default lCreateMainWindow	:= .F.
  
  ::newLibAdvplObj()
  
  ::setCompany(cCompany)
  ::setBranch(cBranch)
  ::setUserName(cUsrName)
  ::setUserPassword(cUserPassword)
  ::setTables(cTables)
  ::setModule(cModule)
  ::setCreateMainWindow(lCreateMainWindow)
  ::lPreparedEnvironment := .F.
  ::aSave := {}
  
  ::save()
              
return


/*/{Protheus.doc} getCompany

Coleta o codigo da Empresa
  
@author soulsys:victorhugo
@since 18/09/2021
/*/
method getCompany() class LibEnvironmentObj
return ::cCompany


/*/{Protheus.doc} setCompany

Define o codigo da Empresa
  
@author soulsys:victorhugo
@since 18/09/2021
/*/
method setCompany(cCompany) class LibEnvironmentObj
  ::cCompany := cCompany
  setNames(@self)
return	


/*/{Protheus.doc} getBranch

Coleta o codigo da Filial
  
@author soulsys:victorhugo
@since 18/09/2021
/*/
method getBranch() class LibEnvironmentObj
return ::cBranch


/*/{Protheus.doc} setBranch

Define o codigo da Filial
  
@author soulsys:victorhugo
@since 18/09/2021
/*/
method setBranch(cBranch) class LibEnvironmentObj
  ::cBranch := cBranch
  setNames(@self)
return

/**
 * Atualiza os Nomes da Empresa/Filial
 */
static function setNames(oSelf)
  
  local cCompany := oSelf:getCompany()
  local cBranch  := oSelf:getBranch()
  local aAreaSM0 := {}
  
  if (Empty(cCompany) .or. Empty(cBranch) .or. Select("SM0") <= 0)
    return
  endIf
  
  aAreaSM0 := SM0->(GetArea())
  
  if SM0->(dbSeek(cCompany+cBranch))
    oSelf:cNameCompany := SM0->M0_NOME
    oSelf:cNameBranch  := SM0->M0_FILIAL
  endIf
  
  RestArea(aAreaSM0)
  
return


/*/{Protheus.doc} getNameCompany

Coleta o Nome da Empresa
  
@author soulsys:victorhugo
@since 18/09/2021
/*/
method getNameCompany() class LibEnvironmentObj
return ::cNameCompany


/*/{Protheus.doc} getNameBranch

Coleta o Nome da Filial
  
@author soulsys:victorhugo
@since 18/09/2021
/*/
method getNameBranch() class LibEnvironmentObj
return ::cNameBranch


/*/{Protheus.doc} getUserName

Coleta o codigo do Uauï¿½rio
  
@author soulsys:victorhugo
@since 18/09/2021
/*/
method getUserName() class LibEnvironmentObj
return ::cUserName


/*/{Protheus.doc} setUserName

Define o codigo do Uauï¿½rio
  
@author soulsys:victorhugo
@since 18/09/2021
/*/
method setUserName(cUserName) class LibEnvironmentObj
  ::cUserName := cUserName
return


/*/{Protheus.doc} getUserPassword

Coleta a Senha do Usuaï¿½ï¿½rio
  
@author soulsys:victorhugo
@since 18/09/2021
/*/
method getUserPassword() class LibEnvironmentObj
return ::cUserPassword


/*/{Protheus.doc} setUserPassword

Define a Senha do Usuaï¿½ï¿½rio
  
@author soulsys:victorhugo
@since 18/09/2021
/*/
method setUserPassword(cUserPassword) class LibEnvironmentObj
  ::cUserPassword := cUserPassword
return


/*/{Protheus.doc} getTables

Coleta as Tabelas para abrir quando o ambiente for inicializado. Ex.: "SA1,SB1,SC5,SC6"
  
@author soulsys:victorhugo
@since 18/09/2021
/*/
method getTables() class LibEnvironmentObj
return ::cTables


/*/{Protheus.doc} setTables

Define as Tabelas para abrir quando o ambiente for inicializado. Ex.: "SA1,SB1,SC5,SC6"
  
@author soulsys:victorhugo
@since 18/09/2021
/*/
method setTables(cTables) class LibEnvironmentObj
  ::cTables := cTables
return


/*/{Protheus.doc} getModule

Coleta o modulo para inicializacao do ambiente. Ex.: "FAT
  
@author soulsys:victorhugo
@since 18/09/2021
/*/
method getModule() class LibEnvironmentObj
return ::cModule


/*/{Protheus.doc} setModule

Define o modulo para inicializacao do ambiente. Ex.: "FAT
  
@author soulsys:victorhugo
@since 18/09/2021
/*/
method setModule(cModule) class LibEnvironmentObj
  ::cModule := cModule
return


/*/{Protheus.doc} isCreateMainWindow

Indica se deve criar a Janela Principal (oMainWnd) do Protheus
  
@author soulsys:victorhugo
@since 18/09/2021
/*/
method isCreateMainWindow() class LibEnvironmentObj
return ::lCreateMainWindow


/*/{Protheus.doc} setCreateMainWindow

Indica se deve criar a Janela Principal (oMainWnd) do Protheus
  
@author soulsys:victorhugo
@since 18/09/2021
/*/
method setCreateMainWindow(lCreateMainWindow) class LibEnvironmentObj
  ::lCreateMainWindow := lCreateMainWindow
return


/*/{Protheus.doc} load

Carrega o ambiente Protheus
  
@author soulsys:victorhugo
@since 18/09/2021
/*/
method load(cFunName) class LibEnvironmentObj
  
  local lOk	 		:= .F. 
  default cFunName	:= "MsgBox('It works !! =D', 'LibEnvironmentObj', 'INFO')"
  
  if (lOk := loadEnvironment(@self))
    if ::isCreateMainWindow()
      lOk := createMainWindow(@self, cFunName)
    endIf	
  endIf
  
return lOk

/**
 * Carrega o ambiente Protheus
 */
static function loadEnvironment(oEnv)
  
  local lOk				     := .F.
  local cCompany	     := oEnv:getCompany()
  local cBranch			   := oEnv:getBranch()
  local cUserName		   := oEnv:getUserName()
  local cPassword			 := oEnv:getUserPassword()
  local cTables			   := oEnv:getTables()
  local cModule			   := Right(oEnv:getModule(), 3)	
  local lHasPublicVars := (Type("cEmpAnt") == "C") 	

  if lHasPublicVars .and. (cCompany+cBranch == cEmpAnt+cFilAnt)
    return .T.
  endIf														
  
  if (lHasPublicVars .or. oEnv:hasMainWindow())
    
    RstMvBuff()
    RpcClearEnv()		               
    RpcSetType(3)
    
    lOk := RpcSetEnv(cCompany, cBranch, cUserName, nil, cModule)
    
  else
    
    if (Empty(cUserName) .or. Empty(cPassword))
      PREPARE ENVIRONMENT EMPRESA cCompany FILIAL cBranch TABLES cTables MODULO cModule
    else
      PREPARE ENVIRONMENT EMPRESA cCompany FILIAL cBranch USER cUserName PASSWORD cPassword TABLES cTables MODULO cModule
    endIf
      
    oEnv:lPreparedEnvironment := .T.
    lOk 				      := .T.
                                         
  endIf
      
  cEmpAnt := cCompany
  cFilAnt	:= cBranch
    
return lOk

/**
 * Criacao da Janela Principal do Protheus
 */
static function createMainWindow(oEnv, cFunName)
  
  local cModName		:= oEnv:getModule()	
  local bWindowInit	:= {|| __cInternet := nil, __Execute(cFunName, "xxxxxxxxxxxxxxxxxxxx", cFunName, cModName, cModName, 1, .T.)}		
  public oMainWnd		:= nil
  public __cInternet	:= nil	
  
  if oEnv:hasMainWindow() 
    return .F.
  endIf
  
  createPublicVars(@cModName)
  
  DEFINE WINDOW oMainWnd FROM 001,001 TO 400,500 TITLE "Teste"
  ACTIVATE WINDOW oMainWnd MAXIMIZED ON INIT (Eval(bWindowInit) , oMainWnd:end())
  
return .T.

/**
 * Cria as variaveis publicas
 */
static function createPublicVars(cModName)
  
  InitPublic()
  SetsDefault()			
  setModulo(cModName)
  
  lMsHelpAuto  := .F.
  lMsFinalAuto := .F.
  
return

/**
 * Setar o modulo em execucao.
 * Funcao obtida no blog http://naldodjblogs.blogspot.com/
 */
static function setModulo(cModName)
  
  local cMod			:= ""
  local aRetModName	:= RetModName( .T. )	
  local cSvcModulo	:= nil
  local nSvnModulo	:= nil
  
  IF ( Type("nModulo") == "U" )
    _SetOwnerPrvt( "nModulo" , 0 )
  Else
    nSvnModulo := nModulo
  EndIF
  
  cModName := Upper( AllTrim( cModName ) )

  IF ( nModulo <> aScan( aRetModName , { |x| Upper( AllTrim( x[2] ) ) == cModName } ) )
    nModulo := aScan( aRetModName , { |x| Upper( AllTrim( x[2] ) ) == cModName } )
    IF ( nModulo == 0 )
      cModName	:= "SIGAFAT"
      nModulo		:= aScan( aRetModName , { |x| Upper( AllTrim( x[2] ) ) == cModName } )
    EndIF
  EndIF
  
  IF ( Type("cModulo") == "U" )
    _SetOwnerPrvt( "cModulo" , "" )
  Else
    cSvcModulo := cModulo
  EndIF
  
  cMod := SubStr( cModName , 5 )

  IF ( cModulo <> cMod )
    cModulo := cMod
  EndIF

return


/*/{Protheus.doc} close

Encerra o ambiente Protheus
  
@author soulsys:victorhugo
@since 18/09/2021
/*/
method close() class LibEnvironmentObj
  
  if ::lPreparedEnvironment
    RESET ENVIRONMENT
  endIf	
  
return


/*/{Protheus.doc} getCompanies

Exibe dialogo para selecao de Empresas/Filiais
  
@author soulsys:victorhugo
@since 18/09/2021
/*/
method getCompanies(cTitle, lSelectOne, lJustBranches, lJustCompanies, bFilter) class LibEnvironmentObj
  
  local aRet				      := {}
  local aCompanies 		    := {}
  local oDlg				      := nil
  local oGrid				      := nil
  default cTitle			    := "Selecione as Empresas/Filiais"
  default lSelectOne		  := .F.
  default lJustBranches	  := .F.
  default lJustCompanies	:= .F.
  default bFilter			    := { || .T. }
  
  aCompanies := readCompanies(lJustBranches, lJustCompanies, bFilter)
  
  DEFINE MSDIALOG oDlg TITLE cTitle FROM 001,001 TO 250,485 PIXEL OF oMainWnd								
    
    createGrid(oDlg, @oGrid, aCompanies, lSelectOne)	
    
    if !lSelectOne
      @ 105,006 BUTTON "Marca todas" SIZE 35,12 ACTION {|| oGrid:markAll() } PIXEL OF oDlg
    endIf	
    
    @ 105,165 BUTTON "Ok" SIZE 35,12 ACTION {|| if(getSelectedCompanies(oGrid, @aRet), oDlg:end(), nil) } PIXEL OF oDlg
    @ 105,205 BUTTON "Cancelar" SIZE 35,12 ACTION {|| oDlg:end() } PIXEL OF oDlg
            
  ACTIVATE MSDIALOG oDlg CENTERED
  
return aRet

/**
 * Leitura das Empresas/Filiais
 */
static function readCompanies(lJustBranches, lJustCompanies, bFilter)
  
  local aCompanies	:= {}
  local aAreaSM0 		:= SM0->(GetArea())
  
  SM0->(dbGoTop())
  while !SM0->(eof())
    
    if lJustBranches .and. SM0->(M0_CODIGO != cEmpAnt)
      SM0->(dbSkip())
      loop
    endIf
    
    if !Eval(bFilter)
      SM0->(dbSkip())
      loop
    endIf
    
    aAdd(aCompanies, {SM0->M0_CODIGO,SM0->M0_CODFIL,SM0->(Capital(AllTrim(M0_NOME))+" / "+Capital(AllTrim(M0_FILIAL))),SM0->M0_NOME})	
      
    SM0->(dbSkip())
  endDo
  
  RestArea(aAreaSM0)
  
  if lJustCompanies
    setJustCompanies(@aCompanies)
  endIf
  
return aCompanies

/**
 * Deixa apenas as empresas no array de Empresas/Filiais
 */
static function setJustCompanies(aCompanies)
  
  local nI		    := 0
  local nScan		  := 0
  local cCompany	:= ""
  local cName		  := ""
  local aNewArray := {}
  
  for nI := 1 to Len(aCompanies)		
    cCompany := aCompanies[nI,1]
    cName	 := aCompanies[nI,4]	 
    nScan	 := aScan(aNewArray, {|x| x[1] == cCompany })		
    if (nScan == 0)
      aAdd(aNewArray, {cCompany,"*",cName,""})	
    endIf		
  next nI
  
  aCompanies := aClone(aNewArray)
  
return

/**
 * Criacao do grid para selecao de Empresas/Filiais
 */
static function createGrid(oDlg, oGrid, aCompanies, lSelectOne)
  
  local nI		  := 0
  local nCol		:= 5
  local nRow		:= 5
  local nWidth	:= 240
  local nHeight	:= 100	
  local oCol		:= nil
  
  oGrid := LibGridObj():newLibGridObj(nCol, nRow, nWidth, nHeight, oDlg)
  
  oGrid:addMarkColumn()
  
  oCol := LibColumnObj():newLibColumnObj("company", "Empresa", "C", 10) 
  oGrid:addColumn(oCol)
  
  oCol := LibColumnObj():newLibColumnObj("branch", "Filial", "C", 10)
  oGrid:addColumn(oCol)
  
  oCol := LibColumnObj():newLibColumnObj("name", "Nome", "C", 40)
   oGrid:addColumn(oCol)
  
  for nI := 1 to Len(aCompanies)
    oGrid:newLine()
    oGrid:setMarkedLine(.F.)
    oGrid:setValue("company", aCompanies[nI,1])
    oGrid:setValue("branch", aCompanies[nI,2])
    oGrid:setValue("name", aCompanies[nI,3])		
  next nI
  
  oGrid:setReadOnly(.T.)
  oGrid:setMarkOne(lSelectOne)
  oGrid:create()
  
return

/**
 * Coleta as Empresas/Filiais selecionadas
 */
static function getSelectedCompanies(oGrid, aRet)
  
  local lOk	:= .F. 
  local nI 	:= 0
  
  aRet := {}
  
  for nI := 1 to oGrid:length()
    if oGrid:isMarkedLine(nI)
      aAdd(aRet, {oGrid:getValue("company", nI), oGrid:getValue("branch", nI)})
      lOk := .T.
    endIf
  next nI
  
  if !lOk
    MsgBox("Selecione ao menos uma Empresa/Filial", "Atenaaï¿½ï¿½o", "ALERT") 
  endIf
  
return lOk


/*/{Protheus.doc} hasMainWindow

Indica se a janela principal existe
  
@author soulsys:victorhugo
@since 18/09/2021
/*/
method hasMainWindow() class LibEnvironmentObj
return (Type("oMainWnd") == "O") 


/*/{Protheus.doc} save

Salva o ambiente atual
  
@author soulsys:victorhugo
@since 18/09/2021
/*/
method save() class LibEnvironmentObj
  
  if !::hasMainWindow()
    return
  endIf

  ::aSave                   := Array(7)
  ::aSave[SAVE_COMPANY]			:= cEmpAnt
  ::aSave[SAVE_BRANCH]			:= cFilAnt
  ::aSave[SAVE_APP]				  := oApp
  ::aSave[SAVE_MODULE_CODE]	:= cModulo
  ::aSave[SAVE_MODULE_ID]		:= nModulo
  ::aSave[SAVE_INTERNET]		:= __cInternet
  ::aSave[SAVE_USER_ID]			:= __cUserId
  
return


/*/{Protheus.doc} restore

Restaura o ambiente anterior
  
@author soulsys:victorhugo
@since 18/09/2021
/*/
method restore() class LibEnvironmentObj
  
  local oEnv := nil
      
  if (Len(::aSave) == 0)
    return
  endIf
  
  oEnv := LibEnvironmentObj():newLibEnvironmentObj()
  oEnv:setCompany(::aSave[SAVE_COMPANY])
  oEnv:setBranch(::aSave[SAVE_BRANCH])

  if oEnv:load()
    public oApp 		   := ::aSave[SAVE_APP]
    public cModulo		 := ::aSave[SAVE_MODULE_CODE]
    public nModulo		 := ::aSave[SAVE_MODULE_ID]
    public __cInternet := ::aSave[SAVE_INTERNET]
    public __cUserId	 := ::aSave[SAVE_USER_ID]
  endIf	
  
return


/*/{Protheus.doc} inputCompanyScreen

Apresenta tela para informacao de empresa e filial

@author soulsys:victorhugo
@since 17/05/2023
/*/
method inputCompanyScreen(aData) class LibEnvironmentObj
  
  local lOk      := .F.
  local oDlg     := nil
  local oBmp     := nil 
  local oPanel   := nil 
  local oOk      := nil
  local oCancel  := nil
  local cCompany := Space(50)
  local cBranch  := Space(50)

  DEFINE MSDIALOG oDlg FROM 0, 0 TO 135, 305 TITLE "Informe a Empresa e Filial" PIXEL //OF oMainWnd

    @ 000,000 BITMAP oBmp RESNAME "APLOGO" SIZE 65,37 NOBORDER PIXEL
    oBmp:Align := CONTROL_ALIGN_RIGHT

    @ 000,000 MSPANEL oPanel OF oDlg
    oPanel:Align := CONTROL_ALIGN_ALLCLIENT

    @ 005,005 SAY "Empresa" SIZE 060,007 OF oPanel PIXEL
    @ 013,005 MSGET cCompany SIZE 080,008 OF oPanel PIXEL

    @ 028,005 SAY "Filial" SIZE 053,007 OF oPanel PIXEL
    @ 036,005 MSGET cBranch SIZE 80,08 OF oPanel PIXEL

    DEFINE SBUTTON oOk FROM 053,027 TYPE 1 ENABLE OF oPanel PIXEL ;
      ACTION ( lOk := checkCompanyScreen(cCompany, cBranch, @aData), iif( lOk, oDlg:End(), ) )

    DEFINE SBUTTON oCancel FROM 053,057 TYPE 2 ENABLE OF oPanel PIXEL ACTION oDlg:End()

  ACTIVATE MSDIALOG oDlg CENTER

return lOk

/**
 * Valida o preenchimento da empresa e filial
 */
static function checkCompanyScreen(cCompany, cBranch, aData)

  local lOk := .F.

  cCompany := AllTrim(cCompany)
  cBranch  := AllTrim(cBranch)

  if Empty(cCompany) .or. Empty(cBranch)
    MsgAlert("Informe os códigos da Empresa/Filial")
  else    
    lOk   := .T.    
    aData := {cCompany,cBranch}
  endIf

return lOk
