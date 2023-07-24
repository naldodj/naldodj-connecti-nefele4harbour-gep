// Proyecto: GEP
/*
 * Fichero: TurnOverGeralFilialDashBoard.prg
 * Descripción:
 * Autor:
 * Fecha: 14/08/2021
 */

#include "Xailer.ch"
#include "Nefele.ch"
#include "LangCGI.ch"

PROCEDURE __TurnOverGeralFilialDashBoard()

   LOCAL hUser := LoginUser()

   LOCAL cTitle := AppData:AppTitle + " :: " + "DashBoard Consulta TurnOver Geral por Filial "

   LOCAL cIDParameters
   LOCAL aParameters

   LOCAL cFilter
   LOCAL codFilial
   LOCAL codPeriodo
   LOCAL codPeriodoAte

   LOCAL oWLabel
   LOCAL oWBevel
   LOCAL oTWebPage

   LOCAL hData
   LOCAL hRowFil
   LOCAL hFilter
   LOCAL hDataFil
   LOCAL hFilterFilial

   LOCAL hGEPParameters

   LOCAL nRow
   LOCAL nRows

   IF ( stacktools():IsInCallStack( "TCGI:__TurnOverGeralFilialDashBoardDet" ) )
      IF ( existsTmpParameters( "__TurnOverGeralFilial" ) )
         restoreTmpParameters( "__TurnOverGeralFilial", @hFilter, .T. )
      ENDIF
   ENDIF

   hFilter:=__TurnOverGeralFilial( .F. )

   saveTmpParameters( "__TurnOverGeralFilial", @hFilter , @hGEPParameters )

   hFilterFilial:= HB_HClone(hFilter)

   codPeriodo := oCGI:GetUserData( "__TurnOverGeralFilial:codPeriodo", "" )
   codPeriodoAte := oCGI:GetUserData( "__TurnOverGeralFilial:codPeriodoAte", "" )
   codFilial := oCGI:GetUserData( "__TurnOverGeralFilial:codFilial", "" )

   WITH OBJECT oTWebPage := wTWebPage():New()

      :cCSS += "h10 {font-size: 12px; font-weight: lighter; font-family: -apple-system,BlinkMacSystemFont,'Segoe UI',Roboto,Oxygen-Sans,Ubuntu,Cantarell,'Helvetica Neue',sans-serif; !important;}"
      :cCSS += "h12 {font-size: 14px; font-weight: bold; font-family: -apple-system,BlinkMacSystemFont,'Segoe UI',Roboto,Oxygen-Sans,Ubuntu,Cantarell,'Helvetica Neue',sans-serif; !important;}"

      :cTitle := cTitle

      oCGI:SetUserData( "HistoryRemoveParams", .F. )
      AppMenu( oTWebPage, AppData:AppName, hUser, .F., .F., .F., .F. )

      WITH OBJECT WFloatingBtn():New( oTWebPage )
         :cClrPane := "#005FAB"
         :cName := ( "WFloatingBtn" + ProcName() )
         :cId := Lower( :cName )
         :cText := "Voltar"
         :oIcon:cIcon := "arrow_back"
         :oIcon:cClrIcon := "#FED300"
         :cOnClick := oCGI:GetUserData( ProcName() + ":Back", "MAINFUNCTION" )
         :Create()
      END WITH

      cFilter:=""

      if (!Empty(codFilial))
         if (!Empty(cFilter))
            cFilter+=" AND "
         endif
         cFilter+="M0_CODFIL='"+codFilial+"'"
      endif

      IF (!Empty(cFilter))
         cFilter:="SQL:"+cFilter
      endif

      oCGI:SetUserData("__CadastroFiliais:codFilial",codFilial)
      hDataFil:=GetDataCadastroFiliais(.F.,.T.,cFilter)
      oCGI:SetUserData("__CadastroFiliais:codFilial","")

      for each hRowFil in hDataFil["data"]

         codFilial:=hRowFil["codFilial"]

         hFilterFilial["codFilial"]:=codFilial
         hFilterFilial["codPeriodo"]:=codPeriodo
         hFilterFilial["codPeriodoAte"]:=codPeriodoAte

         saveTmpParameters( "__TurnOverGeralFilial", @hFilterFilial )

         oCGI:SetUserData("__TurnOverGeralFilial:codFilial",codFilial)
         oCGI:SetUserData("__TurnOverGeralFilial:codPeriodo",codPeriodo)
         oCGI:SetUserData("__TurnOverGeralFilial:codPeriodoAte",codPeriodoAte)

         hData := GetDataTurnOverGeralFilial( .F., .T., "" )

         IF (Empty(hData["data"]))
            LOOP
         ENDIF

         With Object oWBevel:=WBevel():New(oTWebPage)

            With Object oWLabel:=WLabel():New(oWBevel)
              :nHeaderSize:=6
              :nFontSize:=12
              :lBR:=.T.
              :lBold:=.T.
              :cAlign:=xc_Left
              :cText:="<h12>"
              :cText+="Filial: "
              :cText+=codFilial
              :cText+="-"
              :cText+=hRowFil["descFilial"]
              :cText+="</h12>"
              :Create()
            End With

            WITH OBJECT wDashBoardTurnOver():New( oWBevel )
               :yearDashBoard := Left( codPeriodo, 4 )
               :monthsData := { 'JAN', 'FEV', 'MAR', 'ABR', 'MAI', 'JUN', 'JUL', 'AGO', 'SET', 'OUT', 'NOV', 'DEZ' }
               :colorPaletteData := { '#00D8B6', '#008FFB', '#FEB019', '#FF4560', '#775DD0', '#01BFD6', '#5564BE', '#F7A600', '#EDCD12', '#F74F58', '#45DD98', '#012444' }
               :transfEntData := Array( 0 )
               :transfSaiData := Array( 0 )
               :admissoesData := Array( 0 )
               :demissoesData := Array( 0 )
               :totalfuncIMesData := Array( 0 )
               :totalfuncFMesData := Array( 0 )
               :turnOverGeralData := Array( 0 )
               :turnOverDemissoesData := Array( 0 )
               :totalAdmissoes := 0
               :totalDemissoes := 0
               :totalFuncIMes := 0
               :totalFuncIPer := Val( StrTran( hData[ "data" ][ 1 ][ "totalFuncionariosInicioMes" ],",","" ) )
               nRows := Len( hData[ "data" ] )
               FOR nRow := 1 TO nRows
                  AAdd( :transfEntData, Val( StrTran(hData[ "data" ][ nRow ][ "totalTransferenciasEntrada" ],",","" ) ) )
                  AAdd( :transfSaiData, Val( StrTran(hData[ "data" ][ nRow ][ "totalTransferenciasSaida" ],",","" ) ) )
                  AAdd( :admissoesData, Val( StrTran(hData[ "data" ][ nRow ][ "totalFuncionariosAdmitidos" ],",","" ) ) )
                  AAdd( :demissoesData, Val( StrTran(hData[ "data" ][ nRow ][ "totalFuncionariosDemitidos" ],",","" ) ) )
                  AAdd( :totalfuncIMesData, Val( StrTran(hData[ "data" ][ nRow ][ "totalFuncionariosInicioMes" ],",","" ) ) )
                  AAdd( :totalfuncFMesData, Val( StrTran(hData[ "data" ][ nRow ][ "totalFuncionariosFinalMes" ],",","" ) ) )
                  AAdd( :turnOverGeralData, Val( StrTran(hData[ "data" ][ nRow ][ "turnOverGeral" ],",","" ) ) )
                  AAdd( :turnOverDemissoesData, Val( StrTran(hData[ "data" ][ nRow ][ "turnOverDemissoes" ],",","" ) ) )
                  :totalFuncIMes += Val( StrTran( hData[ "data" ][ nRow ][ "totalFuncionariosInicioMes" ],",","" ) )
                  :totalAdmissoes += Val( StrTran( hData[ "data" ][ nRow ][ "totalFuncionariosAdmitidos" ],",","" ) )
                  :totalDemissoes += Val( StrTran( hData[ "data" ][ nRow ][ "totalFuncionariosDemitidos" ],",","" ) )
               NEXT nRow
               :totalFuncFPer := Val( StrTran( hData[ "data" ][ --nRow ][ "totalFuncionariosFinalMes" ],",","" ) )
               :totalTurnOverGeral := ( ( (((:totalAdmissoes + :totalDemissoes ) / 2 ) / :totalFuncIMes ) / nRow ) * 100 )
               :totalturnOverDemissoes := ( ( (((:totalDemissoes ) / 2 ) / :totalFuncIMes ) / nRow ) * 100 )
               :Create()
            END whith

            :Create()

         End With

      next hRowFil

      :lValign    := .F.
      :lContainer := .T.

      oCgi:SendPage( :Create() )

   END

   __TurnOverGeralFilial( .F. , hFilter )

   saveTmpParameters( "__TurnOverGeralFilial", @hFilter)

   SetGEPParameters(hGEPParameters)

RETURN

PROCEDURE TurnOverGeralFilialDashBoard()

   LOCAL hUser := LoginUser()

   LOCAL cSubTitle := + " :: " + "DashBoard Consulta TurnOver Geral por Filial "
   LOCAL cTitle := AppData:AppTitle + cSubTitle

   LOCAL cIDParameters
   LOCAL aParameters

   oCGI:SetUserData( "__TurnOverGeralFilialDashBoard:Back", ProcName() )

   WITH OBJECT wTWebPage():New()

      :cTitle := cTitle

      AppMenu( :WO, AppData:AppName, hUser, .F., .F., .T., .F. )

      aParameters := { "codPeriodo", "codPeriodoAte" }
      cSubTitle := AppData:AppName + cSubTitle
      GEPParameters( :WO, @cIDParameters, "__TurnOverGeralFilialDashBoard", aParameters, .T., cSubTitle, .T. ):Create()

      :lValign    := .F.
      :lContainer := .F.

      oCgi:SendPage( :Create() )

   END

RETURN
