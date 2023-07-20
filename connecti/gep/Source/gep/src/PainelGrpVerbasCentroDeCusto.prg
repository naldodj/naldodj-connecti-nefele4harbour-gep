// Proyecto: GEP
/*
 * Fichero: PainelGrpVerbasCentroDeCusto.prg
 * Descripción:
 * Autor:
 * Fecha: 14/08/2021
 */

#include "Xailer.ch"
#include "Nefele.ch"
#include "LangCGI.ch"

#define __CODMODEL__ "PIVOTCCSUBGRUPO"

PROCEDURE ParametersPainelGrpVerbasCentroDeCusto( lGrpViewTotais )

   LOCAL hUser := LoginUser()

   LOCAL cSubTitle:=" :: " + "Consulta dos Dados Totais Por Centro de Custo/Sub-Grupo de Verbas"
   LOCAL cTitle := AppData:AppTitle + cSubTitle
   LOCAL cIDParameters
   LOCAL aParameters

   hb_default( @lGrpViewTotais, .F. )

   oCGI:SetUserData( "PainelGrpVerbasCentroDeCusto:Back", ProcName() )

   oCGI:SetUserData( "__GrpVerbasCentroDeCusto:lGrpViewTotais", lGrpViewTotais )

   WITH OBJECT wTWebPage():New()

      :cTitle := cTitle

      AppMenu( :WO, AppData:AppName, hUser, .F. )

      aParameters := { "codPeriodo", "codGrupo", "codFilial", "codCentroDeCusto" }
      cSubTitle:=AppData:AppName+cSubTitle
      GEPParameters( :WO, @cIDParameters, "__PainelGrpVerbasCentroDeCusto", aParameters, .T., cSubTitle, .T. ):Create()

      :lValign    := .F.
      :lContainer := .F.

      oCgi:SendPage( :Create() )

   END

RETURN

FUNCTION __PainelGrpVerbasCentroDeCusto(lExecute,hFilter,nMaxRowspPage)

   LOCAL cIDModal

   LOCAL codGrupo
   LOCAL codFilial
   LOCAL codPeriodo
   LOCAL codCentroDeCusto
   LOCAL codGrupoSuperior

   LOCAL hIDModal

   LOCAL lFilter

   hb_default( @lExecute, .T. )
   lFilter := ( HB_ISHASH( hFilter ) .AND. !Empty( hFilter ) )
   hb_default( @hFilter, { => } )

   IF ( lExecute )
      cIDModal := oCGI:GetCgiValue( "cIDModalTotaisGrpVerbasCentroDeCusto", "" )
      IF ( !Empty( cIDModal ) )
         oCGI:SetUserData( "HistoryRemoveParams", .F. )
         cIDModal := __base64Decode( cIDModal )
         hb_jsonDecode( cIDModal, @hIDModal )
         saveTmpParameters( "__PainelGrpVerbasCentroDeCusto", hIDModal )
         IF ( hb_HHasKey( hIDModal,"codGrupo" ) )
            codGrupo := hIDModal[ "codGrupo" ]
         ENDIF
         IF ( hb_HHasKey( hIDModal,"codFilial" ) )
            codFilial := hIDModal[ "codFilial" ]
         ENDIF
         IF ( hb_HHasKey( hIDModal,"codPeriodo" ) )
            codPeriodo := hIDModal[ "codPeriodo" ]
         ENDIF
         IF ( hb_HHasKey( hIDModal,"codCentroDeCusto" ) )
            codCentroDeCusto := hIDModal[ "codCentroDeCusto" ]
         ENDIF
         IF ( hb_HHasKey( hIDModal,"codGrupoSuperior" ) )
            codGrupoSuperior := hIDModal[ "codGrupoSuperior" ]
         ENDIF
      ELSE
         IF ( hb_HHasKey( hFilter,"codGrupo" ) )
            codGrupo := hFilter[ "codGrupo" ]
            oCGI:SetUserData( "__PainelGrpVerbasCentroDeCusto:codGrupo", codGrupo )
         ELSE
            codGrupo := oCGI:GetCgiValue( "codGrupo", "" )
         ENDIF
         IF ( hb_HHasKey( hFilter,"codFilial" ) )
            codFilial := hFilter[ "codFilial" ]
            oCGI:SetUserData( "__PainelGrpVerbasCentroDeCusto:codFilial", codFilial )
         ELSE
            codFilial := oCGI:GetCgiValue( "codFilial", "" )
         ENDIF
         IF ( hb_HHasKey( hFilter,"codPeriodo" ) )
            codPeriodo := hFilter[ "codPeriodo" ]
            oCGI:SetUserData( "__PainelGrpVerbasCentroDeCusto:codPeriodo", codPeriodo )
         ELSE
            codPeriodo := oCGI:GetCgiValue( "codPeriodo", "" )
         ENDIF
         IF ( hb_HHasKey( hFilter,"codCentroDeCusto" ) )
            codCentroDeCusto := hFilter[ "codCentroDeCusto" ]
            oCGI:SetUserData( "__PainelGrpVerbasCentroDeCusto:codCentroDeCusto", codCentroDeCusto )
         ELSE
            codCentroDeCusto := oCGI:GetCgiValue( "codCentroDeCusto", "" )
         ENDIF
         IF ( hb_HHasKey( hFilter,"codGrupoSuperior" ) )
            codGrupoSuperior := hFilter[ "codGrupoSuperior" ]
            oCGI:SetUserData( "__PainelGrpVerbasCentroDeCusto:codGrupoSuperior", codGrupoSuperior )
         ELSE
            codGrupoSuperior := oCGI:GetCgiValue( "codGrupoSuperior", "" )
         ENDIF
      ENDIF
   ELSE
      IF ( hb_HHasKey( hFilter,"codGrupo" ) )
         codGrupo := hFilter[ "codGrupo" ]
         oCGI:SetUserData( "__PainelGrpVerbasCentroDeCusto:codGrupo", codGrupo )
      ELSE
         codGrupo := oCGI:GetCgiValue( "codGrupo", "" )
      ENDIF
      IF ( hb_HHasKey( hFilter,"codFilial" ) )
         codFilial := hFilter[ "codFilial" ]
         oCGI:SetUserData( "__PainelGrpVerbasCentroDeCusto:codFilial", codFilial )
      ELSE
         codFilial := oCGI:GetCgiValue( "codFilial", "" )
      ENDIF
      IF ( hb_HHasKey( hFilter,"codPeriodo" ) )
         codPeriodo := hFilter[ "codPeriodo" ]
         oCGI:SetUserData( "__PainelGrpVerbasCentroDeCusto:codPeriodo", codPeriodo )
      ELSE
         codPeriodo := oCGI:GetCgiValue( "codPeriodo", "" )
      ENDIF
      IF ( hb_HHasKey( hFilter,"codCentroDeCusto" ) )
         codCentroDeCusto := hFilter[ "codCentroDeCusto" ]
         oCGI:SetUserData( "__PainelGrpVerbasCentroDeCusto:codCentroDeCusto", codCentroDeCusto )
      ELSE
         codCentroDeCusto := oCGI:GetCgiValue( "codCentroDeCusto", "" )
      ENDIF
      IF ( hb_HHasKey( hFilter,"codGrupoSuperior" ) )
         codGrupoSuperior := hFilter[ "codGrupoSuperior" ]
         oCGI:SetUserData( "__PainelGrpVerbasCentroDeCusto:codGrupoSuperior", codGrupoSuperior )
      ELSE
         codGrupoSuperior := oCGI:GetCgiValue( "codGrupoSuperior", "" )
      ENDIF
   ENDIF

   IF ( ( !lFilter ) .AND. Empty( cIDModal ) )

      IF ( Empty( codGrupo ) )
         codGrupo := oCGI:GetCgiValue( "GEPParameters_codGrupo", "" )
         IF ( Empty( codGrupo ) )
            codGrupo := oCGI:GetUserData( "__GEPParameters:codGrupo", codGrupo )
         ENDIF
      ENDIF

      IF ( Empty( codFilial ) )
         codFilial := oCGI:GetCgiValue( "GEPParameters_codFilial", "" )
         IF ( Empty( codFilial ) )
            codFilial := oCGI:GetUserData( "__GEPParameters:codFilial", codFilial )
         ENDIF
      ENDIF

      IF ( Empty( codPeriodo ) )
         codPeriodo := oCGI:GetCgiValue( "GEPParameters_codPeriodo", "" )
         IF ( Empty( codPeriodo ) )
            codPeriodo := oCGI:GetUserData( "__GEPParameters:codPeriodo", codPeriodo )
         ENDIF
      ENDIF

      IF ( Empty( codCentroDeCusto ) )
         codCentroDeCusto := oCGI:GetCgiValue( "GEPParameters_codCentroDeCusto", "" )
         IF ( Empty( codCentroDeCusto ) )
            codCentroDeCusto := oCGI:GetUserData( "__GEPParameters:codCentroDeCusto", codCentroDeCusto )
         ENDIF
      ENDIF

      IF ( Empty( codGrupoSuperior ) )
         codGrupoSuperior := oCGI:GetCgiValue( "GEPParameters_codGrupoSuperior", "" )
         IF ( Empty( codGrupoSuperior ) )
            codGrupoSuperior := oCGI:GetUserData( "__GEPParameters:codGrupoSuperior", codGrupoSuperior )
         ENDIF
      ENDIF

   ENDIF

   IF ( oCGI:GetUserData( "lGrupoHasSuper", .F. ) )
      hFilter[ "codGrupo" ] := ""
      oCGI:SetUserData( "__PainelGrpVerbasCentroDeCusto:codGrupo", "" )
      hFilter[ "codGrupoSuperior" ] := codGrupo
      oCGI:SetUserData( "__PainelGrpVerbasCentroDeCusto:codGrupoSuperior", codGrupo )
   ELSE
      hFilter[ "codGrupo" ] := codGrupo
      oCGI:SetUserData( "__PainelGrpVerbasCentroDeCusto:codGrupo", codGrupo )
      hFilter[ "codGrupoSuperior" ] := codGrupoSuperior
      oCGI:SetUserData( "__PainelGrpVerbasCentroDeCusto:codGrupoSuperior", codGrupoSuperior )
   ENDIF

   hFilter[ "codFilial" ] := codFilial
   oCGI:SetUserData( "__PainelGrpVerbasCentroDeCusto:codFilial", codFilial )

   hFilter[ "codPeriodo" ] := codPeriodo
   oCGI:SetUserData( "__PainelGrpVerbasCentroDeCusto:codPeriodo", codPeriodo )

   hFilter[ "codCentroDeCusto" ] := codCentroDeCusto
   oCGI:SetUserData( "__PainelGrpVerbasCentroDeCusto:codCentroDeCusto", codCentroDeCusto )

   IF ( lExecute )
      oCGI:SetUserData( "PainelGrpVerbasFuncionarios:Back", ProcName() )
      PainelGrpVerbasCentroDeCusto(nMaxRowspPage)
   ENDIF

RETURN( hFilter )

PROCEDURE PainelGrpVerbasCentroDeCusto(nMaxRowspPage)

   LOCAL hUser := LoginUser()

   LOCAL cSubTitle:=" :: " + "Painel Consulta Dados Por Centro de Custo/Sub-Grupo de Verbas"
   LOCAL cTitle := AppData:AppTitle + cSubTitle
   LOCAL cColsPrint
   LOCAL cIDParameters
   LOCAL aParameters

   LOCAL nField
   LOCAL aFields
   LOCAL nFields
   LOCAL nRowspPageMax

   LOCAL cTmp

   LOCAL hFilter

   IF ( !stackTools():IsInCallStack( "__PainelGrpVerbasCentroDeCusto" ) )
      hFilter := __PainelGrpVerbasCentroDeCusto( .F. )
   ENDIF

   WITH OBJECT wTWebPage():New()

      :cTitle := cTitle

      AppMenu( :WO, AppData:AppName, hUser, .F. )

      WITH OBJECT WFloatingBtn():New( :WO )
         :cClrPane:="#005FAB"
         :cName := ( "WFloatingBtn" + ProcName() )
         :cId := Lower( :cName )
         :cText := "Voltar"
         :oIcon:cIcon := "arrow_back"
         :oIcon:cClrIcon := "#FED300"
         :cOnClick := oCGI:GetUserData( ProcName() + ":Back", "MAINFUNCTION" )
         :Create()
      END WITH

      aParameters := { "codFilial", "codPeriodo", "codCentroDeCusto", "codGrupo" }
      cSubTitle:=AppData:AppName+cSubTitle
      GEPParameters( :WO, @cIDParameters, "__PainelGrpVerbasCentroDeCusto", aParameters, .F., cSubTitle ):Create()

      :lValign    := .F.
      :lContainer := .F.

      aFields := GetDataFieldsPainelGrpVerbasCentroDeCusto( @cColsPrint )
      nRowspPageMax := oCGI:GetUserData(__CODMODEL__+":RowspPageMax",10)
      HB_Default(@nMaxRowspPage,nRowspPageMax)

      WITH OBJECT wDatatable():New( :WO )

         :cId := Lower("browsePainelGrpVerbasCentroDeCusto")

         DataTableCSS( :cID )

         :cCSS += AppData:CSSDataTable

         // Botones Datatable
         WITH OBject :AddButton( "Exportar" )
            :cCustom := "{extend: 'collection',text: 'Exportar',buttons: [ 'csv',{extend: 'excel',autoFilter: true,exportOptions: {columns: " + cColsPrint + "}},{extend: 'pdf',exportOptions: {columns: " + cColsPrint + "}} ]}"
         END WITH

         :AddButton( "{extend: 'print',text: 'Imprimir',exportOptions: {columns: " + cColsPrint + "}}" )

         WITH OBject :AddButton( "Parâmetros" )
            :cAction := nfl_OpenModal( cIDParameters, .T. )
         END WITH

         :cTitle  := cTitle + tableBtnReload( :cId )

         // Configurar opciones
         WITH OBJECT :Configure()
            :SetLanguage( { "Portugues", "Spanish" }[ AppData:nLang ] )
            :sPaginationType := "full_numbers" //"listbox"
            :paging          := .T.
            :pageLength      :=  nMaxRowspPage
            :serverSide      := .T.
            :info            := .T.
            :lengthChange    := .T.
            :lengthMenu      := { { 0,nRowspPageMax, -1 }, { 0,nRowspPageMax,{"Todos","Todos"}[ AppData:nLang ] } }
            :searching       := .T.
            :ordering        := .T.
            :ORDER           := { { 0,'asc' } }  // Columna por defecto

            // Columnas del browse
            nFields := Len( aFields )
            FOR nField := 1 TO nFields
               WITH OBJECT :AddColumn( aFields[ nField ][ 1 ] )
                  :DATA       := aFields[ nField ][ 2 ]
                  :orderable  := aFields[ nField ][ 3 ]
                  :searchable := aFields[ nField ][ 4 ]
                  :className  := aFields[ nField ][ 5 ]
               END
            NEXT nField

            cTmp := { "Detalhes", "Detalhes" }[ AppData:nLang ]
            :AddColumnButton( "loupe", cTmp, "btn-wDatatable ;", "__PainelGrpVerbasFuncionariosDet", "dt-center", "", /*,'fn_click'*/)
            :AddColumnDef( nField ):width := '30px'

            :ajax := { "cgi" => "GetDataPainelGrpVerbasCentroDeCusto" }

         END

         :Create()

      END

      oCgi:SendPage( :Create() )

   END

RETURN

//------------------------------------------------------------------------------

FUNCTION GetDataPainelGrpVerbasCentroDeCusto( lSendJSON, lGetFull, cSearchFilter )

   LOCAL aRow
   LOCAL aOrder
   LOCAL aRecords

   LOCAL codModel := __CODMODEL__

   LOCAL hRow
   LOCAL hParams

   LOCAL nDraw
   LOCAL nStart
   LOCAL nLimit

   LOCAL xJSONData

   hb_default( @lGetFull, .F. )

   IF ( lGetFull )

      nStart := 1
      nLimit := -1

   ELSE

      hParams := oCGI:aParamsToHash( .T. )

      nStart := Val( hParams[ 'START' ] )

      nLimit := Val( hParams[ 'LENGTH' ] )

      nDraw := hParams[ 'DRAW' ]
      aOrder := { Val( hParams[ 'order[0][column]' ] ) + 1, hParams[ 'order[0][dir]' ] } // datatables empieza en columna 0. segundo elemento asc o desc
      cSearchFilter := hParams[ 'SEARCH[VALUE]' ]
      oCGI:SetUserData( "GetDataModel:cSearchFilter", cSearchFilter )

   ENDIF

   hb_default( @lSendJSON, .T. )

   IF ( !nLimit == 0 )
      GetDataFieldsPainelGrpVerbasCentroDeCusto()
      xJSONData := Extraer( codModel, nStart, nLimit, nDraw, cSearchFilter, aOrder, lSendJSON, .F. )
   ENDIF

RETURN( if( lSendJSON,oCGI:SendJson(xJSONData ),xJSONData ) )

FUNCTION GetDataFieldsPainelGrpVerbasCentroDeCusto( cColsPrint )

   LOCAL aFields
   LOCAL aFieldsADD := Array( 0 )
   LOCAL aDataGrupo
   LOCAL codModel := __CODMODEL__
   LOCAL bFunction := {|| Extraer( codModel, 1, 1, 1, "", {}, .F., .T. ) }
   LOCAL cKey
   LOCAL hDataGrupo
   LOCAL nRow
   LOCAL nRows

   hDataGrupo := GetDataCadastroGrupos( .F., .T., "" )
   aDataGrupo := hDataGrupo[ "data" ]

   nRows := Len( aDataGrupo )
   FOR nRow := 1 TO nRows
      AAdd( aFieldsADD, { aDataGrupo[ nRow ][ "descGrupoHTML" ], aDataGrupo[ nRow ][ "aliasGrupo" ], .F., .F., "dt-right", .T., "@R 999,999,999.99" } )
   NEXT nRow

   aFields := GetDataFields( codModel, bFunction, @cColsPrint, aFieldsADD )

   oCGI:SetUserData( "GetDataModel:aFieldsADD", aFieldsADD )

return( aFields )

//-------------------------------------------
// Recuperamos los datos
STATIC FUNCTION Extraer( codModel, nPage, nRecords, nDraw, cSearchFilter, aOrder, lSendJSON, lGetFields )

   LOCAL cFile
   LOCAL cFilter
   LOCAL cParModel
   LOCAL cGrpFiles

   LOCAL codGrupo
   LOCAL codFilial
   LOCAL codPeriodo
   LOCAL codCentroDeCusto
   LOCAL codGrupoSuperior

   LOCAL hFilter

   LOCAL xData

   AppData:cEmp := oCGI:GetUserData( "cEmp", AppData:cEmp )
   hb_default( AppData:cEmp, "" )
   cFile := ( AppData:PathData + AppData:cEmp + "_" + Lower( ProcName(1 ) ) + ".json" )

   hFilter := { => }
   restoreTmpParameters( "__PainelGrpVerbasCentroDeCusto", @hFilter, .T. )

   codGrupo := oCGI:GetUserData( "__PainelGrpVerbasCentroDeCusto:codGrupo" )
   codFilial := oCGI:GetUserData( "__PainelGrpVerbasCentroDeCusto:codFilial" )
   codPeriodo := oCGI:GetUserData( "__PainelGrpVerbasCentroDeCusto:codPeriodo" )
   codCentroDeCusto := oCGI:GetUserData( "__PainelGrpVerbasCentroDeCusto:codCentroDeCusto" )
   codGrupoSuperior := oCGI:GetUserData( "__PainelGrpVerbasCentroDeCusto:codGrupoSuperior" )

   hb_default( @cFilter, "" )

   hFilter := { => }

   IF ( !Empty( codFilial ) )
      hFilter[ "codFilial" ] := codFilial
      IF ( !Empty( cFilter ) )
         cFilter += " AND "
      ENDIF
      cFilter += "RD_FILIAL='" + codFilial + "'"
   ELSE
      IF ( hb_HHasKey( hFilter,"codFilial" ) )
         hb_HDel( hFilter, "codFilial" )
      ENDIF
   ENDIF

   IF ( !Empty( codPeriodo ) )
      hFilter[ "codPeriodo" ] := codPeriodo
      IF !Empty( cFilter )
         cFilter += " AND "
      ENDIF
      cFilter += "RD_DATARQ='" + codPeriodo + "'"
   ELSE
      IF ( hb_HHasKey( hFilter,"codPeriodo" ) )
         hb_HDel( hFilter, "codPeriodo" )
      ENDIF
   ENDIF

   IF ( !Empty( codGrupo ) )
      hFilter[ "codGrupo" ] := codGrupo
   ELSE
      IF ( hb_HHasKey( hFilter,"codGrupo" ) )
         hb_HDel( hFilter, "codGrupo" )
      ENDIF
   ENDIF

   IF ( !Empty( codCentroDeCusto ) )
      hFilter[ "codCentroDeCusto" ] := codCentroDeCusto
      IF ( !Empty( cFilter ) )
         cFilter += " AND "
      ENDIF
      cFilter += "RD_CC='" + codCentroDeCusto + "'"
   ELSE
      IF ( hb_HHasKey( hFilter,"codCentroDeCusto" ) )
         hb_HDel( hFilter, "codCentroDeCusto" )
      ENDIF
   ENDIF

   IF ( !Empty( codGrupoSuperior   ) )
      hFilter[ "codGrupoSuperior" ] := codGrupoSuperior
   ELSE
      IF ( hb_HHasKey( hFilter,"codGrupoSuperior" ) )
         hb_HDel( hFilter, "codGrupoSuperior" )
      ENDIF
   ENDIF

   cParModel := setParModel( hFilter )

   IF ( !Empty( cFilter ) )
      cFilter := "SQL:" + cFilter
   ELSE
      cFilter := cSearchFilter
   ENDIF

   cGrpFiles := codModel
   IF ( !Empty( codPeriodo ) )
      cGrpFiles += "_"
      cGrpFiles += codPeriodo
   ENDIF

   xData := GetDataModel( codModel, nPage, nRecords, nDraw, cFilter, aOrder, lSendJSON, lGetFields, cFile, cParModel, .F., cGrpFiles )

   IF ( !Empty( hFilter ) )
      hb_default( @lGetFields, .F. )
      IF ( !lGetFields )
         xData := rebuildDataModel( xData, hFilter, lSendJSON, aOrder )
      ENDIF
   ENDIF

RETURN( xData )

PROCEDURE __clearPainelGrpVerbasCentroDeCusto()

   oCGI:SetUserData( "__PainelGrpVerbasCentroDeCusto:codFilial", "" )
   oCGI:SetUserData( "__PainelGrpVerbasCentroDeCusto:codGrupo", "" )
   oCGI:SetUserData( "__PainelGrpVerbasCentroDeCusto:codPeriodo", "" )
   oCGI:SetUserData( "__PainelGrpVerbasCentroDeCusto:codCentroDeCusto", "" )
   oCGI:SetUserData( "__PainelGrpVerbasCentroDeCusto:codGrupoSuperior", "" )

   oCGI:SetUserData( "PainelGrpVerbasCentroDeCusto:Back", "ParametersPainelGrpVerbasCentroDeCusto" )
   oCGI:SetUserData( "PainelGrpVerbasFuncionarios:Back", "ParametersGrpVerbasFuncionarios" )

   deleteTmpParameters( "__PainelGrpVerbasCentroDeCusto" )

RETURN
