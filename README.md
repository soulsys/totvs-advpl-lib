# Biblioteca de Componentes TOTVS Advpl

Essa biblioteca de componentes tem por objetivo ajudar desenvolvedores Advpl a escrever códigos mais
limpos, expressivos e coesos através do encapsulamento de funcionalidades usadas frequentemente.
<br/><br/>

## Exemplo

Para realizar uma query simples normalmente você faria algo [assim](https://tdn.totvs.com/display/framework/Desenvolvendo+queries+no+Protheus):

```clipper
user function SqlSample()

  local cQuery       := ""
  local cDescription := ""
  local cCode        := "P0001"
  local cAlias       := GetNextAlias()

  cQuery := " SELECT B1_DESC FROM " + RetSqlName("SB1") + " SB1 "
  cQuery += " WHERE B1_FILIAL = '" + xFilial("SB1") + "' AND "
  cQuery += "       B1_COD = '" + cCode + "' AND SB1.D_E_L_E_T_ = ' ' "

  dbUseArea(.T., "TOPCONN", TcGenQry(nil, nil, cQuery), cAlias, .T., .T.)

  cDescription := (cAlias)->B1_DESC

  (cAlias)->(dbCloseArea())

return
```

Utilizando a classe **_SysLibSql_** podemos escrever a mesma funcionalidade dessa forma:

```xbase
user function SqlSample()

  local oSql         := SysLibSql():new()
  local cQuery       := ""
  local cDescription := ""
  local cCode        := "P0001"

  cQuery := " SELECT B1_DESC FROM %SB1.SQLNAME% "
  cQuery += " WHERE %SB1.XFILIAL% AND B1_COD = '" + cCode + "' AND %SB1.NOTDEL% "

  oSql:newAlias(cQuery)

  cDescription := oSql:getValue("B1_DESC")

  oSql:close()

return
```

Ou ainda desse jeito:

```xbase
user function SqlSample()

  local oSql         := SysLibSql():new()
  local cCode        := "P0001"
  local cDescription := oSql:getFieldValue("SB1", "B1_DESC", "%SB1.XFILIAL% AND B1_COD = '" + cCode + "'")

return
```

Um simples e-mail pode ser enviado assim:

```xbase
user function MailSample()

  local oMail    := SysLibMail():new()
  local cTo      := "joao@fake-mail.com"
  local cSubject := "Assunto Importante"
  local cBody    := ""

  cBody := '<p>Olá! Esse é o corpo da mensagem em HTML.</p>'
  cBody += '<p>Quando não informadas, as configurações de e-mail são '
  cBody += 'obtidas automaticamente através dos parâmetros padrões (MV_RELXXX).</p>'

  if oMail:send(cTo, cSubject, cBody)
    MsgInfo("E-mail enviado com sucesso")
  else
    Alert(oMail:getError())
  endIf

return
```

O objetivo é sempre fazer mais com menos código! 😃
<br/><br/>

## Uso

Recomendamos que a compilação dos fontes seja realizada da seguinte forma:

1. Clone o repositório: git clone https://github.com/soulsys/totvs-advpl-lib.git

2. Abra o diretório criado através do VS Code. Certifique-se de ter a última versão do plugin oficial da TOTVS.

3. Compile a pasta **_src_**

<br/>
Caso encontre algum bug ou sinta necessidade de alguma melhoria, nos envie um pull request.
<br/><br/>

## Documentação

Conheça todas as classes e recursos disponíveis acessando nossa [documentação](https://soulsys.github.io/totvs-advpl-lib/).
<br/><br/>

## Importante

Esse repositório não possui qualquer relação com a TOTVS S/A. O uso dessa biblioteca é de total responsabilidade do usuário. Ao utilizar
nossos componentes você concorda com os termos da licença MIT.

## Dúvidas e sugestões ❓

Caso encontre alguma dificuldade ou tenha sugestões de melhorias, não deixe de compartilhar conosco através da seção de [issues](https://github.com/soulsys/totvs-advpl-lib/issues).
