/*
 * Proyecto: GEP
 * Fichero: Vista1.prg
 * Descricao:
 * Autor:
 * Fecha: 09/08/2021
 */

#include "Xailer.ch"
#include "Nefele.ch"
#include "LangCGI.ch"


PROCEDURE Vista1()

   LOCAL hVista
   LOCAL nTotal := 0
   LOCAL hItem
   LOCAL cCDC := oCGI:GetCgiValue( "cdc","" )

   HB_JsonDecode( HB_MemoRead(AppData:PathData + "Funcionarios.json"),@hVista )

   FOR EACH hItem IN hVista
      IF hItem["detail","items","CentroDeCusto"] == cCDC
         nTotal += hItem["detail","items","Salario"]
      ENDIF
   NEXT

   With Object WLabel():New()
      :nHeaderSize   := 5
      :lBR           := .T.
      :lBold         := .T.
      :cAlign        := xc_Center
      :cText         := Transform( nTotal,"999,999,999.99" )
      :Create()
      oCGI:SendPage( :FullHtml() )
   End With
RETURN

//------------------------------------------------------------------------------

FUNCTION GetCmbCTT( lOrderAlfa,cClacce,lCodInclude )

   LOCAL hVista,hItem,aResult := {}
   LOCAL hTmp
   LOCAL cCDC,nIdx
   LOCAL hCentros
   LOCAL nTotal
   LOCAL cFilter
   LOCAL cTmpFile := AppData:PathData + "CTT_" + cClacce + ".json"

   DEFAULT lOrderAlfa   TO .F.
   DEFAULT cClacce      TO ""
   DEFAULT lCodInclude  TO .F.

   IF File( cTmpFile ) .AND. nfl_FileDate( cTmpFile ) == Date()
      // Recuperamos el fichero Cache
      HB_JsonDecode( HB_MemoRead( cTmpFile ),@aResult )
      // Ver como controlo si han cambiado el filtro desde la ultima consulta
   ELSE
      cFilter := "CTT_BLOQ=2"
      cFilter += IIF( !Empty( cClacce )," AND CTT_CLASSE=" + cClacce,"" )

      // TODO: Ver la posibilidad de cachear diariamente esta consulta

      hCentros := QueryCodAlias( AppData:cHost,"CTT",cFilter,1,1 )
      IF hCentros["ok"]
         nTotal := hCentros["response","TotalPages"]
         IF nTotal > Len( hCentros["response","table","items"] )
            hCentros := QueryCodAlias( AppData:cHost,"CTT",cFilter,nTotal,1 )
         ENDIF
      ENDIF

      IF hCentros["status"] == 200
         FOR EACH hItem IN hCentros["response","table","items"]
            hVista := hItem["detail","items"]
            aAdd( aResult,{hVista["CTT_CUSTO"],IIF( lCodInclude,hVista["CTT_CUSTO"] + " :: ","" ) + hVista["CTT_DESC01"]} )
         NEXT
         IF lOrderAlfa
            aResult := aSort( aResult,,,{|x,y| x[2] < y[2] } )
         ENDIF
         HB_MemoWrit( cTmpFile,HB_JsonEncode( aResult ) )
      ENDIF
   ENDIF

RETURN aResult

//------------------------------------------------------------------------------

FUNCTION GetCentros()

   LOCAL hVista,hItem,aResult := {}
   LOCAL cCDC,nIdx

   HB_JsonDecode( HB_MemoRead(AppData:PathData + "Funcionarios.json"),@hVista )

   FOR EACH hItem IN hVista
      cCDC := hItem["detail","items","CentroDeCusto"]
      IF (nIdx := HB_Ascan( aResult,{|x| x[1]==cCDC} ) ) == 0
         aAdd( aResult,{ cCDC,hItem["detail","items","Salario"] } )
      ELSE
         aResult[nIdx,2] += hItem["detail","items","Salario"]
      ENDIF
   NEXT

RETURN aResult

//------------------------------------------------------------------------------

PROCEDURE Vista4(cCDC)

   LOCAL hVista := QueryCodModel(AppData:cHost,"SRDHEADER" )
   LOCAL nTotal := 0,hItem
   LOCAL nPags,cText
   LOCAL nPag   := 1


   if hVista["status"] == 200 .AND. !Empty( hVista["response"] )
      nPags  := hVista["response","TotalPages"]
      DO WHILE nPag <= nPags
         nfl_Console( nPag )
         IF hVista["status"] == 200 .AND. !Empty( hVista["response"] )
            FOR EACH hItem IN hVista["response","table","items"]
               IF hItem["detail","items","CentroDeCusto"] == cCDC
                  nTotal += hItem["detail","items","Salario"]
               ENDIF
            NEXT
         ENDIF
         nPag ++
         hVista := QueryCodModel( AppData:cHost,"Funcionarios",,1000,nPag )
      ENDDO
   ENDIF

   With Object WLabel():New()
      :nHeaderSize   := 5
      :lBR           := .T.
      :lBold         := .T.
      :cAlign        := xc_Center
      :cText         := Transform( nTotal,"999,999,999.99" )
      :Create()
      oCGI:SendPage( :FullHtml() )
   End With
RETURN

//------------------------------------------------------------------------------

