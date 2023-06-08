## Exemplo de geração de relatórios desenvolvidos na plataforma TReports

A classe [LibTReportsObj](#) tem como principal objetivo permitir a geração de relatórios TReports via API,
possibilitando assim, a geração de tais relatórios através de pontos de entrada, user fuctions ou através de
web services. Desta forma, contornamos a limitação padrão do Protheus, onde a impressão dos relatórios ocorre
apenas por rotinas de menu.

Para utilizar esta classe, é necessário antes, salvar o arquivo **config.json** no diretório **\\protheus_data\treports\\**.
O arquivo deverá conter a seguinte estrutura:

```cpp
{
  "treports_url": "http://localhost:7017/api/reports/v1", // URL da api do TReports
  "protheus_ws_url": "http://localhost:8073/ws", // URL do webservice REST Protheus
  "user_name": "admin", //Usuário com acesso de Administrador no TReports
  "password": "123456" //Senha
}
```

```cpp
/**
 * Teste da classe LibTReportsObj para impressão de relatório
 */
user function TstTRep1()

  local lOk       := .F.
  local cReportId := "ea987178-433d-4623-9085-bd919356529e"
  local oParams   := JsonObject():new()
  local oSetup    := JsonObject():new()
  local oService  := LibTReportsObj():newLibTReportsObj()

  oParams["filial"]    := "01"
  oParams["numeroDe"]  := "000001"
  oParams["numeroAte"] := "000003"

  lOk := oService:getReport(cReportId, oParams)

  if !lOk
    FwAlertError(oService:getErrorMessage())
  endIf

return
```

O método _getReport_ é uma abstração dos métodos de geração e download dos relatórios. É possível utilizá-los
individualmente:

```cpp
/**
 * Teste da classe LibTReportsObj para geração e download do relatório
 */
user function TstTRep2()

  local lOk           := .F.
  local cGenerationId :=
  local cReportId     := "ea987178-433d-4623-9085-bd919356529e"
  local oParams       := JsonObject():new()
  local oSetup        := JsonObject():new()
  local oService      := LibTReportsObj():newLibTReportsObj()

  oParams["filial"]    := "01"
  oParams["numeroDe"]  := "000001"
  oParams["numeroAte"] := "000003"

  cGenerationId := oService:generateReport(cReportId, oParams)

  if Empty(cGenerationId)
    FwAlertError(oService:getErrorMessage())
    return .F.
  endIf

  oSetup["format"]   := "docx"
  oSetup["folder"]   := "C:\temp\"
  oSetup["openFile"] := .F.

  lOk := oService:downloadReport(cGenerationId, oSetup)

  if !lOk
    FwAlertError(oService:getErrorMessage())
  endIf

return
```

_O envio do objeto Setup é opcional. Caso não utilizado, o relatório será gerado no formato .pdf, será salvo no
diterório %temp% do usuário e será aberto automaticamente._

<br/>

[Voltar](../index)
