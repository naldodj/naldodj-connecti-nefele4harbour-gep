// Proyecto: GEP
/*
 * Fichero: PainelGrpVerbasFuncionarios.prg
 * Descripción:
 * Autor:
 * Fecha: 14/08/2021
 */

#include "Xailer.ch"
#include "Nefele.ch"
#include "LangCGI.ch"

#define __CODMODEL__ "PIVOTFUNCIONARIOSUBGRUPO"

PROCEDURE ParametersPainelGrpVerbasFuncionarios( lGrpViewTotais )

   LOCAL hUser := LoginUser()

   LOCAL cSubTitle:=" :: " + "Consulta Dados Por Funcionario/Sub-Grupo de Verbas"
   LOCAL cTitle := AppData:AppTitle+cSubTitle
   LOCAL cIDParameters
   LOCAL aParameters

   oCGI:SetUserData( "PainelGrpVerbasFuncionarios:Back", ProcName() )

   hb_default( @lGrpViewTotais, .F. )
   oCGI:SetUserData( "__GrpVerbasFuncionarios:lGrpViewTotais", lGrpViewTotais )

   WITH OBJECT wTWebPage():New()

      :cTitle := cTitle

      AppMenu( :WO, AppData:AppName, hUser, .F. )

      aParameters := { "codPeriodo", "codGrupo", "codFilial", "codCentroDeCusto", "codMatricula" }
      cSubTitle:=AppData:AppName+" :: "+cSubTitle
      GEPParameters( :WO, @cIDParameters, "__PainelGrpVerbasFuncionarios", aParameters, .T., cSubTitle, .T. ):Create()

      :lValign    := .F.
      :lContainer := .F.

      oCgi:SendPage( :Create() )

   END

RETURN

FUNCTION __PainelGrpVerbasFuncionarios(lExecute,hFilter,nMaxRowspPage)

   LOCAL cIDModal

   LOCAL codVerba
   LOCAL codGrupo
   LOCAL codFilial
   LOCAL codFuncao
   LOCAL codPeriodo
   LOCAL codMatricula
   LOCAL codGrupoSuperior
   LOCAL codCentroDeCusto

   LOCAL hIDModal

   LOCAL lFilter

   hb_default( @lExecute, .T. )
   lFilter := ( HB_ISHASH( hFilter ) .AND. !Empty( hFilter ) )
   hb_default( @hFilter, { => } )

   IF ( lExecute )
      cIDModal := oCGI:GetCgiValue( "cIDModalTotaisGrpVerbasFuncionarios", "" )
      IF ( !Empty( cIDModal ) )
         oCGI:SetUserData( "HistoryRemoveParams", .F. )
         cIDModal := __base64Decode( cIDModal )
         hb_jsonDecode( cIDModal, @hIDModal )
         saveTmpParameters( "__PainelGrpVerbasFuncionarios", hIDModal )
         IF ( hb_HHasKey( hIDModal,"codGrupo" ) )
            codGrupo := hIDModal[ "codGrupo" ]
         ENDIF
         IF ( hb_HHasKey( hIDModal,"codVerba" ) )
            codVerba := hIDModal[ "codVerba" ]
         ENDIF
         IF ( hb_HHasKey( hIDModal,"codFilial" ) )
            codFilial := hIDModal[ "codFilial" ]
         ENDIF
         IF ( hb_HHasKey( hIDModal,"codFuncao" ) )
            codFuncao := hIDModal[ "codFuncao" ]
         ENDIF
         IF ( hb_HHasKey( hIDModal,"codPeriodo" ) )
            codPeriodo := hIDModal[ "codPeriodo" ]
         ENDIF
         IF ( hb_HHasKey( hIDModal,"codMatricula" ) )
            codMatricula := hIDModal[ "codMatricula" ]
         ENDIF
         IF ( hb_HHasKey( hIDModal,"codCentroDeCusto" ) )
            codCentroDeCusto := hIDModal[ "codCentroDeCusto" ]
         ENDIF
         IF ( hb_HHasKey( hIDModal,"codGrupoSuperior" ) )
            codGrupoSuperior := hIDModal[ "codGrupoSuperior" ]
         ENDIF
      ELSE
         IF ( hb_HHasKey( hFilter,"codVerba" ) )
            codVerba := hFilter[ "codVerba" ]
            oCGI:SetUserData( "__PainelGrpVerbasFuncionarios:codVerba", codVerba )
         ELSE
            codVerba := oCGI:GetCgiValue( "codVerba", "" )
         ENDIF
         IF ( hb_HHasKey( hFilter,"codGrupo" ) )
            codGrupo := hFilter[ "codGrupo" ]
            oCGI:SetUserData( "__PainelGrpVerbasFuncionarios:codGrupo", codGrupo )
         ELSE
            codGrupo := oCGI:GetCgiValue( "codGrupo", "" )
         ENDIF
         IF ( hb_HHasKey( hFilter,"codFuncao" ) )
            codFuncao := hFilter[ "codFuncao" ]
            oCGI:SetUserData( "__PainelGrpVerbasFuncionarios:codFuncao", codFuncao )
         ELSE
            codFuncao := oCGI:GetCgiValue( "codFuncao", "" )
         ENDIF
         IF ( hb_HHasKey( hFilter,"codFilial" ) )
            codFilial := hFilter[ "codFilial" ]
            oCGI:SetUserData( "__PainelGrpVerbasFuncionarios:codFilial", codFilial )
         ELSE
            codFilial := oCGI:GetCgiValue( "codFilial", "" )
         ENDIF
         IF ( hb_HHasKey( hFilter,"codPeriodo" ) )
            codPeriodo := hFilter[ "codPeriodo" ]
            oCGI:SetUserData( "__PainelGrpVerbasFuncionarios:codPeriodo", codPeriodo )
         ELSE
            codPeriodo := oCGI:GetCgiValue( "codPeriodo", "" )
         ENDIF
         IF ( hb_HHasKey( hFilter,"codMatricula" ) )
            codMatricula := hFilter[ "codMatricula" ]
            oCGI:SetUserData( "__PainelGrpVerbasFuncionarios:codMatricula", codMatricula )
         ELSE
            codMatricula := oCGI:GetCgiValue( "codMatricula", "" )
         ENDIF
         IF ( hb_HHasKey( hFilter,"codCentroDeCusto" ) )
            codCentroDeCusto := hFilter[ "codCentroDeCusto" ]
            oCGI:SetUserData( "__PainelGrpVerbasFuncionarios:codCentroDeCusto", codCentroDeCusto )
         ELSE
            codCentroDeCusto := oCGI:GetCgiValue( "codCentroDeCusto", "" )
         ENDIF
         IF ( hb_HHasKey( hFilter,"codGrupoSuperior" ) )
            codGrupoSuperior := hFilter[ "codGrupoSuperior" ]
            oCGI:SetUserData( "__PainelGrpVerbasFuncionarios:codGrupoSuperior", codGrupoSuperior )
         ELSE
            codGrupoSuperior := oCGI:GetCgiValue( "codGrupoSuperior", "" )
         ENDIF
      ENDIF
   ELSE
      IF ( hb_HHasKey( hFilter,"codVerba" ) )
         codVerba := hFilter[ "codVerba" ]
         oCGI:SetUserData( "__PainelGrpVerbasFuncionarios:codVerba", codVerba )
      ELSE
         codVerba := oCGI:GetCgiValue( "codVerba", "" )
      ENDIF
      IF ( hb_HHasKey( hFilter,"codGrupo" ) )
         codGrupo := hFilter[ "codGrupo" ]
         oCGI:SetUserData( "__PainelGrpVerbasFuncionarios:codGrupo", codGrupo )
      ELSE
         codGrupo := oCGI:GetCgiValue( "codGrupo", "" )
      ENDIF
      IF ( hb_HHasKey( hFilter,"codFuncao" ) )
         codFuncao := hFilter[ "codFuncao" ]
         oCGI:SetUserData( "__PainelGrpVerbasFuncionarios:codFuncao", codFuncao )
      ELSE
         codFuncao := oCGI:GetCgiValue( "codFuncao", "" )
      ENDIF
      IF ( hb_HHasKey( hFilter,"codFilial" ) )
         codFilial := hFilter[ "codFilial" ]
         oCGI:SetUserData( "__PainelGrpVerbasFuncionarios:codFilial", codFilial )
      ELSE
         codFilial := oCGI:GetCgiValue( "codFilial", "" )
      ENDIF
      IF ( hb_HHasKey( hFilter,"codPeriodo" ) )
         codPeriodo := hFilter[ "codPeriodo" ]
         oCGI:SetUserData( "__PainelGrpVerbasFuncionarios:codPeriodo", codPeriodo )
      ELSE
         codPeriodo := oCGI:GetCgiValue( "codPeriodo", "" )
      ENDIF
      IF ( hb_HHasKey( hFilter,"codMatricula" ) )
         codMatricula := hFilter[ "codMatricula" ]
         oCGI:SetUserData( "__PainelGrpVerbasFuncionarios:codMatricula", codMatricula )
      ELSE
         codMatricula := oCGI:GetCgiValue( "codMatricula", "" )
      ENDIF
      IF ( hb_HHasKey( hFilter,"codCentroDeCusto" ) )
         codCentroDeCusto := hFilter[ "codCentroDeCusto" ]
         oCGI:SetUserData( "__PainelGrpVerbasFuncionarios:codCentroDeCusto", codCentroDeCusto )
      ELSE
         codCentroDeCusto := oCGI:GetCgiValue( "codCentroDeCusto", "" )
      ENDIF
      IF ( hb_HHasKey( hFilter,"codGrupoSuperior" ) )
         codGrupoSuperior := hFilter[ "codGrupoSuperior" ]
         oCGI:SetUserData( "__PainelGrpVerbasFuncionarios:codGrupoSuperior", codGrupoSuperior )
      ELSE
         codGrupoSuperior := oCGI:GetCgiValue( "codGrupoSuperior", "" )
      ENDIF
   ENDIF

   IF ( ( !lFilter ) .AND. Empty( cIDModal ) )

      IF ( Empty( codVerba ) )
         codVerba := oCGI:GetCgiValue( "GEPParameters_codVerba", "" )
         IF ( Empty( codVerba ) )
            codVerba := oCGI:GetUserData( "__GEPParameters:codVerba", codVerba )
         ENDIF
      ENDIF

      IF ( Empty( codGrupo ) )
         codGrupo := oCGI:GetCgiValue( "GEPParameters_codGrupo", "" )
         IF ( Empty( codGrupo ) )
            codGrupo := oCGI:GetUserData( "__GEPParameters:codGrupo", codGrupo )
         ENDIF
      ENDIF

      IF ( Empty( codFuncao ) )
         codFuncao := oCGI:GetCgiValue( "GEPParameters_codfuncao", "" )
         IF ( Empty( codFuncao ) )
            codFuncao := oCGI:GetUserData( "__GEPParameters:codFuncao", codFuncao )
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

      IF ( Empty( codMatricula ) )
         codMatricula := oCGI:GetCgiValue( "GEPParameters_codMatricula", "" )
         IF ( Empty( codMatricula ) )
            codMatricula := oCGI:GetUserData( "__GEPParameters:codMatricula", codMatricula )
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

   hFilter[ "codVerba" ] := codVerba
   oCGI:SetUserData( "__PainelGrpVerbasFuncionarios:codVerba", codVerba )

   IF ( oCGI:GetUserData( "lGrupoHasSuper", .F. ) )
      hFilter[ "codGrupo" ] := ""
      oCGI:SetUserData( "__PainelGrpVerbasFuncionarios:codGrupo", "" )
      hFilter[ "codGrupoSuperior" ] := codGrupo
      oCGI:SetUserData( "__PainelGrpVerbasFuncionarios:codGrupoSuperior", codGrupo )
   ELSE
      hFilter[ "codGrupo" ] := codGrupo
      oCGI:SetUserData( "__PainelGrpVerbasFuncionarios:codGrupo", codGrupo )
      hFilter[ "codGrupoSuperior" ] := codGrupoSuperior
      oCGI:SetUserData( "__PainelGrpVerbasFuncionarios:codGrupoSuperior", codGrupoSuperior )
   ENDIF

   hFilter[ "codFuncao" ] := codFuncao
   oCGI:SetUserData( "__PainelGrpVerbasFuncionarios:codFuncao", codFuncao )

   hFilter[ "codFilial" ] := codFilial
   oCGI:SetUserData( "__PainelGrpVerbasFuncionarios:codFilial", codFilial )

   hFilter[ "codPeriodo" ] := codPeriodo
   oCGI:SetUserData( "__PainelGrpVerbasFuncionarios:codPeriodo", codPeriodo )

   hFilter[ "codMatricula" ] := codMatricula
   oCGI:SetUserData( "__PainelGrpVerbasFuncionarios:codMatricula", codMatricula )

   hFilter[ "codCentroDeCusto" ] := codCentroDeCusto
   oCGI:SetUserData( "__PainelGrpVerbasFuncionarios:codCentroDeCusto", codCentroDeCusto )

   IF ( lExecute )
      oCGI:SetUserData( "GrpVerbasFuncionarios:Back", ProcName() )
      PainelGrpVerbasFuncionarios(nMaxRowspPage)
   ENDIF

RETURN( hFilter )

PROCEDURE PainelGrpVerbasFuncionarios(nMaxRowspPage)

   LOCAL hUser := LoginUser()

   LOCAL cSubTitle:=" :: " + "Painel Consulta Dados Por Centro de Custo/Funcionario/Sub-Grupo de Verbas"
   LOCAL cTitle := AppData:AppTitle + cSubTitle
   LOCAL cColsPrint
   LOCAL cIDParameters
   LOCAL aParameters

   LOCAL nField
   LOCAL aFields
   LOCAL nFields
   LOCAL nRowspPageMax

   LOCAL cTmp

   local hFilter

   IF ( !stackTools():IsInCallStack( "__PainelGrpVerbasFuncionarios" ) )
      hFilter:=__PainelGrpVerbasFuncionarios( .F. )
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

      aParameters := { "codPeriodo", "codGrupo", "codFilial", "codCentroDeCusto", "codMatricula" }
      cSubTitle:=AppData:AppName+cSubTitle
      GEPParameters( :WO, @cIDParameters, "__PainelGrpVerbasFuncionarios", aParameters, .F., cSubTitle ):Create()

      :lValign    := .F.
      :lContainer := .F.

      aFields := GetDataFieldsPainelGrpVerbasFuncionarios( @cColsPrint )
      nRowspPageMax := oCGI:GetUserData(__CODMODEL__+":RowspPageMax",10)
      HB_Default(@nMaxRowspPage,nRowspPageMax)

      WITH OBJECT wDatatable():New( :WO )

         :cId := Lower("browsepainelgrpverbasfuncionarios")

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
            :AddColumnButton( "loupe", cTmp, "btn-wDatatable ;", "__GrpVerbasFuncionariosDet", "dt-center", "", /*,'fn_click'*/)
            :AddColumnDef( nField ):width := '30px'

            :ajax := { "cgi" => "GetDataPainelGrpVerbasFuncionarios" }

         END

         AAdd( :aScript, fixedColumns( :cID,oCGI:GetUserData( __CODMODEL__+":fixedColumns","6" ) ) )

         :Create()

      END

      oCgi:SendPage( :Create() )

   END

RETURN

//------------------------------------------------------------------------------

FUNCTION GetDataPainelGrpVerbasFuncionarios( lSendJSON, lGetFull, cSearchFilter )

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
      GetDataFieldsPainelGrpVerbasFuncionarios()
      xJSONData := Extraer( codModel, nStart, nLimit, nDraw, cSearchFilter, aOrder, lSendJSON, .F. )
   ENDIF

RETURN( if( lSendJSON,oCGI:SendJson(xJSONData ),xJSONData ) )

FUNCTION GetDataFieldsPainelGrpVerbasFuncionarios( cColsPrint )

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

   local codGrupo
   local codVerba
   local codFilial
   local codFuncao
   local codPeriodo
   local codMatricula
   local codCentroDeCusto
   local codGrupoSuperior

   LOCAL hFilter

   LOCAL xData

   AppData:cEmp := oCGI:GetUserData( "cEmp", AppData:cEmp )
   hb_default( AppData:cEmp, "" )
   cFile := ( AppData:PathData + AppData:cEmp + "_" + Lower( ProcName(1 ) ) + ".json" )

   hFilter:={=>}
   restoreTmpParameters("__PainelGrpVerbasFuncionarios",@hFilter,.T.)

   codVerba:=oCGI:GetUserData("__PainelGrpVerbasFuncionarios:codVerba")
   codGrupo:=oCGI:GetUserData("__PainelGrpVerbasFuncionarios:codGrupo")
   codFilial:=oCGI:GetUserData("__PainelGrpVerbasFuncionarios:codFilial")
   codFuncao:=oCGI:GetUserData("__PainelGrpVerbasFuncionarios:codFuncao")
   codPeriodo:=oCGI:GetUserData("__PainelGrpVerbasFuncionarios:codPeriodo")
   codMatricula:=oCGI:GetUserData("__PainelGrpVerbasFuncionarios:codMatricula")
   codCentroDeCusto:=oCGI:GetUserData("__PainelGrpVerbasFuncionarios:codCentroDeCusto")
   codGrupoSuperior:=oCGI:GetUserData("__PainelGrpVerbasFuncionarios:codGrupoSuperior")

   hb_default( @cFilter, "" )

   IF (!Empty(codFilial))
      hFilter["codFilial"]:=codFilial
      IF (!Empty(cFilter))
         cFilter+=" AND "
      endif
      cFilter+="RD_FILIAL='"+codFilial+"'"
   ELSE
      IF (HB_HHasKey(hFilter,"codFilial"))
         HB_HDel(hFilter,"codFilial")
      ENDIF
   ENDIF

   IF (!Empty(codPeriodo))
      hFilter[ "codPeriodo" ] := codPeriodo
      IF (!Empty(cFilter))
         cFilter+=" AND "
      endif
      cFilter+="RD_DATARQ='"+codPeriodo+"'"
   ELSE
      IF (HB_HHasKey(hFilter,"codPeriodo"))
         HB_HDel(hFilter,"codPeriodo")
      ENDIF
   ENDIF

   IF (!Empty(codGrupo))
      hFilter["codGrupo"]:=codGrupo
   ELSE
      IF (HB_HHasKey(hFilter,"codGrupo"))
         HB_HDel(hFilter,"codGrupo")
      ENDIF
   ENDIF

   IF (!Empty(codCentroDeCusto))
      hFilter["codCentroDeCusto"]:=codCentroDeCusto
      IF (!Empty(cFilter))
         cFilter+=" AND "
      endif
      cFilter+="RD_CC='"+codCentroDeCusto+"'"
   ELSE
      IF (HB_HHasKey(hFilter,"codCentroDeCusto"))
         HB_HDel(hFilter,"codCentroDeCusto")
      ENDIF
   ENDIF

   IF (!Empty(codFuncao))
      hFilter["codFuncao"]:=codFuncao
   ELSE
      IF (HB_HHasKey(hFilter,"codFuncao"))
         HB_HDel(hFilter,"codFuncao")
      ENDIF
   ENDIF

   IF (!Empty(codVerba))
      hFilter["codVerba"]:=codVerba
   ELSE
      IF (HB_HHasKey(hFilter,"codVerba"))
         HB_HDel(hFilter,"codVerba")
      ENDIF
   ENDIF

   IF (!Empty(codMatricula))
      hFilter["codMatricula"]:=codMatricula
      IF (!Empty(cFilter))
         cFilter+=" AND "
      endif
      cFilter+="RA_MAT='"+codMatricula+"'"
   ELSE
      IF (HB_HHasKey(hFilter,"codMatricula"))
         HB_HDel(hFilter,"codMatricula")
      ENDIF
   ENDIF

   IF (!Empty(codGrupoSuperior))
      hFilter["codGrupoSuperior"]:=codGrupoSuperior
   ELSE
      IF (HB_HHasKey(hFilter,"codGrupoSuperior"))
         HB_HDel(hFilter,"codGrupoSuperior")
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

PROCEDURE __clearPainelGrpVerbasFuncionarios()

   oCGI:SetUserData( "__PainelGrpVerbasFuncionarios:codGrupo", "" )
   oCGI:SetUserData( "__PainelGrpVerbasFuncionarios:codFilial", "" )
   oCGI:SetUserData( "__PainelGrpVerbasFuncionarios:codPeriodo", "" )
   oCGI:SetUserData( "__PainelGrpVerbasFuncionarios:codCentroDeCusto", "" )

   oCGI:SetUserData( "GrpVerbasFuncionarios:Back", "GrpVerbasFuncionarios" )
   oCGI:SetUserData( "PainelGrpVerbasFuncionarios:Back", "ParametersPainelGrpVerbasFuncionarios" )

   deleteTmpParameters("__PainelGrpVerbasFuncionarios")

RETURN
