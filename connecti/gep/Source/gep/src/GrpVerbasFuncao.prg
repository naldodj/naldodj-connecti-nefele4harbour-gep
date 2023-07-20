 * Proyecto: GEP
/*
 * Fichero: GrpVerbasFuncao.prg
 * Descripción:
 * Autor:
 * Fecha: 14/08/2021
 */

#include "Xailer.ch"
#include "Nefele.ch"
#include "LangCGI.ch"

#define __CODMODEL__ "GRPVERBASFUNCAO"

function __GrpVerbasFuncao(lExecute,hFilter,nMaxRowspPage)

   local cIDModal

   local codVerba
   local codGrupo
   local codFuncao
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
      cIDModal:=oCGI:GetCgiValue("cIDModalTotaisGrpVerbasFuncao","")
      IF (!Empty(cIDModal))
         oCGI:SetUserData("HistoryRemoveParams",.F.)
         cIDModal:=__base64Decode(cIDModal)
         HB_JsonDecode(cIDModal,@hIDModal)
         saveTmpParameters("__GrpVerbasFuncao",hIDModal)
         IF (HB_HHasKey(hIDModal,"codGrupo"))
            codGrupo:=hIDModal["codGrupo"]
         ENDIF
         IF (HB_HHasKey(hIDModal,"codFuncao"))
            codFuncao:=hIDModal["codFuncao"]
         ENDIF
         IF (HB_HHasKey(hIDModal,"codFilial"))
            codFilial:=hIDModal["codFilial"]
         ENDIF
         IF (HB_HHasKey(hIDModal,"codPeriodo"))
            codPeriodo:=hIDModal["codPeriodo"]
         ENDIF
         IF (HB_HHasKey(hIDModal,"codCentroDeCusto"))
            codCentroDeCusto:=hIDModal["codCentroDeCusto"]
         ENDIF
         IF (HB_HHasKey(hIDModal,"codVerba"))
            codVerba:=hIDModal["codVerba"]
         ENDIF
         IF (HB_HHasKey(hIDModal,"codGrupoSuperior"))
            codGrupoSuperior:=hIDModal["codGrupoSuperior"]
         ENDIF
      ELSE
         IF (HB_HHasKey(hFilter,"codGrupo"))
            codGrupo:=hFilter["codGrupo"]
            oCGI:SetUserData("__GrpVerbasFuncao:codGrupo",codGrupo)
         ELSE
            codGrupo:=oCGI:GetCgiValue("codGrupo","")
         ENDIF
         IF (HB_HHasKey(hFilter,"codFuncao"))
            codFuncao:=hFilter["codFuncao"]
            oCGI:SetUserData("__GrpVerbasFuncao:codFuncao",codFuncao)
         ELSE
            codFuncao:=oCGI:GetCgiValue("codFuncao","")
         ENDIF
         IF (HB_HHasKey(hFilter,"codFilial"))
            codFilial:=hFilter["codFilial"]
            oCGI:SetUserData("__GrpVerbasFuncao:codFilial",codFilial)
         ELSE
            codFilial:=oCGI:GetCgiValue("codFilial","")
         ENDIF
         IF (HB_HHasKey(hFilter,"codPeriodo"))
            codPeriodo:=hFilter["codPeriodo"]
            oCGI:SetUserData("__GrpVerbasFuncao:codPeriodo",codPeriodo)
         ELSE
            codPeriodo:=oCGI:GetCgiValue("codPeriodo","")
         ENDIF
         IF (HB_HHasKey(hFilter,"codCentroDeCusto"))
            codCentroDeCusto:=hFilter["codCentroDeCusto"]
            oCGI:SetUserData("__GrpVerbasFuncao:codCentroDeCusto",codCentroDeCusto)
         ELSE
            codCentroDeCusto:=oCGI:GetCgiValue("codCentroDeCusto","")
         ENDIF
         IF (HB_HHasKey(hFilter,"codVerba"))
            codVerba:=hFilter["codVerba"]
            oCGI:SetUserData("__GrpVerbasFuncao:codVerba",codVerba)
         ELSE
            codVerba:=oCGI:GetCgiValue("codVerba","")
         ENDIF
         IF (HB_HHasKey(hFilter,"codGrupoSuperior"))
            codGrupoSuperior:=hFilter["codGrupoSuperior"]
            oCGI:SetUserData("__GrpVerbasFuncao:codGrupoSuperior",codGrupoSuperior)
         ELSE
            codGrupoSuperior:=oCGI:GetCgiValue("codGrupoSuperior","")
         ENDIF
      endif
   else
        IF (HB_HHasKey(hFilter,"codGrupo"))
            codGrupo:=hFilter["codGrupo"]
            oCGI:SetUserData("__GrpVerbasFuncao:codGrupo",codGrupo)
         ELSE
            codGrupo:=oCGI:GetCgiValue("codGrupo","")
         ENDIF
        IF (HB_HHasKey(hFilter,"codFuncao"))
            codFuncao:=hFilter["codFuncao"]
            oCGI:SetUserData("__GrpVerbasFuncao:codFuncao",codFuncao)
         ELSE
            codFuncao:=oCGI:GetCgiValue("codFuncao","")
         ENDIF
         IF (HB_HHasKey(hFilter,"codFilial"))
            codFilial:=hFilter["codFilial"]
            oCGI:SetUserData("__GrpVerbasFuncao:codFilial",codFilial)
         ELSE
            codFilial:=oCGI:GetCgiValue("codFilial","")
         ENDIF
         IF (HB_HHasKey(hFilter,"codPeriodo"))
            codPeriodo:=hFilter["codPeriodo"]
            oCGI:SetUserData("__GrpVerbasFuncao:codPeriodo",codPeriodo)
         ELSE
            codPeriodo:=oCGI:GetCgiValue("codPeriodo","")
         ENDIF
         IF (HB_HHasKey(hFilter,"codCentroDeCusto"))
            codCentroDeCusto:=hFilter["codCentroDeCusto"]
            oCGI:SetUserData("__GrpVerbasFuncao:codCentroDeCusto",codCentroDeCusto)
         ELSE
            codCentroDeCusto:=oCGI:GetCgiValue("codCentroDeCusto","")
         ENDIF
         IF (HB_HHasKey(hFilter,"codVerba"))
            codVerba:=hFilter["codVerba"]
            oCGI:SetUserData("__GrpVerbasFuncao:codVerba",codVerba)
         ELSE
            codVerba:=oCGI:GetCgiValue("codVerba","")
         ENDIF
         IF (HB_HHasKey(hFilter,"codGrupoSuperior"))
            codGrupoSuperior:=hFilter["codGrupoSuperior"]
            oCGI:SetUserData("__GrpVerbasFuncao:codGrupoSuperior",codGrupoSuperior)
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

       if (Empty(codFuncao))
          codFuncao:=oCGI:GetCgiValue("GEPParameters_codFuncao","")
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

       if (Empty(codCentroDeCusto))
          codCentroDeCusto:=oCGI:GetCgiValue("GEPParameters_codCentroDeCusto","")
          if (Empty(codCentroDeCusto))
             codCentroDeCusto:=oCGI:GetUserData("__GEPParameters:codCentroDeCusto",codCentroDeCusto)
          endif
       endif

       if (Empty(codVerba))
          codVerba:=oCGI:GetCgiValue("GEPParameters_codVerba","")
          if (Empty(codVerba))
             codVerba:=oCGI:GetUserData("__GEPParameters:codVerba",codVerba)
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
      oCGI:SetUserData("__GrpVerbasFuncao:codGrupo","")
      hFilter["codGrupoSuperior"]:=codGrupo
      oCGI:SetUserData("__GrpVerbasFuncao:codGrupoSuperior",codGrupo)
   ELSE
      hFilter["codGrupo"]:=codGrupo
      oCGI:SetUserData("__GrpVerbasFuncao:codGrupo",codGrupo)
      hFilter["codGrupoSuperior"]:=codGrupoSuperior
      oCGI:SetUserData("__GrpVerbasFuncao:codGrupoSuperior",codGrupoSuperior)
   ENDIF

   hFilter["codFuncao"]:=codFuncao
   oCGI:SetUserData("__GrpVerbasFuncao:codFuncao",codFuncao)

   hFilter["codFilial"]:=codFilial
   oCGI:SetUserData("__GrpVerbasFuncao:codFilial",codFilial)

   hFilter["codPeriodo"]:=codPeriodo
   oCGI:SetUserData("__GrpVerbasFuncao:codPeriodo",codPeriodo)

   hFilter["codCentroDeCusto"]:=codCentroDeCusto
   oCGI:SetUserData("__GrpVerbasFuncao:codCentroDeCusto",codCentroDeCusto)

   hFilter["codVerba"]:=codVerba
   oCGI:SetUserData("__GrpVerbasFuncao:codVerba",codVerba)

   if (lExecute)
      oCGI:SetUserData("GrpVerbasFuncionarios:Back",ProcName())
      GrpVerbasFuncao(nMaxRowspPage)
   endif

   RETURN(hFilter)

PROCEDURE GrpVerbasFuncao(nMaxRowspPage)

   local hUser := LoginUser()

   local cSubTitle:=" :: "+"Consulta Dados Por Funcao/Sub-Grupo de Verbas"
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

   if (!stackTools():IsInCallStack("__GrpVerbasFuncao"))
      hFilter:=__GrpVerbasFuncao(.F.)
   endif

   WITH OBJECT oTWebPage:=wTWebPage():New()

      :cTitle:=cTitle

      AppMenu(oTWebPage,AppData:AppName,hUser,.F.,oCGI:GetUserData("HistoryRemoveParams",.F.))

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
         aParameters:={"codFilial","codPeriodo","codGrupo","codCentroDeCusto","codVerba","codFuncao"}
         cSubTitle:=AppData:AppName+cSubTitle
         GEPParameters(oTWebPage,@cIDParameters,"__GrpVerbasFuncao",aParameters,.F.,cSubTitle):Create()
      endif

      :lValign    := .F.
      :lContainer := .F.

      aFields:=GetDataFieldsGrpVerbasFuncao(@cColsPrint)
      nRowspPageMax:=oCGI:GetUserData(__CODMODEL__+":RowspPageMax",10)
      HB_Default(@nMaxRowspPage,nRowspPageMax)

      WITH OBJECT owDatatable:=wDatatable():New(oTWebPage)

         :cId:=Lower("browsegrpverbasfuncao")

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
               hFilter:=__GrpVerbasFuncao(.F.)
               __TotaisGrpVerbasFuncao(owDatatable,.F.,.F.)
               __GrpVerbasFuncao(.F.,hFilter)
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
            :AddColumnButton("loupe",cTmp,"btn-wDatatable ;","__GrpVerbasFuncionariosDet","dt-center","",/*,'fn_click'*/)
            :AddColumnDef( nField ):width := '30px'

            :ajax := { "cgi" => "GetDataGrpVerbasFuncao" }

         END

         :Create()

      END

      oCgi:SendPage( :Create() )

   END

RETURN

//------------------------------------------------------------------------------

FUNCTION GetDataGrpVerbasFuncao(lSendJSON,lGetFull,cSearchFilter)

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
      GetDataFieldsGrpVerbasFuncao()
      xJSONData:=Extraer(codModel,nStart,nLimit,nDraw,cSearchFilter,aOrder,lSendJSON,.F.)
   endif

RETURN(if(lSendJSON,oCGI:SendJson(xJSONData),xJSONData))

function GetDataFieldsGrpVerbasFuncao(cColsPrint)
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
   local codVerba
   local codFuncao
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
   restoreTmpParameters("__GrpVerbasFuncao",@hFilter,.T.)

   codGrupo:=oCGI:GetUserData("__GrpVerbasFuncao:codGrupo")
   codVerba:=oCGI:GetUserData("__GrpVerbasFuncao:codVerba")
   codFuncao:=oCGI:GetUserData("__GrpVerbasFuncao:codFuncao")
   codFilial:=oCGI:GetUserData("__GrpVerbasFuncao:codFilial")
   codPeriodo:=oCGI:GetUserData("__GrpVerbasFuncao:codPeriodo")
   codCentroDeCusto:=oCGI:GetUserData("__GrpVerbasFuncao:codCentroDeCusto")
   codGrupoSuperior:=oCGI:GetUserData("__GrpVerbasFuncao:codGrupoSuperior")

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

   IF (!Empty(codVerba))
      hFilter["codVerba"]:=codVerba
      IF (!Empty(cFilter))
         cFilter+=" AND "
      endif
      cFilter+="RV_COD='"+codVerba+"'"
   ELSE
      IF (HB_HHasKey(hFilter,"codVerba"))
         HB_HDel(hFilter,"codVerba")
      ENDIF
   ENDIF

   IF (!Empty(codFuncao))
      hFilter["codFuncao"]:=codFuncao
      IF (!Empty(cFilter))
         cFilter+=" AND "
      endif
      cFilter+="RJ_FUNCAO='"+codFuncao+"'"
   ELSE
      IF (HB_HHasKey(hFilter,"codFuncao"))
         HB_HDel(hFilter,"codFuncao")
      ENDIF
   ENDIF

   IF (!Empty(codGrupoSuperior))
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

procedure __clearGrpVerbasFuncao()

   oCGI:SetUserData("__GrpVerbasFuncao:codGrupo","")
   oCGI:SetUserData("__GrpVerbasFuncao:codVerba","")
   oCGI:SetUserData("__GrpVerbasFuncao:codFuncao","")
   oCGI:SetUserData("__GrpVerbasFuncao:codFilial","")
   oCGI:SetUserData("__GrpVerbasFuncao:codPeriodo","")
   oCGI:SetUserData("__GrpVerbasFuncao:codCentroDeCusto","")
   oCGI:SetUserData("__GrpVerbasFuncao:codGrupoSuperior","")

   oCGI:SetUserData("GrpVerbasFuncao:Back:lGrpViewTotais",.F.)

   oCGI:SetUserData("GrpVerbasFuncao:Back","GrpVerbasFuncao")
   oCGI:SetUserData("GrpVerbasFuncionarios:Back","GrpVerbasFuncionarios")

   deleteTmpParameters("__GrpVerbasFuncao")
   deleteTmpParameters("__TotaisGrpVerbasFuncao")
   deleteTmpParameters("__ChartTotaisGrpVerbasFuncao")

   return