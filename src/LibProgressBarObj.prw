#include "totvs.ch"
#include "rwmake.ch"

#define DEFAULT_TITLE "Aguarde"
#define DEFAULT_TEXT  "Processando..."


/*/{Protheus.doc} LibProgressBarObj

Objeto para manipulacao de barras de progresso

@author soulsys:victorhugo
@since 23/05/2023
/*/
class LibProgressBarObj from SysLibAdvpl
  
  data oBar

  data lTwoBars
  data lHidden
  
  data bAction
  data cTitle
  data cText

  method newLibProgressBarObj() constructor
  method setTwoBars()
  method setHidden()
  method setAction()  
  method start()
  method setSteps()
  method increment()
  method setFirstBarSteps()
  method setSecondBarSteps()
  method incrementFirstBar()
  method incrementSecondBar()

endClass


/*/{Protheus.doc} newLibProgressBarObj

Construtor

@author soulsys:victorhugo
@since 23/05/2023
/*/
method newLibProgressBarObj(bAction, cText, cTitle) class LibProgressBarObj
  
  _Super:new()  
  
  ::oBar     := nil
  ::lTwoBars := .F.
  ::lHidden  := IsBlind()

  ::setAction(bAction, cText, cTitle)

return


/*/{Protheus.doc} setTwoBars

Define que o processamento sera controlado atraves de duas barras

@author soulsys:victorhugo
@since 23/05/2023
/*/
method setTwoBars(lTwoBars) class LibProgressBarObj  
  ::lTwoBars := lTwoBars
return


/*/{Protheus.doc} setHidden

Define que o processamento sera realizado sem interface visual

@author soulsys:victorhugo
@since 23/05/2023
/*/
method setHidden(lHidden) class LibProgressBarObj
  ::lHidden := lHidden
return


/*/{Protheus.doc} setAction

Define a acao a ser executada

@author soulsys:victorhugo
@since 23/05/2023
/*/
method setAction(bAction, cText, cTitle) class LibProgressBarObj
    
  default cText  := DEFAULT_TEXT
  default cTitle := DEFAULT_TITLE

  ::bAction := bAction
  ::cTitle  := cTitle
  ::cText   := cText

return


/*/{Protheus.doc} start

Inicia o processamento

@author soulsys:victorhugo
@since 23/05/2023
/*/
method start() class LibProgressBarObj

  local lCanAbort := .F.

  if ::lHidden
    Eval(::bAction)
    return
  endIf

  if ::lTwoBars
    ::oBar := MsNewProcess():new(::bAction, ::cTitle, ::cText, lCanAbort)
    ::oBar:activate()
  else
    Processa(::bAction, ::cTitle, ::cText, lCanAbort)
  endIf  

return


/*/{Protheus.doc} setSteps

Define a quantidade de etapas do processamento

@author soulsys:victorhugo
@since 23/05/2023
/*/
method setSteps(nSteps) class LibProgressBarObj
  ProcRegua(nSteps)
return


/*/{Protheus.doc} increment

Incrementa o progresso

@author soulsys:victorhugo
@since 23/05/2023
/*/
method increment(cText) class LibProgressBarObj  
  default cText := DEFAULT_TEXT
  IncProc(cText)
return


/*/{Protheus.doc} setSteps

Define a quantidade de etapas do processamento primeira da barra

@author soulsys:victorhugo
@since 23/05/2023
/*/
method setFirstBarSteps(nSteps) class LibProgressBarObj
  ::oBar:setRegua1(nSteps)
return


/*/{Protheus.doc} setSteps

Define a quantidade de etapas do processamento segunda da barra

@author soulsys:victorhugo
@since 23/05/2023
/*/
method setSecondBarSteps(nSteps) class LibProgressBarObj
  ::oBar:setRegua2(nSteps)
return


/*/{Protheus.doc} incrementFirstBar

Incrementa o progresso da primeira barra

@author soulsys:victorhugo
@since 23/05/2023
/*/
method incrementFirstBar(cText) class LibProgressBarObj  
  default cText := DEFAULT_TEXT
  ::oBar:incRegua1(cText)
return


/*/{Protheus.doc} incrementSecondBar

Incrementa o progresso da segunda barra

@author soulsys:victorhugo
@since 23/05/2023
/*/
method incrementSecondBar(cText) class LibProgressBarObj
  default cText := DEFAULT_TEXT
  ::oBar:incRegua2(cText)
return
