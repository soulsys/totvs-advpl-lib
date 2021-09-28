#include "totvs.ch"
#include "fileio.ch"
#include "rwmake.ch"

#define CHECK_FILE_MSG	"Verifique se o arquivo existe ou se esta sendo usado."		
 
 
/*/{Protheus.doc} LibFileObj
 
Objeto para manipulacao de Arquivos
  
@author soulsys:victorhugo
@since 18/09/2021
/*/
class LibFileObj from LibAdvplObj
  
  data cFile as string	
  data lOpen as boolean
  data aLines as array
  
  method newLibFileObj() constructor
  
  method getFile()
  method setFile()
  method isOpen()
  method getLines()
  
  method createFile()		
  method writeLine()
  method readLine()
  method saveLines()	
  method isEof()
  method notIsEof()
  method skipLine()
  method goTop()
  method open()
  method close()
  method delete()
  method copy()
  method countLines()
  method getFileName()
  method exists()
  method getFileSize()
  method getFileMegabytes()
  method getDirectory()
  
endClass


/*/{Protheus.doc} newLibFileObj

Construtor

@author soulsys:victorhugo
@since 18/09/2021
/*/
method newLibFileObj(cFile) class LibFileObj
  
  default cFile := ""
  
  ::newLibAdvplObj()
  
  ::setFile(cFile)

  ::lOpen := .F.	
  ::aLines:= {}
  
return	


/*/{Protheus.doc} getFile

Coleta o arquivo definido

@author soulsys:victorhugo
@since 18/09/2021
/*/
method getFile() class LibFileObj
return ::cFile


/*/{Protheus.doc} setFile

Define o arquivo do objeto

@author soulsys:victorhugo
@since 18/09/2021
/*/
method setFile(cFile) class LibFileObj
  ::cFile := AllTrim(cFile)
return


/*/{Protheus.doc} isOpen

Indica se o arquivo esta aberto

@author soulsys:victorhugo
@since 18/09/2021
/*/
method isOpen() class LibFileObj
return ::lOpen


/*/{Protheus.doc} getLines

Coleta todas as linhas do arquivo

@author soulsys:victorhugo
@since 18/09/2021
/*/
method getLines() class LibFileObj
return ::aLines


/*/{Protheus.doc} createFile

Cria o Arquivo
  
@author soulsys:victorhugo
@since 18/09/2021
/*/
method createFile() class LibFileObj
  
  local cFile		:= ::getFile()
  local nHandle := -1
  
  if !File(cFile)
    nHandle := createFile(cFile)
  endIf	
  
return (nHandle != -1)

/**
 * Cria o arquivo sem alterar o nome
 */
static function createFile(cFile)
  
  local lChangeCase := .F.
  
return FCreate(cFile, nil, nil, lChangeCase)


/*/{Protheus.doc} writeLine

Gravacao de linhas no arquivo

@author soulsys:victorhugo
@since 18/09/2021
/*/
method writeLine(cText) class LibFileObj
  
  local nHandle := 0                        
  local lWrite	:= .T.
  local cFile		:= ::getFile()
  default cText := ""	                    
  
  if !File(cFile)
    nHandle := createFile(cFile)
  else
    nHandle := FOpen(cFile, FO_READWRITE)
    FSeek(nHandle, 0, 2)
  Endif
  
  if (nHandle == -1)
    lWrite := .F.
  else
    cText += CRLF
    if FWrite(nHandle, cText, Len(cText)) != Len(cText)
      lWrite := .F.
    endIf
  endIf
      
  FClose(nHandle)
  
  if !lWrite
    MsgBox("Falha na gravacao do arquivo "+cFile, "Erro", "STOP")
  endIf
  
return lWrite


/*/{Protheus.doc} readLine

Leitura de linhas do arquivo. 
Esse metodo trabalha como a funcao SubString(), possibilitando a leitura da linha toda ou de apenas uma parte.

@author soulsys:victorhugo
@since 18/09/2021
/*/
method readLine(nCol, nChrs) class LibFileObj
  
  local cLine  := ""	
  default nCol := 0
  default nChrs:= 0
  
  if !::open()
    return ""
  endIf
  
  cLine := FT_FreadLn()
  
  if (nCol > 0)
    if (nChrs == 0)
      nChrs := Len(cLine)
    endIf
    cLine := SubStr(cLine, nCol, nChrs)		
  endIf	
  
return cLine


/*/{Protheus.doc} saveLines

Salva todas as linhas do arquivo em um array. 
Para coletar as linhas utilize o metodo getLines().

@author soulsys:victorhugo
@since 18/09/2021
/*/
method saveLines() class LibFileObj
  
  ::aLines := {}
  
  if ::open()
    ::goTop()
    while !::isEof()
      aAdd(::aLines, ::readLine())	
      ::skipLine()
    endDo
    ::goTop()
  endIf	
  
return
  

/*/{Protheus.doc} isEof

Indica se esta no final do arquivo

@author soulsys:victorhugo
@since 18/09/2021
/*/
method isEof() class LibFileObj
  
  local lEof := .F.
  
  if ::isOpen() 
    lEof := FT_Feof()
  endIf
  
return lEof


/*/{Protheus.doc} notIsEof

Indica se nao esta no final do arquivo

@author soulsys:victorhugo
@since 18/09/2021
/*/
method notIsEof() class LibFileObj		
return !::isEof()


/*/{Protheus.doc} skipLine

Avanca uma linha

@author soulsys:victorhugo
@since 18/09/2021
/*/
method skipLine() class LibFileObj
  
  if !::open()
    return .F.
  endIf
  
  FT_Fskip()
  
return .T.


/*/{Protheus.doc} goTop

Posiciona na primeira linha do arquivo

@author soulsys:victorhugo
@since 18/09/2021
/*/
method goTop() class LibFileObj		
  
  if !::open()
    return .F.
  endIf
  
  FT_FgoTop()
      
return .T.


/*/{Protheus.doc} open

Abre o arquivo

@author soulsys:victorhugo
@since 18/09/2021
/*/
method open() class LibFileObj
  
  local cFile := ::getFile()
  
  if !::isOpen()
    if (FT_Fuse(cFile) == -1)
      MsgBox("nao foi possivel abrir o arquivo "+cFile+"."+CRLF+CHECK_FILE_MSG, "Erro", "STOP")			
    else
      ::lOpen := .T.
      ::goTop()			
    endIf
  endIf
  
return ::isOpen()


/*/{Protheus.doc} close

Fecha o arquivo

@author soulsys:victorhugo
@since 18/09/2021
/*/
method close() class LibFileObj
  
  if ::isOpen()
    FT_Fuse()
    ::lOpen := .F.
  endIf
  
return


/*/{Protheus.doc} delete

Apaga o arquivo

@author soulsys:victorhugo
@since 18/09/2021
/*/
method delete() class LibFileObj
  
  local lOk	:= .T.
  local cFile := ::getFile()	
  
  if (FErase(cFile) == -1)
    lOk := .F.		
  endIf
  
return lOk


/*/{Protheus.doc} copy

Realiza a copia o arquivo

@author soulsys:victorhugo
@since 18/09/2021
/*/
method copy(cNewFile) class LibFileObj
  
  local nI  := 0
  local lOk := .F.
  
  if !::exists()
    return .F.
  endIf
  
  __CopyFile(::getFile(), cNewFile)

  for nI := 1 to 5
    if File(cNewFile)		
      lOk := .T.
      exit
    endIf
    Sleep(3000)
  next nI

return lOk


/*/{Protheus.doc} countLines

Retorna a quantidade total de linhas do arquivo

@author soulsys:victorhugo
@since 18/09/2021
/*/
method countLines() class LibFileObj
  
  local nLines := 0
  
  if ::open()
    ::goTop()
    while !::isEof()
      nLines++
      ::skipLine()
    endDo
    ::goTop()
  endIf
    
return nLines


/*/{Protheus.doc} getFileName

Retorna o nome do arquivo sem o diretorio

@author soulsys:victorhugo
@since 18/09/2021
/*/
method getFileName(lExtens, cBar) class LibFileObj
  
  local nI		    := 0
  local cChr  	  := ""
  local cAux  	  := ""
  local cName 	  := ""
  local cFile 	  := AllTrim(Lower(::getFile()))
  default lExtens := .T.
  default cBar  	:= if(IsSrvUnix(), "/", "\")
  
  for nI := Len(cFile) to 1 step -1
    cChr := SubStr(cFile, nI, 1)
    if (cChr != cBar)
      cAux += cChr
    else
      exit
    endIf
  next nI
  
  for nI := Len(cAux) to 1 step -1
    cName += SubStr(cAux, nI, 1)
  next nI
  
  if !lExtens
    cName := FileNoExt(cName)
  endif
  
return cName


/*/{Protheus.doc} exists

Verifica se o arquivo existe

@author soulsys:victorhugo
@since 18/09/2021
/*/
method exists() class LibFileObj
    
return File(::getFile())


/*/{Protheus.doc} getFileSize

Coleta o tamanho do arquivo em bytes
  
@author soulsys:victorhugo
@since 18/09/2021
/*/
method getFileSize() class LibFileObj
  
  local nSize	  := 0
  local cFile	  := ::getFile()
  local oReader := FwFileReader():new(cFile)
  
  if oReader:open()
    nSize := oReader:getFileSize()
  endIf
  
  oReader:close()
  
return nSize


/*/{Protheus.doc} getFileMegabytes

Retorna o tamanho do arquivo em megabytes
  
@author soulsys:victorhugo
@since 18/09/2021
/*/
method getFileMegabytes() class LibFileObj
  
  local nMegabytes := 0
  local nConv      := 1024	
  local nBytes     := ::getFileSize()
  
  if (nBytes >= nConv)
    nMegabytes := ((nBytes / nConv) / nConv)
  endIf

return nMegabytes


/*/{Protheus.doc} getDirectory

Retorna o diretorio do arquivo
  
@author soulsys:victorhugo
@since 18/09/2021
/*/
method getDirectory() class LibFileObj
  
  local cFile := AllTrim(Lower(::getFile()))
  local cName := AllTrim(Lower(::getFileName()))
  
return StrTran(cFile, cName, "")
