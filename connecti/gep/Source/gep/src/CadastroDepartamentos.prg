 * Proyecto: GEP
/*
 * Fichero: CadastroDepartamentos.prg
 * Descripción:
 * Autor:
 * Fecha: 14/08/2021
 */

#include "Xailer.ch"
#include "Nefele.ch"
#include "LangCGI.ch"

#define __CODMODEL__ "DEPARTAMENTOS_SRA"

function __CadastroDepartamentos(lExecute,hFilter,nMaxRowspPage)

   local cIDModal

   local codFilial
   local codDepartamento

   local hIDModal

   local lFilter

   HB_Default(@lExecute,.T.)
   lFilter:=(HB_IsHash(hFilter).AND.!Empty(hFilter))
   HB_Default(@hFilter,{=>})

   IF (lExecute)
      cIDModal:=oCGI:GetCgiValue("cIDModalCadastroDepartamentos","")
      IF (!Empty(cIDModal))
         oCGI:SetUserData("HistoryRemoveParams",.F.)
         cIDModal:=__base64Decode(cIDModal)
         HB_JsonDecode(cIDModal,@hIDModal)
         saveTmpParameters("__CadastroDepartamentos",hIDModal)
         IF (HB_HHasKey(hIDModal,"codFilial"))
            codFilial:=hIDModal["codFilial"]
         ENDIF
         IF (HB_HHasKey(hIDModal,"codDepartamento"))
            codDepartamento:=hIDModal["codDepartamento"]
         ENDIF
      ELSE
         IF (HB_HHasKey(hFilter,"codFilial"))
            codFilial:=hFilter["codFilial"]
            oCGI:SetUserData("__CadastroDepartamentos:codFilial",codFilial)
         ELSE
            codFilial:=oCGI:GetCgiValue("codFilial","")
         ENDIF
         IF (HB_HHasKey(hFilter,"codDepartamento"))
            codDepartamento:=hFilter["codDepartamento"]
            oCGI:SetUserData("__CadastroDepartamentos:codDepartamento",codDepartamento)
         ELSE
            codDepartamento:=oCGI:GetCgiValue("codDepartamento","")
         ENDIF
      endif
   else
         IF (HB_HHasKey(hFilter,"codFilial"))
            codFilial:=hFilter["codFilial"]
            oCGI:SetUserData("__CadastroDepartamentos:codFilial",codFilial)
         ELSE
            codFilial:=oCGI:GetCgiValue("codFilial","")
         ENDIF
         IF (HB_HHasKey(hFilter,"codDepartamento"))
            codDepartamento:=hFilter["codDepartamento"]
            oCGI:SetUserData("__CadastroDepartamentos:codDepartamento",codDepartamento)
         ELSE
            codDepartamento:=oCGI:GetCgiValue("codDepartamento","")
         ENDIF
   endif

   if ((!lFilter).and.Empty(cIDModal))

       if (Empty(codFilial))
          codFilial:=oCGI:GetCgiValue("GEPParameters_codFilial","")
          if (Empty(codFilial))
             codFilial:=oCGI:GetUserData("__GEPParameters:codFilial",codFilial)
          endif
       endif

       if (Empty(codDepartamento))
          codDepartamento:=oCGI:GetCgiValue("GEPParameters_codDepartamento","")
          if (Empty(codDepartamento))
             codDepartamento:=oCGI:GetUserData("__GEPParameters:codDepartamento",codDepartamento)
          endif
       endif

    endif

   hFilter["codFilial"]:=codFilial
   oCGI:SetUserData("__CadastroDepartamentos:codFilial",codFilial)

   hFilter["codDepartamento"]:=codDepartamento
   oCGI:SetUserData("__CadastroDepartamentos:codDepartamento",codDepartamento)

   if (lExecute)
      CadastroDepartamentos(nMaxRowspPage)
   endif

   RETURN(hFilter)

PROCEDURE CadastroDepartamentos(nMaxRowspPage)

   local hUser:=LoginUser()

   local cSubTitle:=" :: "+"Cadastro de Departamentos"
   local cTitle:=AppData:AppTitle+cSubTitle
   local cColsPrint

   local cIDParameters
   local aParameters

   local nField
   local aFields
   local nFields

   local nRowspPageMax

   local cTmp

   WITH OBJECT wTWebPage():New()

      :cTitle:= cTitle

      AppMenu(:WO,AppData:AppName,hUser,.F.)

      WITH OBJECT WFloatingBtn():New(:WO)
         :cClrPane:="#005FAB"
         :cName:=("WFloatingBtn"+ProcName())
         :cId:=Lower(:cName)
         :cText:="Voltar"
         :oIcon:cIcon:="arrow_back"
         :oIcon:cClrIcon := "#FED300"
         :cOnClick:="MainFunction"
        :Create()
      END WITH

      aParameters:={"codFilial","codDepartamento"}
      cSubTitle:=AppData:AppName+cSubTitle
      GEPParameters(:WO,@cIDParameters,"__CadastroDepartamentosDet",aParameters,.F.,cSubTitle):Create()

      :lValign    := .F.
      :lContainer := .F.

      // hacemos scroll si hay más de 10 registros
      *aAdd(:aScript,'function fn_click(e){ if( document.querySelector("#datas").offsetTop > window.innerHeight) {document.getElementById("datas").scrollIntoView()}     }')

      aFields:=GetDataFieldsCadastroDepartamentos(@cColsPrint)
      nRowspPageMax:=oCGI:GetUserData(__CODMODEL__+":RowspPageMax",10)
      HB_Default(@nMaxRowspPage,nRowspPageMax)

      WITH OBJECT wDatatable():New(:WO)

         :cId:=Lower("browseCadastroDepartamentos")

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

*            cTmp := {"Detalhes","Detalhes"}[AppData:nLang]
*            :AddColumnButton("loupe",cTmp,"btn-wDatatable ;",/*"visparamajax"*/,"dt-center",/*"datas"*/,/*,'fn_click'*/)
*            :AddColumnDef( nField ):width := '30px'

            :ajax := { "cgi" => "GetDataCadastroDepartamentos" }

         END

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

FUNCTION GetDataCadastroDepartamentos(lSendJSON,lGetFull,cSearchFilter)

   local aRow
   local aOrder
   local aRecords

   local codModel:=__CODMODEL__

   local xJSONData

   local hRow
   local hParams

   local nDraw
   local nStart
   local nLimit

   HB_Default(@lGetFull,.F.)

   if (lGetFull)

      nStart:=1
      nLimit:=-1

   else

      hParams:=oCGI:aParamsToHash(.T.)

      nStart:=Val(hParams['START'])
      nLimit:=Val(hParams['LENGTH'])

      nDraw:=hParams['DRAW']
      aOrder:={Val(hParams['order[0][column]'])+1,hParams['order[0][dir]']} // datatables empieza en columna 0. segundo elemento asc o desc
      cSearchFilter:=hParams['SEARCH[VALUE]']
      oCGI:SetUserData( "GetDataModel:cSearchFilter",cSearchFilter )

   endif

   HB_Default(@lSendJSON,.T.)

   if (!Empty(nLimit))
      GetDataFieldsCadastroDepartamentos()
      xJSONData:=Extraer(codModel,nStart,nLimit,nDraw,cSearchFilter,aOrder,lSendJSON,.F.)
   endif

RETURN(if(lSendJSON,oCGI:SendJson(xJSONData),xJSONData))

function GetDataFieldsCadastroDepartamentos(cColsPrint)
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

   local codFilial
   local codDepartamento

   local hFilter

   local xData

   AppData:cEmp:=oCGI:GetUserData("cEmp",AppData:cEmp)
   HB_Default(AppData:cEmp,"")
   cFile:=(AppData:PathData+AppData:cEmp+"_"+Lower(ProcName(1))+".json")

   hFilter:={=>}

   IF (!stacktools():IsInCallStack("GEPParameters"))

      restoreTmpParameters("__CadastroDepartamentos",@hFilter,.T.)

      codFilial:=oCGI:GetUserData("__CadastroDepartamentos:codFilial")
      codDepartamento:=oCGI:GetUserData("__CadastroDepartamentos:codDepartamento")

      HB_Default(@cFilter,"")

      IF (!Empty(codFilial))
         hFilter["codFilial"]:=codFilial
         IF (!Empty(cFilter))
            cFilter+=" AND "
         endif
         cFilter+="CTT_FILIAL='"+codFilial+"'"
      ELSE
         IF (HB_HHasKey(hFilter,"codFilial"))
            HB_HDel(hFilter,"codFilial")
         ENDIF
      ENDIF

      IF (!Empty(codDepartamento))
         hFilter["codDepartamento"]:=codDepartamento
         IF (!Empty(cFilter))
            cFilter+=" AND "
         endif
         cFilter+="CTT_CUSTO='"+codDepartamento+"'"
      ELSE
         IF (HB_HHasKey(hFilter,"codDepartamento"))
            HB_HDel(hFilter,"codDepartamento")
         ENDIF
      ENDIF
   ENDIF

   cParModel:=setParModel(hFilter)

   IF (!Empty(cFilter))
      cFilter:="SQL:"+cFilter
   else
      cFilter:=cSearchFilter
   endif

   cGrpFiles:=codModel

   xData:=GetDataModel(codModel,nPage,nRecords,nDraw,cFilter,aOrder,lSendJSON,lGetFields,cFile,cParModel,.F.,cGrpFiles)

   IF (!Empty(hFilter))
      HB_Default(@lGetFields,.F.)
      IF (!lGetFields)
        xData:=rebuildDataModel(xData,hFilter,lSendJSON,aOrder)
      ENDIF
   ENDIF

RETURN(xData)

procedure __clearCadastroDepartamentos()

   oCGI:SetUserData("__CadastroDepartamentos:codFilial","")
   oCGI:SetUserData("__CadastroDepartamentos:codDepartamento","")

   oCGI:SetUserData("CadastroDepartamentos:Back","MAINFUNCTION")

   deleteTmpParameters("__CadastroDepartamentos")

   return