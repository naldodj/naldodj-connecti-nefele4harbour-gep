 * Proyecto: GEP
/*
 * Fichero: PainelGrpMasterVerbasCentroDeCusto.prg
 * Descripción:
 * Autor:
 * Fecha: 14/08/2021
 */

#include "Xailer.ch"
#include "Nefele.ch"
#include "LangCGI.ch"

#define __CODMODEL__ "PIVOTCCGRUPO"

PROCEDURE ParametersPainelGrpMasterVerbasCentroDeCusto(lGrpViewTotais)

   local hUser := LoginUser()

   local cSubTitle:=" :: "+"Consulta dos Dados Totais Por Centro de Custo/Grupo de Verbas"
   local cTitle:=AppData:AppTitle+cSubTitle
   local cIDParameters
   local aParameters

   HB_Default(@lGrpViewTotais,.F.)
   oCGI:SetUserData("__GrpMasterVerbasCentroDeCusto:lGrpViewTotais",lGrpViewTotais)

   oCGI:SetUserData("PainelGrpMasterVerbasCentroDeCusto:Back",ProcName())

   WITH OBJECT wTWebPage():New()

      :cTitle:=cTitle

      AppMenu(:WO,AppData:AppName,hUser,.F.)

      aParameters:={"codPeriodo","codGrupo","codFilial","codCentroDeCusto"}
      cSubTitle:=AppData:AppName+cSubTitle
      GEPParameters(:WO,@cIDParameters,"__PainelGrpMasterVerbasCentroDeCusto",aParameters,.T.,cSubTitle,.T.):Create()

      :lValign    := .F.
      :lContainer := .F.

      oCgi:SendPage( :Create() )

   END

RETURN

FUNCTION __PainelGrpMasterVerbasCentroDeCusto(lExecute,hFilter,nMaxRowspPage)

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
      cIDModal := oCGI:GetCgiValue( "cIDModalTotaisGrpMasterVerbasCentroDeCusto", "" )
      IF ( !Empty( cIDModal ) )
         oCGI:SetUserData( "HistoryRemoveParams", .F. )
         cIDModal := __base64Decode( cIDModal )
         hb_jsonDecode( cIDModal, @hIDModal )
         saveTmpParameters( "__PainelGrpMasterVerbasCentroDeCusto", hIDModal )
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
            oCGI:SetUserData( "__PainelGrpMasterVerbasCentroDeCusto:codGrupo", codGrupo )
         ELSE
            codGrupo := oCGI:GetCgiValue( "codGrupo", "" )
         ENDIF
         IF ( hb_HHasKey( hFilter,"codFilial" ) )
            codFilial := hFilter[ "codFilial" ]
            oCGI:SetUserData( "__PainelGrpMasterVerbasCentroDeCusto:codFilial", codFilial )
         ELSE
            codFilial := oCGI:GetCgiValue( "codFilial", "" )
         ENDIF
         IF ( hb_HHasKey( hFilter,"codPeriodo" ) )
            codPeriodo := hFilter[ "codPeriodo" ]
            oCGI:SetUserData( "__PainelGrpMasterVerbasCentroDeCusto:codPeriodo", codPeriodo )
         ELSE
            codPeriodo := oCGI:GetCgiValue( "codPeriodo", "" )
         ENDIF
         IF ( hb_HHasKey( hFilter,"codCentroDeCusto" ) )
            codCentroDeCusto := hFilter[ "codCentroDeCusto" ]
            oCGI:SetUserData( "__PainelGrpMasterVerbasCentroDeCusto:codCentroDeCusto", codCentroDeCusto )
         ELSE
            codCentroDeCusto := oCGI:GetCgiValue( "codCentroDeCusto", "" )
         ENDIF
         IF ( hb_HHasKey( hFilter,"codGrupoSuperior" ) )
            codGrupoSuperior := hFilter[ "codGrupoSuperior" ]
            oCGI:SetUserData( "__PainelGrpMasterVerbasCentroDeCusto:codGrupoSuperior", codGrupoSuperior )
         ELSE
            codGrupoSuperior := oCGI:GetCgiValue( "codGrupoSuperior", "" )
         ENDIF
      ENDIF
   ELSE
      IF ( hb_HHasKey( hFilter,"codGrupo" ) )
         codGrupo := hFilter[ "codGrupo" ]
         oCGI:SetUserData( "__PainelGrpMasterVerbasCentroDeCusto:codGrupo", codGrupo )
      ELSE
         codGrupo := oCGI:GetCgiValue( "codGrupo", "" )
      ENDIF
      IF ( hb_HHasKey( hFilter,"codFilial" ) )
         codFilial := hFilter[ "codFilial" ]
         oCGI:SetUserData( "__PainelGrpMasterVerbasCentroDeCusto:codFilial", codFilial )
      ELSE
         codFilial := oCGI:GetCgiValue( "codFilial", "" )
      ENDIF
      IF ( hb_HHasKey( hFilter,"codPeriodo" ) )
         codPeriodo := hFilter[ "codPeriodo" ]
         oCGI:SetUserData( "__PainelGrpMasterVerbasCentroDeCusto:codPeriodo", codPeriodo )
      ELSE
         codPeriodo := oCGI:GetCgiValue( "codPeriodo", "" )
      ENDIF
      IF ( hb_HHasKey( hFilter,"codCentroDeCusto" ) )
         codCentroDeCusto := hFilter[ "codCentroDeCusto" ]
         oCGI:SetUserData( "__PainelGrpMasterVerbasCentroDeCusto:codCentroDeCusto", codCentroDeCusto )
      ELSE
         codCentroDeCusto := oCGI:GetCgiValue( "codCentroDeCusto", "" )
      ENDIF
      IF ( hb_HHasKey( hFilter,"codGrupoSuperior" ) )
         codGrupoSuperior := hFilter[ "codGrupoSuperior" ]
         oCGI:SetUserData( "__PainelGrpMasterVerbasCentroDeCusto:codGrupoSuperior", codGrupoSuperior )
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
      oCGI:SetUserData( "__PainelGrpMasterVerbasCentroDeCusto:codGrupo", "" )
      hFilter[ "codGrupoSuperior" ] := codGrupo
      oCGI:SetUserData( "__PainelGrpMasterVerbasCentroDeCusto:codGrupoSuperior", codGrupo )
   ELSE
      hFilter[ "codGrupo" ] := codGrupo
      oCGI:SetUserData( "__PainelGrpMasterVerbasCentroDeCusto:codGrupo", codGrupo )
      hFilter[ "codGrupoSuperior" ] := codGrupoSuperior
      oCGI:SetUserData( "__PainelGrpMasterVerbasCentroDeCusto:codGrupoSuperior", codGrupoSuperior )
   ENDIF

   hFilter[ "codFilial" ] := codFilial
   oCGI:SetUserData( "__PainelGrpMasterVerbasCentroDeCusto:codFilial", codFilial )

   hFilter[ "codPeriodo" ] := codPeriodo
   oCGI:SetUserData( "__PainelGrpMasterVerbasCentroDeCusto:codPeriodo", codPeriodo )

   hFilter[ "codCentroDeCusto" ] := codCentroDeCusto
   oCGI:SetUserData( "__PainelGrpMasterVerbasCentroDeCusto:codCentroDeCusto", codCentroDeCusto )

   IF ( lExecute )
      oCGI:SetUserData( "PainelGrpMasterVerbasFuncionarios:Back", ProcName() )
      PainelGrpMasterVerbasCentroDeCusto(nMaxRowspPage)
   ENDIF

RETURN( hFilter )

PROCEDURE PainelGrpMasterVerbasCentroDeCusto(nMaxRowspPage)

   local hUser := LoginUser()

   local cSubTitle:=" :: "+"Painel Consulta Dados Por Centro de Custo/Grupo de Verbas"
   local cTitle:=AppData:AppTitle+cSubTitle
   local cColsPrint
   local cIDParameters
   local aParameters

   local nField
   local aFields
   local nFields
   local nRowspPageMax

   local cTmp

   local hFilter

   if (!stackTools():IsInCallStack("__PainelGrpMasterVerbasCentroDeCusto"))
      hFilter:=__PainelGrpMasterVerbasCentroDeCusto(.F.)
   endif

   WITH OBJECT wTWebPage():New()

      :cTitle:=cTitle

      AppMenu(:WO,AppData:AppName,hUser,.F.)

      WITH OBJECT WFloatingBtn():New(:WO)
         :cClrPane:="#005FAB"
         :cName:=("WFloatingBtn"+ProcName())
         :cId:=Lower(:cName)
         :cText:="Voltar"
         :oIcon:cIcon:="arrow_back"
         :oIcon:cClrIcon := "#FED300"
         :cOnClick:=oCGI:GetUserData(ProcName()+":Back","MAINFUNCTION")
         :Create()
      END WITH

      aParameters:={"codFilial","codPeriodo","codCentroDeCusto","codGrupo"}
      cSubTitle:=AppData:AppName+cSubTitle
      GEPParameters(:WO,@cIDParameters,"__PainelGrpMasterVerbasCentroDeCusto",aParameters,.F.,cSubTitle):Create()

      :lValign    := .F.
      :lContainer := .F.

      aFields:=GetDataFieldsPainelGrpMasterVerbasCentroDeCusto(@cColsPrint)
      nRowspPageMax:=oCGI:GetUserData(__CODMODEL__+":RowspPageMax",10)
      HB_Default(@nMaxRowspPage,nRowspPageMax)

      WITH OBJECT wDatatable():New(:WO)

         :cId:=Lower("browsePainelGrpMasterVerbasCentroDeCusto")

         DataTableCSS(:cID)

         :cCSS+=AppData:CSSDataTable

         // Botones Datatable
         WITH OBject :AddButton("Exportar")
            :cCustom := "{extend: 'collection',text: 'Exportar',buttons: [ 'csv',{extend: 'excel',autoFilter: true,exportOptions: {columns: "+cColsPrint+"}},{extend: 'pdf',exportOptions: {columns: "+cColsPrint+"}} ]}"
         END WITH

         :AddButton("{extend: 'print',text: 'Imprimir',exportOptions: {columns: "+cColsPrint+"}}")

         WITH OBject :AddButton("Parâmetros")
            :cAction := nfl_OpenModal(cIDParameters,.T.)
         END WITH

         :cTitle  := cTitle + tableBtnReload(:cId)

         // Configurar opciones
         WITH OBJECT :Configure()
            :SetLanguage({"Portugues","Spanish"}[AppData:nLang])
            :sPaginationType := "full_numbers" //"listbox"
            :paging          := .T.
            :pageLength      :=  nMaxRowspPage
            :serverSide      := .T.
            :info            := .T.
            :lengthChange    := .T.
            :lengthMenu      := { {0,nRowspPageMax,-1},{0,nRowspPageMax,{"Todos","Todos"}[AppData:nLang]} }
            :searching       := .T.
            :ordering        := .T.
            :order           := { {0,'asc'} }  // Columna por defecto

            // Columnas del browse
            nFields:=Len(aFields)
            for nField:=1 to nFields
              WITH OBJECT :AddColumn(aFields[nField][1])
                  :data       := aFields[nField][2]
                  :orderable  := aFields[nField][3]
                  :searchable := aFields[nField][4]
                  :className  := aFields[nField][5]
               END
            next nField

            cTmp := {"Detalhes","Detalhes"}[AppData:nLang]
            :AddColumnButton("loupe",cTmp,"btn-wDatatable ;","__PainelGrpMasterVerbasFuncionariosDet","dt-center","",/*,'fn_click'*/)
            :AddColumnDef( nField ):width := '30px'

            :ajax := { "cgi" => "GetDataPainelGrpMasterVerbasCentroDeCusto" }

         END

         :Create()

      END

      oCgi:SendPage( :Create() )

   END

RETURN

//------------------------------------------------------------------------------

FUNCTION GetDataPainelGrpMasterVerbasCentroDeCusto(lSendJSON,lGetFull,cSearchFilter)

   local aRow
   local aOrder
   local aRecords

   local codModel:=__CODMODEL__

   local hRow
   local hParams

   local nDraw
   local nStart
   local nLimit

   local xJSONData

   HB_Default(@lGetFull,.F.)

   if (lGetFull)

      nStart:=1
      nLimit:=-1

   else

      hParams:=oCGI:aParamsToHash(.T.)

      nStart:=Val(hParams['START'])

      nLimit:=Val(hParams['LENGTH'])

      nDraw:=hParams['DRAW']
      aOrder:= {Val(hParams['order[0][column]'])+1,hParams['order[0][dir]']} // datatables empieza en columna 0. segundo elemento asc o desc
      cSearchFilter:=hParams['SEARCH[VALUE]']
      oCGI:SetUserData( "GetDataModel:cSearchFilter",cSearchFilter )

   endif

   HB_Default(@lSendJSON,.T.)

   if (!nLimit==0)
      GetDataFieldsPainelGrpMasterVerbasCentroDeCusto()
      xJSONData:=Extraer(codModel,nStart,nLimit,nDraw,cSearchFilter,aOrder,lSendJSON,.F.)
   endif

RETURN(if(lSendJSON,oCGI:SendJson(xJSONData),xJSONData))

function GetDataFieldsPainelGrpMasterVerbasCentroDeCusto(cColsPrint)

   local aFields
   local aFieldsADD:=Array(0)
   local aDataGrupo
   local codModel:=__CODMODEL__
   local bFunction:={||Extraer(codModel,1,1,1,"",{},.F.,.T.)}
   local cKey
   local hDataGrupo
   local nRow
   local nRows

   hDataGrupo:=GetDataCadastroGruposMaster(.F.,.T.,"")
   aDataGrupo:=hDataGrupo["data"]

   nRows:=Len(aDataGrupo)
   for nRow:=1 to nRows
        aAdd(aFieldsADD,{aDataGrupo[nRow]["descGrupoHTML"],aDataGrupo[nRow]["aliasGrupo"],.F.,.F.,"dt-right",.T.,"@R 999,999,999.99"})
   next nRow

   aFields:=GetDataFields(codModel,bFunction,@cColsPrint,aFieldsADD)

   oCGI:SetUserData("GetDataModel:aFieldsADD",aFieldsADD)

   return(aFields)

//-------------------------------------------
// Recuperamos los datos
STATIC FUNCTION Extraer(codModel,nPage,nRecords,nDraw,cSearchFilter,aOrder,lSendJSON,lGetFields)

   local cFile
   local cFilter
   local cParModel
   local cGrpFiles

   LOCAL codGrupo
   LOCAL codFilial
   LOCAL codPeriodo
   LOCAL codCentroDeCusto
   LOCAL codGrupoSuperior

   local hFilter

   local xData

   AppData:cEmp:=oCGI:GetUserData("cEmp",AppData:cEmp)
   HB_Default(AppData:cEmp,"")
   cFile:=(AppData:PathData+AppData:cEmp+"_"+Lower(ProcName(1))+".json")

   hFilter := { => }
   restoreTmpParameters( "__PainelGrpMasterVerbasCentroDeCusto", @hFilter, .T. )

   codGrupo := oCGI:GetUserData( "__PainelGrpMasterVerbasCentroDeCusto:codGrupo" )
   codFilial := oCGI:GetUserData( "__PainelGrpMasterVerbasCentroDeCusto:codFilial" )
   codPeriodo := oCGI:GetUserData( "__PainelGrpMasterVerbasCentroDeCusto:codPeriodo" )
   codCentroDeCusto := oCGI:GetUserData( "__PainelGrpMasterVerbasCentroDeCusto:codCentroDeCusto" )
   codGrupoSuperior := oCGI:GetUserData( "__PainelGrpMasterVerbasCentroDeCusto:codGrupoSuperior" )

   HB_Default(@cFilter,"")

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

   cParModel:=setParModel(hFilter)

   IF (!Empty(cFilter))
      cFilter:="SQL:"+cFilter
   else
      cFilter:=cSearchFilter
   endif

   cGrpFiles:=codModel
   IF (!Empty(codPeriodo))
       cGrpFiles+="_"
       cGrpFiles+=codPeriodo
   ENDIF

   xData:=GetDataModel(codModel,nPage,nRecords,nDraw,cFilter,aOrder,lSendJSON,lGetFields,cFile,cParModel,.F.,cGrpFiles)

   IF (!Empty(hFilter))
      HB_Default(@lGetFields,.F.)
      IF (!lGetFields)
        xData:=rebuildDataModel(xData,hFilter,lSendJSON,aOrder)
      ENDIF
   ENDIF

RETURN(xData)

PROCEDURE __clearPainelGrpMasterVerbasCentroDeCusto()

   oCGI:SetUserData( "__PainelGrpMasterVerbasCentroDeCusto:codFilial", "" )
   oCGI:SetUserData( "__PainelGrpMasterVerbasCentroDeCusto:codGrupo", "" )
   oCGI:SetUserData( "__PainelGrpMasterVerbasCentroDeCusto:codPeriodo", "" )
   oCGI:SetUserData( "__PainelGrpMasterVerbasCentroDeCusto:codCentroDeCusto", "" )
   oCGI:SetUserData( "__PainelGrpMasterVerbasCentroDeCusto:codGrupoSuperior", "" )

   oCGI:SetUserData( "PainelGrpMasterVerbasCentroDeCusto:Back", "ParametersPainelGrpMasterVerbasCentroDeCusto" )
   oCGI:SetUserData( "PainelGrpMasterVerbasFuncionarios:Back", "ParametersGrpMasterVerbasFuncionarios" )

   deleteTmpParameters( "__PainelGrpMasterVerbasCentroDeCusto" )

RETURN