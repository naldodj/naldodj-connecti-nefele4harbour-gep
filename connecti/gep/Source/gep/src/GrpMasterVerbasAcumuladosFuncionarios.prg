// Proyecto: GEP
/*
 * Fichero: GrpMasterVerbasAcumuladosFuncionarios.prg
 * Descripción:
 * Autor:
 * Fecha: 14/08/2021
 */
///

#include "Xailer.ch"
#include "Nefele.ch"
#include "LangCGI.ch"

#define __CODMODEL__ "GRPMASTERVERBASACMFUNCIONARIOS"

PROCEDURE ParametersGrpMasterVerbasAcumuladosFuncionarios( lGrpViewTotais )

   LOCAL hUser := LoginUser()

   LOCAL cSubTitle := " :: " + "Consulta Dados Acumulados Por Centro de Custo/Funcionario/Grupo de Verbas"
   LOCAL cTitle := AppData:AppTitle + cSubTitle
   LOCAL cIDParameters
   LOCAL aParameters

   hb_default( @lGrpViewTotais, .F. )
   oCGI:SetUserData( "__GrpMasterVerbasAcumuladosFuncionarios:lGrpViewTotais", lGrpViewTotais )

   oCGI:SetUserData( "GrpMasterVerbasAcumuladosFuncionarios:Back", ProcName() )

   WITH OBJECT wTWebPage():New()

      :cTitle := cTitle

      AppMenu( :WO, AppData:AppName, hUser, .F. )

      aParameters := { "codPeriodo", "codPeriodoAte", "codGrupo", "codFilial", "codCentroDeCusto", "codMatricula" }
      cSubTitle := AppData:AppName + cSubTitle
      GEPParameters( :WO, @cIDParameters, "__GrpMasterVerbasAcumuladosFuncionarios", aParameters, .T., cSubTitle, .T. ):Create()

      :lValign    := .F.
      :lContainer := .F.

      oCgi:SendPage( :Create() )

   END

RETURN

FUNCTION __GrpMasterVerbasAcumuladosFuncionarios(lExecute,hFilter,nMaxRowspPage)

   LOCAL cIDModal

   LOCAL codGrupo
   LOCAL codFilial
   LOCAL codPeriodo
   LOCAL codPeriodoAte
   LOCAL codMatricula
   LOCAL codCentroDeCusto

   LOCAL hIDModal

   LOCAL lFilter

   hb_default( @lExecute, .T. )
   lFilter := ( HB_ISHASH( hFilter ) .AND. !Empty( hFilter ) )
   hb_default( @hFilter, { => } )

   IF ( lExecute )
      cIDModal := oCGI:GetCgiValue( "cIDModalTotaisGrpMasterVerbasAcumuladosFuncionarios", "" )
      IF ( !Empty( cIDModal ) )
         oCGI:SetUserData( "HistoryRemoveParams", .F. )
         cIDModal := __base64Decode( cIDModal )
         hb_jsonDecode( cIDModal, @hIDModal )
         saveTmpParameters( "__GrpMasterVerbasAcumuladosFuncionarios", hIDModal )
         IF ( hb_HHasKey( hIDModal,"codGrupo" ) )
            codGrupo := hIDModal[ "codGrupo" ]
         ENDIF
         IF ( hb_HHasKey( hIDModal,"codFilial" ) )
            codFilial := hIDModal[ "codFilial" ]
         ENDIF
         IF ( hb_HHasKey( hIDModal,"codPeriodo" ) )
            codPeriodo := hIDModal[ "codPeriodo" ]
         ENDIF
         IF ( hb_HHasKey( hIDModal,"codPeriodoAte" ) )
            codPeriodoAte := hIDModal[ "codPeriodoAte" ]
         ENDIF
         IF ( hb_HHasKey( hIDModal,"codMatricula" ) )
            codMatricula := hIDModal[ "codMatricula" ]
         ENDIF
         IF ( hb_HHasKey( hIDModal,"codCentroDeCusto" ) )
            codCentroDeCusto := hIDModal[ "codCentroDeCusto" ]
         ENDIF
      ELSE
         IF ( hb_HHasKey( hFilter,"codGrupo" ) )
            codGrupo := hFilter[ "codGrupo" ]
            oCGI:SetUserData( "__GrpMasterVerbasAcumuladosFuncionarios:codGrupo", codGrupo )
         ELSE
            codGrupo := oCGI:GetCgiValue( "codGrupo", "" )
         ENDIF
         IF ( hb_HHasKey( hFilter,"codFilial" ) )
            codFilial := hFilter[ "codFilial" ]
            oCGI:SetUserData( "__GrpMasterVerbasAcumuladosFuncionarios:codFilial", codFilial )
         ELSE
            codFilial := oCGI:GetCgiValue( "codFilial", "" )
         ENDIF
         IF ( hb_HHasKey( hFilter,"codPeriodo" ) )
            codPeriodo := hFilter[ "codPeriodo" ]
            oCGI:SetUserData( "__GrpMasterVerbasAcumuladosFuncionarios:codPeriodo", codPeriodo )
         ELSE
            codPeriodo := oCGI:GetCgiValue( "codPeriodo", "" )
         ENDIF
         IF ( hb_HHasKey( hFilter,"codPeriodoAte" ) )
            codPeriodoAte := hFilter[ "codPeriodoAte" ]
            oCGI:SetUserData( "__GrpMasterVerbasAcumuladosFuncionarios:codPeriodoAte", codPeriodoAte )
         ELSE
            codPeriodoAte := oCGI:GetCgiValue( "codPeriodoAte", "" )
         ENDIF
         IF ( hb_HHasKey( hFilter,"codMatricula" ) )
            codMatricula := hFilter[ "codMatricula" ]
            oCGI:SetUserData( "__GrpMasterVerbasAcumuladosFuncionarios:codMatricula", codMatricula )
         ELSE
            codMatricula := oCGI:GetCgiValue( "codMatricula", "" )
         ENDIF
         IF ( hb_HHasKey( hFilter,"codCentroDeCusto" ) )
            codCentroDeCusto := hFilter[ "codCentroDeCusto" ]
            oCGI:SetUserData( "__GrpMasterVerbasAcumuladosFuncionarios:codCentroDeCusto", codCentroDeCusto )
         ELSE
            codCentroDeCusto := oCGI:GetCgiValue( "codCentroDeCusto", "" )
         ENDIF
      ENDIF
   ELSE
      IF ( hb_HHasKey( hFilter,"codGrupo" ) )
         codGrupo := hFilter[ "codGrupo" ]
         oCGI:SetUserData( "__GrpMasterVerbasAcumuladosFuncionarios:codGrupo", codGrupo )
      ELSE
         codGrupo := oCGI:GetCgiValue( "codGrupo", "" )
      ENDIF
      IF ( hb_HHasKey( hFilter,"codFilial" ) )
         codFilial := hFilter[ "codFilial" ]
         oCGI:SetUserData( "__GrpMasterVerbasAcumuladosFuncionarios:codFilial", codFilial )
      ELSE
         codFilial := oCGI:GetCgiValue( "codFilial", "" )
      ENDIF
      IF ( hb_HHasKey( hFilter,"codPeriodo" ) )
         codPeriodo := hFilter[ "codPeriodo" ]
         oCGI:SetUserData( "__GrpMasterVerbasAcumuladosFuncionarios:codPeriodo", codPeriodo )
      ELSE
         codPeriodo := oCGI:GetCgiValue( "codPeriodo", "" )
      ENDIF
      IF ( hb_HHasKey( hFilter,"codPeriodoAte" ) )
         codPeriodoAte := hFilter[ "codPeriodoAte" ]
         oCGI:SetUserData( "__GrpMasterVerbasAcumuladosFuncionarios:codPeriodoAte", codPeriodoAte )
      ELSE
         codPeriodoAte := oCGI:GetCgiValue( "codPeriodoAte", "" )
      ENDIF
      IF ( hb_HHasKey( hFilter,"codMatricula" ) )
         codMatricula := hFilter[ "codMatricula" ]
         oCGI:SetUserData( "__GrpMasterVerbasAcumuladosFuncionarios:codMatricula", codMatricula )
      ELSE
         codMatricula := oCGI:GetCgiValue( "codMatricula", "" )
      ENDIF
      IF ( hb_HHasKey( hFilter,"codCentroDeCusto" ) )
         codCentroDeCusto := hFilter[ "codCentroDeCusto" ]
         oCGI:SetUserData( "__GrpMasterVerbasAcumuladosFuncionarios:codCentroDeCusto", codCentroDeCusto )
      ELSE
         codCentroDeCusto := oCGI:GetCgiValue( "codCentroDeCusto", "" )
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

      IF ( Empty( codPeriodoAte ) )
         codPeriodoAte := oCGI:GetCgiValue( "GEPParameters_codPeriodoAte", "" )
         IF ( Empty( codPeriodoAte ) )
            codPeriodoAte := oCGI:GetUserData( "__GEPParameters:codPeriodoAte", codPeriodoAte )
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

   ENDIF

   hFilter[ "codGrupo" ] := codGrupo
   oCGI:SetUserData( "__GrpMasterVerbasAcumuladosFuncionarios:codGrupo", codGrupo )

   hFilter[ "codFilial" ] := codFilial
   oCGI:SetUserData( "__GrpMasterVerbasAcumuladosFuncionarios:codFilial", codFilial )

   hFilter[ "codPeriodo" ] := codPeriodo
   oCGI:SetUserData( "__GrpMasterVerbasAcumuladosFuncionarios:codPeriodo", codPeriodo )

   hFilter[ "codPeriodoAte" ] := codPeriodoAte
   oCGI:SetUserData( "__GrpMasterVerbasAcumuladosFuncionarios:codPeriodoAte", codPeriodoAte )

   hFilter[ "codMatricula" ] := codMatricula
   oCGI:SetUserData( "__GrpMasterVerbasAcumuladosFuncionarios:codMatricula", codMatricula )

   hFilter[ "codCentroDeCusto" ] := codCentroDeCusto
   oCGI:SetUserData( "__GrpMasterVerbasAcumuladosFuncionarios:codCentroDeCusto", codCentroDeCusto )

   IF ( lExecute )
      oCGI:SetUserData( "lGrupoHasSuper", .T. )
      restoreTmpParameters( "__GrpMasterVerbasAcumuladosFuncionarios", @hFilter, .T. )
*      oCGI:SetUserData( "GrpVerbasFuncionarios:Back", ProcName() )
      GrpMasterVerbasAcumuladosFuncionarios(nMaxRowspPage)
   ENDIF

RETURN( hFilter )

PROCEDURE GrpMasterVerbasAcumuladosFuncionarios(nMaxRowspPage)

   LOCAL hUser := LoginUser()

   LOCAL cSubTitle := " :: " + "Consulta Dados Acumulados Por Centro de Custo/Funcionario/Grupo de Verbas"
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

   LOCAL codPeriodo
   LOCAL codPeriodoAte

   IF ( !stackTools():IsInCallStack( "__GrpMasterVerbasAcumuladosFuncionarios" ) )
      hFilter:=__GrpMasterVerbasAcumuladosFuncionarios( .F. )
   ENDIF

   WITH OBJECT wTWebPage():New()

      :cTitle := cTitle

      AppMenu( :WO, AppData:AppName, hUser, .F. )

      WITH OBJECT WFloatingBtn():New( :WO )
         :cClrPane := "#005FAB"
         :cName := ( "WFloatingBtn" + ProcName() )
         :cId := Lower( :cName )
         :cText := "Voltar"
         :oIcon:cIcon := "arrow_back"
         :oIcon:cClrIcon := "#FED300"
         :cOnClick := oCGI:GetUserData( ProcName() + ":Back", "MAINFUNCTION" )
         :Create()
      END WITH

      codPeriodo := oCGI:GetUserData( "__GrpMasterVerbasAcumuladosFuncionarios:codPeriodo" )
      codPeriodoAte := oCGI:GetUserData( "__GrpMasterVerbasAcumuladosFuncionarios:codPeriodoAte" )

      IF ((codPeriodoAte<codPeriodo )).or.(Left(codPeriodoAte,4)<>Left(codPeriodo,4))

         WITH OBJECT WMsgAlert():New(:WO)
            :lTagScript       := .T.
            :cText            := "Período Inválido. Informe um período Válido."
            :cType            := "info"
            :nPrimaryDelay    := 15
            :cConfirmButton   := Lang(LNG_ACEPTAR)
            :Create()
         END WITH

      ELSE

         aParameters := { "codPeriodo", "codPeriodoAte", "codGrupo", "codFilial", "codCentroDeCusto", "codMatricula" }
         cSubTitle := AppData:AppName
         GEPParameters( :WO, @cIDParameters, "__GrpMasterVerbasAcumuladosFuncionarios", aParameters, .F., cSubTitle ):Create()

         :lValign    := .F.
         :lContainer := .F.

         aFields := GetDataFieldsGrpMasterVerbasAcumuladosFuncionarios( @cColsPrint )
         nRowspPageMax := oCGI:GetUserData(__CODMODEL__+":RowspPageMax",10)
         HB_Default(@nMaxRowspPage,nRowspPageMax)

         WITH OBJECT wDatatable():New( :WO )

            :cId := Lower("browseGrpMasterVerbasAcumuladosFuncionarios")

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
               :lengthMenu      := { { 0,nRowspPageMax, - 1 }, { 0,nRowspPageMax,{"Todos","Todos"}[ AppData:nLang ] } }
               :searching       := .T.
               :ordering        := .T.
               :ORDER           := { { 0,'asc' } }  // Columna por defecto
               :ScrollX:=.T.
               :ScrollY:=.T.

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

*               cTmp := { "Detalhes", "Detalhes" }[ AppData:nLang ]
*               :AddColumnButton( "loupe", cTmp, "btn-wDatatable ;", "__GrpVerbasFuncionariosDet", "dt-center", "", /*,'fn_click'*/ )
*               :AddColumnDef( nField ):width := '14px'

               :ajax := { "cgi" => "GetDataGrpMasterVerbasAcumuladosFuncionarios" }

            END

            AAdd( :aScript, fixedColumns( :cID,oCGI:GetUserData( __CODMODEL__+":fixedColumns","6" ) ) )

            :Create()

         END

      ENDIF

      oCgi:SendPage( :Create() )

   END

RETURN

//------------------------------------------------------------------------------

FUNCTION GetDataGrpMasterVerbasAcumuladosFuncionarios( lSendJSON, lGetFull, cSearchFilter )

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
      GetDataFieldsGrpMasterVerbasAcumuladosFuncionarios()
      xJSONData := Extraer( codModel, nStart, nLimit, nDraw, cSearchFilter, aOrder, lSendJSON, .F. )
   ENDIF

RETURN( if( lSendJSON,oCGI:SendJson(xJSONData ),xJSONData ) )

FUNCTION GetDataFieldsGrpMasterVerbasAcumuladosFuncionarios( cColsPrint )

   LOCAL aFields
   LOCAL aFieldsADD := Array( 0 )
   LOCAL aDataPeriodo
   LOCAL codModel := __CODMODEL__
   LOCAL bFunction := {|| Extraer( codModel, 1, 1, 1, "", {}, .F., .T. ) }
   LOCAL cKey
   LOCAL hDataPeriodo
   LOCAL nRow
   LOCAL nRows

   local cYear
   local cMonth

   local codPeriodo
   local codPeriodoAte

   local codPeriodoYear
   local codPeriodoAteYear

   local codPeriodoMonth
   local codPeriodoAteMonth

   local aliasPeriodo

   local hFilter
   local hFilterPeriodos

   hFilterPeriodos:=__CadastroPeriodosSRD(.F.)

   hFilter:={=>}
   restoreTmpParameters( "__GrpMasterVerbasAcumuladosFuncionarios", @hFilter, .T. )

   codPeriodo:=oCGI:GetUserData("__GrpMasterVerbasAcumuladosFuncionarios:codPeriodo","")
   codPeriodoAte:=oCGI:GetUserData("__GrpMasterVerbasAcumuladosFuncionarios:codPeriodoAte","")

   hFilter["codPeriodo"]:=codPeriodo
   hFilter["codPeriodoAte"]:=codPeriodoAte

   saveTmpParameters("__CadastroPeriodosSRD",hFilter)
      oCGI:SetUserData("GetDataCadastroPeriodosSRD:lFilterRemove",.T.)
      oCGI:SetUserData("GetDataCadastroPeriodosSRD:hFilterRemove",hFilter)
      hDataPeriodo := GetDataCadastroPeriodosSRD( .F., .T., "" )
      oCGI:SetUserData("GetDataCadastroPeriodosSRD:lFilterRemove",.F.)
      oCGI:SetUserData("GetDataCadastroPeriodosSRD:hFilterRemove",{=>})
   deleteTmpParameters("__CadastroPeriodosSRD")

   aDataPeriodo := hDataPeriodo[ "data" ]

   codPeriodoYear:=Left(codPeriodo,4)
   codPeriodoAteYear:=Left(codPeriodoAte,4)

   codPeriodoMonth:=Right(codPeriodo,2)
   codPeriodoAteMonth:=Right(codPeriodoAte,2)

   nRows := Len( aDataPeriodo )
   FOR nRow := 1 TO nRows
      cYear:=Left(aDataPeriodo[ nRow ][ "codPeriodo" ],4)
      cMonth:=Right(aDataPeriodo[ nRow ][ "codPeriodo" ],2)
      IF ((cYear==codPeriodoYear).or.(cYear==codPeriodoAteYear))
         IF ((cMonth>=codPeriodoMonth).and.(cMonth<=codPeriodoAteMonth))
            aliasPeriodo:=aDataPeriodo[ nRow ][ "aliasPeriodo" ]
            AAdd( aFieldsADD, { aliasPeriodo , aliasPeriodo, .F., .F., "dt-right", .T., "@R 999,999,999.99" } )
         ENDIF
      ENDIF
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
   LOCAL codPeriodoAte
   LOCAL codCentroDeCusto

   LOCAL hFilter

   LOCAL xData

   AppData:cEmp := oCGI:GetUserData( "cEmp", AppData:cEmp )
   hb_default( AppData:cEmp, "" )
   cFile := ( AppData:PathData + AppData:cEmp + "_" + Lower( ProcName(1 ) ) + ".json" )

   hFilter := { => }
   restoreTmpParameters( "__GrpMasterVerbasAcumuladosFuncionarios", @hFilter, .T. )

   codGrupo := oCGI:GetUserData( "__GrpMasterVerbasAcumuladosFuncionarios:codGrupo" )
   codFilial := oCGI:GetUserData( "__GrpMasterVerbasAcumuladosFuncionarios:codFilial" )
   codPeriodo := oCGI:GetUserData( "__GrpMasterVerbasAcumuladosFuncionarios:codPeriodo" )
   codPeriodoAte := oCGI:GetUserData( "__GrpMasterVerbasAcumuladosFuncionarios:codPeriodoAte" )
   codCentroDeCusto := oCGI:GetUserData( "__GrpMasterVerbasAcumuladosFuncionarios:codCentroDeCusto" )

   hb_default( @cFilter, "" )

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
   ELSE
      IF ( hb_HHasKey( hFilter,"codPeriodo" ) )
         hb_HDel( hFilter, "codPeriodo" )
      ENDIF
   ENDIF

   IF ( !Empty( codPeriodoAte ) )
      hFilter[ "codPeriodoAte" ] := codPeriodoAte
   ELSE
      IF ( hb_HHasKey( hFilter,"codPeriodoAte" ) )
         hb_HDel( hFilter, "codPeriodoAte" )
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

   IF ( !Empty( codGrupo ) )
      hFilter[ "codGrupo" ] := codGrupo
   ELSE
      IF ( hb_HHasKey( hFilter,"codGrupo" ) )
         hb_HDel( hFilter, "codGrupo" )
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
      cGrpFiles += Left( codPeriodo, 4 )
   ENDIF

   xData := GetDataModel( codModel, nPage, nRecords, nDraw, cFilter, aOrder, lSendJSON, lGetFields, cFile, cParModel, .F., cGrpFiles )

   IF ( !Empty( hFilter ) )
      hb_default( @lGetFields, .F. )
      IF ( !lGetFields )
         xData := rebuildDataModel( xData, hFilter, lSendJSON, aOrder )
      ENDIF
   ENDIF

RETURN( xData )

PROCEDURE __clearGrpMasterVerbasAcumuladosFuncionarios()

   oCGI:SetUserData( "__GrpMasterVerbasAcumuladosFuncionarios:codGrupo", "" )
   oCGI:SetUserData( "__GrpMasterVerbasAcumuladosFuncionarios:codFilial", "" )
   oCGI:SetUserData( "__GrpMasterVerbasAcumuladosFuncionarios:codPeriodo", "" )
   oCGI:SetUserData( "__GrpMasterVerbasAcumuladosFuncionarios:codPeriodoAte", "" )
   oCGI:SetUserData( "__GrpMasterVerbasAcumuladosFuncionarios:codCentroDeCusto", "" )

   oCGI:SetUserData( "GrpMasterVerbasAcumuladosFuncionarios:Back", "ParametersGrpMasterVerbasAcumuladosFuncionarios" )
   oCGI:SetUserData( "GrpVerbasFuncionarios:Back", "GrpVerbasFuncionarios" )

   deleteTmpParameters( "__GrpMasterVerbasAcumuladosFuncionarios" )

RETURN
