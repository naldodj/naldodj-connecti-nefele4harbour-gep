 * Proyecto: GEP
/*
 * Fichero: GrpVerbasFuncionarios.prg
 * Descripción:
 * Autor:
 * Fecha: 14/08/2021
 */

#include "Xailer.ch"
#include "Nefele.ch"
#include "LangCGI.ch"

#define __CODMODEL__ "GRPVERBASFUNCIONARIOS"

function __GrpVerbasFuncionarios(lExecute,hFilter,nMaxRowspPage)

   local cIDModal

   local codVerba
   local codGrupo
   local codFilial
   local codFuncao
   local codPeriodo
   local codMatricula
   local codGrupoSuperior
   local codCentroDeCusto

   local hIDModal

   local lFilter

   HB_Default(@lExecute,.T.)
   lFilter:=(HB_IsHash(hFilter).AND.!Empty(hFilter))
   HB_Default(@hFilter,{=>})

   IF (lExecute)
      cIDModal:=oCGI:GetCgiValue("cIDModalTotaisGrpVerbasFuncionarios","")
      IF (!Empty(cIDModal))
         oCGI:SetUserData("HistoryRemoveParams",.F.)
         cIDModal:=__base64Decode(cIDModal)
         HB_JsonDecode(cIDModal,@hIDModal)
         saveTmpParameters("__GrpVerbasFuncionarios",hIDModal)
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
         IF (HB_HHasKey(hIDModal,"codGrupoSuperior"))
            codGrupoSuperior:=hIDModal["codGrupoSuperior"]
         ENDIF
      ELSE
         IF (HB_HHasKey(hFilter,"codVerba"))
            codVerba:=hFilter["codVerba"]
            oCGI:SetUserData("__GrpVerbasFuncionarios:codVerba",codVerba)
         ELSE
            codVerba:=oCGI:GetCgiValue("codVerba","")
         ENDIF
         IF (HB_HHasKey(hFilter,"codGrupo"))
            codGrupo:=hFilter["codGrupo"]
            oCGI:SetUserData("__GrpVerbasFuncionarios:codGrupo",codGrupo)
         ELSE
            codGrupo:=oCGI:GetCgiValue("codGrupo","")
         ENDIF
         IF (HB_HHasKey(hFilter,"codFuncao"))
            codFuncao:=hFilter["codFuncao"]
            oCGI:SetUserData("__GrpVerbasFuncionarios:codFuncao",codFuncao)
         ELSE
            codFuncao:=oCGI:GetCgiValue("codFuncao","")
         ENDIF
         IF (HB_HHasKey(hFilter,"codFilial"))
            codFilial:=hFilter["codFilial"]
            oCGI:SetUserData("__GrpVerbasFuncionarios:codFilial",codFilial)
         ELSE
            codFilial:=oCGI:GetCgiValue("codFilial","")
         ENDIF
         IF (HB_HHasKey(hFilter,"codPeriodo"))
            codPeriodo:=hFilter["codPeriodo"]
            oCGI:SetUserData("__GrpVerbasFuncionarios:codPeriodo",codPeriodo)
         ELSE
            codPeriodo:=oCGI:GetCgiValue("codPeriodo","")
         ENDIF
         IF (HB_HHasKey(hFilter,"codMatricula"))
            codMatricula:=hFilter["codMatricula"]
            oCGI:SetUserData("__GrpVerbasFuncionarios:codMatricula",codMatricula)
         ELSE
            codMatricula:=oCGI:GetCgiValue("codMatricula","")
         ENDIF
         IF (HB_HHasKey(hFilter,"codCentroDeCusto"))
            codCentroDeCusto:=hFilter["codCentroDeCusto"]
            oCGI:SetUserData("__GrpVerbasFuncionarios:codCentroDeCusto",codCentroDeCusto)
         ELSE
            codCentroDeCusto:=oCGI:GetCgiValue("codCentroDeCusto","")
         ENDIF
         IF (HB_HHasKey(hFilter,"codGrupoSuperior"))
            codGrupoSuperior:=hFilter["codGrupoSuperior"]
            oCGI:SetUserData("__GrpVerbasFuncionarios:codGrupoSuperior",codGrupoSuperior)
         ELSE
            codGrupoSuperior:=oCGI:GetCgiValue("codGrupoSuperior","")
         ENDIF
      endif
   else
        IF (HB_HHasKey(hFilter,"codVerba"))
            codVerba:=hFilter["codVerba"]
            oCGI:SetUserData("__GrpVerbasFuncionarios:codVerba",codVerba)
         ELSE
            codVerba:=oCGI:GetCgiValue("codVerba","")
         ENDIF
         IF (HB_HHasKey(hFilter,"codGrupo"))
            codGrupo:=hFilter["codGrupo"]
            oCGI:SetUserData("__GrpVerbasFuncionarios:codGrupo",codGrupo)
         ELSE
            codGrupo:=oCGI:GetCgiValue("codGrupo","")
         ENDIF
         IF (HB_HHasKey(hFilter,"codFuncao"))
            codFuncao:=hFilter["codFuncao"]
            oCGI:SetUserData("__GrpVerbasFuncionarios:codFuncao",codFuncao)
         ELSE
            codFuncao:=oCGI:GetCgiValue("codFuncao","")
         ENDIF
         IF (HB_HHasKey(hFilter,"codFilial"))
            codFilial:=hFilter["codFilial"]
            oCGI:SetUserData("__GrpVerbasFuncionarios:codFilial",codFilial)
         ELSE
            codFilial:=oCGI:GetCgiValue("codFilial","")
         ENDIF
         IF (HB_HHasKey(hFilter,"codPeriodo"))
            codPeriodo:=hFilter["codPeriodo"]
            oCGI:SetUserData("__GrpVerbasFuncionarios:codPeriodo",codPeriodo)
         ELSE
            codPeriodo:=oCGI:GetCgiValue("codPeriodo","")
         ENDIF
         IF (HB_HHasKey(hFilter,"codMatricula"))
            codMatricula:=hFilter["codMatricula"]
            oCGI:SetUserData("__GrpVerbasFuncionarios:codMatricula",codMatricula)
         ELSE
            codMatricula:=oCGI:GetCgiValue("codMatricula","")
         ENDIF
         IF (HB_HHasKey(hFilter,"codCentroDeCusto"))
            codCentroDeCusto:=hFilter["codCentroDeCusto"]
            oCGI:SetUserData("__GrpVerbasFuncionarios:codCentroDeCusto",codCentroDeCusto)
         ELSE
            codCentroDeCusto:=oCGI:GetCgiValue("codCentroDeCusto","")
         ENDIF
         IF (HB_HHasKey(hFilter,"codGrupoSuperior"))
            codGrupoSuperior:=hFilter["codGrupoSuperior"]
            oCGI:SetUserData("__GrpVerbasFuncionarios:codGrupoSuperior",codGrupoSuperior)
         ELSE
            codGrupoSuperior:=oCGI:GetCgiValue("codGrupoSuperior","")
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

       if (Empty(codGrupoSuperior))
          codGrupoSuperior:=oCGI:GetCgiValue("GEPParameters_codGrupoSuperior","")
          if (Empty(codGrupoSuperior))
             codGrupoSuperior:=oCGI:GetUserData("__GEPParameters:codGrupoSuperior",codGrupoSuperior)
          endif
       endif

    endif

   hFilter["codVerba"]:=codVerba
   oCGI:SetUserData("__GrpVerbasFuncionarios:codVerba",codVerba)

   IF (oCGI:GetUserData("lGrupoHasSuper",.F.))
      hFilter["codGrupo"]:=""
      oCGI:SetUserData("__GrpVerbasFuncionarios:codGrupo","")
      hFilter["codGrupoSuperior"]:=codGrupo
      oCGI:SetUserData("__GrpVerbasFuncionarios:codGrupoSuperior",codGrupo)
   ELSE
      hFilter["codGrupo"]:=codGrupo
      oCGI:SetUserData("__GrpVerbasFuncionarios:codGrupo",codGrupo)
      hFilter["codGrupoSuperior"]:=codGrupoSuperior
      oCGI:SetUserData("__GrpVerbasFuncionarios:codGrupoSuperior",codGrupoSuperior)
   ENDIF

   hFilter["codFuncao"]:=codFuncao
   oCGI:SetUserData("__GrpVerbasFuncionarios:codFuncao",codFuncao)

   hFilter["codFilial"]:=codFilial
   oCGI:SetUserData("__GrpVerbasFuncionarios:codFilial",codFilial)

   hFilter["codPeriodo"]:=codPeriodo
   oCGI:SetUserData("__GrpVerbasFuncionarios:codPeriodo",codPeriodo)

   hFilter["codMatricula"]:=codMatricula
   oCGI:SetUserData("__GrpVerbasFuncionarios:codMatricula",codMatricula)

   hFilter["codCentroDeCusto"]:=codCentroDeCusto
   oCGI:SetUserData("__GrpVerbasFuncionarios:codCentroDeCusto",codCentroDeCusto)

   if (lExecute)
      GrpVerbasFuncionarios(nMaxRowspPage)
   endif

   RETURN(hFilter)

PROCEDURE GrpVerbasFuncionarios(nMaxRowspPage)

   local hUser := LoginUser()

   local cSubTitle:=" :: "+"Consulta Dados Por Funcionario/Sub-Grupo de Verbas"
   local cTitle:=AppData:AppTitle+cSubTitle

   local cHtml
   local cColsPrint
   local cIDParameters
   local aParameters

   local nField
   local aFields
   local nFields

   local nRowspPageMax

   local cTmp

   local lGrpViewTotais:=oCGI:GetUserData("lGrpViewTotais",.F.)

   if (!stackTools():IsInCallStack("__GrpVerbasFuncionarios"))
      __GrpVerbasFuncionarios(.F.)
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

      if (!lGrpViewTotais)
          aParameters:={"codFilial","codPeriodo","codGrupo","codCentroDeCusto","codVerba","codFuncao"}
          cSubTitle:=AppData:AppName+cSubTitle
          GEPParameters(:WO,@cIDParameters,"__GrpVerbasFuncionarios",aParameters,.F.,cSubTitle):Create()
      endif

      :lValign    := .F.
      :lContainer := .F.

      // hacemos scroll si hay m�s de 10 registros
      *aAdd(:aScript,'function fn_click(e){ if( document.querySelector("#datas").offsetTop > window.innerHeight) {document.getElementById("datas").scrollIntoView()}     }')

      aFields:=GetDataFieldsGrpVerbasFuncionarios(@cColsPrint)
      nRowspPageMax:=oCGI:GetUserData(__CODMODEL__+":RowspPageMax",10)
      HB_Default(@nMaxRowspPage,nRowspPageMax)

      WITH OBJECT wDatatable():New(:WO)

         :cId:=Lower("browsegrpverbasfuncionarios")

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

            IF (!stacktools():IsInCallStack("__GrpVerbasFuncionarios"))
 *               cTmp := {"Detalhes","Detalhes"}[AppData:nLang]
 *               :AddColumnButton("loupe",cTmp,"btn-wDatatable ;",/*"visparamajax"*/,"dt-center",/*"datas"*/,/*,'fn_click'*/)
 *               :AddColumnDef( nField ):width := '30px'
            endif

            :ajax := { "cgi" => "GetDataGrpVerbasFuncionarios" }

        END

 *       aAdd(:aScript,fixedColumns(:cID,"6"))

         :Create()

      END
/*
      WITH OBJECT WBevel():New(:WO)
         :cId     :="datas"
         :cClass  := "z-depth-4"
         WITH OBJECT:oStyle
            :cMargin_Top :=  20
            :cMin_Height := 400
            :cMax_Height := 400
            :cOverflow   := "auto"
         END
         :Create()
      END
*/
      oCgi:SendPage( :Create() )

   END

RETURN

//------------------------------------------------------------------------------

FUNCTION GetDataGrpVerbasFuncionarios(lSendJSON,lGetFull,cSearchFilter)

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
      GetDataFieldsGrpVerbasFuncionarios()
      xJSONData:=Extraer(codModel,nStart,nLimit,nDraw,cSearchFilter,aOrder,lSendJSON,.F.)
   endif

RETURN(if(lSendJSON,oCGI:SendJson(xJSONData),xJSONData))

function GetDataFieldsGrpVerbasFuncionarios(cColsPrint)
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
   local codFilial
   local codFuncao
   local codPeriodo
   local codMatricula
   local codCentroDeCusto
   local codGrupoSuperior

   local hFilter

   local xData

   AppData:cEmp:=oCGI:GetUserData("cEmp",AppData:cEmp)
   HB_Default(AppData:cEmp,"")
   cFile:=(AppData:PathData+AppData:cEmp+"_"+Lower(ProcName(1))+".json")

   hFilter:={=>}
   restoreTmpParameters("__GrpVerbasFuncionarios",@hFilter,.T.)

   codVerba:=oCGI:GetUserData("__GrpVerbasFuncionarios:codVerba")
   codGrupo:=oCGI:GetUserData("__GrpVerbasFuncionarios:codGrupo")
   codFilial:=oCGI:GetUserData("__GrpVerbasFuncionarios:codFilial")
   codFuncao:=oCGI:GetUserData("__GrpVerbasFuncionarios:codFuncao")
   codPeriodo:=oCGI:GetUserData("__GrpVerbasFuncionarios:codPeriodo")
   codMatricula:=oCGI:GetUserData("__GrpVerbasFuncionarios:codMatricula")
   codCentroDeCusto:=oCGI:GetUserData("__GrpVerbasFuncionarios:codCentroDeCusto")
   codGrupoSuperior:=oCGI:GetUserData("__GrpVerbasFuncionarios:codGrupoSuperior")

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

procedure __clearGrpVerbasFuncionarios()

   oCGI:SetUserData("__GrpVerbasFuncionarios:codGrupo","")
   oCGI:SetUserData("__GrpVerbasFuncionarios:codVerba","")
   oCGI:SetUserData("__GrpVerbasFuncionarios:codFuncao","")
   oCGI:SetUserData("__GrpVerbasFuncionarios:codFilial","")
   oCGI:SetUserData("__GrpVerbasFuncionarios:codPeriodo","")
   oCGI:SetUserData("__GrpVerbasFuncionarios:codCentroDeCusto","")
   oCGI:SetUserData("__GrpVerbasFuncionarios:codGrupoSuperior","")

   deleteTmpParameters("__GrpVerbasFuncionarios")

   return