## Exemplo de Geração de Arquivo Texto

A classe [LibFileObj](#) facilita a manipulação de arquivos texto. Através dela fica fácil 
criar, copiar e apagar arquivos em disco.

```cpp
user function FileSample()

  local nAction := 0
  local cFile1  := "C:\temp\file1.txt"
  local cFile2  := "C:\temp\file2.txt"
  local oFile1  := LibFileObj():newLibFileObj(cFile1)  
  local oFile2  := nil

  oFile1:writeLine("Esse arquivo foi criado através da classe LibFileObj!")
  oFile1:copy(cFile2)

  nAction := Aviso("LibFileObj", 1, "Arquivos criados com sucesso. O que deseja fazer ?", {"Apagar arquivos", "Finalizar"})

  if (nAction == 1)
    oFile1:delete()
    oFile2 := LibFileObj():newLibFileObj(cFile2)
    oFile2:delete()
  endIf

return
```

Além disso, a classe também possui métodos para facilitar a leitura do conteúdo do arquivo, obter o tamanho em bytes ou megabytes, etc.

<br/>

[Voltar](../index)