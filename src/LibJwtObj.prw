#include "totvs.ch"
#include "rwmake.ch"

#define DEFAULT_JWT_SECRET 	"#LibJwtObj@!" 

#define ALGORITHM_MD5		  1
#define ALGORITHM_SHA1		3
#define ALGORITHM_SHA256	5
#define ALGORITHM_SHA512	7

#define RAW_HASH  1
#define HEX_HASH	2


/*/{Protheus.doc} LibJwtObj

Objeto para manipulacao de tokens no padrao JWT
    
@author soulsys:victorhugo
@since 18/09/2021
/*/
class LibJwtObj

  data cError
  
  method newLibJwtObj() constructor
  method encode()
  method decode()
  method getError()
  
endClass


/*/{Protheus.doc} newLibJwtObj

Construtor
    
@author soulsys:victorhugo
@since 18/09/2021
/*/
method newLibJwtObj() class LibJwtObj

  ::cError := ""
  
return self


/*/{Protheus.doc} encode

Gera um token
  
@author soulsys:victorhugo
@since 18/09/2021
/*/
method encode(cPayload, cSecret, nAlgorithm) class LibJwtObj
  
  local cToken		   := ""
  local cSignature	 := ""	
  local cHeader		   := ""
  default cSecret 	 := DEFAULT_JWT_SECRET
  default nAlgorithm := ALGORITHM_SHA256
  
  ::cError   := ""	
  cHeader    := createHeader(nAlgorithm)
  cSignature := createSignature(cHeader, cPayload, cSecret, nAlgorithm)
  cToken     := Encode64(cHeader) + "." + Encode64(cPayload) + "." + Encode64(cSignature)

return cToken

/**
 * Cria o header do token
 */
static function createHeader(nAlgorithm)
return '{ "type": "jwt", "alg": "' + getAlgorithmStr(nAlgorithm) + '" }'

/**
 * Retorna o ID de um tipo de algoritimo
 */
static function getAlgorithmStr(nAlgorithm)

  local cStr := ""
  
  if (nAlgorithm == ALGORITHM_MD5)
    cStr := "md5"
  elseIf (nAlgorithm == ALGORITHM_SHA1)
    cStr := "sha1"
  elseIf (nAlgorithm == ALGORITHM_SHA256)
    cStr := "sha256"
  elseIf (nAlgorithm == ALGORITHM_SHA512)
    cStr := "sha512"
  endIf

return cStr 

/**
 * Cria uma assinatura para o token
 */
static function createSignature(cHeader, cPayload, cSecret, nAlgorithm)
return HMAC(Encode64(cHeader) + "." +  Encode64(cPayload), cSecret, nAlgorithm, RAW_HASH)


/*/{Protheus.doc} decode

Obtem os dados de um token
  
@author soulsys:victorhugo
@since 18/09/2021
/*/
method decode(cToken, cSecret, nAlgorithm) class LibJwtObj
  
  local aData      		   := StrTokArr(cToken, ".")
  local cHeader			     := ""
  local cValidHeader	   := ""	
  local cPayload   		   := ""
  local cSignature 		   := ""
  local cValidSignature  := ""
  local cDecodedPayload  := ""	
  default cSecret 		   := DEFAULT_JWT_SECRET
  default nAlgorithm		 := ALGORITHM_SHA256
  
  ::cError := ""
  
  if Empty(aData) .or. Len(aData) != 3
    ::cError := "Invalid token"
    return ""
  endIf	
  
  cHeader			    := aData[1]	
  cPayload   		  := aData[2]
  cSignature 		  := aData[3]		
  cDecodedPayload := Decode64(cPayload)
  cValidHeader    := createHeader(nAlgorithm)
  cValidSignature := createSignature(cValidHeader, cDecodedPayload, cSecret, nAlgorithm)	
  cValidHeader	  := Encode64(cValidHeader)
  cValidSignature := Encode64(cValidSignature)
  
  if !(cHeader == cValidHeader .and. cSignature == cValidSignature)
    cDecodedPayload := ""
    ::cError 		    := "Invalid signature"
  endIf	
  
return cDecodedPayload


/*/{Protheus.doc} getError

Retorna a mensagem de erro do objeto
  
@author soulsys:victorhugo
@since 18/09/2021
/*/
method getError() class LibJwtObj
return ::cError

