#include "totvs.ch"


/*/{Protheus.doc} LibTReportsObj

Servico para interacao com API do TReports
    
@author soulsys:waldiresmerio
@since 10/04/2023
/*/
class LibTReportsObj from LibAdvplObj

  data cErrorMessage
  data cAuthToken
  data cTReportsUrl
  data cProtheusWsUrl
  data cUserName
  data cPassword

  method newLibTReportsObj() constructor
	
  method getAuthToken()
  method genereateReport()
  method downloadReport()
  method getReport()
  
endClass


/*/{Protheus.doc} newLibTReportsObj

Construtor

@author soulsys:waldiresmerio
@since 10/04/2023
/*/
method newLibTReportsObj() class LibTReportsObj

  local oConfig := getConfig()

  ::cErrorMessage  := ""
  ::cTReportsUrl   := oConfig["treports_url"]
  ::cProtheusWsUrl := oConfig["protheus_ws_url"]
  ::cUserName      := oConfig["user_name"]
  ::cPassword      := oConfig["password"]

return self


/*/{Protheus.doc} getAuthToken

Obtem o token de autenticacao da API do TReports

@author soulsys:waldiresmerio
@since 10/04/2023
/*/
method getAuthToken() class LibTReportsObj

  local cPath      := "/api/oauth2/v1/token"
  local aHeaders   := {"Content-Type: application/json"}
  local oApi       := FwRest():new(::cProtheusWsUrl)
  local oResponse  := nil

  if !Empty(::cAuthToken)
    return ::cAuthToken
  endIf

  If (!Empty(::cUserName) .and. !Empty(::cPassword))
    cPath += "?grant_type=password&username=" + ::cUserName + "&password=" + ::cPassword
  else 
    ::cErrorMessage := "Arquivo config.json configurado incorretamente"
    return ""
  endIf

   oApi:setPath(cPath)
   oApi:setChkStatus(.F.)

  if !oApi:post(aHeaders)
    setApiErrorMessage(@self, oApi, cPath)
    return ""
  endIf

  oResponse := getResponse(oApi)

  ::cAuthToken := oResponse["access_token"]
  
  if Empty(::cAuthToken)
    setApiErrorMessage(@self, oApi, cPath, oResponse)
  endIf

return ::cAuthToken


/*/{Protheus.doc} genereateReport

Gera relatorio a partir do ID

@author soulsys:waldiresmerio
@since 10/04/2023
/*/
method genereateReport(cReportId, oParams) class LibTReportsObj

  local cBody         := ""
  local cGenerationId := ""
  local cPath         := "/resources/" + cReportId + "/generate"
  local aHeaders      := {}
  local oApi          := FwRest():new(::cTReportsUrl)
  default oParams     := JsonObject():new()

  if Empty(::cAuthToken)
    ::cAuthToken := self:getAuthToken()
  endIf

  aAdd(aHeaders, "Content-Type: application/json")
  aAdd(aHeaders, "Authorization: Bearer " + ::cAuthToken)

  cBody := oParams:toJson()

  oApi:setPath(cPath)
  oApi:setPostParams(cBody)
  oApi:setChkStatus(.F.)
  
  if !oApi:post(aHeaders)
    setApiErrorMessage(@self, oApi, cPath)
    return ""
  endIf

  cGenerationId := StrTran(oApi:getResult(), '"',"")

return cGenerationId


/*/{Protheus.doc} downloadReport

Baixa relatorio a partir do Generation ID

@author soulsys:waldiresmerio
@since 10/04/2023
/*/
method downloadReport(cGenerationId, oSetup) class LibTReportsObj

  local cFormat   := ""
  local cFolder   := ""
  local cFile     := ""
  local cPath     := ""
  local aHeaders  := {}
  local lIsUnix   := (GetRemoteType() == 2)
  local lOpenFile := .F.
  local oFile     := nil
  local oApi      := FwRest():new(::cTReportsUrl)
  local oUtils    := LibUtilsObj():newLibUtilsObj()
  default oSetup  := JsonObject():new()

  cFormat   := oUtils:whenIsNull(oSetup["format"], "pdf")
  cFolder   := oUtils:whenIsNull(oSetup["folder"], GetTempPath())
  lOpenFile := oUtils:whenIsNull(oSetup["openFile"], .T.)

  if !(Right(AllTrim(cFolder), 1) $ "\/")
    cFolder += "\"
  endIf

  if lIsUnix
    cFolder := "l:" + StrTran(cFolder, "\", "/")
  endIf

  cFile := cFolder + cGenerationId + "." + cFormat

  cPath := "/generated/" + cGenerationId + "/" + cFormat
  
  if Empty(::cAuthToken)
    ::cAuthToken := self:getAuthToken()
  endIf

  aAdd(aHeaders, "Content-Type: application/json")
  aAdd(aHeaders, "Authorization: Bearer " + ::cAuthToken)

  oApi:setPath(cPath)
  oApi:setChkStatus(.F.)
  
  if !oApi:get(aHeaders)
    setApiErrorMessage(@self, oApi, cPath)
    return .F.
  endIf

  oFile := FwFileWriter():new(cFile)

  if oFile:create()
    oFile:write(oApi:getResult())
    oFile:close()
  else
    ::cErrorMessage := "O arquivo não foi criado (Erro: " + oUtils:strAnyType(oFile:error()) + ")"
  endIf
  
  if lOpenFile
    QA_OpenArq(cFile)
  endIf

return .T.


/*/{Protheus.doc} getReport

Gera e baixa um relatorio TReports

@author soulsys:waldiresmerio
@since 10/04/2023
/*/
method getReport(cReportId, oParams, oSetup) class LibTReportsObj

  local cGenerationId := ::genereateReport(cReportId, oParams)

  if Empty(cGenerationId)
    return .F.
  endIf

return ::downloadReport(cGenerationId, oSetup)

/**
* Obtem configurações do TReports
*/
static function getConfig()

  local cConfig := ""
  local cFile   := "\treports\config.json"
  local oConfig := JsonObject():new()
  local oFile   := FwFileReader():new(cFile)

  if oFile:open()
    cConfig := oFile:fullRead()
    oConfig:fromJson(cConfig)
    oFile:close()
  else
    ::cErrorMessage := "Falha na abertura do arquivo '" + cFile + "'"
  endIf

return oConfig

/**
 * Retorna o resultado de uma requisição
 */
static function getResponse(oApi)
  
  local oResponse := JsonObject():new()
  local cResult   := oApi:getResult()  

  oResponse:fromJson(cResult)

return oResponse

/**
 * Define a mensagem de erro da API
 */
static function setApiErrorMessage(oSelf, oApi, cRequest, oResponse)

  local cLog      := ""
  local cFolder   := "\treports\logs\"
  local cFileName := "error_" + DtoS(Date()) + "_" + StrTran(Time(),":","") + ".log"
  local oUtils    := LibUtilsObj():newLibUtilsObj()

  oSelf:cErrorMessage := ""
  
  if oUtils:isNotNull(oApi)
    oSelf:cErrorMessage := oApi:getLastError() + CRLF + oApi:getResult()
  endIf
  
  cLog := "Error Message: " + oSelf:cErrorMessage

  if !Empty(cRequest)
    cLog += CRLF + CRLF
    cLog += "Request: " + cRequest
  endIf

  if oUtils:isNotNull(oResponse)
  
    cLog += CRLF + CRLF
    cLog += "Response: " + oResponse:toJson()
    
    if Empty(oSelf:cErrorMessage)
      oSelf:cErrorMessage := oResponse:toJson()
    endIf
  
  endIf

  if !ExistDir(cFolder)
    MakeDir(cFolder)
  endIf

  MemoWrite(cFolder + cFileName, cLog)

return
