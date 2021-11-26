## Exemplo de Controle de Log

A classe [LibLogObj](#) tem por objetivo facilitar o controle de logs. 

```cpp
user function LogFileSample()

  local cFile := "my.log"
  local oLog  := LibLogObj():newLibLogObj(cFile)

  oLog:setShowCompany(.T.)
  oLog:setShowThreadId(.T.)

  oLog:info("Mensagem tipo INFO")
  oLog:warn("Mensagem tipo WARN")
  oLog:debug("Mensagem tipo DEBUG")
  oLog:lineBreak(2)
  oLog:error("Mensagem tipo ERROR")

return
```

Também permite a exibição de mensagens no console do appserver.

```cpp
user function LogConsoleSample()

  local oLog := LibLogObj():newLibLogObj()

  oLog:setWriteFile(.F.)
  oLog:setConsole(.T.)  

  oLog:debug("Mensagem tipo DEBUG exibida somente no console do appserver")

return
```

Para trabalhar com mensagens via console não se esqueça de habilitar a chave FWLOGMSG_DEBUG=1, 
conforme descrito [aqui](https://centraldeatendimento.totvs.com/hc/pt-br/articles/360041301114-MP-ADVPL-Como-Ativar-a-função-FWLogMsg-).

<br/>

[Voltar](../index)