#include "totvs.ch"
#include "fwprintsetup.ch"
#include "totvs.ch"
#include "parmtype.ch"
#include "rptdef.ch"
#include "rwmake.ch"

#define SETUP_TEXT_SIZE 400


/*/{Protheus.doc} LibPdfObj

Objeto para geracao de arquivos PDF
  
@author soulsys:victorhugo
@since 18/09/2021
/*/
class LibPdfObj from LibAdvplObj
  
  data oPrinter
  data cDirectory
  data cPdfFile
  data cFileName
  data lServer
  data lShowPdf
  data cEmail
  data oFontDefault
  data nSleep

  data H_LEFT
  data H_RIGHT
  data H_CENTER

  data V_CENTER
  data V_TOP
  data V_BOTTOM
  
  method newLibPdfObj() constructor
  
  method getFwMsPrinter()
  method getDirectory() 
  method setDirectory()
  method getPdfFile()
  method getFileName()
  method setFileName()
  method isServer()
  method isShowPdf()
  method setShowPdf()
  method getEmail()
  method setEmail()
  method getFontDefault()
  method setFontDefault() 	
  method getSleep()
  method setSleep()
  
  method setup()
  method setLandscape()
  method setPortrait()
  method say()
  method sayAlign()
  method line()
  method box()
  method bitmap()
  method startPage()
  method endPage()
  method setMargin()
  method create()
  method sendEmail()
  method clear()
  
endClass


/*/{Protheus.doc} newLibPdfObj

Construtor
  
@author soulsys:victorhugo
@since 18/09/2021
/*/
method newLibPdfObj(cFileName, cDirectory, lShowPdf) class LibPdfObj
  
  default cFileName	 := "PdfFile"
  default cDirectory := "\spool\"
  default lShowPdf	 := .F.
          
  ::newLibAdvplObj()	
  
  ::cFileName	   := cFileName
  ::cDirectory   := cDirectory
  ::lShowPdf	   := lShowPdf
  ::oFontDefault := TFont():new("Arial", 10, 10, nil, .F., nil, nil, nil, nil, .F.)
  ::nSleep	     := 500	

  ::H_LEFT       := 0
  ::H_RIGHT      := 1
  ::H_CENTER     := 2

  ::V_CENTER     := 0
  ::V_TOP        := 1
  ::V_BOTTOM     := 2
  
  setPdfFile(@self)
    
return self

/**
 * Carrega o objeto de impressao
 */
static function loadPrinter(oSelf)
  
  local lAdjustToLegacy	:= .T.
  local cPathInServer		:= nil
  local lDisabeSetup		:= .T. 
  local lTReport			  := .F.
  local oPrintSetup		  := nil
  local cPrinter			  := "" 
  local lPDFAsPNG			  := nil
  local lRaw				    := nil 
  local nQtdCopy			  := nil
  
  if (ValType(oSelf:oPrinter) == "O")
    return
  endIf
  
  setPdfFile(@oSelf)		 	 						
  
  if oSelf:lServer 
    cPathInServer := oSelf:cDirectory
  endIf
                       
  oSelf:oPrinter := FwMsPrinter():new(oSelf:cFileName, IMP_PDF, lAdjustToLegacy, cPathInServer, lDisabeSetup, lTReport, oPrintSetup, cPrinter, oSelf:lServer, lPDFAsPNG, lRaw, oSelf:lShowPdf, nQtdCopy)
  
  if oSelf:lServer
    oSelf:oPrinter:lServer := .T.
    oSelf:oPrinter:lInJob  := .T.
  else	
    oSelf:oPrinter:cPathPdf := oSelf:cDirectory
  endIf		
                  
  oSelf:oPrinter:setResolution(81)
  oSelf:oPrinter:setPortrait() 
  oSelf:oPrinter:setPaperSize(DMPAPER_A4) 
  oSelf:oPrinter:setMargin(10, 10, 10, 10)				

return

/**
 * Define o arquivo a ser gerado
 */
static function setPdfFile(oSelf)
  
  local oUtils := LibUtilsObj():newLibUtilsObj()
  
  oSelf:cFileName	:= FileNoExt(AllTrim(oSelf:cFileName))
  oSelf:cPdfFile  := oUtils:concatDirectory(@oSelf:cDirectory, oSelf:cFileName+".pdf")			
  oSelf:lServer 	:= oUtils:isOnServer(oSelf:cPdfFile)
  
  if oSelf:lServer
    oSelf:lShowPdf := .F.
  endIf	
  
return


/*/{Protheus.doc} getFwMsPrinter

Coleta o Objeto padrao de controle da impressao
  
@author soulsys:victorhugo
@since 18/09/2021
/*/
method getFwMsPrinter() class LibPdfObj	
  loadPrinter(@self)	
return ::oPrinter


/*/{Protheus.doc} getDirectory

Coleta o diretorio para gravacao do arquivo
  
@author soulsys:victorhugo
@since 18/09/2021
/*/
method getDirectory() class LibPdfObj
return ::cDirectory


/*/{Protheus.doc} setDirectory

Define o diretorio para gravacao do arquivo
  
@author soulsys:victorhugo
@since 18/09/2021
/*/
method setDirectory(cDirectory) class LibPdfObj
  ::cDirectory := AllTrim(cDirectory)
return


/*/{Protheus.doc} getPdfFile

Coleta o Arquivo PDF a ser gerado (com o diretorio e com a extensao)
  
@author soulsys:victorhugo
@since 18/09/2021
/*/
method getPdfFile() class LibPdfObj
return ::cPdfFile


/*/{Protheus.doc} getFileName

Coleta o Nome do PDF (sem o diretorio e sem a extensao)
  
@author soulsys:victorhugo
@since 18/09/2021
/*/
method getFileName() class LibPdfObj
return ::cFileName


/*/{Protheus.doc} setFileName

Define o Nome do PDF (sem o diretorio e sem a extensao)
  
@author soulsys:victorhugo
@since 18/09/2021
/*/
method setFileName(cFileName) class LibPdfObj
  ::cFileName := AllTrim(cFileName)
return


/*/{Protheus.doc} isServer

Indica se arquivo esta sendo gerado no Servidor
  
@author soulsys:victorhugo
@since 18/09/2021
/*/
method isServer() class LibPdfObj
return ::lServer


/*/{Protheus.doc} isShowPdf

Indica se Exibe o PDF apos a geracao
  
@author soulsys:victorhugo
@since 18/09/2021
/*/
method isShowPdf() class LibPdfObj
return ::lShowPdf


/*/{Protheus.doc} setShowPdf

Define se Exibe o PDF apos a geracao
  
@author soulsys:victorhugo
@since 18/09/2021
/*/
method setShowPdf(lShowPdf) class LibPdfObj
  ::lShowPdf := lShowPdf
return


/*/{Protheus.doc} getEmail

Coleta o e-mail para envio do Arquivo
  
@author soulsys:victorhugo
@since 18/09/2021
/*/
method getEmail() class LibPdfObj
return ::cEmail


/*/{Protheus.doc} setEmail

Define o e-mail para envio do Arquivo
  
@author soulsys:victorhugo
@since 18/09/2021
/*/
method setEmail(cEmail) class LibPdfObj
  ::cEmail := AllTrim(cEmail)
return


/*/{Protheus.doc} getFontDefault

Coleta a Fonte padrao do objeto
  
@author soulsys:victorhugo
@since 18/09/2021
/*/
method getFontDefault() class LibPdfObj
return ::oFontDefault


/*/{Protheus.doc} setFontDefault

Define a Fonte padrao do objeto
  
@author soulsys:victorhugo
@since 18/09/2021
/*/
method setFontDefault(oFontDefault) class LibPdfObj
  ::oFontDefault := oFontDefault
return


/*/{Protheus.doc} getSleep

Coleta o Tempo de Espera antes de gerar o PDF (milisegundos)
  
@author soulsys:victorhugo
@since 18/09/2021
/*/
method getSleep() class LibPdfObj
return ::nSleep


/*/{Protheus.doc} setSleep

Define o Tempo de Espera antes de gerar o PDF (milisegundos)
  
@author soulsys:victorhugo
@since 18/09/2021
/*/
method setSleep(nSleep) class LibPdfObj
  ::nSleep := nSleep
return


/*/{Protheus.doc} showSetupDialog

Exibe o Dialogo de Setup
  
@author soulsys:victorhugo
@since 18/09/2021
/*/
method setup(cTitle, oParamBox) class LibPdfObj

  local lOk				      := .F.
  local bValid			    := {|| validSetup(@self)}
  private oDlg			    := nil
  private oBmpPdf			  := nil
  private oBtnCancel		:= nil
  private oBtnOk			  := nil	
  private oBtnParams		:= nil
  private oBtnSearch		:= nil
  private oChkOnServer	:= nil
  private oSayDirectory	:= nil
  private oSayEmail		  := nil
  private oSayExtPdf		:= nil
  private oSayFile		  := nil
  private oChkShowPdf		:= nil
  private oGetDirectory	:= nil
  private oGetEmail		  := nil
  private oGetFileName	:= nil	
  private cGetFileName	:= PadR(::cFileName, SETUP_TEXT_SIZE)
  private cGetDirectory	:= PadR(::cDirectory, SETUP_TEXT_SIZE)
  private cGetEmail		  := PadR(::cEmail, SETUP_TEXT_SIZE) 
  default cTitle			  := "geracao de PDF"

  DEFINE MSDIALOG oDlg TITLE cTitle FROM 000, 000  TO 300, 460 PIXEL

    @ 012, 155 BITMAP oBmpPdf SIZE 080, 070 OF oDlg NOBORDER PIXEL
    oBmpPdf:load("soulsys-pdf-icon")
    
    @ 013, 006 SAY oSayFile PROMPT "Arquivo" SIZE 025, 007 OF oDlg PIXEL
    @ 023, 006 MSGET oGetFile VAR cGetFileName VALID Eval(bValid) SIZE 120, 010 OF oDlg PIXEL    
    @ 026, 127 SAY oSayExtPdf PROMPT ".pdf" SIZE 025, 007 OF oDlg PIXEL
    
    @ 040, 006 SAY oSayDirectory PROMPT "diretorio" SIZE 025, 007 OF oDlg PIXEL
    @ 050, 006 MSGET oGetDirectory VAR cGetDirectory VALID Eval(bValid) SIZE 120, 010 OF oDlg PIXEL    
    @ 050, 127 BUTTON oBtnSearch PROMPT "..." ACTION searchDirectory(@self) SIZE 012, 012 OF oDlg PIXEL
    
    @ 068, 006 CHECKBOX oChkOnServer VAR ::lServer PROMPT "Gerar no Servidor" SIZE 111, 008 OF oDlg PIXEL
    oChkOnServer:bWhen := {|| .F. }
    
    @ 080, 006 CHECKBOX oChkShowPdf VAR ::lShowPdf PROMPT "Abrir PDF apos a geracao" SIZE 112, 008 OF oDlg PIXEL
    oChkShowPdf:bWhen := {|| !::lServer }
    
    @ 097, 006 SAY oSayEmail PROMPT "Enviar para o(s) e-mail(s)" SIZE 135, 007 OF oDlg PIXEL
    @ 105, 006 MSGET oGetEmail VAR cGetEmail VALID Eval(bValid) SIZE 221, 010 OF oDlg PIXEL
    
    if (ValType(oParamBox) == "O")
      @ 130, 006 BUTTON oBtnParams PROMPT "parametros" ACTION oParamBox:show() SIZE 037, 012 OF oDlg PIXEL
    endIf	
    
    @ 130, 143 BUTTON oBtnCancel PROMPT "Cancelar" ACTION oDlg:end() SIZE 037, 012 OF oDlg PIXEL
    @ 130, 188 BUTTON oBtnOk PROMPT "Ok" ACTION {|| lOk := confirmSetup(@self) } SIZE 037, 012 OF oDlg PIXEL

  ACTIVATE MSDIALOG oDlg CENTERED	
  
return lOk

/**
 * Valida os Campos da Tela de Setup
 */
static function validSetup(oSelf)
  
  local lOk := .F.
  
  begin sequence
    
    if ("\" $ cGetFileName) .or. ("/" $ cGetFileName) .or. (":" $ cGetFileName) .or. (".pdf" $ Lower(cGetFileName))
      MsgBox("Informe apenas o nome do arquivo (sem extensao e sem o diretorio)", "Atencao", "ALERT") 
      break	
    endIf
    
    if !Empty(cGetDirectory) .and. !ExistDir(cGetDirectory)
      MsgBox("diretorio inv�lido", "Atencao", "ALERT") 
      break	
    endIf
    
    lOk := .T.
    
  end sequence
  
  if lOk
    oSelf:setFileName(cGetFileName)
    oSelf:setDirectory(cGetDirectory)
    oSelf:setEmail(cGetEmail)
    setPdfFile(@oSelf)
  endIf	
    
return lOk

/**
 * Pesquisa de diretorio
 */
static function searchDirectory(oSelf)
  
  local nMask 		   := nil
  local cTitle		   := "Selecione o diretorio"
  local nDefaultMask := 1
  local cStartDir		 := ""
  local lSave			   := .F.
  local nOptions		 := NOR(GETF_LOCALHARD, GETF_LOCALFLOPPY, GETF_NETWORKDRIVE, GETF_RETDIRECTORY)
  local lTree			   := .T.
  local lKeepCase		 := .T.	
  local cDirectory	 := cGetFile (nMask, cTitle, nDefaultMask, cStartDir, lSave, nOptions, lTree, lKeepCase)
  
  if !Empty(cDirectory)
    cGetDirectory := PadR(cDirectory, SETUP_TEXT_SIZE)
  endIf
  
  validSetup(@oSelf)
  
return
  
/**
 * confirmacao da tela de configuracao
 */
static function confirmSetup(oSelf)
  
  local lOk := .F.
  
  begin sequence
    
    if Empty(cGetFileName)
      MsgBox("Informe o nome do arquivo", "Atencao", "ALERT") 
      break	
    endIf
    
    if Empty(cGetDirectory)
      MsgBox("Informe o diretorio", "Atencao", "ALERT") 
      break	
    endIf
    
    lOk := .T.
    
  end sequence
  
  if lOk
    loadPrinter(@oSelf)	 
    oDlg:end()
  endIf		
  
return lOk
  

/*/{Protheus.doc} setLandscape

Define o layout do relatorio como paisagem
  
@author soulsys:victorhugo
@since 18/09/2021
/*/
method setLandscape() class LibPdfObj
  
  loadPrinter(@self)
  
  ::oPrinter:setLandscape()
  
return


/*/{Protheus.doc} setPortrait

Define o layout do relatorio como retrato
  
@author soulsys:victorhugo
@since 18/09/2021
/*/
method setPortrait() class LibPdfObj
  
  loadPrinter(@self)
  
  ::oPrinter:setPortrait()
  
return

  
/*/{Protheus.doc} say

Imprime um Texto
  
@author soulsys:victorhugo
@since 18/09/2021
/*/	
method say(nRow, nCol, cText, oFont, nWidth, nColor, nAngle, nAlign) class LibPdfObj		
  
  default oFont := ::oFontDefault
  
  loadPrinter(@self)
  
  ::oPrinter:say(nRow, nCol, cText, oFont, nWidth, nColor, nAngle, nAlign)
    
return


/*/{Protheus.doc} sayAlign

Imprime um Texto
  
@author soulsys:victorhugo
@since 18/09/2021
/*/	
method sayAlign(nRow, nCol, cText, oFont, nWidth, nHeight, nColor, nAlignHorz, nAlignVert) class LibPdfObj		
  
  default oFont := ::oFontDefault
  
  loadPrinter(@self)
  
  ::oPrinter:sayAlign(nRow, nCol, cText, oFont, nWidth, nHeight, nColor, nAlignHorz, nAlignVert)
    
return


/*/{Protheus.doc} line

Imprime uma linha
  
@author soulsys:victorhugo
@since 18/09/2021
/*/	
method line(nTop, nLeft, nBottom, nRight, nColor, cPixel) class LibPdfObj
  
  loadPrinter(@self)
  
  ::oPrinter:line(nTop, nLeft, nBottom, nRight, nColor, cPixel)

return

/*/{Protheus.doc} box

Imprime um quadrado
  
@author soulsys:victorhugo
@since 18/09/2021
/*/	
method box(nRow, nCol, nBottom, nRight, cPixel) class LibPdfObj
  
  loadPrinter(@self)
  
  ::oPrinter:box(nRow, nCol, nBottom, nRight, cPixel)
  
return


/*/{Protheus.doc} bitmap

impressao de um bitmap
  
@author soulsys:victorhugo
@since 18/09/2021
/*/
method bitmap(nRow, nCol, cBitmap, nWidth, nHeight) class LibPdfObj
  
  loadPrinter(@self)
  
  ::oPrinter:sayBitmap(nRow, nCol, cBitmap, nWidth, nHeight)
  
return


/*/{Protheus.doc} startPage

Inicia uma nova pagina
  
@author soulsys:victorhugo
@since 18/09/2021
/*/	
method startPage() class LibPdfObj
  
  loadPrinter(@self)
  
  ::oPrinter:startPage()
  
return


/*/{Protheus.doc} endPage

Encerra uma pagina
  
@author soulsys:victorhugo
@since 18/09/2021
/*/	
method endPage() class LibPdfObj
  
  loadPrinter(@self)
  
  ::oPrinter:endPage()
  
return


/*/{Protheus.doc} setMargin

Define as Margens de impressao
  
@author soulsys:victorhugo
@since 18/09/2021
/*/	
method setMargin(nLeft, nTop, nRight, nBottom) class LibPdfObj
  
  loadPrinter(@self)
  
  ::oPrinter:setMargin(nLeft, nTop, nRight, nBottom)
  
return
 

/*/{Protheus.doc} create

Cria o PDF
  
@author soulsys:victorhugo
@since 18/09/2021
/*/	
method create(lSendMail) class LibPdfObj	
  
  local lOk	 	      := .F.
   local oFile  	    := LibFileObj():newLibFileObj(::cPdfFile)	
   default lSendMail := .T.
  
  if oFile:exists() .and. !oFile:delete()
    MsgBox("Falha ao substituir arquivo "+AllTrim(::cPdfFile), "Atencao", "STOP")
    return .F.		
  endIf
  
  loadPrinter(@self)
  
  ::oPrinter:print()
  
  Sleep(::nSleep)  
  
  if oFile:exists()
    lOk := .T.
    eraseRelFile(self)
    if lSendMail
      ::sendEmail() 
    endIf
  else
    MsgBox("Falha ao gerar arquivo "+AllTrim(::cPdfFile)+". Verifique o diretorio definido para geracao do PDF", "Atencao", "STOP") 	
  endIf
  
  oFile:close()
  
return lOk

/**
 * Apaga o arquivo .rel deixado pela FwMsPrinter
 */
static function eraseRelFile(oSelf)
  
  local cFileName := AllTrim(oSelf:getFileName())
  local cRelFile  := "\spool\"+cFileName+".rel"
  local oFile     := LibFileObj():newLibFileObj(cRelFile)
  
  if oFile:exists()
    oFile:delete()
  endIf
  
  oFile:close()
  
return


/*/{Protheus.doc} sendEmail

Envia o PDF por e-mail
  
@author soulsys:victorhugo
@since 18/09/2021

@param cSubject, String, Assunto do E-mail
@param cBody, String, Corpo da Mensagem

@return Logico Indica se o e-mail foi enviado
/*/
method sendEmail(cSubject, cBody) class LibPdfObj
  
  local lOk 		  := .F.
  local cTo		    := ::getEmail()
  local cPdfFile	:= ::getPdfFile()
  local cFileName	:= ::getFileName()
  local cSrvFile	:= "\spool\"+AllTrim(cFileName)+".pdf"
  local lServer	  := ::isServer()
  local oFile		  := nil
  local oMail		  := LibMailObj():newLibMailObj()
  
  if Empty(cPdfFile) .or. Empty(cTo)
    return .F.
  else
    oFile := LibFileObj():newLibFileObj(cPdfFile)
    if !oFile:exists()
      return .F.
    endIf
  endIf
  
  if !lServer
    if oFile:copy(cSrvFile)
      oFile:close()
      oFile := LibFileObj():newLibFileObj(cSrvFile)
    else
      MsgBox("Falha ao copiar o arquivo "+cPdfFile+" para o servidor", "Atencao", "STOP")
      oFile:close()	 
      return .F.		
    endIf
  endIf
  
  if Empty(cSubject)
    cSubject := "Enviando arquivo "+cFileName+".pdf"
  endIf
  
  if Empty(cBody)
    cBody := "Enviado por "+cUserName
    Alert(cBody)
  endIf
  
  oMail:attachFile(oFile:getFile())
  
  lOk := oMail:send(cTo, cSubject, cBody)
  
  if lOk
    MsgBox("Arquivo "+oFile:getFile()+" enviado com sucesso para "+AllTrim(cTo), "Aviso", "INFO")
  else
    MsgBox(oMail:getError(), "Atencao", "ALERT")  
  endIf
  
  if !lServer
    oFile:delete()
  endIf
  
  oFile:close()
  
return lOk


/*/{Protheus.doc} clear

Limpa o objeto de impressao
  
@author soulsys:victorhugo
@since 18/09/2021
/*/
method clear() class LibPdfObj	
  ::oPrinter := nil	
return
