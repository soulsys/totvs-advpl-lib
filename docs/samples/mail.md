## Exemplo de Envio de E-mail

Através da classe [LibMailObj](#) fica muito fácil enviar e-mails pelo Protheus. 

```xbase
user function MailSample()

  local oMail    := LibMailObj():newLibMailObj()
  local cTo      := "joao@fake-mail.com"
  local cSubject := "Assunto Importante"
  local cBody    := ""

  cBody := "<p>Olá! Esse é o corpo da mensagem em HTML.</p>"
  cBody += "<p>Quando não informadas, as configurações de e-mail são "
  cBody += "obtidas automaticamente através dos parâmetros padrões (MV_RELXXX).</p>"
  
  if oMail:send(cTo, cSubject, cBody)
    MsgInfo("E-mail enviado com sucesso")
  else
    Alert(oMail:getError())
  endIf

return
```

Outro recurso legal é a possibilidade de criação de um layout HTML para o corpo da mensagem.

```html
<html>
  <body>
    <h3>Exemplo de mensagem HTML</h3>
    <p>E-mail enviado em <strong>%date%</strong> às <strong>%time%</strong></p>
    <table>
      <tbody>
        <tr>            
          <td>%tb.row%</td>          
        </tr>
      </tbody>
    </table>
  </body>
</html>
```

A partir da definição do HTML basta substituir as variáveis contidas no template.

```xbase
user function HtmlMailSample()

  local oMail    := LibMailObj():newLibMailObj()
  local cTo      := "joao@fake-mail.com"
  local cSubject := "Assunto Importante"
  local nRow     := 0
  
  oMail:setHtmlLayout("template.html")
  oMail:setHtmlValue("date", DtoC(dDataBase))
  oMail:setHtmlValue("time", Time())

  for nRow := 1 to 5
    oMail:addHtmlTableValue("tb.row", StrZero(nRow, 2))
  next nRow
  
  if oMail:send(cTo, cSubject)
    MsgInfo("E-mail enviado com sucesso")
  else
    Alert(oMail:getError())
  endIf

return
```

<br/>

[Voltar](../index)