// Proyecto: GEP
/*
 * Fichero: GrpMasterDetailVerbasFilial.prg
 * Descripción:
 * Autor:
 * Fecha: 14/08/2021
 */

#include "Xailer.ch"
#include "Nefele.ch"
#include "LangCGI.ch"

#define __CODMODEL__ "GRPMASTERDETVERBASFIL"

PROCEDURE ParametersGrpMasterDetailVerbasFilial( lGrpViewTotais )

   LOCAL hUser := LoginUser()

   LOCAL cSubTitle:=" :: "+"Consulta Dados Por Filial/Grupo e SubGrupo de Verbas"
   LOCAL cTitle := AppData:AppTitle+cSubTitle
   LOCAL cIDParameters
   LOCAL aParameters

   hb_default( @lGrpViewTotais,.F. )
   oCGI:SetUserData( "__GrpMasterDetailVerbasFilial:lGrpViewTotais",lGrpViewTotais )

   oCGI:SetUserData( "GrpMasterDetailVerbasFilial:Back",ProcName() )

   WITH OBJECT wTWebPage():New()

      :cTitle := cTitle

      AppMenu(:WO,AppData:AppName ,hUser,.F. )

      aParameters := { "codPeriodo","codGrupo","codFilial" }
      cSubTitle:=AppData:AppName+cSubTitle
      GEPParameters( :WO,@cIDParameters,"__GrpMasterDetailVerbasFilial",aParameters,.T.,cSubTitle,.T. ):Create()

      :lValign    := .F.
      :lContainer := .F.

      oCgi:SendPage( :Create() )

   END

RETURN

function __GrpMasterDetailVerbasFilial(lExecute,hFilter,nMaxRowspPage)

   local cIDModal

   local codGrupo
   local codFilial
   local codPeriodo

   local hIDModal

   local lFilter

   HB_Default(@lExecute,.T.)
   lFilter:=(HB_IsHash(hFilter).AND.!Empty(hFilter))
   HB_Default(@hFilter,{=>})

   IF (lExecute)
      cIDModal:=oCGI:GetCgiValue("cIDModalTotaisGrpMasterDetailVerbasFilial","")
      IF (!Empty(cIDModal))
         oCGI:SetUserData("HistoryRemoveParams",.F.)
         cIDModal:=__base64Decode(cIDModal)
         HB_JsonDecode(cIDModal,@hIDModal)
         saveTmpParameters("__GrpMasterDetailVerbasFilial",hIDModal)
         IF (HB_HHasKey(hIDModal,"codGrupo"))
            codGrupo:=hIDModal["codGrupo"]
         endif
         IF (HB_HHasKey(hIDModal,"codFilial"))
            codFilial:=hIDModal["codFilial"]
         ENDIF
         IF (HB_HHasKey(hIDModal,"codPeriodo"))
            codPeriodo:=hIDModal["codPeriodo"]
         ENDIF
      ELSE
         IF (HB_HHasKey(hFilter,"codGrupo"))
            codGrupo:=hFilter["codGrupo"]
            oCGI:SetUserData("__GrpMasterDetailVerbasFilial:codGrupo",codGrupo)
         ELSE
            codGrupo:=oCGI:GetCgiValue("codGrupo","")
         ENDIF
         IF (HB_HHasKey(hFilter,"codFilial"))
            codFilial:=hFilter["codFilial"]
            oCGI:SetUserData("__GrpMasterDetailVerbasFilial:codFilial",codFilial)
         ELSE
            codFilial:=oCGI:GetCgiValue("codFilial","")
         ENDIF
         IF (HB_HHasKey(hFilter,"codPeriodo"))
            codPeriodo:=hFilter["codPeriodo"]
            oCGI:SetUserData("__GrpMasterDetailVerbasFilial:codPeriodo",codPeriodo)
         ELSE
            codPeriodo:=oCGI:GetCgiValue("codPeriodo","")
         ENDIF
      endif
   else
        IF (HB_HHasKey(hFilter,"codGrupo"))
            codGrupo:=hFilter["codGrupo"]
            oCGI:SetUserData("__GrpMasterDetailVerbasFilial:codGrupo",codGrupo)
         ELSE
            codGrupo:=oCGI:GetCgiValue("codGrupo","")
         ENDIF
         IF (HB_HHasKey(hFilter,"codFilial"))
            codFilial:=hFilter["codFilial"]
            oCGI:SetUserData("__GrpMasterDetailVerbasFilial:codFilial",codFilial)
         ELSE
            codFilial:=oCGI:GetCgiValue("codFilial","")
         ENDIF
         IF (HB_HHasKey(hFilter,"codPeriodo"))
            codPeriodo:=hFilter["codPeriodo"]
            oCGI:SetUserData("__GrpMasterDetailVerbasFilial:codPeriodo",codPeriodo)
         ELSE
            codPeriodo:=oCGI:GetCgiValue("codPeriodo","")
         ENDIF
    endif

   if ((!lFilter).and.Empty(cIDModal))

       if (Empty(codGrupo))
          codGrupo:=oCGI:GetCgiValue("GEPParameters_codGrupo","")
          if (Empty(codGrupo))
             codGrupo:=oCGI:GetUserData("__GEPParameters:codGrupo",codGrupo)
          endif
       endif

       if (Empty(codFilial))
          codFilial:=oCGI:GetCgiValue("GEPParameters_codFilial","")
          if (Empty(codFilial))
             codFilial:=oCGI:GetUserData("__GEPParameters:codFilial",codFilial)
          endif
       endif

       if (Empty(codPeriodo))
          codPeriodo:=oCGI:GetCgiValue("GEPParameters_codPeriodo","")
          if (Empty(codPeriodo))
             codPeriodo:=oCGI:GetUserData("__GEPParameters:codPeriodo",codPeriodo)
          endif
       endif

    endif

   hFilter["codGrupo"]:=codGrupo
   oCGI:SetUserData("__GrpMasterDetailVerbasFilial:codGrupo",codGrupo)

   hFilter["codFilial"]:=codFilial
   oCGI:SetUserData("__GrpMasterDetailVerbasFilial:codFilial",codFilial)

   hFilter["codPeriodo"]:=codPeriodo
   oCGI:SetUserData("__GrpMasterDetailVerbasFilial:codPeriodo",codPeriodo)

   if (lExecute)
      oCGI:SetUserData("GrpMasterDetailVerbasCentroDeCusto:Back",ProcName())
      GrpMasterDetailVerbasFilial(nMaxRowspPage)
   endif

   RETURN(hFilter)

PROCEDURE GrpMasterDetailVerbasFilial(nMaxRowspPage)

   LOCAL hUser := LoginUser()
   LOCAL cSubTitle:=" :: "+"Consulta Dados Por Filial/Grupo e SubGrupo de Verbas"
   LOCAL cTitle := AppData:AppTitle+cSubTitle
   LOCAL cColsPrint
   LOCAL cIDParameters

   LOCAL aDataGrupo
   LOCAL aParameters
   LOCAL aColsShowHide

   LOCAL nField
   LOCAL aFields
   LOCAL nFields
   LOCAL nRowspPageMax

   LOCAL cTmp

   local hFilter

   local owDataTable

   IF ( !stackTools():IsInCallStack( "__GrpMasterDetailVerbasFilial" ) )
      hFilter:=__GrpMasterDetailVerbasFilial( .F. )
   ENDIF

   WITH OBJECT wTWebPage():New()

      :cTitle := cTitle

      AppMenu(:WO,AppData:AppName ,hUser,.F. )

      WITH OBJECT WFloatingBtn():New( :WO )
         :cClrPane:="#005FAB"
         :cName := ( "WFloatingBtn" + ProcName() )
         :cId := Lower( :cName )
         :cText := "Voltar"
         :oIcon:cIcon := "arrow_back"
         :oIcon:cClrIcon := "#FED300"
         :cOnClick := oCGI:GetUserData( ProcName() + ":Back","MAINFUNCTION" )
         :Create()
      END WITH

      aParameters := { "codFilial","codPeriodo","codCentroDeCusto","codGrupo" }
      cSubTitle:=AppData:AppName+cSubTitle
      GEPParameters( :WO,@cIDParameters,"__GrpMasterDetailVerbasFilial",aParameters,.F.,cSubTitle ):Create()

      :lValign    := .F.
      :lContainer := .F.

      aFields := GetDataFieldsGrpMasterDetailVerbasFilial( @cColsPrint , @aDataGrupo )
      nFields := Len( aFields )
      aColsShowHide:=array(0)
      for nField:=1 to nFields
         IF (AScan(aDataGrupo,{|h|h["aliasGrupo" ]==aFields[nField][2]})>0)
            AAdd(aColsShowHide,nField)
         ENDIF
      next nField
      nRowspPageMax := oCGI:GetUserData(__CODMODEL__+":RowspPageMax",10)
      HB_Default(@nMaxRowspPage,nRowspPageMax)

      WITH OBJECT owDataTable:=wDatatable():New( :WO )

         owDataTable:cId := Lower("browseGrpMasterDetailVerbasFilial")

         DataTableCSS( owDataTable:cID )

         :cCSS += AppData:CSSDataTable

         // Botones Datatable
         WITH OBject :AddButton( "Exportar" )
            :cCustom := "{extend: 'collection',text: 'Exportar',buttons: [ 'csv',{extend: 'excel',autoFilter: true,exportOptions: {columns: " + cColsPrint + "}},{extend: 'pdf',exportOptions: {columns: " + cColsPrint + "}} ]}"
         END WITH

         :AddButton( "{extend: 'print',text: 'Imprimir',exportOptions: {columns: " + cColsPrint + "}}" )

         WITH OBject :AddButton( "Parâmetros" )
            :cAction := nfl_OpenModal( cIDParameters,.T. )
         END WITH

         IF (!Empty(aColsShowHide))
            WITH OBject :AddButton( "( + | - ) SubGrupos" )
               :cAction := tablefnColsToShowHide(owDataTable:cId,aColsShowHide)["jsFunction"]
            END WITH
         ENDIF

         :cTitle  := cTitle + tableBtnReload( owDataTable:cId )

         // Configurar opciones
         WITH OBJECT :Configure()
            :SetLanguage( { "Portugues","Spanish" }[ AppData:nLang ] )
            :sPaginationType := "full_numbers" //"listbox"
            :paging          := .T.
            :pageLength      :=  nMaxRowspPage
            :serverSide      := .T.
            :info            := .T.
            :lengthChange    := .T.
            :lengthMenu      := { { 0,nRowspPageMax,-1 },{ 0,nRowspPageMax,{"Todos","Todos"}[ AppData:nLang ] } }
            :searching       := .T.
            :ordering        := .T.
            :ORDER           := { { 0,'asc' } }  // Columna por defecto

            // Columnas del browse
            FOR nField := 1 TO nFields
               WITH OBJECT :AddColumn( aFields[ nField ][ 1 ] )
                  :DATA       := aFields[ nField ][ 2 ]
                  :orderable  := aFields[ nField ][ 3 ]
                  :searchable := aFields[ nField ][ 4 ]
                  :className  := aFields[ nField ][ 5 ]
               END
            NEXT nField

            cTmp := { "Detalhes","Detalhes" }[ AppData:nLang ]
            :AddColumnButton( "loupe",cTmp,"btn-wDatatable ;","__GrpMasterDetailVerbasCentroDeCustoDet","dt-center","",/*,'fn_click'*/ )
            :AddColumnDef( nField ):width := '30px'

            :ajax := { "cgi" => "GetDataGrpMasterDetailVerbasFilial" }

         END

         IF (!Empty(aColsShowHide))
            AAdd( :aScript, tablefnShowHideCol(owDataTable:cID) )
            AAdd( :aScript, tablefnAdjustDraw(owDataTable:cID) )
            AAdd( :aScript, tablefnColsToShowHide(owDataTable:cID,aColsShowHide)["jsScript"] )
         ENDIF

*         AAdd( :aScript,fixedColumns( :cID,oCGI:GetUserData( __CODMODEL__+":fixedColumns","0" ) ) )

         :Create()

      END

      oCgi:SendPage( :Create() )

   END

RETURN

//------------------------------------------------------------------------------

FUNCTION GetDataGrpMasterDetailVerbasFilial( lSendJSON,lGetFull,cSearchFilter )

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

   hb_default( @lGetFull,.F. )

   IF ( lGetFull )

      nStart := 1
      nLimit := -1

   ELSE

      hParams := oCGI:aParamsToHash( .T. )

      nStart := Val( hParams[ 'START' ] )

      nLimit := Val( hParams[ 'LENGTH' ] )

      nDraw := hParams[ 'DRAW' ]
      aOrder := { Val( hParams[ 'order[0][column]' ] ) + 1,hParams[ 'order[0][dir]' ] } // datatables empieza en columna 0. segundo elemento asc o desc
      cSearchFilter := hParams[ 'SEARCH[VALUE]' ]
      oCGI:SetUserData( "GetDataModel:cSearchFilter",cSearchFilter )

   ENDIF

   hb_default( @lSendJSON,.T. )

   IF ( !nLimit == 0 )
      GetDataFieldsGrpMasterDetailVerbasFilial()
      xJSONData := Extraer( codModel,nStart,nLimit,nDraw,cSearchFilter,aOrder,lSendJSON,.F. )
   ENDIF

RETURN( if( lSendJSON,oCGI:SendJson(xJSONData ),xJSONData ) )

FUNCTION GetDataFieldsGrpMasterDetailVerbasFilial( cColsPrint , aDataGrupo , aDataGrupoMaster )

   LOCAL aFields
   LOCAL aFieldsADD := Array( 0 )
   LOCAL codModel := __CODMODEL__
   LOCAL bFunction := {|| Extraer( codModel,1,1,1,"",{},.F.,.T. ) }
   LOCAL cKey
   LOCAL hDataGrupo
   LOCAL nRow
   LOCAL nRows

   hDataGrupo := GetDataCadastroGrupos( .F.,.T.,"" )
   aDataGrupo := hDataGrupo[ "data" ]

   nRows := Len( aDataGrupo )
   FOR nRow := 1 TO nRows
      AAdd( aFieldsADD,{ aDataGrupo[ nRow ][ "descGrupo" ],aDataGrupo[ nRow ][ "aliasGrupo" ],.F.,.F.,"dt-right",.T.,"@R 999,999,999.99" } )
   NEXT nRow

   hDataGrupo := GetDataCadastroGruposMaster( .F.,.T.,"" )
   aDataGrupoMaster := hDataGrupo[ "data" ]

   nRows := Len( aDataGrupoMaster )
   FOR nRow := 1 TO nRows
      AAdd( aFieldsADD, { aDataGrupoMaster[ nRow ][ "descGrupoHTML" ], aDataGrupoMaster[ nRow ][ "aliasGrupo" ], .F., .F., "dt-right", .T., "@R 999,999,999.99" } )
   NEXT nRow

   aFields := GetDataFields( codModel,bFunction,@cColsPrint,aFieldsADD )

   oCGI:SetUserData( "GetDataModel:aFieldsADD",aFieldsADD )

return( aFields )

//-------------------------------------------
// Recuperamos los datos
STATIC FUNCTION Extraer( codModel,nPage,nRecords,nDraw,cSearchFilter,aOrder,lSendJSON,lGetFields )

   LOCAL cFile
   LOCAL cFilter
   LOCAL cParModel
   LOCAL cGrpFiles

   LOCAL codGrupo
   LOCAL codFilial
   LOCAL codPeriodo

   LOCAL hFilter

   LOCAL xData

   AppData:cEmp := oCGI:GetUserData( "cEmp",AppData:cEmp )
   hb_default( AppData:cEmp,"" )
   cFile := ( AppData:PathData + AppData:cEmp + "_" + Lower( ProcName(1 ) ) + ".json" )

   hFilter:={=>}
   restoreTmpParameters("__GrpMasterDetailVerbasFilial",@hFilter,.T.)

   codGrupo := oCGI:GetUserData( "__GrpMasterDetailVerbasFilial:codGrupo" )
   codFilial := oCGI:GetUserData( "__GrpMasterDetailVerbasFilial:codFilial" )
   codPeriodo := oCGI:GetUserData( "__GrpMasterDetailVerbasFilial:codPeriodo" )

   hb_default( @cFilter,"" )

  IF (!Empty(codPeriodo))
      hFilter[ "codPeriodo" ] := codPeriodo
      IF (!Empty(cFilter))
         cFilter+=" AND "
      endif
      cFilter+="RD_DATARQ='"+codPeriodo+"'"
   ENDIF

   IF (!Empty(codGrupo))
      hFilter["codGrupo"]:=codGrupo
      IF (!Empty(cFilter))
         cFilter+=" AND "
      endif
      cFilter+="ZY__CODIGO='"+codGrupo+"'"
    ELSE
      IF (HB_HHasKey(hFilter,"codGrupo"))
         HB_HDel(hFilter,"codGrupo")
      ENDIF
    ENDIF

   IF (!Empty(codFilial))
      hFilter["codFilial"]:=codFilial
      IF (!Empty(cFilter))
         cFilter+=" AND "
      endif
      cFilter+="RA_FILIAL='"+codFilial+"'"
   else
      IF (HB_HHasKey(hFilter,"codFilial"))
         HB_HDel(hFilter,"codFilial")
      ENDIF
   ENDIF

   cParModel:=setParModel(hFilter)

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

   xData := GetDataModel( codModel,nPage,nRecords,nDraw,cFilter,aOrder,lSendJSON,lGetFields,cFile,cParModel,.F.,cGrpFiles )

   IF ( !Empty( hFilter ) )
      hb_default( @lGetFields,.F. )
      IF ( !lGetFields )
         xData := rebuildDataModel( xData,hFilter,lSendJSON,aOrder )
      ENDIF
   ENDIF

RETURN( xData )

PROCEDURE __clearGrpMasterDetailVerbasFilial()

   oCGI:SetUserData( "__GrpMasterDetailVerbasFilial:codGrupo","" )
   oCGI:SetUserData( "__GrpMasterDetailVerbasFilial:codFilial","" )
   oCGI:SetUserData( "__GrpMasterDetailVerbasFilial:codPeriodo","" )

   oCGI:SetUserData("GrpMasterDetailVerbasFilial:Back:lGrpViewTotais",.F.)

   oCGI:SetUserData( "GrpMasterDetailVerbasFilial:Back","ParametersGrpMasterDetailVerbasFilial" )
   oCGI:SetUserData( "GrpMasterDetailVerbasCentroDeCusto:Back","ParametersGrpMasterDetailVerbasCentroDeCusto" )

   deleteTmpParameters("__GrpMasterDetailVerbasFilial")

RETURN
