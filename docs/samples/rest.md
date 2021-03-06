## Exemplo de implementação de Web Service REST

Criamos as classes [LibWsRestRequestObj](#) e [LibWsRestResponseObj](#) para facilitar a 
manipulação de requisições em [web services REST](https://tdn.totvs.com/display/framework/02.+Criando+uma+classe+REST).

```cpp
wsMethod POST wsService MyRestApi

  local lOk       := .F.
  local oRequest  := LibWsRestRequestObj():newLibWsRestRequestObj(self)
  local oResponse := LibWsRestResponseObj():newLibWsRestResponseObj(self)
  local oBody     := oRequest:getBody()  
  local oService  := MyService():newMyService()

  if oService:save(oBody)
    lOk := .T.
    oResponse:success()
  else
    oResponse:badRequest(oService:getError())
  endIf

return lOk
```

<br/>

[Voltar](../index)