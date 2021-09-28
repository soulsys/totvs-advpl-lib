#include "totvs.ch"
#include "rwmake.ch"


/*/{Protheus.doc} LibTaxObj

Objeto para calculo de impostos
    
@author soulsys:victorhugo
@since 18/09/2021
/*/
class LibTaxObj

  data cCode
  data cUnit
  data lIsCustomer
  data lIsSupplier
  data cEntityType
  data cInvoiceType
  data cFreight
  data aItems
  
  method newLibTaxObj() constructor
  
  method setCustomer()
  method setSupplier()
  method setEntityType()
  method setInvoiceType()
  method setFreight()
  method addItem()
  method clearItems()
  method calculate()
  
endClass


/*/{Protheus.doc} newLibTaxObj

Construtor
    
@author soulsys:victorhugo
@since 18/09/2021
/*/
method newLibTaxObj() class LibTaxObj
  
  ::cCode 		    := ""
  ::cUnit 		    := ""
  ::lIsCustomer	  := .F.
  ::lIsSupplier	  := .F.
  ::cEntityType   := ""
  ::cInvoiceType	:= "N"
  ::cFreight		  := nil
  ::aItems		    := {}

return self


/*/{Protheus.doc} setCustomer

Define o cliente
  
@author soulsys:victorhugo
@since 18/09/2021
/*/
method setCustomer(cCode, cUnit) class LibTaxObj
  
  ::cCode 		  := cCode
  ::cUnit 		  := cUnit
  ::lIsCustomer	:= .T.
  
return


/*/{Protheus.doc} setSupplier

Define o fornecedor
  
@author soulsys:victorhugo
@since 18/09/2021
/*/
method setSupplier(cCode, cUnit) class LibTaxObj
  
  ::cCode 		  := cCode
  ::cUnit 		  := cUnit
  ::lIsSupplier	:= .T.
  
return


/*/{Protheus.doc} setEntityType

Define o tipo da entidade
  
@author soulsys:victorhugo
@since 18/09/2021
/*/
method setEntityType(cEntityType) class LibTaxObj
  ::cEntityType := cEntityType
return


/*/{Protheus.doc} setInvoiceType

Define o tipo da NF
  
@author soulsys:victorhugo
@since 18/09/2021
/*/
method setInvoiceType(cInvoiceType) class LibTaxObj
  ::cInvoiceType := cInvoiceType
return


/*/{Protheus.doc} setFreight

Define o tipo do Frete
  
@author soulsys:victorhugo
@since 18/09/2021
/*/
method setFreight(cFreight) class LibTaxObj
  ::cFreight := cFreight
return


/*/{Protheus.doc} addItem

Adiciona itens ao calculo
  
@author soulsys:victorhugo
@since 18/09/2021
/*/
method addItem(cProduct, cTES, nQuantity, nPrice, nFreight) class LibTaxObj
  
  local oItem      := JsonObject():new()
  default nFreight := 0
  
  oItem["product"]  := PadR(cProduct, Len(SB1->B1_COD))
  oItem["tes"]      := cTES
  oItem["quantity"] := nQuantity
  oItem["price"]    := nPrice
  oItem["freight"]  := nFreight
  
  aAdd(::aItems, oItem)
  
return


/*/{Protheus.doc} clearItems

Remove todos os itens
  
@author soulsys:victorhugo
@since 18/09/2021
/*/
method clearItems() class LibTaxObj
  ::aItems := {}
return


/*/{Protheus.doc} calculate

Processa o calculo dos impostos
  
@author soulsys:victorhugo
@since 18/09/2021
/*/
method calculate() class LibTaxObj
  
  local nI			:= 0	
  local oItem   := nil	
  local oResult	:= JsonObject():new()	
  
  initMaFis(self)
  
  for nI := 1 to Len(::aItems)		
    addMaFisItem(::aItems[nI])						
  next nI	
  
  oResult["icmsBase"]  	  := MaFisRet(nil, "NF_BASEICM")
  oResult["icmsValue"]    := MaFisRet(nil, "NF_VALICM")
  oResult["icmsstBase"]  	:= MaFisRet(nil, "NF_BASESOL")
  oResult["icmsstValue"]  := MaFisRet(nil, "NF_VALSOL")
  oResult["ipiBase"]  	  := MaFisRet(nil, "NF_BASEIPI")
  oResult["ipiValue"]     := MaFisRet(nil, "NF_VALIPI")
  oResult["suframa"]      := MaFisRet(nil, "NF_DESCZF")
  oResult["invoiceValue"] := MaFisRet(nil, "NF_TOTAL")
  oResult["receivable"]   := MaFisRet(nil, "NF_BASEDUP")  

  for nI := 1 to Len(::aItems)		
    oItem                   := ::aItems[nI]    
    oItem["icmsBase"]  	    := MaFisRet(nI, "IT_BASEICM")
    oItem["icmsAliquot"]    := MaFisRet(nI, "IT_ALIQICM")
    oItem["icmsValue"]      := MaFisRet(nI, "IT_VALICM")
    oItem["icmsstBase"]  	  := MaFisRet(nI, "IT_BASESOL")
    oItem["icmsstAliquot"]  := MaFisRet(nI, "IT_ALIQSOL")
    oItem["icmsstValue"]    := MaFisRet(nI, "IT_VALSOL")
    oItem["ipiBase"]  	    := MaFisRet(nI, "IT_BASEIPI")
    oItem["ipiAliquot"]     := MaFisRet(nI, "IT_ALIQIPI")
    oItem["ipiValue"]       := MaFisRet(nI, "IT_VALIPI")
    oItem["suframa"]        := MaFisRet(nI, "IT_DESCZF")
    oItem["invoiceValue"]   := MaFisRet(nI, "IT_TOTAL")
    oItem["cfop"]           := MaFisRet(nI, "IT_CF")
    oItem["receivable"]     := MaFisRet(nI, "IT_BASEDUP")
  next nI

  oResult["items"] := ::aItems
  
  MaFisEnd()
  MaFisRestore()

return oResult

/**
 * Inicializa a funcao fiscal
 */
static function initMaFis(oSelf)  

  local cCodCliFor 	:= oSelf:cCode
  local cLoja		 	  := oSelf:cUnit
  local cCliFor	 	  := if ( oSelf:lIsCustomer, "C", "F" )
  local cTipoNF	 	  := oSelf:cInvoiceType
  local cTpCliFor	 	:= oSelf:cEntityType
  local aRelImp	 	  := nil
  local cTpComp		  := nil
  local lInsere		  := nil
  local cAliasP		  := nil
  local cRotina		  := "MATA461"
  local cTipoDoc  	:= nil
  local cEspecie  	:= nil
  local cCodProsp		:= nil
  local cGrpCliFor	:= nil	
  local cRecolheISS	:= nil
  local cCliEnt		  := nil
  local cLojEnt		  := nil
  local aTransp		  := nil
  local lEmiteNF		:= nil
  local lCalcIPI    := nil
  local cPedido     := nil
  local cCliFat 	  := oSelf:cCode
  local cLojCFat    := oSelf:cUnit
  local nTotPed		  := nil
  local dDtEmiss  	:= nil
  local cTpFrete    := oSelf:cFreight
  local lCalcPCC    := nil
  local lCalcINSS   := nil
  local lCalcIRRF   := nil
  local cTpCompl    := nil
  local cCltdest  	:= nil
  local cLjtdest    := nil	
  local oSql		    := LibSqlObj():newLibSqlObj()
  
  if Empty(cTpCliFor)
    if (cCliFor == "C")
      cTpCliFor := oSql:getFieldValue("SA1", "A1_TIPO", "%SA1.XFILIAL% AND A1_COD = '" + cCodCliFor + "' AND A1_LOJA = '" + cLoja + "'") 
    else
      cTpCliFor := oSql:getFieldValue("SA2", "A2_TIPO", "%SA1.XFILIAL% AND A2_COD = '" + cCodCliFor + "' AND A2_LOJA = '" + cLoja + "'")
    endIf
  endIf	
  
  MaFisSave()
  MaFisEnd()  

return MaFisIni(cCodCliFor,;	// 1-Cod. Cli/For
        cLoja,;			// 02-Lj do Cli/For
        cCliFor,;		// 03-C:Cliente , F:Fornecedor
        cTipoNF,;		// 04-Tp NF( "N","D","B","C","P","I" )
        cTpCliFor,;		// 05-Tp do Cli/For
        aRelImp,;		// 06-Relacao de Impostos que suportados no arquivo
        cTpComp,;		// 07-Tipo de complemento
        lInsere,;		// 08-Permite Incluir Impostos no Rodape .T./.F.
        cAliasP,;		// 09-Alias do Cadastro de Produtos - ("SBI" P/ Front Loja)
        cRotina,;		// 10-Nome da rotina que esta utilizando a funcao
        cTipoDoc,;		// 11-Tipo de documento
        cEspecie,;		// 12-Especie do documento
        cCodProsp,;		// 13-Codigo e Loja do Prospect
        cGrpCliFor,;	// 14-Grupo Cliente
        cRecolheISS,;	// 15-Recolhe ISS
        cCliEnt,;		// 16-Codigo do cliente de entrega na nota fiscal de saida
        cLojEnt,;		// 17-Loja do cliente de entrega na nota fiscal de saida
        aTransp,;		// 18-Informacoes do transportador [01]-UF,[02]-TPTRANS
        lEmiteNF,;		// 19-Se esta emitindo nota fiscal ou cupom fiscal (Sigaloja)
        lCalcIPI,;      // 20-Define se calcula IPI (SIGALOJA)
        cPedido,;       // 21-Pedido de Venda
        cCliFat,;	    // 22-Cliente do faturamento ( cCodCliFor � passado como o cliente de entrega, pois � o considerado na maioria das funo�es fiscais, exceto ao gravar o clinte nas tabelas do livro)
        cLojCFat,;      // 23-Loja do cliente do faturamento
        nTotPed,;		// 24-Total do Pedido
        dDtEmiss,;		// 25-Data de emiss�o do documento inicialmente sera diferente de dDataBase nas notas de entrada (MATA103 e MATA910)
        cTpFrete,;      // 26- Tipo de Frete informado no pedido
        lCalcPCC,;      // 27- Indica se Calcula (PIS,COFINS,CSLL), independete da TES estar configurada para Gerar Duplicata (F4_DUPLIC)
        lCalcINSS,;     // 28- Indica se Calcula (INSS), independete da TES estar configurada para Gerar Duplicata (F4_DUPLIC)
        lCalcIRRF,;     // 29- Indica se Calcula (IRRF), independete da TES estar configurada para Gerar Duplicata (F4_DUPLIC)
        cTpCompl,;      // 30- Tipo de Complemento
        cCltdest,;	    // 31-Cliente de destino de transporte (Notas de entrada de transporte )
        cLjtdest )      // 32-Loja de destino de transporte (Notas de entrada de transporte )
        
        
/**
 * Adiciona itens na funcao fiscal
 */
static function addMaFisItem(oItem)

  local cProduto		:= oItem["product"]
  local cTes			  := oItem["tes"] 
  local nQtd			  := oItem["quantity"]
  local nPrcUnit		:= oItem["price"]
  local nDesconto		:= 0
  local cNFOri		  := ""
  local cSEROri		  := ""
  local nRecOri		  := 0
  local nFrete		  := oItem["freight"]
  local nDespesa		:= 0
  local nSeguro		  := 0
  local nFretAut		:= 0
  local nValMerc		:= (oItem["quantity"] * oItem["price"])
  local nValEmb		  := 0
  local nRecSB1		  := nil
  local nRecSF4		  := nil
  local cNItem		  := nil
  local nDesNTrb		:= nil
  local nTara			  := nil
  local cCfo			  := nil
  local aNfOri		  := nil
  local cConcept		:= nil
  local nBaseVeic		:= nil
  local nPLote		  := nil
  local nPSubLot		:= nil
  local nAbatIss		:= nil
  local cCodISS		  := nil
  local cClasFis		:= nil
  local cProdFis		:= nil
  local nRecPrdF		:= nil
  local cNcmFiscal	:= nil

return MaFisAdd(cProduto,;  // 1-Codigo do Produto ( Obrigatorio )
        cTes,;	   	// 2-Codigo do TES ( Opcional )
        nQtd,;	   	// 3-Quantidade ( Obrigatorio )
        nPrcUnit,;  // 4 -Preco Unitario ( Obrigatorio )
        nDesconto,; // 5 -Valor do Desconto ( Opcional )
        cNFOri,;	// 6 -Numero da NF Original ( Devolucao/Benef )
        cSEROri,;	// 7 -Serie da NF Original ( Devolucao/Benef )
        nRecOri,;	// 8 -RecNo da NF Original no arq SD1/SD2
        nFrete,;	// 9 -Valor do Frete do Item ( Opcional )
        nDespesa,;	// 10-Valor da Despesa do item ( Opcional )
        nSeguro,;	// 11-Valor do Seguro do item ( Opcional )
        nFretAut,;	// 12-Valor do Frete Autonomo ( Opcional )
        nValMerc,;	// 13-Valor da Mercadoria ( Obrigatorio )
        nValEmb,;	// 14-Valor da Embalagem ( Opiconal )
        nRecSB1,;	// 15-RecNo do SB1
        nRecSF4,;	// 16-RecNo do SF4
        cNItem,;    // 17-Item
        nDesNTrb,;  // 18-Despesas nao tributadas - Portugal
        nTara,;		// 19-Tara - Portugal
        cCfo,; 		// 20-CFO
        aNfOri,;    // 21-Array para o calculo do IVA Ajustado (opcional)
        cConcept,;	// 22-Concepto
        nBaseVeic,;	// 23-Base Veiculo
        nPLote,; 	// 24-Lote Produto
        nPSubLot,;	// 25-Sub-Lote Produto
        nAbatIss,;	// 26-Valor do Abatimento ISS
        cCodISS,; 	// 27-Codigo ISS
        cClasFis,;	// 28-Classificacao Fiscal
        cProdFis,;	// 29-Cod. do Produto Fiscal
        nRecPrdF,;	// 30-Recno do Produto Fiscal
        cNcmFiscal) // 31-NCM do produto Fiscal
