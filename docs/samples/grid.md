## Exemplo de Manipulação de Grids

A classe [SysLibGrid](#) tem como objetivo facilitar a manipulação de grids para visualização e edição de dados.

```cpp
user function GridSample()

  local oDlg       := nil
  local oGrid      := nil
  local oGetFilter := nil
  local cFilter	   := Space(500)

  DEFINE MSDIALOG oDlg TITLE "SysLibGrid" FROM 001,001 TO 360,800 PIXEL OF oMainWnd

    createGrid(@oGrid, oDlg)

    @ 160,006 BUTTON "Marca Todos" SIZE 35,12 ACTION {|| oGrid:markAll() } PIXEL OF oDlg
    @ 160,046 BUTTON "Rem. Linha" SIZE 35,12 ACTION {|| oGrid:removeLine() } PIXEL OF oDlg
    @ 160,086 BUTTON "Rem. Todos" SIZE 35,12 ACTION {|| oGrid:clear() } PIXEL OF oDlg

    @ 160,210 MSGET oGetFilter VAR cFilter HASBUTTON SIZE 105,010 PIXEL OF oDlg
    @ 160,320 BUTTON "Filtrar" SIZE 35,12 ACTION {|| oGrid:filter(cFilter) } PIXEL OF oDlg
    @ 160,360 BUTTON "Limpar" SIZE 35,12 ACTION {|| oGrid:clearFilter() } PIXEL OF oDlg

  ACTIVATE MSDIALOG oDlg CENTERED

return

/**
 * Criação do grid
 */
static function createGrid(oGrid, oDlg)

  local nCol    := 5
  local nRow    := 20
  local nWidth  := 400
  local nHeight := 150
  local oCol    := nil

  oGrid := SysLibGrid():new(nCol, nRow, nWidth, nHeight, oDlg)
  oGrid:addMarkColumn({|| MsgInfo("onMark") }, {|| MsgInfo("onMarkAll"), oDlg:refresh() })
  oGrid:addBmpColumn("bmp")
  oGrid:addColumn("B1_COD")
  oGrid:addColumn("B1_DESC")

  oCol := SysLibColumn():new("price", "Preço", "N", 25, 2, "@E 999,999,999.99")
  oCol:setValidation("Positivo()")
  oGrid:addColumn(oCol)

  oGrid:newLine()
  oGrid:setMarkedLine(.T.)
  oGrid:setBmpValue("bmp", "BR_VERDE")
  oGrid:setValue("B1_COD", "P0001")
  oGrid:setValue("B1_DESC", "PRODUTO TESTE 1")
  oGrid:setValue("price", 1234.56)

  oGrid:create()

return
```

Essa classe é uma abstração da [MsNewGetDados](https://tdn.totvs.com/display/framework/MsNewGetDados) que foi **depreciada** pela TOTVS.
Entretanto, a _SysLibGrid_ torna-se útil em casos em que se deseja ter um grid não vinculado ao dicionário de dados.

<br/>

[Voltar](../index)
