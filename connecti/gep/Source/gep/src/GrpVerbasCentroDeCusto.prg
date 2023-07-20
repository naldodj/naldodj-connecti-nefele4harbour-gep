 * Proyecto: GEP
/*
 * Fichero: GrpVerbasCentroDeCusto.prg
 * Descripción:
 * Autor:
 * Fecha: 14/08/2021
 */

#include "Xailer.ch"
#include "Nefele.ch"
#include "LangCGI.ch"

#define __CODMODEL__ "GRPVERBASCC"

function __GrpVerbasCentroDeCusto(lExecute,hFilter,nMaxRowspPage)

   local cIDModal

   local codGrupo
   local codFilial
   local codPeriodo
   local codCentroDeCusto
   local codGrupoSuperior

   local hIDModal

   local lFilter

   HB_Default(@lExecute,.T.)
   lFilter:=(HB_IsHash(hFilter).AND.!Empty(hFilter))
   HB_Default(@hFilter,{=>})

   IF (lExecute)
      cIDModal:=oCGI:GetCgiValue("cIDModalTotaisGrpVerbasCentroDeCusto","")
      IF (!Empty(cIDModal))
         oCGI:SetUserData("HistoryRemoveParams",.F.)
         cIDModal:=__base64Decode(cIDModal)
         HB_JsonDecode(cIDModal,@hIDModal)
         saveTmpParameters("__GrpVerbasCentroDeCusto",hIDModal)
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
         IF (HB_HHasKey(hIDModal,"codGrupoSuperior"))
            codGrupoSuperior:=hIDModal["codGrupoSuperior"]
         ENDIF
      ELSE
         IF (HB_HHasKey(hFilter,"codGrupo"))
            codGrupo:=hFilter["codGrupo"]
            oCGI:SetUserData("__GrpVerbasCentroDeCusto:codGrupo",codGrupo)
         ELSE
            codGrupo:=oCGI:GetCgiValue("codGrupo","")
         ENDIF
         IF (HB_HHasKey(hFilter,"codFilial"))
            codFilial:=hFilter["codFilial"]
            oCGI:SetUserData("__GrpVerbasCentroDeCusto:codFilial",codFilial)
         ELSE
            codFilial:=oCGI:GetCgiValue("codFilial","")
         ENDIF
         IF (HB_HHasKey(hFilter,"codPeriodo"))
            codPeriodo:=hFilter["codPeriodo"]
            oCGI:SetUserData("__GrpVerbasCentroDeCusto:codPeriodo",codPeriodo)
         ELSE
            codPeriodo:=oCGI:GetCgiValue("codPeriodo","")
         ENDIF
         IF (HB_HHasKey(hFilter,"codCentroDeCusto"))
            codCentroDeCusto:=hFilter["codCentroDeCusto"]
            oCGI:SetUserData("__GrpVerbasCentroDeCusto:codCentroDeCusto",codCentroDeCusto)
         ELSE
            codCentroDeCusto:=oCGI:GetCgiValue("codCentroDeCusto","")
         ENDIF
         IF (HB_HHasKey(hFilter,"codGrupoSuperior"))
            codGrupoSuperior:=hFilter["codGrupoSuperior"]
            oCGI:SetUserData("__GrpVerbasCentroDeCusto:codGrupoSuperior",codGrupoSuperior)
         ELSE
            codGrupoSuperior:=oCGI:GetCgiValue("codGrupoSuperior","")
         ENDIF
      endif
   else
        IF (HB_HHasKey(hFilter,"codGrupo"))
            codGrupo:=hFilter["codGrupo"]
            oCGI:SetUserData("__GrpVerbasCentroDeCusto:codGrupo",codGrupo)
         ELSE
            codGrupo:=oCGI:GetCgiValue("codGrupo","")
         ENDIF
         IF (HB_HHasKey(hFilter,"codFilial"))
            codFilial:=hFilter["codFilial"]
            oCGI:SetUserData("__GrpVerbasCentroDeCusto:codFilial",codFilial)
         ELSE
            codFilial:=oCGI:GetCgiValue("codFilial","")
         ENDIF
         IF (HB_HHasKey(hFilter,"codPeriodo"))
            codPeriodo:=hFilter["codPeriodo"]
            oCGI:SetUserData("__GrpVerbasCentroDeCusto:codPeriodo",codPeriodo)
         ELSE
            codPeriodo:=oCGI:GetCgiValue("codPeriodo","")
         ENDIF
         IF (HB_HHasKey(hFilter,"codCentroDeCusto"))
            codCentroDeCusto:=hFilter["codCentroDeCusto"]
            oCGI:SetUserData("__GrpVerbasCentroDeCusto:codCentroDeCusto",codCentroDeCusto)
         ELSE
            codCentroDeCusto:=oCGI:GetCgiValue("codCentroDeCusto","")
         ENDIF
         IF (HB_HHasKey(hFilter,"codGrupoSuperior"))
            codGrupoSuperior:=hFilter["codGrupoSuperior"]
            oCGI:SetUserData("__GrpVerbasCentroDeCusto:codGrupoSuperior",codGrupoSuperior)
         ELSE
            codGrupoSuperior:=oCGI:GetCgiValue("codGrupoSuperior","")
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

       if (Empty(codGrupoSuperior))
          codGrupoSuperior:=oCGI:GetCgiValue("GEPParameters_codGrupoSuperior","")
          if (Empty(codGrupoSuperior))
             codGrupoSuperior:=oCGI:GetUserData("__GEPParameters:codGrupoSuperior",codGrupoSuperior)
          endif
       endif

    endif

   IF (oCGI:GetUserData("lGrupoHasSuper",.F.))
      hFilter["codGrupo"]:=""
      oCGI:SetUserData("__GrpVerbasCentroDeCusto:codGrupo","")
      hFilter["codGrupoSuperior"]:=codGrupo
      oCGI:SetUserData("__GrpVerbasCentroDeCusto:codGrupoSuperior",codGrupo)
   ELSE
      hFilter["codGrupo"]:=codGrupo
      oCGI:SetUserData("__GrpVerbasCentroDeCusto:codGrupo",codGrupo)
      hFilter["codGrupoSuperior"]:=codGrupoSuperior
      oCGI:SetUserData("__GrpVerbasCentroDeCusto:codGrupoSuperior",codGrupoSuperior)
   ENDIF

   hFilter["codFilial"]:=codFilial
   oCGI:SetUserData("__GrpVerbasCentroDeCusto:codFilial",codFilial)

   hFilter["codPeriodo"]:=codPeriodo
   oCGI:SetUserData("__GrpVerbasCentroDeCusto:codPeriodo",codPeriodo)

   hFilter["codCentroDeCusto"]:=codCentroDeCusto
   oCGI:SetUserData("__GrpVerbasCentroDeCusto:codCentroDeCusto",codCentroDeCusto)

   if (lExecute)
      oCGI:SetUserData("GrpVerbasVerbas:Back",ProcName())
      GrpVerbasCentroDeCusto(nMaxRowspPage)
   endif

   RETURN(hFilter)

PROCEDURE GrpVerbasCentroDeCusto(nMaxRowspPage)

   local hUser := LoginUser()

   local cSubTitle:=" :: "+"Consulta Dados Por Centro de Custo/Sub-Grupo de Verbas"
   local cTitle:=AppData:AppTitle+cSubTitle
   local cColsPrint

   local cIDParameters
   local aParameters

   local nField
   local aFields
   local nFields

   local nRowspPageMax

   local cTmp

   local cJS

   local lGrpViewTotais:=oCGI:GetUserData("lGrpViewTotais",.F.)

   local oTWebPage
   local owDatatable

   local hFilter

   if (!stackTools():IsInCallStack("__GrpVerbasCentroDeCusto"))
      hFilter:=__GrpVerbasCentroDeCusto(.F.)
   endif

   WITH OBJECT oTWebPage:=wTWebPage():New()

      :cTitle:= cTitle

      AppMenu(oTWebPage,AppData:AppName,hUser,.F.)

      WITH OBJECT WFloatingBtn():New(oTWebPage)
         :cClrPane:="#005FAB"
         :cName:=("WFloatingBtn"+ProcName())
         :cId:=Lower(:cName)
         :cText:="Voltar"
         :oIcon:cIcon:="arrow_back"
         :oIcon:cClrIcon := "#FED300"
         :cOnClick:=oCGI:GetUserData(ProcName()+":Back","MAINFUNCTION")
         :Create()
      END WITH

      if (!lGrpViewTotais)
         aParameters:={"codFilial","codPeriodo","codGrupo","codCentroDeCusto"}
         cSubTitle:=AppData:AppName+cSubTitle
         GEPParameters(oTWebPage,@cIDParameters,"__GrpVerbasCentroDeCusto",aParameters,.F.,cSubTitle):Create()
      endif

      :lValign    := .F.
      :lContainer := .F.

      aFields:=GetDataFieldsGrpVerbasCentroDeCusto(@cColsPrint)
      nRowspPageMax:=oCGI:GetUserData(__CODMODEL__+":RowspPageMax",10)
      HB_Default(@nMaxRowspPage,nRowspPageMax)

      WITH OBJECT owDatatable:=wDatatable():New(oTWebPage)

         :cId:=Lower("browsegrpverbascentrodecusto")

         DataTableCSS(:cID)

         :cCSS+=AppData:CSSDataTable

        // Botones Datatable
         WITH OBject :AddButton("Exportar")
            :cCustom := "{extend: 'collection',text: 'Exportar',buttons: [ 'csv',{extend: 'excel',autoFilter: true,exportOptions: {columns: "+cColsPrint+"}},{extend: 'pdf',exportOptions: {columns: "+cColsPrint+"}} ]}"
         END WITH

         :AddButton("{extend: 'print',text: 'Imprimir',exportOptions: {columns: "+cColsPrint+"}}")

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
                hFilter:=__GrpVerbasCentroDeCusto(.F.,hFilter)
               __TotaisGrpVerbasCentroDeCusto(owDatatable,.F.,.F.)
               __GrpVerbasCentroDeCusto(.F.,hFilter)
            endif
         endif

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
            :AddColumnButton("loupe",cTmp,"btn-wDatatable ;","__GrpVerbasVerbasDet","dt-center","",/*,'fn_click'*/)
            :AddColumnDef( nField ):width := '30px'

            :ajax := { "cgi" => "GetDataGRPVerbasCentroDeCusto" }

         END

         :Create()

      END

      oCgi:SendPage( :Create() )

   END

RETURN

//------------------------------------------------------------------------------

FUNCTION GetDataGRPVerbasCentroDeCusto(lSendJSON,lGetFull,cSearchFilter)

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
      GetDataFieldsGrpVerbasCentroDeCusto()
      xJSONData:=Extraer(codModel,nStart,nLimit,nDraw,cSearchFilter,aOrder,lSendJSON,.F.)
   endif

RETURN(if(lSendJSON,oCGI:SendJson(xJSONData),xJSONData))

function GetDataFieldsGrpVerbasCentroDeCusto(cColsPrint)
   local aFields
   local codModel:=__CODMODEL__
   local bFunction:={||Extraer(codModel,1,1,1,"",{},.F.,.T.)}
   aFields:=GetDataFields(codModel,bFunction,@cColsPrint)
   return(aFields)

//-------------------------------------------
// Recuperamos los datos
STATIC FUNCTION Extraer(codModel,nPage,nRecords,nDraw,cSearchFilter,aOrder,lSendJSON,lGetFields)

   local cFile
   local cFilter
   local cParModel
   local cGrpFiles

   local codGrupo
   local codFilial
   local codPeriodo
   local codCentroDeCusto
   local codGrupoSuperior

   local hFilter

   local xData

   AppData:cEmp:=oCGI:GetUserData("cEmp",AppData:cEmp)
   HB_Default(AppData:cEmp,"")
   cFile:=(AppData:PathData+AppData:cEmp+"_"+Lower(ProcName(1))+".json")

   hFilter:={=>}
   restoreTmpParameters("__GrpVerbasCentroDeCusto",@hFilter,.T.)

   codGrupo:=oCGI:GetUserData("__GrpVerbasCentroDeCusto:codGrupo")
   codFilial:=oCGI:GetUserData("__GrpVerbasCentroDeCusto:codFilial")
   codPeriodo:=oCGI:GetUserData("__GrpVerbasCentroDeCusto:codPeriodo")
   codCentroDeCusto:=oCGI:GetUserData("__GrpVerbasCentroDeCusto:codCentroDeCusto")
   codGrupoSuperior:=oCGI:GetUserData("__GrpVerbasCentroDeCusto:codGrupoSuperior")

   HB_Default(@cFilter,"")

   IF (!Empty(codFilial))
      hFilter["codFilial"]:=codFilial
      IF (!Empty(cFilter))
         cFilter+=" AND "
      endif
      cFilter+="RA_FILIAL='"+codFilial+"'"
   ELSE
      IF (HB_HHasKey(hFilter,"codFilial"))
         HB_HDel(hFilter,"codFilial")
      ENDIF
   ENDIF

   IF (!Empty(codPeriodo))
      hFilter["codPeriodo"]:=codPeriodo
      if !Empty(cFilter)
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
      IF (!Empty(cFilter))
         cFilter+=" AND "
      endif
      cFilter+="ZY__CODIGO='"+codGrupo+"'"
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

   IF (!Empty(codGrupoSuperior   ))
      hFilter["codGrupoSuperior"]:=codGrupoSuperior
      IF (!Empty(cFilter))
         cFilter+=" AND "
      endif
      cFilter+="ZY__MASTER='"+codGrupoSuperior+"'"
   ELSE
      IF (HB_HHasKey(hFilter,"codGrupoSuperior"))
         HB_HDel(hFilter,"codGrupoSuperior")
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

procedure __clearGrpVerbasCentroDeCusto()

   oCGI:SetUserData("__GrpVerbasCentroDeCusto:codFilial","")
   oCGI:SetUserData("__GrpVerbasCentroDeCusto:codGrupo","")
   oCGI:SetUserData("__GrpVerbasCentroDeCusto:codPeriodo","")
   oCGI:SetUserData("__GrpVerbasCentroDeCusto:codCentroDeCusto","")
   oCGI:SetUserData("__GrpVerbasCentroDeCusto:codGrupoSuperior","")

   oCGI:SetUserData("GrpVerbasCentroDeCusto:Back:lGrpViewTotais",.F.)

   oCGI:SetUserData("GrpVerbasVerbas:Back","GrpVerbasVerbas")
   oCGI:SetUserData("GrpVerbasCentroDeCusto:Back","GrpVerbasCentroDeCusto")

   deleteTmpParameters("__GrpVerbasCentroDeCusto")
   deleteTmpParameters("__TotaisGrpVerbasCentroDeCusto")

   return
