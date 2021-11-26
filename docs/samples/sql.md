## Exemplo de Manipulação de Instruções SQL

A classe [LibSqlObj](#) tem como principal objetivo permitir a escrita de códigos mais curtos e legíveis ao 
manipular instruções SQL. Podemos considerar que manipular dados gravados no BD do ERP faz parte de 
praticamente qualquer customização, portanto, essa classe pode agilizar bastante o desenvolvimento.

```clipper
user function SqlSample()

  local cMsg   := ""
  local cQuery := ""
  local oSql   := LibSqlObj():newLibSqlObj()

  cQuery := " SELECT E1_NUM [NUMBER], E1_VENCTO [DUE_DATE] "
  cQuery += " FROM %SE1.SQLNAME% " 
  cQuery += " WHERE %SE1.XFILIAL% AND E1_VENCTO < '" + DtoS(dDataBase) + "' AND "
  cQuery += "       E1_SALDO > 0 AND %SE1.NOTDEL% "

  oSql:newAlias(cQuery)
  oSql:setDateFields({"DUE_DATE"})

  while oSql:notIsEof()

    cMsg += CRLF
    cMsg += oSql:getValue("NUMBER")
    cMsg += " - "
    cMsg += oSql:getValue("DtoC(DUE_DATE)")

    oSql:skip()
  endDo

  oSql:close()

  MsgInfo("Título(s) vencido(s): " + cMsg)

return
```

Caso queira fazer uma query simples em apenas uma tabela:

```xbase
user function SqlSample2()

  local cMsg := ""
  local oSql := LibSqlObj():newLibSqlObj()

  oSql:newTable("SB1", "B1_COD, B1_DESC", "%SB1.XFILIAL% AND B1_TIPO = 'ME'")

  if !oSql:hasRecords()
    oSql:close()
    return Alert("Nenhum produto tipo ME")
  endIf

  while oSql:notIsEof()

    cMsg += CRLF
    cMsg += oSql:getValue("AllTrim(B1_COD)")
    cMsg += " - "
    cMsg += oSql:getValue("AllTrim(B1_DESC)")

    oSql:skip()
  endDo

  oSql:close()

  MsgInfo("Produtos tipo ME: " + cMsg)

return
```

Se precisar obter um campo de uma tabela:

```xbase
user function SqlSample3()

  local oSql  := LibSqlObj():newLibSqlObj()
  local cName := oSql:getFieldValue("SA3", "A3_NOME", "%SA3.XFILIAL% AND A3_COD = 'V00001'")

  MsgInfo("O nome do vendedor é " + cName)

return
```

Também é possível incluir, alterar e remover registros através da *LibSqlObj*:

```xbase
user function SqlSample4()

  local oSql    := LibSqlObj():newLibSqlObj()
  local cAlias  := "SB1"
  local cFields := "B1_MSBLQL = '1', B1_ZZST = '0'"
  local cWhere  := "%SB1.XFILIAL% AND B1_COD = 'P00001'"
  
  if !oSql:exists(cAlias, cWhere)
    return MsgAlert("Produto não encontrado")    
  endIf

  if oSql:update(cAlias, cFields, cWhere)
    MsgInfo("Produto bloqueado")
  else
    Alert(oSql:getLastError())
  endIf

return
```

<br/>

[Voltar](../index)