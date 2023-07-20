 * Proyecto: GEP
/*
 * Fichero: PainelGrpMasterVerbasEmpresa.prg
 * Descripción:
 * Autor:
 * Fecha: 14/08/2021
 */

#include "Xailer.ch"
#include "Nefele.ch"
#include "LangCGI.ch"

#define __CODMODEL__ "PIVOTEMPRESAGRUPO"

PROCEDURE ParametersPainelGrpMasterVerbasEmpresa(lGrpViewTotais)

   local hUser := LoginUser()

   local cSubTitle:=" :: "+"Consulta dos Dados Totais Por Empresa/Grupo de Verbas"
   local cTitle:=AppData:AppTitle+cSubTitle
   local cIDParameters
   local aParameters

   HB_Default(@lGrpViewTotais,.F.)

   oCGI:SetUserData("__GrpMasterVerbasEmpresa:lGrpViewTotais",lGrpViewTotais)

   oCGI:SetUserData("PainelGrpMasterVerbasEmpresa:Back",ProcName())

   WITH OBJECT wTWebPage():New()

      :cTitle:=cTitle

      AppMenu(:WO,AppData:AppName,hUser,.F.)

      aParameters:={"codPeriodo","codGrupo"}
      cSubTitle:=AppData:AppName+cSubTitle
      GEPParameters(:WO,@cIDParameters,"__PainelGrpMasterVerbasEmpresa",aParameters,.T.,cSubTitle,.T.,.T.):Create()

      :lValign    := .F.
      :lContainer := .F.

      oCgi:SendPage( :Create() )

   END

RETURN

function __PainelGrpMasterVerbasEmpresa(lExecute,hFilter,nMaxRowspPage)

   local cIDModal

   local codGrupo
   local codPeriodo
   local codGrupoSuperior

   local hIDModal

   local lFilter

   HB_Default(@lExecute,.T.)
   lFilter:=(HB_IsHash(hFilter).AND.!Empty(hFilter))
   HB_Default(@hFilter,{=>})

   IF (lExecute)
      cIDModal:=oCGI:GetCgiValue("cIDModalTotaisGrpMasterVerbasEmpresa","")
      IF (!Empty(cIDModal))
         oCGI:SetUserData("HistoryRemoveParams",.F.)
         cIDModal:=__base64Decode(cIDModal)
         HB_JsonDecode(cIDModal,@hIDModal)
         saveTmpParameters("__PainelGrpMasterVerbasEmpresa",hIDModal)
         IF (HB_HHasKey(hIDModal,"codGrupo"))
            codGrupo:=hIDModal["codGrupo"]
         endif
         IF (HB_HHasKey(hIDModal,"codPeriodo"))
            codPeriodo:=hIDModal["codPeriodo"]
         ENDIF
         IF (HB_HHasKey(hIDModal,"codGrupoSuperior"))
            codGrupoSuperior:=hIDModal["codGrupoSuperior"]
         ENDIF
      ELSE
         IF (HB_HHasKey(hFilter,"codGrupo"))
            codGrupo:=hFilter["codGrupo"]
            oCGI:SetUserData("__PainelGrpMasterVerbasEmpresa:codGrupo",codGrupo)
         ELSE
            codGrupo:=oCGI:GetCgiValue("codGrupo","")
         ENDIF
         IF (HB_HHasKey(hFilter,"codPeriodo"))
            codPeriodo:=hFilter["codPeriodo"]
            oCGI:SetUserData("__PainelGrpMasterVerbasEmpresa:codPeriodo",codPeriodo)
         ELSE
            codPeriodo:=oCGI:GetCgiValue("codPeriodo","")
         ENDIF
        IF (HB_HHasKey(hFilter,"codGrupoSuperior"))
            codGrupoSuperior:=hFilter["codGrupoSuperior"]
            oCGI:SetUserData("__PainelGrpMasterVerbasEmpresa:codGrupoSuperior",codGrupoSuperior)
         ELSE
            codGrupoSuperior:=oCGI:GetCgiValue("codGrupoSuperior","")
         ENDIF
     endif
   else
        IF (HB_HHasKey(hFilter,"codGrupo"))
            codGrupo:=hFilter["codGrupo"]
            oCGI:SetUserData("__PainelGrpMasterVerbasEmpresa:codGrupo",codGrupo)
         ELSE
            codGrupo:=oCGI:GetCgiValue("codGrupo","")
         ENDIF
         IF (HB_HHasKey(hFilter,"codPeriodo"))
            codPeriodo:=hFilter["codPeriodo"]
            oCGI:SetUserData("__PainelGrpMasterVerbasEmpresa:codPeriodo",codPeriodo)
         ELSE
            codPeriodo:=oCGI:GetCgiValue("codPeriodo","")
         ENDIF
         IF (HB_HHasKey(hFilter,"codGrupoSuperior"))
            codGrupoSuperior:=hFilter["codGrupoSuperior"]
            oCGI:SetUserData("__PainelGrpMasterVerbasEmpresa:codGrupoSuperior",codGrupoSuperior)
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

       if (Empty(codPeriodo))
          codPeriodo:=oCGI:GetCgiValue("GEPParameters_codPeriodo","")
          if (Empty(codPeriodo))
             codPeriodo:=oCGI:GetUserData("__GEPParameters:codPeriodo",codPeriodo)
          endif
       endif

       if (Empty(codGrupoSuperior))
          codGrupoSuperior:=oCGI:GetCgiValue("GEPParameters_codGrupoSuperior","")
          if (Empty(codGrupoSuperior))
             codGrupoSuperior:=oCGI:GetUserData("__GEPParameters:codGrupoSuperior",codGrupoSuperior)
          endif
       endif

    endif

   hFilter["codGrupo"]:=codGrupo
   oCGI:SetUserData("__PainelGrpMasterVerbasEmpresa:codGrupo",codGrupo)

   hFilter["codPeriodo"]:=codPeriodo
   oCGI:SetUserData("__PainelGrpMasterVerbasEmpresa:codPeriodo",codPeriodo)

   hFilter["codGrupoSuperior"]:=codGrupoSuperior
   oCGI:SetUserData("__PainelGrpMasterVerbasEmpresa:codGrupoSuperior",codGrupoSuperior)

   if (lExecute)
      oCGI:SetUserData("PainelGrpMasterVerbasFilial:Back",ProcName())
      PainelGrpMasterVerbasEmpresa(nMaxRowspPage)
   endif

   RETURN(hFilter)

PROCEDURE PainelGrpMasterVerbasEmpresa(nMaxRowspPage)

   local hUser := LoginUser()

   local cSubTitle:=" :: "+"Painel Consulta Dados Por Empresa/Grupo de Verbas"
   local cTitle:=AppData:AppTitle+cSubTitle
   local cColsPrint
   local cIDParameters
   local aParameters
   local bExecuteOnStart

   local nField
   local aFields
   local nFields
   local nRowspPageMax

   local cTmp

   local hFilter

   if (!stackTools():IsInCallStack("__PainelGrpMasterVerbasEmpresa"))
        hFilter:=__PainelGrpMasterVerbasEmpresa(.F.)
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

      aParameters:={"codPeriodo","codGrupo"}
      cSubTitle:=AppData:AppName+cSubTitle
      GEPParameters(:WO,@cIDParameters,"__PainelGrpMasterVerbasEmpresa",aParameters,.F.,cSubTitle):Create()

      :lValign    := .F.
      :lContainer := .F.

      aFields:=GetDataFieldsPainelGrpMasterVerbasEmpresa(@cColsPrint)
      nRowspPageMax:=oCGI:GetUserData(__CODMODEL__+":RowspPageMax",10)
      HB_Default(@nMaxRowspPage,nRowspPageMax)

      WITH OBJECT wDatatable():New(:WO)

         :cId:=Lower("browsePainelGrpMasterVerbasEmpresa")

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
            :AddColumnButton("loupe",cTmp,"btn-wDatatable ;","__PainelGrpMasterVerbasFilialDet","dt-center","",/*,'fn_click'*/)
            :AddColumnDef( nField ):width := '30px'

            :ajax := { "cgi" => "GetDataPainelGrpMasterVerbasEmpresa" }

         END

         :Create()

      END

      oCgi:SendPage( :Create() )

   END

RETURN

//------------------------------------------------------------------------------

FUNCTION GetDataPainelGrpMasterVerbasEmpresa(lSendJSON,lGetFull,cSearchFilter)

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
      GetDataFieldsPainelGrpMasterVerbasEmpresa()
      xJSONData:=Extraer(codModel,nStart,nLimit,nDraw,cSearchFilter,aOrder,lSendJSON,.F.)
   endif

RETURN(if(lSendJSON,oCGI:SendJson(xJSONData),xJSONData))

function GetDataFieldsPainelGrpMasterVerbasEmpresa(cColsPrint)

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

   local codGrupo
   local codPeriodo
   local codGrupoSuperior

   local hFilter

   local xData

   AppData:cEmp:=oCGI:GetUserData("cEmp",AppData:cEmp)
   HB_Default(AppData:cEmp,"")
   cFile:=(AppData:PathData+AppData:cEmp+"_"+Lower(ProcName(1))+".json")

   hFilter:={=>}
   restoreTmpParameters("__PainelGrpMasterVerbasEmpresa",@hFilter,.T.)

   codGrupo:=oCGI:GetUserData("__PainelGrpMasterVerbasEmpresa:codGrupo")
   codPeriodo:=oCGI:GetUserData("__PainelGrpMasterVerbasEmpresa:codPeriodo")
   codGrupoSuperior:=oCGI:GetUserData("__PainelGrpMasterVerbasEmpresa:codGrupoSuperior")

   HB_Default(@cFilter,"")

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

   IF (!Empty(codGrupoSuperior))
      hFilter["codGrupoSuperior"]:=codGrupoSuperior
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

procedure __clearPainelGrpMasterVerbasEmpresa()

   oCGI:SetUserData("__PainelGrpMasterVerbasEmpresa:codGrupo","")
   oCGI:SetUserData("__PainelGrpMasterVerbasEmpresa:codPeriodo","")
   oCGI:SetUserData("__PainelGrpMasterVerbasEmpresa:codGrupoSuperior","")

   oCGI:SetUserData("PainelGrpMasterVerbasFilial:Back","ParametersPainelGrpMasterVerbasFilial")
   oCGI:SetUserData("PainelGrpMasterVerbasEmpresa:Back","ParametersPainelGrpMasterVerbasEmpresa")

   deleteTmpParameters("__PainelGrpMasterVerbasEmpresa")

   return