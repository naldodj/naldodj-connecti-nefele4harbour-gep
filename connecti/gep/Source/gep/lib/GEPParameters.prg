/*
 * Proyecto:      Gep
 * Fichero:       Gep.prg
 * Descripción:   Parametros GEP
 * Autor:         Administrator
 * Fecha:         28/07/2021
 */

#include "Xailer.ch"
#include "Nefele.ch"
#include "LangCGI.ch"

#define __nfl_FileDate_NotChk__ (.T.)

PROCEDURE __GEPParameters( lExecute )

   LOCAL cGEPParameter
   LOCAL hGEPParameter := hGEPParameters()

   LOCAL __cGEPParameter
   LOCAL __hGEPParameter := { => }

   FOR EACH __cGEPParameter in hb_HKeys( hGEPParameter )
      hGEPParameter[ __cGEPParameter ] := oCGI:GetCgiValue( __cGEPParameter, "" )
      IF ( Empty( hGEPParameter[ __cGEPParameter ] ) )
         hGEPParameter[ __cGEPParameter ] := oCGI:GetCgiValue( "GEPParameters_" + __cGEPParameter, "" )
      ENDIF
      __hGEPParameter[ "__GEPParameters:" + __cGEPParameter ] := hGEPParameter[ __cGEPParameter ]
   NEXT EACH

   FOR EACH __cGEPParameter in hb_HKeys( __hGEPParameter )
      oCGI:SetUserData( __cGEPParameter, __hGEPParameter[ __cGEPParameter ] )
   NEXT EACH

   saveTmpParameters( "__GEPParameters", __hGEPParameter )

   hb_default( @lExecute, .F. )

   IF ( lExecute )
      MainPage()
   ENDIF

RETURN

PROCEDURE GEPParametersShow()

   LOCAL hUser := LoginUser()

   LOCAL cTitle := "Parâmetros"
   LOCAL cSubTitle
   LOCAL cIDParameters
   LOCAL aParameters

   WITH OBJECT wTWebPage():New()

      :cTitle := AppData:AppTitle + " :: " + cTitle
      cSubTitle := AppData:AppName + " :: " + cTitle

      AppMenu( :WO, AppData:AppName, hUser, .F. )

      aParameters := { "codFilial", "codPeriodo", "codGrupo", "codCentroDeCusto", "codVerba", "codFuncao" , "codAgrFuncao" }
      GEPParameters( :WO, @cIDParameters, "__GEPParameters", aParameters, .T., cSubTitle, .T. ):Create()

      :lValign    := .F.
      :lContainer := .F.

      oCgi:SendPage( :Create() )

   END

RETURN

FUNCTION GEPParameters( oWO, cID, cAction, aParameters, lNoStyle, cSubTitle, lFloatBTN )

   LOCAL aPeriodos

   LOCAL cCSS
   LOCAL cIDParameters := "GEPParameters"

   LOCAL __cGEPParameter
   LOCAL __hGEPParameter

   LOCAL oWForm
   LOCAL oWBevel
   LOCAL oWPanel

   hb_default( @cID, Lower( ProcName(1 ) ) + "_parameters" )
   hb_default( @cAction, "VisParam" )
   hb_default( @aParameters, Array( 0 ) )

   restoreTmpParameters( "__GEPParameters", @__hGEPParameter )

   cCSS := "div.nflcompress > .select-wrapper input.select-dropdown { color: black !important; background-color: transparent !important; font-size: 11px !Important; font-weight: 500; font-family: 'Helvetica Neue','Helvetica',-apple-system,BlinkMacSystemFont,'Segoe UI',Roboto,Oxygen-Sans,Ubuntu,Cantarell,'Helvetica Neue',sans-serif !important;}"
   IF ( !( cCSS $ oWO:cCSS ) )
      oWO:cCSS += cCSS
   ENDIF

   cCSS := ".select-dropdown li.disabled, .select-dropdown li.disabled>span, .select-dropdown li.optgroup { line-height: 13px !Important ; color: white !important; background-color: transparent !important; font-size: 11px !Important; font-weight: 500; font-family: 'Helvetica Neue','Helvetica',-apple-system,BlinkMacSystemFont,'Segoe UI',Roboto,Oxygen-Sans,Ubuntu,Cantarell,'Helvetica Neue',sans-serif !important;}"
   IF ( !( cCSS $ oWO:cCSS ) )
      oWO:cCSS += cCSS
   ENDIF

   cCSS := ".dropdown-content li > a, .dropdown-content li > span { line-height: 13px !Important ; color: #45DD98 !important; background-color: transparent !important; font-size: 11px !Important; font-weight: 500; font-family: 'Helvetica Neue','Helvetica',-apple-system,BlinkMacSystemFont,'Segoe UI',Roboto,Oxygen-Sans,Ubuntu,Cantarell,'Helvetica Neue',sans-serif !important;}"
   IF ( !( cCSS $ oWO:cCSS ) )
      oWO:cCSS += cCSS
   ENDIF

   hb_default( @lFloatBTN, .F. )
   IF ( lFloatBTN )
      WITH OBJECT WFloatingBtn():New( oWO )
         :cClrPane := "#005FAB"
         :cName := ( "WFloatingBtn" + ProcName() )
         :cID := Lower( :cName )
         :cText := "Voltar"
         :oIcon:cIcon := "arrow_back"
         :oIcon:cClrIcon := "#FED300"
         :cOnClick := "MainFunction"
         :Create()
      END WITH
   ENDIF

   WITH Object oWBevel := WBevel():New( oWO )
      :cID := cID
      hb_default( @lNoStyle, .F. )
      IF ( !lNoStyle )
         :nStyle := xc_Modal
      ENDIF
      :cModalHeight := "80%"
      :cModalWidth := "80%"
      WITH object oWPanel := WPanel():New( oWBevel )
         :cClrText := "white"
         :cClrTitle := :cClrText
         :cBackgroundColor := "#012444"
         hb_default( @cSubTitle, "" )
         :cTitle := "<h6>Parâmetros</h6>"
         :cText := cSubTitle
         :oStyle:cText_align := xc_Center
         :lShadow := .F.
         oWPanel:Create()
      END WITH
      WITH object WSeparator():New( oWBevel )
         :lLine := .T.
         :Create()
      END WITH
      WITH Object oWForm := WForm():New( oWBevel )
         :cID := ( cIDParameters + "_form" )
         :cFunction := cAction
         :lCompress := .T.
         :lShadowSheet := .T.
         IF ( GEPHasParameter( aParameters,"codPeriodo" ) )
            aPeriodos := GEPParametersGetPeriodos()
            WITH OBJECT wJQueryDatePicker():New(oWForm)
               :cID := ( cIDParameters + "_codPeriodo" )
               :AddParam( { :cID, "#" + :cID + ":selected" } )
               :hOptions["yearRange"]:=Left(aPeriodos[Len(aPeriodos)][1],4)+":"+Left(aPeriodos[1][1],4)
               :cTitle := "Periodo"
               :cHint  := "Selecione um Periodo"
               :cValue:=oCGI:GetUserData("__GEPParameters:codPeriodo",aPeriodos[1][1])
               //https://materializecss.com/icons.html
               :oIcon:cIcon  := "date_range"
               :cHelp  := "Este parametro sera utilizado para Filtrar o Periodo"
               :lCompress := .T.
               :SetRequired()
               :Create()
            END With
         ENDIF
         IF ( GEPHasParameter( aParameters,"codPeriodoAte" ) )
            IF Empty( aPeriodos )
               aPeriodos := GEPParametersGetPeriodos()
            ENDIF
            WITH OBJECT wJQueryDatePicker():New(oWForm)
               :cID := ( cIDParameters + "_codPeriodoAte" )
               :AddParam( { :cID, "#" + :cID + ":selected" } )
               :hOptions["yearRange"]:=Left(aPeriodos[Len(aPeriodos)][1],4)+":"+Left(aPeriodos[1][1],4)
               :cTitle := "Periodo"
               :cHint  := "Selecione um Periodo"
               :cValue:=oCGI:GetUserData("__GEPParameters:codPeriodo",aPeriodos[1][1])
               //https://materializecss.com/icons.html
               :oIcon:cIcon  := "date_range"
               :cHelp  := "Este parametro sera utilizado para Filtrar o Periodo Ate"
               :lCompress := .T.
               :SetRequired()
               :Create()
            END With
         ENDIF
         IF ( GEPHasParameter( aParameters,"codFilial" ) )
            WITH Object WComboBox():New( oWForm )
               :cID := ( cIDParameters + "_codFilial" )
               :AddParam( { :cID, "#" + :cID + ":selected" } )
               :cTitle := "Filial"
               :cText  := "Selecione uma Filial"
               //https://materializecss.com/icons.html
               :oIcon:cIcon  := "business"
               :cHelp  := "Este parametro sera utilizado para Filtrar a Filial"
               :aItems := GEPParametersGetFiliais()
               :cSelected := oCGI:GetUserData( "__GEPParameters:codFilial", :aItems[ 1 ][ 2 ] )
               :lCompress := .T.
               :lCompressList := .T.
               :Create()
            END WITH
         ENDIF
         IF ( GEPHasParameter( aParameters,"codCentroDeCusto" ) )
            WITH Object WComboBox():New( oWForm )
               :cID := ( cIDParameters + "_codCentroDeCusto" )
               :AddParam( { :cID, "#" + :cID + ":selected" } )
               :cTitle := "Centro de Custo"
               :cText  := "Selecione um Centro de Custo"
               //https://materializecss.com/icons.html
               :oIcon:cIcon  := "business_center"
               :cHelp  := "Este parametro sera utilizado para Filtrar o Centro de Custo"
               :aItems := GEPParametersGetCentrodeCusto()
               :cSelected := oCGI:GetUserData( "__GEPParameters:codCentroDeCusto", :aItems[ 1 ][ 2 ] )
               :lCompress := .T.
               :lCompressList := .T.
               :Create()
            END WITH
         ENDIF
         IF ( GEPHasParameter( aParameters,"codGrupoSuperior" ) )
            WITH Object WComboBox():New( oWForm )
               :cID := ( cIDParameters + "_codGrupoSuperior" )
               :AddParam( { :cID, "#" + :cID + ":selected" } )
               :cTitle := "Grupo Superior"
               :cText  := "Selecione um Grupo"
               //https://materializecss.com/icons.html
               :oIcon:cIcon  := "group"
               :cHelp  := "Este parametro sera utilizado para Filtrar o Grupo Superior de Verbas"
               :aItems := GEPParametersGetGruposMaster()
               :cSelected := oCGI:GetUserData( "__GEPParameters:codGrupoSuperior", :aItems[ 1 ][ 2 ] )
               :lCompress := .T.
               :lCompressList := .T.
               :Create()
            END WITH
         ENDIF
         IF ( GEPHasParameter( aParameters,"codGrupo" ) )
            WITH Object WComboBox():New( oWForm )
               :cID := ( cIDParameters + "_codGrupo" )
               :AddParam( { :cID, "#" + :cID + ":selected" } )
               :cTitle := "Grupo da Verba"
               :cText  := "Selecione um Grupo"
               //https://materializecss.com/icons.html
               :oIcon:cIcon  := "group"
               :cHelp  := "Este parametro sera utilizado para Filtrar o Grupo de Verbas"
               :aItems := GEPParametersGetGrupos()
               :cSelected := oCGI:GetUserData( "__GEPParameters:codGrupo", :aItems[ 1 ][ 2 ] )
               :lCompress := .T.
               :lCompressList := .T.
               :Create()
            END WITH
         ENDIF
         IF ( GEPHasParameter( aParameters,"codVerba" ) )
            WITH Object WComboBox():New( oWForm )
               :cID := ( cIDParameters + "_codVerba" )
               :AddParam( { :cID, "#" + :cID + ":selected" } )
               :cTitle := "Verba"
               :cText  := "Selecione uma Verba"
               //https://materializecss.com/icons.html
               :oIcon:cIcon  := "money"
               :cHelp  := "Este parametro sera utilizado para Filtrar a Verba"
               :aItems := GEPParametersGetVerbas()
               :cSelected := oCGI:GetUserData( "__GEPParameters:codVerba", :aItems[ 1 ][ 2 ] )
               :lCompress := .T.
               :lCompressList := .T.
               :Create()
            END WITH
         ENDIF
         IF ( GEPHasParameter( aParameters,"codFuncao" ) )
            WITH Object WComboBox():New( oWForm )
               :cID := ( cIDParameters + "_codFuncao" )
               :AddParam( { :cID, "#" + :cID + ":selected" } )
               :cTitle := "Funcao"
               :cText  := "Selecione uma Funcao"
               //https://materializecss.com/icons.html
               :oIcon:cIcon  := "work"
               :cHelp  := "Este parametro sera utilizado para Filtrar a Funcao"
               :aItems := GEPParametersGetFuncoes()
               :cSelected := oCGI:GetUserData( "__GEPParameters:codFuncao", :aItems[ 1 ][ 2 ] )
               :lCompress := .T.
               :lCompressList := .T.
               :Create()
            END WITH
         ENDIF
         IF ( GEPHasParameter( aParameters,"codAgrFuncao" ) )
            WITH Object WComboBox():New( oWForm )
               :cID := ( cIDParameters + "_codAgrFuncao" )
               :AddParam( { :cID, "#" + :cID + ":selected" } )
               :cTitle := "Agr.Funcao"
               :cText  := "Selecione um Agr.Funcao"
               //https://materializecss.com/icons.html
               :oIcon:cIcon  := "work"
               :cHelp  := "Este parametro sera utilizado para Filtrar o Agr.Funcao"
               :aItems := GEPParametersGetAgrFuncoes()
               :cSelected := oCGI:GetUserData( "__GEPParameters:codAgrFuncao", :aItems[ 1 ][ 2 ] )
               :lCompress := .T.
               :lCompressList := .T.
               :Create()
            END WITH
         ENDIF
         WITH Object WButton():New( oWForm )
            :cID := ( cIDParameters + "_submit" )
            :cText := "OK"
            :lSubmit    := .T.
            :lVisible   := .T.
            :lLarge     := .F.
            :lBold      := .T.
            :lCenter    := .T.
            :cPosition := "center"
            :oIcon:cIcon := "check_circle"
            :oIcon:cSize := Lower( "large" )
            :oIcon:cAlign := "right"
            :Create()
         END WITH
         oWForm:Create()
      END WITH

   END WITH

   __clearGEPParameters()

RETURN( oWBevel )

STATIC FUNCTION GEPHasParameter( aParameters, cParameter )

   hb_default( @aParameters, Array( 0 ) )
   hb_default( @cParameter, "" )

return( ( AScan(aParameters,{| x | (Lower(AllTrim(x ) ) == Lower(AllTrim(cParameter ) ) ) } ) > 0 ) )

FUNCTION GEPParametersGetFiliais( lUseCachedParameters )

   LOCAL aSource := Array( 0 )

   LOCAL cFile
   LOCAL xData

   LOCAL nRow
   LOCAL nRows

   hb_default( @lUseCachedParameters, .T. )

   AppData:cEmp := oCGI:GetUserData( "cEmp", AppData:cEmp )
   hb_default( AppData:cEmp, "" )

   cFile := ( AppData:PathData + AppData:cEmp + "_" + Lower( ProcName() ) + ".json" )
   cFile := StrTran( cFile, ".json", "_dataparameters.json" )
   IF ( File( cFile ) .AND. ( lUseCachedParameters .AND. ( (__nfl_FileDate_NotChk__ ) .OR. nfl_FileDate(cFile ) == Date() ) ) )
      hb_jsonDecode( hb_MemoRead( cFile ), @aSource )
   ELSE
      xData := GetDataCadastroFiliais( .F., .T., "" )
      AAdd( aSource, { "", "Todos(as)" } )
      nRows := Len( xData[ "data" ] )
      FOR nRow := 1 TO nRows
         AAdd( aSource, { xData[ "data" ][ nRow ][ "codFilial" ], xData[ "data" ][ nRow ][ "codFilial" ] + "-" + xData[ "data" ][ nRow ][ "descFilial" ] } )
      NEXT nRow
      hb_MemoWrit( cFile, hb_jsonEncode( aSource ) )
   ENDIF

return( aSource )

FUNCTION GEPParametersGetPeriodos( lUseCachedParameters )

   LOCAL aSource := Array( 0 )

   LOCAL cFile
   LOCAL xData

   LOCAL nRow
   LOCAL nRows

   hb_default( @lUseCachedParameters, .T. )

   AppData:cEmp := oCGI:GetUserData( "cEmp", AppData:cEmp )
   hb_default( AppData:cEmp, "" )

   cFile := ( AppData:PathData + AppData:cEmp + "_" + Lower( ProcName() ) + ".json" )
   cFile := StrTran( cFile, ".json", "_dataparameters.json" )
   IF ( File( cFile ) .AND. ( lUseCachedParameters .AND. ( (__nfl_FileDate_NotChk__ ) .OR. nfl_FileDate(cFile ) == Date() ) ) )
      hb_jsonDecode( hb_MemoRead( cFile ), @aSource )
   ELSE
      xData := GetDataCadastroPeriodosSRD( .F., .T., "" )
      nRows := Len( xData[ "data" ] )
      IF ( stacktools():IsInCallStack( "CadastroPeriodosSRD" ) )
         AAdd( aSource, { "", "Todos(as)" } )
      ENDIF
      FOR nRow := 1 TO nRows
         AAdd( aSource, { xData[ "data" ][ nRow ][ "codPeriodo" ], xData[ "data" ][ nRow ][ "codPeriodoMesAno" ] } )
      NEXT nRow
      ASort( aSource, NIL, NIL, {| x, y | x[ 1 ] > y[ 1 ] } )
      hb_MemoWrit( cFile, hb_jsonEncode( aSource ) )
   ENDIF

   IF ( !Empty( aSource ) .AND. ( Empty(oCGI:GetUserData("__GEPParameters:codPeriodo","" ) ) ) )
      oCGI:SetUserData( "__GEPParameters:codPeriodo", aSource[ 1 ][ 1 ] )
   ENDIF

   IF ( !Empty( aSource ) .AND. ( Empty(oCGI:GetUserData("__GEPParameters:codPeriodoAte","" ) ) ) )
      oCGI:SetUserData( "__GEPParameters:codPeriodoAte", aSource[ 1 ][ 1 ] )
   ENDIF

return( aSource )

FUNCTION GEPParametersGetCentrodeCusto( lUseCachedParameters )

   LOCAL aSource := Array( 0 )

   LOCAL cFile
   LOCAL xData

   LOCAL nRow
   LOCAL nRows

   hb_default( @lUseCachedParameters, .T. )

   AppData:cEmp := oCGI:GetUserData( "cEmp", AppData:cEmp )
   hb_default( AppData:cEmp, "" )

   cFile := ( AppData:PathData + AppData:cEmp + "_" + Lower( ProcName() ) + ".json" )
   cFile := StrTran( cFile, ".json", "_dataparameters.json" )
   IF ( File( cFile ) .AND. ( lUseCachedParameters .AND. ( (__nfl_FileDate_NotChk__ ) .OR. nfl_FileDate(cFile ) == Date() ) ) )
      hb_jsonDecode( hb_MemoRead( cFile ), @aSource )
   ELSE
      AAdd( aSource, { "", "Todos(as)" } )
      xData := GetDataCadastroCentrosDeCusto( .F., .T., "" )
      nRows := Len( xData[ "data" ] )
      FOR nRow := 1 TO nRows
         AAdd( aSource, { xData[ "data" ][ nRow ][ "codCentroDeCusto" ], xData[ "data" ][ nRow ][ "codCentroDeCusto" ] + "-" + xData[ "data" ][ nRow ][ "descCentroDeCusto" ] } )
      NEXT nRow
      hb_MemoWrit( cFile, hb_jsonEncode( aSource ) )
   ENDIF

return( aSource )

FUNCTION GEPParametersGetGruposMaster( lUseCachedParameters )

   LOCAL aSource := Array( 0 )

   LOCAL cFile
   LOCAL xData

   LOCAL nRow
   LOCAL nRows

   hb_default( @lUseCachedParameters, .T. )

   AppData:cEmp := oCGI:GetUserData( "cEmp", AppData:cEmp )
   hb_default( AppData:cEmp, "" )

   cFile := ( AppData:PathData + AppData:cEmp + "_" + Lower( ProcName() ) + ".json" )
   cFile := StrTran( cFile, ".json", "_dataparameters.json" )
   IF ( File( cFile ) .AND. ( lUseCachedParameters .AND. ( (__nfl_FileDate_NotChk__ ) .OR. nfl_FileDate(cFile ) == Date() ) ) )
      hb_jsonDecode( hb_MemoRead( cFile ), @aSource )
   ELSE
      AAdd( aSource, { "", "Todos(as)" } )
      xData := GetDataCadastroGruposMaster( .F., .T., "" )
      nRows := Len( xData[ "data" ] )
      FOR nRow := 1 TO nRows
         AAdd( aSource, { xData[ "data" ][ nRow ][ "codGrupo" ], xData[ "data" ][ nRow ][ "codGrupo" ] + "-" + xData[ "data" ][ nRow ][ "descGrupo" ] } )
      NEXT nRow
      hb_MemoWrit( cFile, hb_jsonEncode( aSource ) )
   ENDIF

return( aSource )

FUNCTION GEPParametersGetGrupos( lUseCachedParameters )

   LOCAL aSource := Array( 0 )

   LOCAL cFile
   LOCAL xData

   LOCAL nRow
   LOCAL nRows

   hb_default( @lUseCachedParameters, .T. )

   AppData:cEmp := oCGI:GetUserData( "cEmp", AppData:cEmp )
   hb_default( AppData:cEmp, "" )

   cFile := ( AppData:PathData + AppData:cEmp + "_" + Lower( ProcName() ) + ".json" )
   cFile := StrTran( cFile, ".json", "_dataparameters.json" )
   IF ( File( cFile ) .AND. ( lUseCachedParameters .AND. ( (__nfl_FileDate_NotChk__ ) .OR. nfl_FileDate(cFile ) == Date() ) ) )
      hb_jsonDecode( hb_MemoRead( cFile ), @aSource )
   ELSE
      AAdd( aSource, { "", "Todos(as)" } )
      xData := GetDataCadastroGrupos( .F., .T., "" )
      nRows := Len( xData[ "data" ] )
      FOR nRow := 1 TO nRows
         AAdd( aSource, { xData[ "data" ][ nRow ][ "codGrupo" ], xData[ "data" ][ nRow ][ "codGrupo" ] + "-" + xData[ "data" ][ nRow ][ "descGrupo" ] } )
      NEXT nRow
      hb_MemoWrit( cFile, hb_jsonEncode( aSource ) )
   ENDIF

return( aSource )

FUNCTION GEPParametersGetVerbas( lUseCachedParameters )

   LOCAL aSource := Array( 0 )

   LOCAL cFile
   LOCAL xData

   LOCAL nRow
   LOCAL nRows

   hb_default( @lUseCachedParameters, .T. )

   AppData:cEmp := oCGI:GetUserData( "cEmp", AppData:cEmp )
   hb_default( AppData:cEmp, "" )

   cFile := ( AppData:PathData + AppData:cEmp + "_" + Lower( ProcName() ) + ".json" )
   cFile := StrTran( cFile, ".json", "_dataparameters.json" )
   IF ( File( cFile ) .AND. ( lUseCachedParameters .AND. ( (__nfl_FileDate_NotChk__ ) .OR. nfl_FileDate(cFile ) == Date() ) ) )
      hb_jsonDecode( hb_MemoRead( cFile ), @aSource )
   ELSE
      AAdd( aSource, { "", "Todos(as)" } )
      xData := GetDataCadastroVerbas( .F., .T., "" )
      nRows := Len( xData[ "data" ] )
      FOR nRow := 1 TO nRows
         AAdd( aSource, { xData[ "data" ][ nRow ][ "codVerba" ], xData[ "data" ][ nRow ][ "codVerba" ] + "-" + xData[ "data" ][ nRow ][ "descVerba" ] } )
      NEXT nRow
      hb_MemoWrit( cFile, hb_jsonEncode( aSource ) )
   ENDIF

return( aSource )

FUNCTION GEPParametersGetFuncoes( lUseCachedParameters )

   LOCAL aSource := Array( 0 )

   LOCAL cFile
   LOCAL xData

   LOCAL nRow
   LOCAL nRows

   hb_default( @lUseCachedParameters, .T. )

   AppData:cEmp := oCGI:GetUserData( "cEmp", AppData:cEmp )
   hb_default( AppData:cEmp, "" )

   cFile := ( AppData:PathData + AppData:cEmp + "_" + Lower( ProcName() ) + ".json" )
   cFile := StrTran( cFile, ".json", "_dataparameters.json" )
   IF ( File( cFile ) .AND. ( lUseCachedParameters .AND. ( (__nfl_FileDate_NotChk__ ) .OR. nfl_FileDate(cFile ) == Date() ) ) )
      hb_jsonDecode( hb_MemoRead( cFile ), @aSource )
   ELSE
      AAdd( aSource, { "", "Todos(as)" } )
      xData := GetDataCadastroFuncoes( .F., .T., "" )
      nRows := Len( xData[ "data" ] )
      FOR nRow := 1 TO nRows
         AAdd( aSource, { xData[ "data" ][ nRow ][ "codFuncao" ], xData[ "data" ][ nRow ][ "codFuncao" ] + "-" + xData[ "data" ][ nRow ][ "descFuncao" ] } )
      NEXT nRow
      hb_MemoWrit( cFile, hb_jsonEncode( aSource ) )
   ENDIF

return( aSource )

FUNCTION GEPParametersGetAgrFuncoes( lUseCachedParameters )

   LOCAL aSource := Array( 0 )

   LOCAL cFile
   LOCAL xData

   LOCAL nRow
   LOCAL nRows

   hb_default( @lUseCachedParameters, .T. )

   AppData:cEmp := oCGI:GetUserData( "cEmp", AppData:cEmp )
   hb_default( AppData:cEmp, "" )

   cFile := ( AppData:PathData + AppData:cEmp + "_" + Lower( ProcName() ) + ".json" )
   cFile := StrTran( cFile, ".json", "_dataparameters.json" )
   IF ( File( cFile ) .AND. ( lUseCachedParameters .AND. ( (__nfl_FileDate_NotChk__ ) .OR. nfl_FileDate(cFile ) == Date() ) ) )
      hb_jsonDecode( hb_MemoRead( cFile ), @aSource )
   ELSE
      AAdd( aSource, { "", "Todos(as)" } )
      xData := GetDataCadastroFuncoes( .F., .T., "" )
      nRows := Len( xData[ "data" ] )
      FOR nRow := 1 TO nRows
         IF (aScan(aSource,{|x|x[1]==xData[ "data" ][ nRow ][ "codAgrFuncao" ]})==0)
            AAdd( aSource, { xData[ "data" ][ nRow ][ "codAgrFuncao" ], xData[ "data" ][ nRow ][ "codAgrFuncao" ] + "-" + xData[ "data" ][ nRow ][ "descAgrFuncao" ] } )
         ENDIF
      NEXT nRow
      hb_MemoWrit( cFile, hb_jsonEncode( aSource ) )
   ENDIF

return( aSource )

FUNCTION hGEPParameters()

   LOCAL hGEPParameter := { => }

   hGEPParameter[ "codGrupo" ] := ""
   hGEPParameter[ "codVerba" ] := ""
   hGEPParameter[ "codFilial" ] := ""
   hGEPParameter[ "codFuncao" ] := ""
   hGEPParameter[ "codAgrFuncao" ] := ""
   hGEPParameter[ "codPeriodo" ] := ""
   hGEPParameter[ "codPeriodoAte" ] := ""
   hGEPParameter[ "codCentroDeCusto" ] := ""

return( hGEPParameter )

PROCEDURE __clearGEPParameters( lCleanAll )

   LOCAL hGEPParameter := hGEPParameters()

   LOCAL __cGEPParameter

   FOR EACH __cGEPParameter in hb_HKeys( hGEPParameter )
      oCGI:SetUserData( "GEPParameters_" + __cGEPParameter, "" )
   NEXT EACH

   hb_default( @lCleanAll, stacktools():IsInCallStack( "LogOut" ) )

   IF ( lCleanAll )

      FOR EACH __cGEPParameter in hb_HKeys( hGEPParameter )
         oCGI:SetUserData( "__GEPParameters:" + __cGEPParameter, "" )
      NEXT EACH

      deleteTmpParameters( "__GEPParameters" )

   ENDIF

RETURN

FUNCTION saveTmpParameters( cParameter, hParameters )

   LOCAL lRet

   LOCAL cFile

   BEGIN SEQUENCE

      lRet := existsTmpParameters( cParameter, @cFile )
      IF ( lRet )
         deleteTmpParameters( cParameter )
      ENDIF

      lRet := hb_MemoWrit( cFile, hb_jsonEncode( hParameters ) )

   END SEQUENCE

return( lRet )

FUNCTION restoreTmpParameters( cParameter, hJSON, lReplaceKeyParameter, cToken )

   LOCAL lRet

   LOCAL cFile
   LOCAL cJSON

   BEGIN SEQUENCE

      lRet := existsTmpParameters( cParameter, @cFile )
      IF ( !lRet )
         break
      ENDIF

      cJSON := hb_MemoRead( cFile )

      lRet := ( !Empty( cJSON ) )
      IF ( !lRet )
         break
      ENDIF

      hb_default( @hJSON, { => } )
      hb_jsonDecode( cJSON, @hJSON )

      lRet := ( HB_ISHASH( hJSON ) )
      IF ( !lRet )
         break
      ENDIF

      hb_default( @lReplaceKeyParameter, .F. )
      hb_default( @cToken, ":" )

      setUserDataTmpParameters( cParameter, hJSON, lReplaceKeyParameter, cToken )

   END SEQUENCE

return( lRet )

FUNCTION setUserDataTmpParameters( cParameter, hJSON, lReplaceKeyParameter, cToken )

   LOCAL cKey
   LOCAL cKeyParameter

   LOCAL xValue

   LOCAL lRet := ( HB_ISHASH( hJSON ) )

   IF ( lRet )
      hb_default( @cParameter, "" )
      hb_default( @hJSON, { => } )
      hb_default( @lReplaceKeyParameter, .F. )
      hb_default( @cToken, ":" )
      FOR EACH cKey in hb_HKeys( hJSON )
         xValue := hJSON[ cKey ]
         oCGI:SetUserData( cKey, xValue )
         IF ( ( lReplaceKeyParameter ) .AND. ( !Lower(cParameter ) $ Lower(cKey ) ) )
            cKeyParameter := cParameter
            cKeyParameter += cToken
            cKeyParameter += cKey
            oCGI:SetUserData( cKeyParameter, xValue )
         ENDIF
      NEXT EACH
   ENDIF

return( lRet )

FUNCTION deleteTmpParameters( cParameter )

   LOCAL lRet

   LOCAL cFile

   BEGIN SEQUENCE

      lRet := existsTmpParameters( cParameter, @cFile )
      IF ( !lRet )
         break
      ENDIF

      lRet := FErase( cFile )

   END SEQUENCE

return( lRet )

FUNCTION existsTmpParameters( cParameter, cFile )

   LOCAL lRet

   BEGIN SEQUENCE

      lRet := ( Type( "AppData:PathTmp" ) == "C" )
      IF ( !lRet )
         break
      ENDIF

      cFile := AppData:PathTmp

      hb_default( @cParameter, "" )
      cFile += cParameter

      lRet := ( Type( "oCGI:cServerSession" ) == "C" )
      IF ( !lRet )
         break
      ENDIF

      cFile += oCGI:cServerSession

      lRet := ( File( cFile ) )
      IF ( !lRet )
         break
      ENDIF

   END SEQUENCE

return( lRet )

FUNCTION setParModel( hFilter )

   LOCAL cParModel
   LOCAL hParModel := { => }

   AppData:cEmp := oCGI:GetUserData( "cEmp", AppData:cEmp )

   hb_default( @hFilter, { => } )

   hParModel[ "parameters" ] := Array( 0 )

   AAdd( hParModel[ "parameters" ], { "!EMPRESA!", "'" + AppData:cEmp + "'" } )

   IF ( hb_HHasKey( hFilter,"codPeriodo" ) )
      AAdd( hParModel[ "parameters" ], { "!DATARQDE!", "'" + hFilter[ "codPeriodo" ] + "'" } )
      IF ( hb_HHasKey( hFilter,"codPeriodoAte" ) )
         AAdd( hParModel[ "parameters" ], { "!DATARQATE!", "'" + IF( Empty(hFilter[ "codPeriodoAte" ] ),"z",hFilter[ "codPeriodoAte" ] ) + "'" } )
      ELSE
         AAdd( hParModel[ "parameters" ], { "!DATARQATE!", "'" + IF( Empty(hFilter[ "codPeriodo" ] ),"z",hFilter[ "codPeriodo" ] ) + "'" } )
      ENDIF
   ELSE
      AAdd( hParModel[ "parameters" ], { "!DATARQDE!", "''" } )
      AAdd( hParModel[ "parameters" ], { "!DATARQATE!", "'z'" } )
   ENDIF

   IF ( hb_HHasKey( hFilter,"codFilial" ) )
      AAdd( hParModel[ "parameters" ], { "!FILIALDE!", "'" + hFilter[ "codFilial" ] + "'" } )
      AAdd( hParModel[ "parameters" ], { "!FILIALATE!", "'" + IF( Empty(hFilter[ "codFilial" ] ),"z",hFilter[ "codFilial" ] ) + "'" } )
   ELSE
      AAdd( hParModel[ "parameters" ], { "!FILIALDE!", "''" } )
      AAdd( hParModel[ "parameters" ], { "!FILIALATE!", "'z'" } )
   ENDIF

   IF ( hb_HHasKey( hFilter,"codCentroDeCusto" ) )
      AAdd( hParModel[ "parameters" ], { "!CCDE!", "'" + hFilter[ "codCentroDeCusto" ] + "'" } )
      AAdd( hParModel[ "parameters" ], { "!CCATE!", "'" + IF( Empty(hFilter[ "codCentroDeCusto" ] ),"z",hFilter[ "codCentroDeCusto" ] ) + "'" } )
   ELSE
      AAdd( hParModel[ "parameters" ], { "!CCDE!", "''" } )
      AAdd( hParModel[ "parameters" ], { "!CCATE!", "'z'" } )
   ENDIF

   IF ( hb_HHasKey( hFilter,"codGrupo" ) )
      AAdd( hParModel[ "parameters" ], { "!GRUPODE!", "'" + hFilter[ "codGrupo" ] + "'" } )
      AAdd( hParModel[ "parameters" ], { "!GRUPOATE!", "'" + IF( Empty(hFilter[ "codGrupo" ] ),"z",hFilter[ "codGrupo" ] ) + "'" } )
   ELSE
      AAdd( hParModel[ "parameters" ], { "!GRUPODE!", "''" } )
      AAdd( hParModel[ "parameters" ], { "!GRUPOATE!", "'z'" } )
   ENDIF

   IF ( hb_HHasKey( hFilter,"codFuncao" ) )
      AAdd( hParModel[ "parameters" ], { "!FUNCAODE!", "'" + hFilter[ "codFuncao" ] + "'" } )
      AAdd( hParModel[ "parameters" ], { "!FUNCAOATE!", "'" + IF( Empty(hFilter[ "codFuncao" ] ),"z",hFilter[ "codFuncao" ] ) + "'" } )
   ELSE
      AAdd( hParModel[ "parameters" ], { "!FUNCAODE!", "''" } )
      AAdd( hParModel[ "parameters" ], { "!FUNCAOATE!", "'z'" } )
   ENDIF

   IF ( hb_HHasKey( hFilter,"codAgrFuncao" ) )
      AAdd( hParModel[ "parameters" ], { "!FUNCAOAGRDE!", "'" + hFilter[ "codAgrFuncao" ] + "'" } )
      AAdd( hParModel[ "parameters" ], { "!FUNCAOAGRATE!", "'" + IF( Empty(hFilter[ "codAgrFuncao" ] ),"z",hFilter[ "codAgrFuncao" ] ) + "'" } )
   ELSE
      AAdd( hParModel[ "parameters" ], { "!FUNCAOAGRDE!", "''" } )
      AAdd( hParModel[ "parameters" ], { "!FUNCAOAGRATE!", "'z'" } )
   ENDIF

   IF ( hb_HHasKey( hFilter,"codMatricula" ) )
      AAdd( hParModel[ "parameters" ], { "!MATRICULADE!", "'" + hFilter[ "codMatricula" ] + "'" } )
      AAdd( hParModel[ "parameters" ], { "!MATRICULAATE!", "'" + IF( Empty(hFilter[ "codMatricula" ] ),"z",hFilter[ "codMatricula" ] ) + "'" } )
   ELSE
      AAdd( hParModel[ "parameters" ], { "!MATRICULADE!", "''" } )
      AAdd( hParModel[ "parameters" ], { "!MATRICULAATE!", "'z'" } )
   ENDIF

   IF ( hb_HHasKey( hFilter,"codVerba" ) )
      AAdd( hParModel[ "parameters" ], { "!VERBADE!", "'" + hFilter[ "codVerba" ] + "'" } )
      AAdd( hParModel[ "parameters" ], { "!VERBAATE!", "'" + IF( Empty(hFilter[ "codVerba" ] ),"z",hFilter[ "codVerba" ] ) + "'" } )
   ELSE
      AAdd( hParModel[ "parameters" ], { "!VERBADE!", "''" } )
      AAdd( hParModel[ "parameters" ], { "!VERBAATE!", "'z'" } )
   ENDIF

   cParModel := hb_jsonEncode( hParModel, .F. )
   cParModel := __base64Encode( cParModel )

return( cParModel )
