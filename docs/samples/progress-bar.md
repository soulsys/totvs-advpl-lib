## Exemplo de Manipulação de Barras de Progresso

A classe [SysLibProgressBar](#) tem como objetivo facilitar a manipulação de barras de progresso.

```cpp
/**
 * Teste da classe SysLibProgressBar com uma barra de progresso
 */
user function TstPrgBar1()

  local oBar := SysLibProgressBar():new()

  oBar:setAction({|| runSimpleProcess(oBar) })
  oBar:start()

  MsgInfo("Done")

return

/**
 * Processamento usando a classe SysLibProgressBar com uma barra de progresso
 */
static function runSimpleProcess(oBar)

  local nI     := 0
  local nSteps := 40

  oBar:setSteps(nSteps)

  for nI := 1 to nSteps

    oBar:increment()

    Sleep(500)

  next nI

return .T.


/**
 * Teste da classe SysLibProgressBar com duas barras de progresso
 */
user function TstPrgBar2()

  local cText  := "Starting..."
  local cTitle := "SysLibProgressBar - Two Bars"
  local oBar   := SysLibProgressBar():new()

  oBar:setAction({|| runComplexProcess(oBar) }, cText, cTitle)
  oBar:setTwoBars(.T.)
  oBar:start()

  MsgInfo("Done")

return

/**
 * Processamento usando a classe SysLibProgressBar com duas barras de progresso
 */
static function runComplexProcess(oBar)

  local nI     := 0
  local nSteps := 3

  oBar:setFirstBarSteps(nSteps)

  for nI := 1 to nSteps

    oBar:incrementFirstBar("Step " + AllTrim(Str(nI)))

    runSubProcess(oBar)

  next nI

return

/**
 * Exemplo de subprocesso para teste da classe SysLibProgressBar com duas barras de progresso
 */
static function runSubProcess(oBar)

  local nI     := 0
  local nSteps := 10

  oBar:setSecondBarSteps(nSteps)

  for nI := 1 to nSteps

    oBar:incrementSecondBar("Doing something at " + AllTrim(Str(nI)) + " of " + AllTrim(Str(nSteps)) + " ...")

    Sleep(500)

  next nI

return
```

Essa classe é uma abstração da função [Processa](https://tdn.totvs.com/pages/releaseview.action?pageId=727933986) e da
classe [MsNewProcess](https://tdn.totvs.com/display/public/framework/MsNewProcess).

<br/>

[Voltar](../index)
