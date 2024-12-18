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
  data nDocType
  data cOperation
  data cFreight
  data aItems
  
  method newLibTaxObj() constructor
  
  method setCustomer()
  method setSupplier()
  method setEntityType()
  method setInvoiceType()
  method setDocType()
  method setOperation()
  method setFreight()
  method addItem()
  method clearItems()
  method calculate()
  method restore()
  method getItemTaxesAsArray()
  
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
  ::nDocType      := 2 
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


/*/{Protheus.doc} setDocType

Define o tipo de documento (1=Entrada, 2=Saida)
  
@author soulsys:victorhugo
@since 13/12/2023
/*/
method setDocType(nDocType) class LibTaxObj
  ::nDocType := nDocType
return


/*/{Protheus.doc} setOperation

Define a Operacao (TES Inteligente)
  
@author soulsys:victorhugo
@since 13/12/2023
/*/
method setOperation(cOperation) class LibTaxObj
  ::cOperation := cOperation
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
method addItem(cProduct, cTES, nQuantity, nPrice, nFreight, nDiscount, nExpenses) class LibTaxObj
  
  local oItem       := JsonObject():new()
  default nFreight  := 0
  default nDiscount := 0
  default nExpenses := 0

  if Empty(cTES)
    cTES := getOperationTES(self, cProduct)
  endIf
  
  oItem["product"]  := PadR(cProduct, Len(SB1->B1_COD))
  oItem["tes"]      := cTES
  oItem["quantity"] := nQuantity
  oItem["price"]    := nPrice
  oItem["freight"]  := nFreight
  oItem["discount"] := nDiscount
  oItem["expenses"] := nExpenses
  
  aAdd(::aItems, oItem)
  
return

/**
 * Retorna o TES a partir da operacao (TES Inteligente)
 */
static function getOperationTES(oSelf, cProduct)

  local cType := if ( oSelf:lIsCustomer, "C", "F" )

return MaTesInt(oSelf:nDocType, oSelf:cOperation, oSelf:cCode, oSelf:cUnit, cType, cProduct)


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
method calculate(lRestore) class LibTaxObj
  
  local nI			   := 0	
  local oItem      := nil	
  local oResult	   := JsonObject():new()	
  default lRestore := .T.
  
  initMaFis(self)
  
  for nI := 1 to Len(::aItems)		
    addMaFisItem(::aItems[nI])						
  next nI	
  
  oResult["icmsBase"]  	      := MaFisRet(nil, "NF_BASEICM")
  oResult["icmsValue"]        := MaFisRet(nil, "NF_VALICM")
  oResult["icmsstBase"]  	    := MaFisRet(nil, "NF_BASESOL")
  oResult["icmsstValue"]      := MaFisRet(nil, "NF_VALSOL")
  oResult["supIcmsBase"]      := MaFisRet(nil, "NF_BASEICM")
  oResult["supIcmsValue"]     := MaFisRet(nil, "NF_VALCMP")
  oResult["supDifIcmsBase"]   := MaFisRet(nil, "NF_BASEICM")
  oResult["supDifIcmsValue"]  := MaFisRet(nil, "NF_DIFAL")
  oResult["icmsDeducted"]     := MaFisRet(nil, "NF_DEDICM") 
  oResult["ipiBase"]  	      := MaFisRet(nil, "NF_BASEIPI")
  oResult["ipiValue"]         := MaFisRet(nil, "NF_VALIPI")
  oResult["pisBase"]  	      := MaFisRet(nil, "NF_BASEPS2")
  oResult["pisValue"]         := MaFisRet(nil, "NF_VALPS2")
  oResult["cofinsBase"]  	    := MaFisRet(nil, "NF_BASECF2")
  oResult["cofinsValue"]      := MaFisRet(nil, "NF_VALCF2")  
  oResult["suframa"]          := MaFisRet(nil, "NF_DESCZF")
  oResult["invoiceValue"]     := MaFisRet(nil, "NF_TOTAL")
  oResult["receivable"]       := MaFisRet(nil, "NF_BASEDUP")

  for nI := 1 to Len(::aItems)		
    oItem                      := ::aItems[nI]    
    oItem["icmsBase"]  	       := MaFisRet(nI, "IT_BASEICM") // Base ICMS
    oItem["icmsAliquot"]       := MaFisRet(nI, "IT_ALIQICM") // % ICMS
    oItem["icmsValue"]         := MaFisRet(nI, "IT_VALICM")  // Valor ICMS
    oItem["icmsstBase"]  	     := MaFisRet(nI, "IT_BASESOL") // Base ICMS Solidario
    oItem["icmsstAliquot"]     := MaFisRet(nI, "IT_ALIQSOL") // % ICMS Solidario
    oItem["icmsstValue"]       := MaFisRet(nI, "IT_VALSOL")  // Valor ICMS Solidario
    oItem["supIcmsBase"]       := MaFisRet(nI, "IT_BASEICM") // Base ICMS Complementar
    oItem["supIcmsAliquot"]    := MaFisRet(nI, "IT_ALIQCMP") // % ICMS Complementar
    oItem["supIcmsValue"]      := MaFisRet(nI, "IT_VALCMP")  // Valor ICMS Complementar
    oItem["supDifIcmsBase"]    := MaFisRet(nI, "IT_BASEICM") // Base ICMS DIFAL
    oItem["supDifIcmsAliquot"] := MaFisRet(nI, "IT_ALIQCMP") // % ICMS DIFAL 
    oItem["supDifIcmsValue"]   := MaFisRet(nI, "IT_DIFAL")   // Valor ICMS DIFAL
    oItem["icmsDeducted"]      := MaFisRet(nI, "IT_DEDICM")  // Valor ICMS Deduzido
    oItem["ipiBase"]  	       := MaFisRet(nI, "IT_BASEIPI") // Base IPI
    oItem["ipiAliquot"]        := MaFisRet(nI, "IT_ALIQIPI") // % IPI
    oItem["ipiValue"]          := MaFisRet(nI, "IT_VALIPI")  // Valor IPI
    oItem["pisBase"]  	       := MaFisRet(nI, "IT_BASEPS2") // Base PIS
    oItem["pisAliquot"]        := MaFisRet(nI, "IT_ALIQPS2") // % PIS
    oItem["pisValue"]          := MaFisRet(nI, "IT_VALPS2")  // Valor PIS
    oItem["cofinsBase"]  	     := MaFisRet(nI, "IT_BASECF2") // Base COFINS
    oItem["cofinsAliquot"]     := MaFisRet(nI, "IT_ALIQCF2") // % COFINS
    oItem["cofinsValue"]       := MaFisRet(nI, "IT_VALCF2")  // Valor COFINS
    oItem["suframa"]           := MaFisRet(nI, "IT_DESCZF")  // Valor SUFRAMA
    oItem["invoiceValue"]      := MaFisRet(nI, "IT_TOTAL")   // Valor NF
    oItem["cfop"]              := MaFisRet(nI, "IT_CF")      // CFOP
    oItem["receivable"]        := MaFisRet(nI, "IT_BASEDUP") // Valor Titulo Receber
  next nI

  oResult["items"] := ::aItems
  
  if lRestore
    ::restore()
  endIf

return oResult


/*/{Protheus.doc} restore

Restaura as funcoes fiscais
  
@author soulsys:victorhugo
@since 13/12/2023
/*/
method restore() class LibTaxObj
  MaFisEnd()
  MaFisRestore()
return


/*/{Protheus.doc} getItemTaxesAsArray

Retorna os impostos de um item em forma de array de objetos
  
@author soulsys:victorhugo
@since 28/12/2023
/*/
method getItemTaxesAsArray(oTaxItem) class LibTaxObj

  local aTaxes := {}

  if oTaxItem["icmsValue"] > 0
    addTaxData("ICMS", "ICMS", oTaxItem["icmsBase"], oTaxItem["icmsAliquot"], oTaxItem["icmsValue"], @aTaxes)
  endIf

  if oTaxItem["icmsstValue"] > 0
    addTaxData("ICMSST", "ICMS ST", oTaxItem["icmsstBase"], oTaxItem["icmsstAliquot"], oTaxItem["icmsstValue"], @aTaxes)
  endIf

  if oTaxItem["ipiValue"] > 0
    addTaxData("IPI", "IPI", oTaxItem["ipiBase"], oTaxItem["ipiAliquot"], oTaxItem["ipiValue"], @aTaxes)
  endIf

  if oTaxItem["supIcmsValue"] > 0
    addTaxData("ICMSCMP", "ICMS Complementar", oTaxItem["supIcmsBase"], oTaxItem["supIcmsAliquot"], oTaxItem["supIcmsValue"], @aTaxes)
  endIf

  if oTaxItem["supDifIcmsValue"] > 0
    addTaxData("ICMSDIF", "ICMS DIFAL", oTaxItem["supDifIcmsBase"], oTaxItem["supDifIcmsAliquot"], oTaxItem["supDifIcmsValue"], @aTaxes)
  endIf

  if oTaxItem["pisValue"] > 0
    addTaxData("PIS", "PIS", oTaxItem["pisBase"], oTaxItem["pisAliquot"], oTaxItem["pisValue"], @aTaxes)
  endIf

  if oTaxItem["cofinsValue"] > 0
    addTaxData("PIS", "PIS", oTaxItem["cofinsBase"], oTaxItem["cofinsAliquot"], oTaxItem["cofinsValue"], @aTaxes)
  endIf

  if oTaxItem["icmsDeducted"] > 0
    addTaxData("ICMSDED", "ICMS Desonerado", nil, nil, oTaxItem["icmsDeducted"], @aTaxes)
  endIf

  if oTaxItem["suframa"] > 0
    addTaxData("SUFRAMA", "SUFRAMA", nil, nil, oTaxItem["suframa"], @aTaxes)
  endIf
  
return aTaxes

static function addTaxData(cId, cDescription, nBasis, nAliquot, nValue, aTaxes)

  local oTax := JsonObject():new()

  oTax["id"]          := cId
  oTax["description"] := cDescription
  oTax["basis"]       := nBasis
  oTax["aliquot"]     := nAliquot
  oTax["value"]       := nValue
  
  aAdd(aTaxes, oTax)

return

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
  local nDesconto		:= oItem["discount"]
  local cNFOri		  := ""
  local cSEROri		  := ""
  local nRecOri		  := 0
  local nFrete		  := oItem["freight"]
  local nDespesa		:= oItem["expenses"]
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
