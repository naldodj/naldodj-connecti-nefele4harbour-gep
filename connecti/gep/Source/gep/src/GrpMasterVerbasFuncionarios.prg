// Proyecto: GEP
/*
 * Fichero: GrpMasterVerbasFuncionarios.prg
 * Descripción:
 * Autor:
 * Fecha: 14/08/2021
 */
 */

#include "Xailer.ch"
#include "Nefele.ch"
#include "LangCGI.ch"

#define __CODMODEL__ "GRPMASTERVERBASFUNCIONARIOS"

PROCEDURE ParametersGrpMasterVerbasFuncionarios( lGrpViewTotais )

   LOCAL hUser := LoginUser()

   LOCAL cSubTitle:=" :: "+"Consulta Dados Por Funcionario/Grupo de Verbas"
   LOCAL cTitle := AppData:AppTitle+cSubTitle
   LOCAL cIDParameters
   LOCAL aParameters

   hb_default( @lGrpViewTotais,.F. )
   oCGI:SetUserData( "__GrpMasterVerbasFuncionarios:lGrpViewTotais",lGrpViewTotais )

   oCGI:SetUserData( "GrpMasterVerbasFuncionarios:Back",ProcName() )

   WITH OBJECT wTWebPage():New()

      :cTitle := cTitle

      AppMenu(:WO,AppData:AppName ,hUser,.F. )

      aParameters := { "codPeriodo","codGrupo","codFilial","codCentroDeCusto","codFuncao","codMatricula" }
      cSubTitle:=AppData:AppName+cSubTitle
      GEPParameters( :WO,@cIDParameters,"__GrpMasterVerbasFuncionarios",aParameters,.T.,cSubTitle,.T. ):Create()

      :lValign    := .F.
      :lContainer := .F.

      oCgi:SendPage( :Create() )

   END

RETURN

function __GrpMasterVerbasFuncionarios(lExecute,hFilter,nMaxRowspPage)

   local cIDModal

   local codVerba
   local codGrupo
   local codFilial
   local codFuncao
   local codPeriodo
   local codMatricula
   local codCentroDeCusto

   local hIDModal

   local lFilter

   HB_Default(@lExecute,.T.)
   lFilter:=(HB_IsHash(hFilter).AND.!Empty(hFilter))
   HB_Default(@hFilter,{=>})

   IF (lExecute)
      cIDModal:=oCGI:GetCgiValue("cIDModalTotaisGrpMasterVerbasFuncionarios","")
      IF (!Empty(cIDModal))
         oCGI:SetUserData("HistoryRemoveParams",.F.)
         cIDModal:=__base64Decode(cIDModal)
         HB_JsonDecode(cIDModal,@hIDModal)
         saveTmpParameters("__GrpMasterVerbasFuncionarios",hIDModal)
         IF (HB_HHasKey(hIDModal,"codGrupo"))
            codGrupo:=hIDModal["codGrupo"]
         ENDIF
         IF (HB_HHasKey(hIDModal,"codVerba"))
            codVerba:=hIDModal["codVerba"]
         ENDIF
         IF (HB_HHasKey(hIDModal,"codFilial"))
            codFilial:=hIDModal["codFilial"]
         ENDIF
         IF (HB_HHasKey(hIDModal,"codFuncao"))
            codFuncao:=hIDModal["codFuncao"]
         ENDIF
         IF (HB_HHasKey(hIDModal,"codPeriodo"))
            codPeriodo:=hIDModal["codPeriodo"]
         ENDIF
         IF (HB_HHasKey(hIDModal,"codMatricula"))
            codMatricula:=hIDModal["codMatricula"]
         ENDIF
         IF (HB_HHasKey(hIDModal,"codCentroDeCusto"))
            codCentroDeCusto:=hIDModal["codCentroDeCusto"]
         ENDIF
      ELSE
         IF (HB_HHasKey(hFilter,"codVerba"))
            codVerba:=hFilter["codVerba"]
            oCGI:SetUserData("__GrpMasterVerbasFuncionarios:codVerba",codVerba)
         ELSE
            codVerba:=oCGI:GetCgiValue("codVerba","")
         ENDIF
         IF (HB_HHasKey(hFilter,"codGrupo"))
            codGrupo:=hFilter["codGrupo"]
            oCGI:SetUserData("__GrpMasterVerbasFuncionarios:codGrupo",codGrupo)
         ELSE
            codGrupo:=oCGI:GetCgiValue("codGrupo","")
         ENDIF
         IF (HB_HHasKey(hFilter,"codFuncao"))
            codFuncao:=hFilter["codFuncao"]
            oCGI:SetUserData("__GrpMasterVerbasFuncionarios:codFuncao",codFuncao)
         ELSE
            codFuncao:=oCGI:GetCgiValue("codFuncao","")
         ENDIF
         IF (HB_HHasKey(hFilter,"codFilial"))
            codFilial:=hFilter["codFilial"]
            oCGI:SetUserData("__GrpMasterVerbasFuncionarios:codFilial",codFilial)
         ELSE
            codFilial:=oCGI:GetCgiValue("codFilial","")
         ENDIF
         IF (HB_HHasKey(hFilter,"codPeriodo"))
            codPeriodo:=hFilter["codPeriodo"]
            oCGI:SetUserData("__GrpMasterVerbasFuncionarios:codPeriodo",codPeriodo)
         ELSE
            codPeriodo:=oCGI:GetCgiValue("codPeriodo","")
         ENDIF
         IF (HB_HHasKey(hFilter,"codMatricula"))
            codMatricula:=hFilter["codMatricula"]
            oCGI:SetUserData("__GrpMasterVerbasFuncionarios:codMatricula",codMatricula)
         ELSE
            codMatricula:=oCGI:GetCgiValue("codMatricula","")
         ENDIF
         IF (HB_HHasKey(hFilter,"codCentroDeCusto"))
            codCentroDeCusto:=hFilter["codCentroDeCusto"]
            oCGI:SetUserData("__GrpMasterVerbasFuncionarios:codCentroDeCusto",codCentroDeCusto)
         ELSE
            codCentroDeCusto:=oCGI:GetCgiValue("codCentroDeCusto","")
         ENDIF
      endif
   else
        IF (HB_HHasKey(hFilter,"codVerba"))
            codVerba:=hFilter["codVerba"]
            oCGI:SetUserData("__GrpMasterVerbasFuncionarios:codVerba",codVerba)
         ELSE
            codVerba:=oCGI:GetCgiValue("codVerba","")
         ENDIF
         IF (HB_HHasKey(hFilter,"codGrupo"))
            codGrupo:=hFilter["codGrupo"]
            oCGI:SetUserData("__GrpMasterVerbasFuncionarios:codGrupo",codGrupo)
         ELSE
            codGrupo:=oCGI:GetCgiValue("codGrupo","")
         ENDIF
         IF (HB_HHasKey(hFilter,"codFuncao"))
            codFuncao:=hFilter["codFuncao"]
            oCGI:SetUserData("__GrpMasterVerbasFuncionarios:codFuncao",codFuncao)
         ELSE
            codFuncao:=oCGI:GetCgiValue("codFuncao","")
         ENDIF
         IF (HB_HHasKey(hFilter,"codFilial"))
            codFilial:=hFilter["codFilial"]
            oCGI:SetUserData("__GrpMasterVerbasFuncionarios:codFilial",codFilial)
         ELSE
            codFilial:=oCGI:GetCgiValue("codFilial","")
         ENDIF
         IF (HB_HHasKey(hFilter,"codPeriodo"))
            codPeriodo:=hFilter["codPeriodo"]
            oCGI:SetUserData("__GrpMasterVerbasFuncionarios:codPeriodo",codPeriodo)
         ELSE
            codPeriodo:=oCGI:GetCgiValue("codPeriodo","")
         ENDIF
         IF (HB_HHasKey(hFilter,"codMatricula"))
            codMatricula:=hFilter["codMatricula"]
            oCGI:SetUserData("__GrpMasterVerbasFuncionarios:codMatricula",codMatricula)
         ELSE
            codMatricula:=oCGI:GetCgiValue("codMatricula","")
         ENDIF
         IF (HB_HHasKey(hFilter,"codCentroDeCusto"))
            codCentroDeCusto:=hFilter["codCentroDeCusto"]
            oCGI:SetUserData("__GrpMasterVerbasFuncionarios:codCentroDeCusto",codCentroDeCusto)
         ELSE
            codCentroDeCusto:=oCGI:GetCgiValue("codCentroDeCusto","")
         ENDIF
   endif

   if ((!lFilter).and.Empty(cIDModal))

       if (Empty(codVerba))
          codVerba:=oCGI:GetCgiValue("GEPParameters_codVerba","")
          if (Empty(codVerba))
             codVerba:=oCGI:GetUserData("__GEPParameters:codVerba",codVerba)
          endif
       endif

       if (Empty(codGrupo))
          codGrupo:=oCGI:GetCgiValue("GEPParameters_codGrupo","")
          if (Empty(codGrupo))
             codGrupo:=oCGI:GetUserData("__GEPParameters:codGrupo",codGrupo)
          endif
       endif

       if (Empty(codFuncao))
         codFuncao:=oCGI:GetCgiValue("GEPParameters_codfuncao","")
         if (Empty(codFuncao))
            codFuncao:=oCGI:GetUserData("__GEPParameters:codFuncao",codFuncao)
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

       if (Empty(codMatricula))
          codMatricula:=oCGI:GetCgiValue("GEPParameters_codMatricula","")
          if (Empty(codMatricula))
             codMatricula:=oCGI:GetUserData("__GEPParameters:codMatricula",codMatricula)
          endif
       endif

       if (Empty(codCentroDeCusto))
          codCentroDeCusto:=oCGI:GetCgiValue("GEPParameters_codCentroDeCusto","")
          if (Empty(codCentroDeCusto))
             codCentroDeCusto:=oCGI:GetUserData("__GEPParameters:codCentroDeCusto",codCentroDeCusto)
          endif
       endif

    endif

   hFilter["codVerba"]:=codVerba
   oCGI:SetUserData("__GrpMasterVerbasFuncionarios:codVerba",codVerba)

   hFilter["codGrupo"]:=codGrupo
   oCGI:SetUserData("__GrpMasterVerbasFuncionarios:codGrupo",codGrupo)

   hFilter["codFuncao"]:=codFuncao
   oCGI:SetUserData("__GrpMasterVerbasFuncionarios:codFuncao",codFuncao)

   hFilter["codFilial"]:=codFilial
   oCGI:SetUserData("__GrpMasterVerbasFuncionarios:codFilial",codFilial)

   hFilter["codPeriodo"]:=codPeriodo
   oCGI:SetUserData("__GrpMasterVerbasFuncionarios:codPeriodo",codPeriodo)

   hFilter["codMatricula"]:=codMatricula
   oCGI:SetUserData("__GrpMasterVerbasFuncionarios:codMatricula",codMatricula)

   hFilter["codCentroDeCusto"]:=codCentroDeCusto
   oCGI:SetUserData("__GrpMasterVerbasFuncionarios:codCentroDeCusto",codCentroDeCusto)

   if (lExecute)
      oCGI:SetUserData("lGrupoHasSuper",.T.)
      oCGI:SetUserData( "GrpVerbasFuncionarios:Back",ProcName() )
      GrpMasterVerbasFuncionarios(nMaxRowspPage)
   endif

   RETURN(hFilter)

PROCEDURE GrpMasterVerbasFuncionarios(nMaxRowspPage)

   LOCAL hUser := LoginUser()

   LOCAL cSubTitle:=" :: "+"Consulta Dados Por Centro de Custo/Funcionario/Grupo de Verbas"
   LOCAL cTitle := AppData:AppTitle+cSubTitle
   LOCAL cColsPrint
   LOCAL cIDParameters
   LOCAL aParameters

   LOCAL nField
   LOCAL aFields
   LOCAL nFields
   LOCAL nRowspPageMax

   LOCAL cTmp

   IF ( !stackTools():IsInCallStack( "__GrpMasterVerbasFuncionarios" ) )
      __GrpMasterVerbasFuncionarios( .F. )
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
      cSubTitle:=AppData:AppName
      GEPParameters( :WO,@cIDParameters,"__GrpMasterVerbasFuncionarios",aParameters,.F.,cSubTitle ):Create()

      :lValign    := .F.
      :lContainer := .F.

      aFields := GetDataFieldsGrpMasterVerbasFuncionarios( @cColsPrint )
      nRowspPageMax := oCGI:GetUserData(__CODMODEL__+":RowspPageMax",10)
      HB_Default(@nMaxRowspPage,nRowspPageMax)

      WITH OBJECT wDatatable():New( :WO )

         :cId := Lower("browseGrpMasterVerbasFuncionarios")

         DataTableCSS( :cID )

         :cCSS += AppData:CSSDataTable

         // Botones Datatable
         WITH OBject :AddButton( "Exportar" )
            :cCustom := "{extend: 'collection',text: 'Exportar',buttons: [ 'csv',{extend: 'excel',autoFilter: true,exportOptions: {columns: " + cColsPrint + "}},{extend: 'pdf',exportOptions: {columns: " + cColsPrint + "}} ]}"
         END WITH

         :AddButton( "{extend: 'print',text: 'Imprimir',exportOptions: {columns: " + cColsPrint + "}}" )

         WITH OBject :AddButton( "Parâmetros" )
            :cAction := nfl_OpenModal( cIDParameters,.T. )
         END WITH

         :cTitle  := cTitle + tableBtnReload( :cId )

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
            nFields := Len( aFields )
            FOR nField := 1 TO nFields
               WITH OBJECT :AddColumn( aFields[ nField ][ 1 ] )
                  :DATA       := aFields[ nField ][ 2 ]
                  :orderable  := aFields[ nField ][ 3 ]
                  :searchable := aFields[ nField ][ 4 ]
                  :className  := aFields[ nField ][ 5 ]
               END
            NEXT nField

            cTmp := { "Detalhes","Detalhes" }[ AppData:nLang ]
            :AddColumnButton( "loupe",cTmp,"btn-wDatatable ;","__GrpVerbasFuncionariosDet","dt-center","",/*,'fn_click'*/ )
            :AddColumnDef( nField ):width := '30px'

            :ajax := { "cgi" => "GetDataGrpMasterVerbasFuncionarios" }

         END

         AAdd( :aScript,fixedColumns( :cID,oCGI:GetUserData( __CODMODEL__+":fixedColumns","6" ) ) )

         :Create()

      END

      oCgi:SendPage( :Create() )

   END

RETURN

//------------------------------------------------------------------------------

FUNCTION GetDataGrpMasterVerbasFuncionarios( lSendJSON,lGetFull,cSearchFilter )

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
     GetDataFieldsGrpMasterVerbasFuncionarios()
      xJSONData := Extraer( codModel,nStart,nLimit,nDraw,cSearchFilter,aOrder,lSendJSON,.F. )
   ENDIF

RETURN( if( lSendJSON,oCGI:SendJson(xJSONData ),xJSONData ) )

FUNCTION GetDataFieldsGrpMasterVerbasFuncionarios( cColsPrint )

   LOCAL aFields
   LOCAL aFieldsADD := Array( 0 )
   LOCAL aDataGrupo
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
   LOCAL codCentroDeCusto

   LOCAL hFilter

   LOCAL xData

   AppData:cEmp := oCGI:GetUserData( "cEmp",AppData:cEmp )
   hb_default( AppData:cEmp,"" )
   cFile := ( AppData:PathData + AppData:cEmp + "_" + Lower( ProcName(1 ) ) + ".json" )

   hFilter:={=>}
   restoreTmpParameters("__GrpMasterVerbasFuncionarios",@hFilter,.T.)

   codGrupo := oCGI:GetUserData( "__GrpMasterVerbasFuncionarios:codGrupo" )
   codFilial := oCGI:GetUserData( "__GrpMasterVerbasFuncionarios:codFilial" )
   codPeriodo := oCGI:GetUserData( "__GrpMasterVerbasFuncionarios:codPeriodo" )
   codCentroDeCusto := oCGI:GetUserData( "__GrpMasterVerbasFuncionarios:codCentroDeCusto" )

   hb_default( @cFilter,"" )

   IF ( !Empty( codFilial ) )
      hFilter[ "codFilial" ] := codFilial
      IF ( !Empty( cFilter ) )
         cFilter += " AND "
      ENDIF
      cFilter += "RD_FILIAL='" + codFilial + "'"
   ELSE
     IF (HB_HHasKey(hFilter,"codFilial"))
         HB_HDel(hFilter,"codFilial")
      ENDIF
    ENDIF

   IF ( !Empty( codPeriodo ) )
      hFilter[ "codPeriodo" ] := codPeriodo
      IF ( !Empty( cFilter ) )
         cFilter += " AND "
      ENDIF
      cFilter += "RD_DATARQ='" + codPeriodo + "'"
   ELSE
      IF (HB_HHasKey(hFilter,"codPeriodo"))
         HB_HDel(hFilter,"codPeriodo")
      ENDIF
   ENDIF

   IF ( !Empty( codCentroDeCusto ) )
      hFilter[ "codCentroDeCusto" ] := codCentroDeCusto
      IF ( !Empty( cFilter ) )
         cFilter += " AND "
      ENDIF
      cFilter += "RD_CC='" + codCentroDeCusto + "'"
   ELSE
      IF (HB_HHasKey(hFilter,"codCentroDeCusto"))
         HB_HDel(hFilter,"codCentroDeCusto")
      ENDIF
   ENDIF

   IF ( !Empty( codGrupo ) )
      hFilter[ "codGrupo" ] := codGrupo
   ELSE
      IF (HB_HHasKey(hFilter,"codGrupo"))
         HB_HDel(hFilter,"codGrupo")
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

PROCEDURE __clearGrpMasterVerbasFuncionarios()

   oCGI:SetUserData( "__GrpMasterVerbasFuncionarios:codGrupo","" )
   oCGI:SetUserData( "__GrpMasterVerbasFuncionarios:codFilial","" )
   oCGI:SetUserData( "__GrpMasterVerbasFuncionarios:codPeriodo","" )
   oCGI:SetUserData( "__GrpMasterVerbasFuncionarios:codCentroDeCusto","" )

   oCGI:SetUserData( "GrpMasterVerbasFuncionarios:Back","ParametersGrpMasterVerbasFuncionarios" )
   oCGI:SetUserData("GrpVerbasFuncionarios:Back","GrpVerbasFuncionarios" )

   deleteTmpParameters("__GrpMasterVerbasFuncionarios")

RETURN
