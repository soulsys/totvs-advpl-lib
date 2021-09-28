#include "totvs.ch"

 
/*/{Protheus.doc} LibAdvplObj
 
Objeto pai de todos os objetos da LibAdvpl
  
@author soulsys:victorhugo
@since 18/09/2021 
/*/
class LibAdvplObj
  
  method newLibAdvplObj() constructor
  
  method isInJob()
  
endClass


/*/{Protheus.doc} newLibAdvplObj

Construtor

@author soulsys:victorhugo
@since 18/09/2021
/*/
method newLibAdvplObj() class LibAdvplObj
return	


/*/{Protheus.doc} isInJob

Indica se o Protheus esta sendo executado em Job (sem interface visual)
  
@author soulsys:victorhugo
@since 18/09/2021
/*/
method isInJob() class LibAdvplObj
return (Type("oMainWnd") != "O")
