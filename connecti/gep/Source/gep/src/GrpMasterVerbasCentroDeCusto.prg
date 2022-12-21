// Proyecto: GEP
/*
 * Fichero: GrpMasterVerbasCentroDeCusto.prg
 * Descripción:
 * Autor:
 * Fecha: 14/08/2021
 */

#include "Xailer.ch"
#include "Nefele.ch"
#include "LangCGI.ch"

#define __CODMODEL__ "GRPMASTERVERBASCC"

PROCEDURE ParametersGrpMasterVerbasCentroDeCusto(lGrpViewTotais)

   LOCAL hUser := LoginUser()

   LOCAL cSubTitle:=" :: "+"Consulta Dados Por Centro de Custo/Grupo de Verbas"
   LOCAL cTitle := AppData:AppTitle+cSubTitle
   LOCAL cIDParameters
   LOCAL aParameters

   hb_default(@lGrpViewTotais,.F.)
   oCGI:SetUserData("__GrpMasterVerbasCentroDeCusto:lGrpViewTotais",lGrpViewTotais)

   oCGI:SetUserData("GrpMasterVerbasCentroDeCusto:Back",ProcName())

   WITH OBJECT wTWebPage():New()

      :cTitle := cTitle

      AppMenu(:WO,AppData:AppName,hUser,.F.)

      aParameters := { "codPeriodo","codGrupo","codFilial","codCentroDeCusto" }
      cSubTitle:=AppData:AppName
      GEPParameters(:WO,@cIDParameters,"__GrpMasterVerbasCentroDeCusto",aParameters,.T.,cSubTitle,.T.):Create()

      :lValign    := .F.
      :lContainer := .F.

      oCgi:SendPage(:Create())

   END

RETURN

function __GrpMasterVerbasCentroDeCusto(lExecute,hFilter,nMaxRowspPage)

   local cIDModal

   local codGrupo
   local codFilial
   local codPeriodo
   local codCentroDeCusto

   local hIDModal

   local lFilter

   HB_Default(@lExecute,.T.)
   lFilter:=(HB_IsHash(hFilter).AND.!Empty(hFilter))
   HB_Default(@hFilter,{=>})

   IF (lExecute)
      cIDModal:=oCGI:GetCgiValue("cIDModalTotaisGrpMasterVerbasCentroDeCusto","")
      IF (!Empty(cIDModal))
         oCGI:SetUserData("HistoryRemoveParams",.F.)
         cIDModal:=__base64Decode(cIDModal)
         HB_JsonDecode(cIDModal,@hIDModal)
         saveTmpParameters("__GrpMasterVerbasCentroDeCusto",hIDModal)
         IF (HB_HHasKey(hIDModal,"codGrupo"))
            codGrupo:=hIDModal["codGrupo"]
         endif
         IF (HB_HHasKey(hIDModal,"codFilial"))
            codFilial:=hIDModal["codFilial"]
         ENDIF
         IF (HB_HHasKey(hIDModal,"codPeriodo"))
            codPeriodo:=hIDModal["codPeriodo"]
         ENDIF
         IF (HB_HHasKey(hIDModal,"codCentroDeCusto"))
            codCentroDeCusto:=hIDModal["codCentroDeCusto"]
         ENDIF
      ELSE
         IF (HB_HHasKey(hFilter,"codGrupo"))
            codGrupo:=hFilter["codGrupo"]
            oCGI:SetUserData("__GrpMasterVerbasCentroDeCusto:codGrupo",codGrupo)
         ELSE
            codGrupo:=oCGI:GetCgiValue("codGrupo","")
         ENDIF
         IF (HB_HHasKey(hFilter,"codFilial"))
            codFilial:=hFilter["codFilial"]
            oCGI:SetUserData("__GrpMasterVerbasCentroDeCusto:codFilial",codFilial)
         ELSE
            codFilial:=oCGI:GetCgiValue("codFilial","")
         ENDIF
         IF (HB_HHasKey(hFilter,"codPeriodo"))
            codPeriodo:=hFilter["codPeriodo"]
            oCGI:SetUserData("__GrpMasterVerbasCentroDeCusto:codPeriodo",codPeriodo)
         ELSE
            codPeriodo:=oCGI:GetCgiValue("codPeriodo","")
         ENDIF
         IF (HB_HHasKey(hFilter,"codCentroDeCusto"))
            codCentroDeCusto:=hFilter["codCentroDeCusto"]
            oCGI:SetUserData("__GrpMasterVerbasCentroDeCusto:codCentroDeCusto",codCentroDeCusto)
         ELSE
            codCentroDeCusto:=oCGI:GetCgiValue("codCentroDeCusto","")
         ENDIF
      endif
   else
        IF (HB_HHasKey(hFilter,"codGrupo"))
            codGrupo:=hFilter["codGrupo"]
            oCGI:SetUserData("__GrpMasterVerbasCentroDeCusto:codGrupo",codGrupo)
         ELSE
            codGrupo:=oCGI:GetCgiValue("codGrupo","")
         ENDIF
         IF (HB_HHasKey(hFilter,"codFilial"))
            codFilial:=hFilter["codFilial"]
            oCGI:SetUserData("__GrpMasterVerbasCentroDeCusto:codFilial",codFilial)
         ELSE
            codFilial:=oCGI:GetCgiValue("codFilial","")
         ENDIF
         IF (HB_HHasKey(hFilter,"codPeriodo"))
            codPeriodo:=hFilter["codPeriodo"]
            oCGI:SetUserData("__GrpMasterVerbasCentroDeCusto:codPeriodo",codPeriodo)
         ELSE
            codPeriodo:=oCGI:GetCgiValue("codPeriodo","")
         ENDIF
         IF (HB_HHasKey(hFilter,"codCentroDeCusto"))
            codCentroDeCusto:=hFilter["codCentroDeCusto"]
            oCGI:SetUserData("__GrpMasterVerbasCentroDeCusto:codCentroDeCusto",codCentroDeCusto)
         ELSE
            codCentroDeCusto:=oCGI:GetCgiValue("codCentroDeCusto","")
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

       if (Empty(codCentroDeCusto))
          codCentroDeCusto:=oCGI:GetCgiValue("GEPParameters_codCentroDeCusto","")
          if (Empty(codCentroDeCusto))
             codCentroDeCusto:=oCGI:GetUserData("__GEPParameters:codCentroDeCusto",codCentroDeCusto)
          endif
       endif

    endif

   hFilter["codGrupo"]:=codGrupo
   oCGI:SetUserData("__GrpMasterVerbasCentroDeCusto:codGrupo",codGrupo)

   hFilter["codFilial"]:=codFilial
   oCGI:SetUserData("__GrpMasterVerbasCentroDeCusto:codFilial",codFilial)

   hFilter["codPeriodo"]:=codPeriodo
   oCGI:SetUserData("__GrpMasterVerbasCentroDeCusto:codPeriodo",codPeriodo)

   hFilter["codCentroDeCusto"]:=codCentroDeCusto
   oCGI:SetUserData("__GrpMasterVerbasCentroDeCusto:codCentroDeCusto",codCentroDeCusto)

   if (lExecute)
      oCGI:SetUserData("GrpMasterVerbasFuncionarios:Back",ProcName())
      GrpMasterVerbasCentroDeCusto(nMaxRowspPage)
   endif

   RETURN(hFilter)

PROCEDURE GrpMasterVerbasCentroDeCusto(nMaxRowspPage)

   LOCAL hUser := LoginUser()

   LOCAL cSubTitle:=" :: "+"Consulta Dados Por Centro de Custo/Grupo de Verbas"
   LOCAL cTitle := AppData:AppTitle+cSubTitle
   LOCAL cColsPrint
   LOCAL cIDParameters
   LOCAL aParameters

   LOCAL nField
   LOCAL aFields
   LOCAL nFields
   LOCAL nRowspPageMax

   local cTmp

   local cJS

   local lGrpViewTotais:=oCGI:GetUserData("lGrpViewTotais",.F.)

   local oTWebPage
   local owDatatable

   local hFilter

   IF (!stackTools():IsInCallStack("__GrpMasterVerbasCentroDeCusto"))
      hFilter:=__GrpMasterVerbasCentroDeCusto(.F.)
   ENDIF

   WITH OBJECT oTWebPage:=wTWebPage():New()

      :cTitle := cTitle

      AppMenu(oTWebPage,AppData:AppName,hUser,.F.)

      WITH OBJECT WFloatingBtn():New(oTWebPage)
         :cClrPane:="#005FAB"
         :cName := ("WFloatingBtn" + ProcName())
         :cId := Lower(:cName)
         :cText := "Voltar"
         :oIcon:cIcon := "arrow_back"
         :oIcon:cClrIcon := "#FED300"
         :cOnClick := oCGI:GetUserData(ProcName() + ":Back","MAINFUNCTION")
         :Create()
      END WITH

      aParameters := { "codFilial","codPeriodo","codCentroDeCusto","codGrupo" }
      cSubTitle:=AppData:AppName+cSubTitle
      GEPParameters(oTWebPage,@cIDParameters,"__GrpMasterVerbasCentroDeCusto",aParameters,.F.,cSubTitle):Create()

      :lValign    := .F.
      :lContainer := .F.

      aFields := GetDataFieldsGrpMasterVerbasCentroDeCusto(@cColsPrint)
      nRowspPageMax := oCGI:GetUserData(__CODMODEL__+":RowspPageMax",10)
      HB_Default(@nMaxRowspPage,nRowspPageMax)

      WITH OBJECT owDatatable:=wDatatable():New(oTWebPage)

         :cId := Lower("browseGrpMasterVerbasCentroDeCusto")

         DataTableCSS(:cID)

         :cCSS += AppData:CSSDataTable

         // Botones Datatable
         WITH OBject :AddButton("Exportar")
            :cCustom := "{extend: 'collection',text: 'Exportar',buttons: [ 'csv',{extend: 'excel',autoFilter: true,exportOptions: {columns: " + cColsPrint + "}},{extend: 'pdf',exportOptions: {columns: " + cColsPrint + "}} ]}"
         END WITH

         :AddButton("{extend: 'print',text: 'Imprimir',exportOptions: {columns: " + cColsPrint + "}}")

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
                hFilter:=__GrpMasterVerbasCentroDeCusto(.F.,hFilter)
               __TotaisGrpMasterVerbasCentroDeCusto(owDatatable,.F.,.F.)
               __GrpMasterVerbasCentroDeCusto(.F.,hFilter)
            endif
         endi

         :cTitle  := cTitle + tableBtnReload(:cId)

         // Configurar opciones
         WITH OBJECT :Configure()
            :SetLanguage({ "Portugues","Spanish" }[ AppData:nLang ])
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
            nFields := Len(aFields)
            FOR nField := 1 TO nFields
               WITH OBJECT :AddColumn(aFields[ nField ][ 1 ])
                  :DATA       := aFields[ nField ][ 2 ]
                  :orderable  := aFields[ nField ][ 3 ]
                  :searchable := aFields[ nField ][ 4 ]
                  :className  := aFields[ nField ][ 5 ]
               END
            NEXT nField

            cTmp := { "Detalhes","Detalhes" }[ AppData:nLang ]
            :AddColumnButton("loupe",cTmp,"btn-wDatatable ;","__GrpMasterVerbasFuncionariosDet","dt-center","",/*,'fn_click'*/)
            :AddColumnDef(nField):width := '30px'

            :ajax := { "cgi" => "GetDataGrpMasterVerbasCentroDeCusto" }

         END

*         AAdd(:aScript,fixedColumns(:cID,oCGI:GetUserData(__CODMODEL__+":fixedColumns","0")))

         :Create()

      END

      oCgi:SendPage(:Create())

   END

RETURN

//------------------------------------------------------------------------------

FUNCTION GetDataGrpMasterVerbasCentroDeCusto(lSendJSON,lGetFull,cSearchFilter)

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

   hb_default(@lGetFull,.F.)

   IF (lGetFull)

      nStart := 1
      nLimit := -1

   ELSE

      hParams := oCGI:aParamsToHash(.T.)

      nStart := Val(hParams[ 'START' ])

      nLimit := Val(hParams[ 'LENGTH' ])

      nDraw := hParams[ 'DRAW' ]
      aOrder := { Val(hParams[ 'order[0][column]' ]) + 1,hParams[ 'order[0][dir]' ] } // datatables empieza en columna 0. segundo elemento asc o desc
      cSearchFilter := hParams[ 'SEARCH[VALUE]' ]
      oCGI:SetUserData("GetDataModel:cSearchFilter",cSearchFilter)

   ENDIF

   hb_default(@lSendJSON,.T.)

   IF (!nLimit == 0)
      GetDataFieldsGrpMasterVerbasCentroDeCusto()
      xJSONData := Extraer(codModel,nStart,nLimit,nDraw,cSearchFilter,aOrder,lSendJSON,.F.)
   ENDIF

RETURN(if(lSendJSON,oCGI:SendJson(xJSONData),xJSONData))

FUNCTION GetDataFieldsGrpMasterVerbasCentroDeCusto(cColsPrint)

   LOCAL aFields
   LOCAL aFieldsADD := Array(0)
   LOCAL aDataGrupo
   LOCAL codModel := __CODMODEL__
   LOCAL bFunction := {|| Extraer(codModel,1,1,1,"",{},.F.,.T.) }
   LOCAL cKey
   LOCAL hDataGrupo
   LOCAL nRow
   LOCAL nRows

   hDataGrupo := GetDataCadastroGrupos(.F.,.T.,"")
   aDataGrupo := hDataGrupo[ "data" ]

   nRows := Len(aDataGrupo)
   FOR nRow := 1 TO nRows
      AAdd(aFieldsADD,{ aDataGrupo[ nRow ][ "descGrupo" ],aDataGrupo[ nRow ][ "aliasGrupo" ],.F.,.F.,"dt-right",.T.,"@R 999,999,999.99" })
   NEXT nRow

   aFields := GetDataFields(codModel,bFunction,@cColsPrint,aFieldsADD)

   oCGI:SetUserData("GetDataModel:aFieldsADD",aFieldsADD)

return(aFields)

//-------------------------------------------
// Recuperamos los datos
STATIC FUNCTION Extraer(codModel,nPage,nRecords,nDraw,cSearchFilter,aOrder,lSendJSON,lGetFields)

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

   AppData:cEmp := oCGI:GetUserData("cEmp",AppData:cEmp)
   hb_default(AppData:cEmp,"")
   cFile := (AppData:RootPath + "data\" + AppData:cEmp + "_" + Lower(ProcName(1)) + ".json")

   hFilter:={=>}
   restoreTmpParameters("__GrpMasterVerbasCentroDeCusto",@hFilter,.T.)

   codGrupo := oCGI:GetUserData("__GrpMasterVerbasCentroDeCusto:codGrupo")
   codFilial := oCGI:GetUserData("__GrpMasterVerbasCentroDeCusto:codFilial")
   codPeriodo := oCGI:GetUserData("__GrpMasterVerbasCentroDeCusto:codPeriodo")
   codCentroDeCusto := oCGI:GetUserData("__GrpMasterVerbasCentroDeCusto:codCentroDeCusto")

   hb_default(@cFilter,"")

   IF (!Empty(codFilial))
      hFilter[ "codFilial" ] := codFilial
      IF (!Empty(cFilter))
         cFilter += " AND "
      ENDIF
      cFilter += "RD_FILIAL='" + codFilial + "'"
   ELSE
      IF (HB_HHasKey(hFilter,"codFilial"))
         HB_HDel(hFilter,"codFilial")
      ENDIF
   ENDIF

   IF (!Empty(codPeriodo))
      hFilter[ "codPeriodo" ] := codPeriodo
      IF (!Empty(cFilter))
         cFilter += " AND "
      ENDIF
      cFilter += "RD_DATARQ='" + codPeriodo + "'"
   ELSE
      IF (HB_HHasKey(hFilter,"codPeriodo"))
         HB_HDel(hFilter,"codPeriodo")
      ENDIF
   ENDIF

   IF (!Empty(codCentroDeCusto))
      hFilter[ "codCentroDeCusto" ] := codCentroDeCusto
      IF (!Empty(cFilter))
         cFilter += " AND "
      ENDIF
      cFilter += "RD_CC='" + codCentroDeCusto + "'"
   ELSE
      IF (HB_HHasKey(hFilter,"codCentroDeCusto"))
         HB_HDel(hFilter,"codCentroDeCusto")
      ENDIF
   ENDIF

   IF (!Empty(codGrupo))
      hFilter[ "codGrupo" ] := codGrupo
   ELSE
      IF (HB_HHasKey(hFilter,"codGrupo"))
         HB_HDel(hFilter,"codGrupo")
      ENDIF
   ENDIF

   cParModel:=setParModel(hFilter)

   IF (!Empty(cFilter))
      cFilter := "SQL:" + cFilter
   ELSE
      cFilter := cSearchFilter
   ENDIF

   cGrpFiles := codModel
   IF (!Empty(codPeriodo))
      cGrpFiles += "_"
      cGrpFiles += codPeriodo
   ENDIF

   xData := GetDataModel(codModel,nPage,nRecords,nDraw,cFilter,aOrder,lSendJSON,lGetFields,cFile,cParModel,.F.,cGrpFiles)

   IF (!Empty(hFilter))
      hb_default(@lGetFields,.F.)
      IF (!lGetFields)
         xData := rebuildDataModel(xData,hFilter,lSendJSON,aOrder)
      ENDIF
   ENDIF

RETURN(xData)

PROCEDURE __clearGrpMasterVerbasCentroDeCusto()

   oCGI:SetUserData("__GrpMasterVerbasCentroDeCusto:codGrupo","")
   oCGI:SetUserData("__GrpMasterVerbasCentroDeCusto:codFilial","")
   oCGI:SetUserData("__GrpMasterVerbasCentroDeCusto:codPeriodo","")
   oCGI:SetUserData("__GrpMasterVerbasCentroDeCusto:codCentroDeCusto","")

   oCGI:SetUserData("GrpMasterVerbasCentroDeCusto:Back:lGrpViewTotais",.F.)

   oCGI:SetUserData("GrpMasterVerbasCentroDeCusto:Back","ParametersGrpMasterVerbasCentroDeCusto")
   oCGI:SetUserData("GrpMasterVerbasFuncionarios:Back","ParametersGrpMasterVerbasFuncionarios")

   deleteTmpParameters("__GrpMasterVerbasCentroDeCusto")
   deleteTmpParameters("__TotaisGrpMasterVerbasCentroDeCusto")

RETURN
