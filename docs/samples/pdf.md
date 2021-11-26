## Exemplo de Geração de Arquivo PDF

Podemos utilizar a classe [LibPdfObj](../classes/pdf) para manipular arquivos PDF. Essa classe simplifica a criação de PDF 
através da abstração de métodos da classe padrão [FwMsPrinter](https://tdn.totvs.com/display/public/PROT/FWMsPrinter).

Um simples PDF pode ser criado dessa forma:

```cpp
user function PdfSample()

  local cFileName := "MyPdf"
  local cFolder   := "C:\temp"
  local oPdf      := LibPdfObj():newLibPdfObj(cFileName, cFolder)
  local oFont     := TFont():new("Arial", 12, 12, nil, .T., nil, nil, nil, nil, .T.)

  oPdf:startPage()
  oPdf:say(10, 10, "Hello World!", oFont)
  oPdf:endPage()

  if oPdf:create()
    MsgInfo("PDF criado com sucesso: " + oPdf:getPdfFile())
  else
    Alert("Falha ao criar aquivo PDF")
  endIf

  oPdf:clear()

return
```

Através de uma API mais simples, a ***LibPdfObj*** assume as configurações padrões da ***FwMsPrinter*** e não exige 
que sejam passados vários parâmetros no construtor. Outra grande vantagem é que a classe trata automaticamente 
a execução via job (sem interface de usuário).

Se necessário invocar algum método da classe padrão da TOTVS, basta utilizar o método ***getFwMsPrinter()***:

```cpp
oPdf:getFwMsPrinter():ellipse(nColumn, nLine, nRight, nBottom, CLR_WHITE, CLR_BLACK)
```

<br/>

[Voltar](../index)