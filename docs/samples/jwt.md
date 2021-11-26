## Exemplo de implementação de JSON Web Tokens

A classe [LibJwtObj](#) permite a manipulação de tokens de autenticação através 
do padrão [JWT (JSON Web Tokens)](https://jwt.io).

```cpp
#include "totvs.ch"

#define DAYS_TO_EXPIRE_TOKEN  1
#define TOKEN_PASSWORD        "!token#p@$$w0rd"

user function JwtSample()
  
  local cToken   := createToken()  
  local oPayload := decodeToken(cToken)

  MsgInfo(oPayload:toJson())

return

static function createToken()

  local oPayload := JsonObject():new()
  local oJwt	   := LibJwtObj():newLibJwtObj()

  oPayload["userId"]    := RetCodUsr()
  oPayload["expiresAt"] := DtoS(dDatabase + DAYS_TO_EXPIRE_TOKEN)
	
return oJwt:encode(oPayload:toJson(), TOKEN_PASSWORD)

static function decodeToken(cToken)

  local oPayload := JsonObject():new()
  local oJwt     := LibJwtObj():newLibJwtObj()
  local cData    := oJwt:decode(cToken, TOKEN_PASSWORD)  

  oPayload:fromJson(cData)

return oPayload
```

<br/>

[Voltar](../index)