// Proyecto: GEP
/*
 * Fichero: GrpMasterVerbasAcumuladosEmpresa.prg
 * Descripción:
 * Autor:
 * Fecha: 14/08/2021
 */

#include "Xailer.ch"
#include "Nefele.ch"
#include "LangCGI.ch"

#define __CODMODEL__ "GRPMASTERVERBASACMEMP"

PROCEDURE ParametersGrpMasterVerbasAcumuladosEmpresa( lGrpViewTotais )

   LOCAL hUser := LoginUser()

   LOCAL cSubTitle:=" :: "+"Consulta Dados Acumulados Por Empresa/Grupo de Verbas"
   LOCAL cTitle := AppData:AppTitle+cSubTitle
   LOCAL cIDParameters
   LOCAL aParameters

   hb_default( @lGrpViewTotais,.F. )
   oCGI:SetUserData( "__GrpMasterVerbasAcumuladosEmpresa:lGrpViewTotais",lGrpViewTotais )

   oCGI:SetUserData( "GrpMasterVerbasAcumuladosEmpresa:Back",ProcName() )

   WITH OBJECT wTWebPage():New()

      :cTitle := cTitle

      AppMenu(:WO,AppData:AppName ,hUser,.F. )

      aParameters := { "codPeriodo","codPeriodoAte","codGrupo" }
      cSubTitle:=AppData:AppName+cSubTitle
      GEPParameters( :WO,@cIDParameters,"__GrpMasterVerbasAcumuladosEmpresa",aParameters,.T.,cSubTitle,.T. ):Create()

      :lValign    := .F.
      :lContainer := .F.

      oCgi:SendPage( :Create() )

   END

RETURN

function __GrpMasterVerbasAcumuladosEmpresa(lExecute,hFilter,nMaxRowspPage)

   local cIDModal

   local codGrupo
   local codPeriodo
   local codPeriodoAte

   local hIDModal

   local lFilter

   HB_Default(@lExecute,.T.)
   lFilter:=(HB_IsHash(hFilter).AND.!Empty(hFilter))
   HB_Default(@hFilter,{=>})

   IF (lExecute)
      cIDModal:=oCGI:GetCgiValue("cIDModalTotaisGrpMasterVerbasAcumuladosEmpresa","")
      IF (!Empty(cIDModal))
         oCGI:SetUserData("HistoryRemoveParams",.F.)
         cIDModal:=__base64Decode(cIDModal)
         HB_JsonDecode(cIDModal,@hIDModal)
         saveTmpParameters("__GrpMasterVerbasAcumuladosEmpresa",hIDModal)
         IF (HB_HHasKey(hIDModal,"codGrupo"))
            codGrupo:=hIDModal["codGrupo"]
         endif
         IF (HB_HHasKey(hIDModal,"codPeriodo"))
            codPeriodo:=hIDModal["codPeriodo"]
         ENDIF
         IF (HB_HHasKey(hIDModal,"codPeriodoAte"))
            codPeriodoAte:=hIDModal["codPeriodoAte"]
         ENDIF
      ELSE
         IF (HB_HHasKey(hFilter,"codGrupo"))
            codGrupo:=hFilter["codGrupo"]
            oCGI:SetUserData("__GrpMasterVerbasAcumuladosEmpresa:codGrupo",codGrupo)
         ELSE
            codGrupo:=oCGI:GetCgiValue("codGrupo","")
         ENDIF
         IF (HB_HHasKey(hFilter,"codPeriodo"))
            codPeriodo:=hFilter["codPeriodo"]
            oCGI:SetUserData("__GrpMasterVerbasAcumuladosEmpresa:codPeriodo",codPeriodo)
         ELSE
            codPeriodo:=oCGI:GetCgiValue("codPeriodo","")
         ENDIF
         IF (HB_HHasKey(hFilter,"codPeriodoAte"))
            codPeriodoAte:=hFilter["codPeriodoAte"]
            oCGI:SetUserData("__GrpMasterVerbasAcumuladosEmpresa:codPeriodoAte",codPeriodoAte)
         ELSE
            codPeriodoAte:=oCGI:GetCgiValue("codPeriodoAte","")
         ENDIF
      endif
   else
        IF (HB_HHasKey(hFilter,"codGrupo"))
            codGrupo:=hFilter["codGrupo"]
            oCGI:SetUserData("__GrpMasterVerbasAcumuladosEmpresa:codGrupo",codGrupo)
         ELSE
            codGrupo:=oCGI:GetCgiValue("codGrupo","")
         ENDIF
         IF (HB_HHasKey(hFilter,"codPeriodo"))
            codPeriodo:=hFilter["codPeriodo"]
            oCGI:SetUserData("__GrpMasterVerbasAcumuladosEmpresa:codPeriodo",codPeriodo)
         ELSE
            codPeriodo:=oCGI:GetCgiValue("codPeriodo","")
         ENDIF
         IF (HB_HHasKey(hFilter,"codPeriodoAte"))
            codPeriodoAte:=hFilter["codPeriodoAte"]
            oCGI:SetUserData("__GrpMasterVerbasAcumuladosEmpresa:codPeriodoAte",codPeriodoAte)
         ELSE
            codPeriodoAte:=oCGI:GetCgiValue("codPeriodoAte","")
         ENDIF
    endif

   if ((!lFilter).and.Empty(cIDModal))

       if (Empty(codGrupo))
          codGrupo:=oCGI:GetCgiValue("GEPParameters_codGrupo","")
          if (Empty(codGrupo))
             codGrupo:=oCGI:GetUserData("__GEPParameters:codGrupo",codGrupo)
          endif
       endif

       if (Empty(codPeriodo))
          codPeriodo:=oCGI:GetCgiValue("GEPParameters_codPeriodo","")
          if (Empty(codPeriodo))
             codPeriodo:=oCGI:GetUserData("__GEPParameters:codPeriodo",codPeriodo)
          endif
       endif

       if (Empty(codPeriodoAte))
          codPeriodoAte:=oCGI:GetCgiValue("GEPParameters_codPeriodoAte","")
          if (Empty(codPeriodoAte))
             codPeriodoAte:=oCGI:GetUserData("__GEPParameters:codPeriodoAte",codPeriodoAte)
          endif
       endif

    endif

   hFilter["codGrupo"]:=codGrupo
   oCGI:SetUserData("__GrpMasterVerbasAcumuladosEmpresa:codGrupo",codGrupo)

   hFilter["codPeriodo"]:=codPeriodo
   oCGI:SetUserData("__GrpMasterVerbasAcumuladosEmpresa:codPeriodo",codPeriodo)

   hFilter["codPeriodoAte"]:=codPeriodoAte
   oCGI:SetUserData("__GrpMasterVerbasAcumuladosEmpresa:codPeriodoAte",codPeriodoAte)

   if (lExecute)
      oCGI:SetUserData( "lGrupoHasSuper", .T. )
      saveTmpParameters("__GrpMasterVerbasAcumuladosFilial",HB_HDel(hFilter,"codGrupo"))
      __GrpMasterVerbasAcumuladosFilial(.F.,HB_HDel(hFilter,"codGrupo"))
      oCGI:SetUserData("GrpMasterVerbasAcumuladosFilial:Back",ProcName())
      GrpMasterVerbasAcumuladosEmpresa(nMaxRowspPage)
   endif

   RETURN(hFilter)

PROCEDURE GrpMasterVerbasAcumuladosEmpresa(nMaxRowspPage)

   LOCAL hUser := LoginUser()

   LOCAL cSubTitle:=" :: "+"Consulta Dados Acumulados Por Empresa/Grupo de Verbas"
   LOCAL cTitle := AppData:AppTitle+cSubTitle
   LOCAL cColsPrint
   LOCAL cIDParameters
   LOCAL aParameters

   LOCAL nField
   LOCAL aFields
   LOCAL nFields
   LOCAL nRowspPageMax

   local cJS

   local lGrpViewTotais:=oCGI:GetUserData("lGrpViewTotais",.F.,oCGI:GetUserData("HistoryRemoveParams",.F.))

   local cTmp

   local hFilter

   local oTWebPage
   local owDatatable

   LOCAL codPeriodo
   LOCAL codPeriodoAte

   IF ( !stackTools():IsInCallStack( "__GrpMasterVerbasAcumuladosEmpresa" ) )
      hFilter:=__GrpMasterVerbasAcumuladosEmpresa( .F. )
   ENDIF

   WITH OBJECT oTWebPage:=wTWebPage():New()

      :cTitle := cTitle

      AppMenu(oTWebPage,AppData:AppName ,hUser,.F. )

      WITH OBJECT WFloatingBtn():New( oTWebPage )
         :cClrPane:="#005FAB"
         :cName := ( "WFloatingBtn" + ProcName() )
         :cId := Lower( :cName )
         :cText := "Voltar"
         :oIcon:cIcon := "arrow_back"
         :oIcon:cClrIcon := "#FED300"
         :cOnClick := oCGI:GetUserData( ProcName() + ":Back","MAINFUNCTION" )
         :Create()
      END WITH

      codPeriodo := oCGI:GetUserData( "__GrpMasterVerbasAcumuladosEmpresa:codPeriodo" )
      codPeriodoAte := oCGI:GetUserData( "__GrpMasterVerbasAcumuladosEmpresa:codPeriodoAte" )

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

         aParameters := { "codPeriodo","codPeriodoAte","codGrupo" }
         cSubTitle:=AppData:AppName+cSubTitle
         GEPParameters(oTWebPage,@cIDParameters,"__GrpMasterVerbasAcumuladosEmpresa",aParameters,.F.,cSubTitle ):Create()

         :lValign    := .F.
         :lContainer := .F.

         aFields := GetDataFieldsGrpMasterVerbasAcumuladosEmpresa( @cColsPrint )
         nRowspPageMax := oCGI:GetUserData(__CODMODEL__+":RowspPageMax",10)
         HB_Default(@nMaxRowspPage,nRowspPageMax)

         WITH OBJECT owDatatable:=wDatatable():New(oTWebPage)

            :cId := Lower("browseGrpMasterVerbasAcumuladosEmpresa")

            DataTableCSS( :cID )

            :cCSS += AppData:CSSDataTable

            // Botones Datatable
            WITH OBject :AddButton( "Exportar" )
               :cCustom := "{extend: 'collection',text: 'Exportar',buttons: [ 'csv',{extend: 'excel',autoFilter: true,exportOptions: {columns: " + cColsPrint + "}},{extend: 'pdf',exportOptions: {columns: " + cColsPrint + "}} ]}"
            END WITH

            :AddButton( "{extend: 'print',text: 'Imprimir',exportOptions: {columns: " + cColsPrint + "}}" )

           if (!lGrpViewTotais)
               WITH OBject :AddButton("Parâmetros")
                  :cAction := nfl_OpenModal(cIDParameters,.T.)
               END WITH
            else
               cJS:=tableBtnTotalAction(:cID)
               WITH OBject :AddButton("Totais")
                  :cAction:=cJS
               END WITH
               :cInMain:="<script>"+cJS+"</script>"
               if (lGrpViewTotais)
                  hFilter:=__GrpMasterVerbasAcumuladosEmpresa(.F.,hFilter)
   *               __TotaisGrpMasterVerbasAcumuladosEmpresa(owDatatable,.F.,.F.)
                  __GrpMasterVerbasAcumuladosEmpresa(.F.,hFilter)
               endif
            endif

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
               :AddColumnButton( "loupe",cTmp,"btn-wDatatable ;","__GrpMasterVerbasAcumuladosFilialDet","dt-center","",/*,'fn_click'*/ )
               :AddColumnDef( nField ):width := '30px'

               :ajax := { "cgi" => "GetDataGrpMasterVerbasAcumuladosEmpresa" }

            END

   *         AAdd( :aScript,fixedColumns( :cID,oCGI:GetUserData( __CODMODEL__+":fixedColumns","0" ) ) )

            :Create()

         END

      ENDIF

      oCgi:SendPage( :Create() )

   END

RETURN

//------------------------------------------------------------------------------

FUNCTION GetDataGrpMasterVerbasAcumuladosEmpresa( lSendJSON,lGetFull,cSearchFilter )

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
      GetDataFieldsGrpMasterVerbasAcumuladosEmpresa()
      xJSONData := Extraer( codModel,nStart,nLimit,nDraw,cSearchFilter,aOrder,lSendJSON,.F. )
   ENDIF

RETURN( if( lSendJSON,oCGI:SendJson(xJSONData ),xJSONData ) )

FUNCTION GetDataFieldsGrpMasterVerbasAcumuladosEmpresa( cColsPrint )

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

   hFilter:={=>}
   restoreTmpParameters("__GrpMasterVerbasAcumuladosEmpresa",@hFilter,.T.)

   codPeriodo:=oCGI:GetUserData("__GrpMasterVerbasAcumuladosEmpresa:codPeriodo","")
   codPeriodoAte:=oCGI:GetUserData("__GrpMasterVerbasAcumuladosEmpresa:codPeriodoAte","")

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
STATIC FUNCTION Extraer( codModel,nPage,nRecords,nDraw,cSearchFilter,aOrder,lSendJSON,lGetFields )

   LOCAL cFile
   LOCAL cFilter
   LOCAL cParModel
   LOCAL cGrpFiles

   LOCAL codGrupo
   LOCAL codPeriodo
   LOCAL codPeriodoAte

   LOCAL hFilter

   LOCAL xData

   AppData:cEmp := oCGI:GetUserData( "cEmp",AppData:cEmp )
   hb_default( AppData:cEmp,"" )
   cFile := ( AppData:PathData + AppData:cEmp + "_" + Lower( ProcName(1 ) ) + ".json" )

   hFilter:={=>}
   restoreTmpParameters("__GrpMasterVerbasAcumuladosEmpresa",@hFilter,.T.)

   codGrupo := oCGI:GetUserData( "__GrpMasterVerbasAcumuladosEmpresa:codGrupo" )
   codPeriodo := oCGI:GetUserData( "__GrpMasterVerbasAcumuladosEmpresa:codPeriodo" )
   codPeriodoAte := oCGI:GetUserData( "__GrpMasterVerbasAcumuladosEmpresa:codPeriodoAte" )


   hb_default( @cFilter,"" )

   IF (!Empty(codPeriodo))
      hFilter[ "codPeriodo" ] := codPeriodo
   ENDIF

   IF (!Empty(codPeriodoAte))
      hFilter[ "codPeriodoAte" ] := codPeriodoAte
   ENDIF

   IF (!Empty(codGrupo))
      hFilter["codGrupo"]:=codGrupo
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
      cGrpFiles += Left( codPeriodo, 4 )
   ENDIF

   xData := GetDataModel( codModel,nPage,nRecords,nDraw,cFilter,aOrder,lSendJSON,lGetFields,cFile,cParModel,.F.,cGrpFiles )

   IF ( !Empty( hFilter ) )
      hb_default( @lGetFields,.F. )
      IF ( !lGetFields )
         xData := rebuildDataModel( xData,hFilter,lSendJSON,aOrder )
      ENDIF
   ENDIF

RETURN( xData )

PROCEDURE __clearGrpMasterVerbasAcumuladosEmpresa()

   oCGI:SetUserData( "__GrpMasterVerbasAcumuladosEmpresa:codGrupo","" )
   oCGI:SetUserData( "__GrpMasterVerbasAcumuladosEmpresa:codPeriodo","" )
   oCGI:SetUserData( "__GrpMasterVerbasAcumuladosEmpresa:codPeriodoAte","" )

   oCGI:SetUserData("GrpMasterVerbasAcumuladosEmpresa:Back:lGrpViewTotais",.F.)

   oCGI:SetUserData( "GrpMasterVerbasAcumuladosEmpresa:Back","ParametersGrpMasterVerbasAcumuladosEmpresa" )
   oCGI:SetUserData( "GrpMasterVerbasAcumuladosFilial:Back","ParametersGrpMasterVerbasAcumuladosFilial" )

   deleteTmpParameters("__GrpMasterVerbasAcumuladosEmpresa")

RETURN