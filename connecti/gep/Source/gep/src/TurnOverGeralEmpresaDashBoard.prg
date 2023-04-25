// Proyecto: GEP
/*
 * Fichero: TurnOverGeralEmpresaDashBoard.prg
 * Descripción:
 * Autor:
 * Fecha: 14/08/2021
 */

#include "Xailer.ch"
#include "Nefele.ch"
#include "LangCGI.ch"

PROCEDURE __TurnOverGeralEmpresaDashBoard()

   LOCAL hUser := LoginUser()

   LOCAL cTitle := AppData:AppTitle + " :: " + "DashBoard Consulta TurnOver Geral por Empresa "

   LOCAL cIDParameters
   LOCAL aParameters

   LOCAL codPeriodo
   LOCAL codPeriodoAte

   LOCAL oTWebPage

   LOCAL hData
   LOCAL hFilter

   LOCAL nRow
   LOCAL nRows

   IF (stacktools():IsInCallStack("TCGI:__TurnOverGeralEmpresaDashBoardDet"))
      IF (existsTmpParameters("__TurnOverGeralEmpresa"))
         restoreTmpParameters("__TurnOverGeralEmpresa",@hFilter,.T.)
      ENDIF
   ELSE
      codPeriodo := oCGI:GetUserData( "__TurnOverGeralEmpresaDashBoard:codPeriodo", "" )
      hFilter["codPeriodo"]:=codPeriodo
      codPeriodoAte := oCGI:GetUserData( "__TurnOverGeralEmpresaDashBoard:codPeriodoAte", "" )
      hFilter["codPeriodoAte"]:=codPeriodoAte
   ENDIF

   __TurnOverGeralEmpresa(.F.,hFilter)
   codPeriodo := oCGI:GetUserData( "__TurnOverGeralEmpresa:codPeriodo", "" )
   codPeriodoAte := oCGI:GetUserData( "__TurnOverGeralEmpresa:codPeriodoAte", "" )

   hData:=GetDataTurnOverGeralEmpresa(.F.,.T.,"")

   WITH OBJECT oTWebPage:=wTWebPage():New()

      :cCSS += "h10 {font-size: 12px; font-weight: lighter; font-family: -apple-system,BlinkMacSystemFont,'Segoe UI',Roboto,Oxygen-Sans,Ubuntu,Cantarell,'Helvetica Neue',sans-serif; !important;}"
      :cCSS += "h12 {font-size: 14px; font-weight: bold; font-family: -apple-system,BlinkMacSystemFont,'Segoe UI',Roboto,Oxygen-Sans,Ubuntu,Cantarell,'Helvetica Neue',sans-serif; !important;}"

      :cTitle := cTitle

      oCGI:SetUserData( "HistoryRemoveParams", .F. )
      AppMenu( oTWebPage, AppData:AppName, hUser, .F., .F.,.F., .F. )

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

      WITH object wDashBoardTurnOver():New( oTWebPage )
         :yearDashBoard:=Left(codPeriodo,4)
         :monthsData:={'JAN','FEV','MAR','ABR','MAI','JUN','JUL','AGO','SET','OUT','NOV','DEZ'}
         :colorPaletteData:={'#00D8B6','#008FFB','#FEB019','#FF4560','#775DD0','#01BFD6','#5564BE','#F7A600','#EDCD12','#F74F58','#45DD98','#012444'}
         :transfEntData:=Array(0)
         :transfSaiData:=Array(0)
         :admissoesData:=Array(0)
         :demissoesData:=Array(0)
         :totalfuncIMesData:=Array(0)
         :totalfuncFMesData:=Array(0)
         :turnOverGeralData:=Array(0)
         :turnOverDemissoesData:=Array(0)
         :totalAdmissoes:=0
         :totalDemissoes:=0
         :totalFuncIMes:=0
         :totalFuncIPer:=Val(StrTran(hData[ "data" ][ 1 ][ "totalFuncionariosInicioMes" ],",",""))
         nRows := Len( hData[ "data" ] )
         FOR nRow := 1 TO nRows
            AAdd(:transfEntData,Val(StrTran(hData[ "data" ][ nRow ][ "totalTransferenciasEntrada" ],",","")))
            AAdd(:transfSaiData,Val(StrTran(hData[ "data" ][ nRow ][ "totalTransferenciasSaida" ],",","")))
            AAdd(:admissoesData,Val(StrTran(hData[ "data" ][ nRow ][ "totalFuncionariosAdmitidos" ],",","")))
            AAdd(:demissoesData,Val(StrTran(hData[ "data" ][ nRow ][ "totalFuncionariosDemitidos" ],",","")))
            AAdd(:totalfuncIMesData,Val(StrTran(hData[ "data" ][ nRow ][ "totalFuncionariosInicioMes" ],",","")))
            AAdd(:totalfuncFMesData,Val(StrTran(hData[ "data" ][ nRow ][ "totalFuncionariosFinalMes" ],",","")))
            AAdd(:turnOverGeralData,Val(StrTran(hData[ "data" ][ nRow ][ "turnOverGeral" ],",","")))
            AAdd(:turnOverDemissoesData,Val(StrTran(hData[ "data" ][ nRow ][ "turnOverDemissoes" ],",","")))
            :totalFuncIMes+=Val(StrTran(hData[ "data" ][ nRow ][ "totalFuncionariosInicioMes" ],",",""))
            :totalAdmissoes+=Val(StrTran(hData[ "data" ][ nRow ][ "totalFuncionariosAdmitidos" ],",",""))
            :totalDemissoes+=Val(StrTran(hData[ "data" ][ nRow ][ "totalFuncionariosDemitidos" ],",",""))
         NEXT nRow
         :totalFuncFPer:=Val(StrTran(hData[ "data" ][ --nRow ][ "totalFuncionariosFinalMes" ],",",""))
         :totalTurnOverGeral:=(((((:totalAdmissoes+:totalDemissoes)/2)/:totalFuncIMes)/nRow)*100)
         :totalturnOverDemissoes:=(((((:totalDemissoes)/2)/:totalFuncIMes)/nRow)*100)
         :Create()
      END whith

      :lValign    := .F.
      :lContainer := .T.

      oCgi:SendPage( :Create() )

   END

RETURN

PROCEDURE TurnOverGeralEmpresaDashBoard()

   LOCAL hUser := LoginUser()

   LOCAL cSubTitle := + " :: " + "DashBoard Consulta TurnOver Geral por Empresa "
   LOCAL cTitle := AppData:AppTitle + cSubTitle

   LOCAL cIDParameters
   LOCAL aParameters

   oCGI:SetUserData( "__TurnOverGeralEmpresaDashBoard:Back", ProcName() )

   WITH OBJECT wTWebPage():New()

      :cTitle := cTitle

      AppMenu( :WO, AppData:AppName, hUser, .F., .F., .T., .F. )

      aParameters := { "codPeriodo", "codPeriodoAte" }
      cSubTitle := AppData:AppName + cSubTitle
      GEPParameters( :WO, @cIDParameters, "__TurnOverGeralEmpresaDashBoard", aParameters, .T., cSubTitle, .T. ):Create()

      :lValign    := .F.
      :lContainer := .F.

      oCgi:SendPage( :Create() )

   END

RETURN
