/*
 * Proyecto: GEP
 * Fichero: DashBoard.prg
 * Descricao:
 * Autor:
 * Fecha: 11/08/2021
 */

#include "Xailer.ch"
#include "Nefele.ch"
#include "LangCGI.ch"

//------------------------------------------------------------------------------
//Función principal de la app Web
PROCEDURE MainDashBoard(lAjax)
   LOCAL hUser := LoginUser()
   LOCAL cCall,aCentros := GetCentros(),cCDC
   LOCAL nItem,cId,aCDC
   LOCAL cTmp

   // Comenzamos instanciando la Página Web que queremos crear
   With Object TWebPage():New()

      :cIcon:= "connecti.ico"
      :cTitle:=" GEP :: Connecti"

      AppMenu( :WO,AppData:AppName,hUser )

      :lValign          := .F.
      :lContainer       := .F.

      // Dentro de la web montamos un primer contenedor bEvel que ocupa 4/12 anchura en pantallas grandes
      // en una mediana o pequeña se adaptará responsivamente ya que no le damos tamaño
      for EACH aCDC IN aCentros
         if !Empty( aCDC ) .AND. aCDC[2] > 0
            cCDC := aCDC[1]
            nItem := aCDC:__EnumIndex
            cId := "data" + StrZero( nItem,3 )
            With Object WBevel():New(:WO)
               :aWidth[xc_M]  := 4
               :aWidth[xc_L]  := 3
               :cOnClick:="CadastroFiliais" //Adicionar uma açao
               :oStyle:cCursor:="pointer" //Mudar o ponteiro do Mouse para Maozinha
               With Object WPanel():New(:WO)     // :WO   o  :__WithObject() indica que el parent del objeto es el del nivel anterior no cerrado,en este caso Webpage
                  :cTitle := "Centro de Cousto " + cCDC
                  :nFontTitle := 6
                  With Object WBevel():New(:WO)
                     :cId := cId
                     if !lAjax
                        With Object WLabel():New(:WO)
                           :nHeaderSize   := 5
                           :lBR           := .T.
                           :lBold         := .T.
                           :cAlign        := xc_Center
                           :cText         := Transform( aCDC[2],"999,999,999.99" )
                           :Create()
                        End With
                     ENDIF
                     :Create()
                  End With
                  :Create()
               End With
               :Create()
            End With
            if lAjax
               cTmp := nfl_CallAutoForm("VistaCDC",{{"cdc",cCDC}},cId,.T.,Lang(LNG_SSTITLE),,,,,,,,.T. )
               cTmp := StrTran( cTmp,"<script>","")
               cTmp := StrTran( cTmp,";</script>","")
               cTmp := "setTimeout(" + cTmp + "," + ToString(1000*nItem) + ")"
               :cOnReady := cTmp
            ENDIF
         ENDIF
      NEXT

      oCgi:SendPage( :Create() )        // Se crea el HTML final y se envía al navegador saliendo del ejecutable CGI

   End With

RETURN

//------------------------------------------------------------------------------
//Función principal de la app Web
PROCEDURE VistaSRDDETAIL()
   LOCAL hUser := LoginUser()
   LOCAL nI
   LOCAL aTmp := LastYearMonth()

   // Comenzamos instanciando la Página Web que queremos crear
   With Object TWebPage():New()

      :cIcon:= "connecti.ico"
      :cTitle:=" GEP :: Connecti"

      AppMenu( :WO,AppData:AppName,hUser )

      :lValign    := .F.
      :lContainer := .F.

      With Object WBevel():New(:WO)
         :aWidth[xc_M]     := 3
         :aOffset[xc_M]    := 1
         With Object WPanel():New(:WO)
            :oStyle:cMargin_bottom := 0
            :cClrPane := "blue lighten-5"
            With Object WLabel():New(:WO)
               :aWidth[xc_S]  := 0
               :aWidth[xc_M]  := 12
               :nFontSize     := 6
               :cAlign        := xc_Center
               :cText         := Lang(LNG_FILTROS)
               :cClrPane      := "#26a69a"
               :cClrText      := "white"
               :oStyle:cMargin_top := 10.5
               :oStyle:cPadding := 0
               :lTransparent  := .F.
               :Create()
            End With

            With Object WForm():New(:WO)
               :cFunction  := "AjaxSRDDETAIL"
               :lShadowSheet := .T.
               :oStyle:cMargin_bottom := 0
               :oStyle:cMargin_top    := 0
               :cAjaxBevel   := "dataviewer"
               With Object WComboBox():New(:WO)
                  :cId             := "axo"
                  :cTitle          := Lang(LNG_AXO)
                  :aItems          := CmbLastYears(10)
                  :cSelected       := aTmp[1]
                  :aWidth[xc_M]    := 4
                  :aWidth[xc_S]    := 6
                  :cTitleClrText   := "orange darken-4"
                  :lCompress       := .T.
//                  :lCompressList   := .T.
                  :Create()
               End With
               With Object WComboBox():New(:WO)
                  :cId             := "mes"
                  :cTitle          := Lang(LNG_MES)
                  :aItems          := CmbMeses()
                  :cSelected       := aTmp[2]
                  :cTitleClrText   := "orange darken-4"
                  :aWidth[xc_M]    := 8
                  :aWidth[xc_S]    := 6
                  :lCompress       := .T.
                  :lCompressList   := .T.
                  :Create()
               End With
               With Object WComboBox():New(:WO)
                  :cId             := "ctt"
                  :cTitle          := Lang(LNG_CTT)
                  :aItems          := GetCmbCTT(.T.,"2")
                  :cSelected       := oCGI:GetUserData("RSDETAIL_CTT","")
                  :cText           := Lang(LNG_SELCTT)
                  :cTitleClrText   := "orange darken-4"
                  :aWidth[xc_M]    := 12
                  :aWidth[xc_S]    := 8
                  :cOnChange       := "AjaxSRDDETAIL"
                  :cAjaxBevel      := "dataviewer"
                  :lShadowSheet    := .T.
                  :lCompress       := .T.
                  :lCompressList   := .T.
*                  :aParams         := {{"mes","#mes:selected"},{"axo","#axo:selected"}}
                  :AddParam({"mes","#mes:selected"})
                  :AddParam({"axo","#axo:selected"})
                  :Create()
               End With
               With Object WButton():New(:WO)
                  :aWidth[xc_M]  := 12
                  :aWidth[xc_S]  := 4
                  :cId           := "send"
                  :cText         := Lang(LNG_BUSCAR)
                  :lSubmit       := .T.
                  :cPosition     := "right"
                  :Create()
               End With
               :Create()
            End With
            :Create()
         End With

         :Create()

      End With

      With Object WPanel():New(:WO)
         :aWidth[xc_M]     := 6
         With Object WBevel():New(:WO)
            :cId := "dataviewer"
            IF !Empty( oCGI:GetUserData("RSDETAIL_CTT","") )
               UpdateSRDDETAIL( :WO,aTmp[1],aTmp[2],oCGI:GetUserData("RSDETAIL_CTT","" ) )
            ELSE
               With Object WLabel():New(:WO)
                  :nFontSize     := 5
                  :lBold         := .T.
                  :cAlign        := xc_Center
                  :lBR           := .T.
                  :cText         := Lang(LNG_INIT_RSDETAIL)
                  :cClrText      := "grey"
                  :Create()
               End With
            ENDIF
            :Create()
         End With
         :Create()
      End With
      oCgi:SendPage( :Create() )        // Se crea el HTML final y se envía al navegador saliendo del ejecutable CGI

   End With

RETURN

//------------------------------------------------------------------------------

FUNCTION UpdateSRDDETAIL( oParent,cAxo,cMes,cCTT )
   LOCAL cDesde := cAxo + cMes
   LOCAL cHtml,hData,hItem,nTotal := 0

   DEFAULT cAxo TO "2010"
   DEFAULT cMes TO "05"
   DEFAULT cCTT TO "6.1"


   hData := QueryCodModel(AppData:cHost,"SRDDETAIL",;
            "RD_DATARQ BETWEEN '" + cDesde + "' AND '" + cDesde+;
            IIF( !Empty( cCTT ),"' AND RD_CC='" + cCTT + "'","" ))

   if hData["status"] == 200 .AND. Len( hData["response","table","items"] ) > 0
      WITH OBJECT WListView():New(oParent)
         :lTitleItem := .T.
         for EACH hItem IN hData["response","table","items"]
            WITH OBJECT :AddItem() AS WITemListView
               :cTitle := AsciiHTML(hItem["detail","items","DescricaoVerba"])
               :cSecondTitle := Transform( hItem["detail","items","Valor"],"999,999,999.99" )
            END WITH
            nTotal += hItem["detail","items","Valor"]
         NEXT
         WITH OBJECT :AddItem() AS WItemListView
            :cClrPane := "brown darken-4"
            :cClrText := "white"
            :oBadge:cClrPane := "brown darken-4"
            :oBadge:cClrText := "white"
            :cTitle := Lang(LNG_TOTAL)
            :cSecondTitle := Transform( nTotal,"999,999,999.99" )
         END WITH
         :Create()
         if HB_IsNIL( oParent )
            cHtml := :FullHtml()
         ENDIF
      END WITH
   ELSE
      With Object WLabel():New(oParent)
         :nFontSize     := 5
         :lBold         := .T.
         :cAlign        := xc_Center
         :lBR           := .T.
         :cText         := Lang(LNG_SINDATOS)
         :cClrText      := "grey"
         :Create()
         if HB_IsNIL( oParent )
            cHtml := :FullHtml()
         ENDIF
      End With
   ENDIF
RETURN cHtml

//------------------------------------------------------------------------------

PROCEDURE AjaxSRDDETAIL()
   LOCAL cAxo := oCGI:GetCgiValue("axo","")
   LOCAL cMes := oCGI:GetCgiValue("mes","" )
   LOCAL cCTT := oCGI:GetCgiValue("ctt","")
   LOCAL aTmp := LastYearMonth()

   oCGI:SetUserData("RSDETAIL_CTT",cCTT)
//   nfl_Console( cAxo,cMes,cCTT )
   IF Empty( cAxo )
      cAxo := aTmp[1]
      cMes := aTmp[2]
   ENDIF

   oCGI:SendPage( UpdateSRDDETAIL(,cAxo,cMes,cCTT ) )
RETURN

//------------------------------------------------------------------------------
// Crea un Array con el Mes y Año anteriores al Mes Actual
FUNCTION LastYearMonth()
   LOCAL nYear := Year( Date() ),nMonth := Month(Date() ) -1
   LOCAL cAxo,cMes

   IF nMonth == 0
      cAxo   := ToString( Year( Date () ) - 1 )
      nMonth := 12
   ELSE
      cAxo := ToString( Year( Date () ) )
   ENDIF
      cMes := StrZero( nMonth,2 )
RETURN {cAxo,cMes}

