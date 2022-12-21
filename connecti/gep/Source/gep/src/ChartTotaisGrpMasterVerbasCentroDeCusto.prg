 * Proyecto: GEP
/*
 * Fichero: ChartTotaisGrpMasterVerbasCentroDeCusto.prg
 * Descripción:
 * Autor:
 * Fecha: 14/08/2021
 */

#include "Xailer.ch"
#include "Nefele.ch"
#include "LangCGI.ch"

PROCEDURE __ChartTotaisGrpMasterVerbasCentroDeCusto(oTWebPage,lOpenModal,lSendPage)

   local hUser := LoginUser()

   local hData
   local hRowFil
   local hFilter
   local hDataFil

   local cTitle:=AppData:AppTitle+" :: "+"Consulta dos Dados Totais Por Centro De Custo/Grupo de Verbas"

   local cFilter

   local codGrupo
   local codFilial
   local codPeriodo
   local codCentroDeCusto

   Local owRTabs
   local oWLabel
   local oWbevel
   local oWBevel0

   hFilter:=__GrpMasterVerbasCentroDeCusto(.F.)

   deleteTmpParameters("__GrpMasterVerbasCentroDeCusto")
   oCGI:SetUserData( "GrpMasterVerbasCentroDeCusto:Back",ProcName() )

   codGrupo:=oCGI:GetUserData("__GrpMasterVerbasCentroDeCusto:codGrupo",codGrupo)
   codFilial:=oCGI:GetUserData("__GrpMasterVerbasCentroDeCusto:codFilial",codFilial)
   codPeriodo:=oCGI:GetUserData("__GrpMasterVerbasCentroDeCusto:codPeriodo",codPeriodo)
   codCentroDeCusto:=oCGI:GetUserData("__GrpMasterVerbasCentroDeCusto:codCentroDeCusto",codCentroDeCusto)

   HB_Default(@oTWebPage,wTWebPage():New())
   HB_Default(@lOpenModal,.T.)
   HB_Default(@lSendPage,.T.)

   AppData:cEmp:=oCGI:GetUserData("cEmp",AppData:cEmp)

   WITH OBJECT oTWebPage

      if (lSendPage)

         :cTitle:=cTitle

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

      endif

        With Object oWLabel:=WLabel():New(oTWebPage)
            :nHeaderSize:=6
            :nFontSize:=12
            :lBR:=.T.
            :lBold:=.T.
            :cAlign:=xc_Left
            :cText:="<h12>"
            :cText+="Competência: "+Right(codPeriodo,2)+"/"+Left(codPeriodo,4)
            :cText+="</h12>"
            :Create()
      End With

      cFilter:=""

      if (!Empty(codFilial))
         if (!Empty(cFilter))
            cFilter+=" AND "
         endif
         cFilter+="M0_CODFIL='"+codFilial+"'"
      endif

      IF (!Empty(cFilter))
         cFilter:="SQL:"+cFilter
      endif

      oCGI:SetUserData("__CadastroFiliais:codFilial",codFilial)
      hDataFil:=GetDataCadastroFiliais(.F.,.T.,cFilter)
      oCGI:SetUserData("__CadastroFiliais:codFilial","")

      With Object oWBevel0:=WBevel():New(oTWebPage)

         with object owRTabs:=wRTabs():New(oTWebPage)

            :cId:="Tabs_ChartTotaisGrpMasterVerbasCentroDeCusto"

            for each hRowFil in hDataFil["data"]

                 codFilial:=hRowFil["codFilial"]

                 cFilter:=""

                 if (!Empty(codFilial))
                    if (!Empty(cFilter))
                       cFilter+=" AND "
                    endif
                    cFilter+="RD_FILIAL='"+codFilial+"'"
                 endif

                 if (!Empty(codPeriodo))
                    if (!Empty(cFilter))
                       cFilter+=" AND "
                    endif
                    cFilter+="RD_DATARQ='"+codPeriodo+"'"
                 endif

                 if (!Empty(codCentroDeCusto))
                    if (!Empty(cFilter))
                       cFilter+=" AND "
                    endif
                    cFilter+="RD_CC='"+codCentroDeCusto+"'"
                 endif

                 if (!Empty(codGrupo))
                    if (!Empty(cFilter))
                       cFilter+=" AND "
                    endif
                    cFilter+="ZY__CODIGO='"+codGrupo+"'"
                 endif

                 if (!Empty(cFilter))
                    cFilter:="SQL:"+cFilter
                 endif

                 oCGI:SetUserData("__GrpMasterVerbasCentroDeCusto:codGrupo",codGrupo)
                 oCGI:SetUserData("__GrpMasterVerbasCentroDeCusto:codFilial",codFilial)
                 oCGI:SetUserData("__GrpMasterVerbasCentroDeCusto:codPeriodo",codPeriodo)
                 oCGI:SetUserData("__GrpMasterVerbasCentroDeCusto:codCentroDeCusto",codCentroDeCusto)

                 hData:=GetDataTotaisGrpMasterVerbasCentroDeCusto(.F.,.T.,cFilter)

                IF (Empty(hData["data"]))
                   loop
                endif

               with object WItemTabs():New(owRTabs)
                  :cFolder:=owRTabs:cId+'-'+codFilial
                  :cTitle:=codFilial+'-'+hRowFil["descFilial"]
                  :create()
               end

            next hRowFil

            :Create()

         end

         for each hRowFil in hDataFil["data"]

              codFilial:=hRowFil["codFilial"]

              cFilter:=""

              if (!Empty(codFilial))
                 if (!Empty(cFilter))
                    cFilter+=" AND "
                 endif
                 cFilter+="RD_FILIAL='"+codFilial+"'"
              endif

              if (!Empty(codPeriodo))
                 if (!Empty(cFilter))
                    cFilter+=" AND "
                 endif
                 cFilter+="RD_DATARQ='"+codPeriodo+"'"
              endif

              if (!Empty(codCentroDeCusto))
                 if (!Empty(cFilter))
                    cFilter+=" AND "
                 endif
                 cFilter+="RD_CC='"+codCentroDeCusto+"'"
              endif

              if (!Empty(codGrupo))
                 if (!Empty(cFilter))
                    cFilter+=" AND "
                 endif
                 cFilter+="ZY__CODIGO='"+codGrupo+"'"
              endif

              if (!Empty(cFilter))
                 cFilter:="SQL:"+cFilter
              endif

              oCGI:SetUserData("__GrpMasterVerbasCentroDeCusto:codGrupo",codGrupo)
              oCGI:SetUserData("__GrpMasterVerbasCentroDeCusto:codFilial",codFilial)
              oCGI:SetUserData("__GrpMasterVerbasCentroDeCusto:codPeriodo",codPeriodo)
              oCGI:SetUserData("__GrpMasterVerbasCentroDeCusto:codCentroDeCusto",codCentroDeCusto)

              hData:=GetDataTotaisGrpMasterVerbasCentroDeCusto(.F.,.T.,cFilter)

             IF (Empty(hData["data"]))
                loop
             endif

             with object oWbevel:=WBevel():New(oWBevel0)
               :cID:=owRTabs:cId+'-'+codFilial
               ChartGrpMasterVerbasCentroDeCusto(oWbevel,hData,hDataFil,lOpenModal)
               :create()
             end

         next hRowFil

         :Create()

      end

       if (lSendPage)
         :lValign    := .F.
         :lContainer := .F.
         oCgi:SendPage( :Create() )
       endif

   END

   __GrpMasterVerbasCentroDeCusto(.F.,hFilter)

   RETURN

static function ChartGrpMasterVerbasCentroDeCusto(oParent,hData,hDataFil,lOpenModal)

   local aData

   local aChartData:=Array(0)
   local aCharLabels:=Array(0)
   local aCharColors:=Array(0)

   local valor

   local cHTML

   local codGrupo
   local codFilial
   local codCentroDeCusto

   local cHtmlColor

   local ckeyProc
   local hkeyProc

   local hRow
   local hRowFil

   local cIDParameters

   local descFilial
   local descCentroDeCusto

   local cIDModal
   local cJSONModal
   local hJSONModal

   local nID
   local nData
   local nATFilial

   local owRTabs

   local oWPanel

   local oWLabel

   local oWBevel
   local oWBevel0
   local oWBevel1
   local oWBevel2
   local oWBevel3
   local oWBevel4

   local oWBevelModal

   cHTML:=""

   hkeyProc:={=>}

   for each hRowFil in hData["data"]
      ckeyProc:=hRowFil["codFilial"]
      ckeyProc+=hRowFil["codCentroDeCusto"]
      if (HB_HPos(hkeyProc,ckeyProc)==0)
         hkeyProc[ckeyProc]:=Array(0)
      endif
      aAdd(hkeyProc[ckeyProc],hRowFil)
   next hRowFil

   HB_HClear(hData)

   with object oWBevel:=WBevel():New(oParent)
      with object owRTabs:=wRTabs():New(oWBevel)
         :cId:="ChartTotaisGrpMasterVerbasCentroDeCusto"
         :cId+=__AutoID()
         for each ckeyProc in hb_HKeys(hkeyProc)
            aData:=hkeyProc[ckeyProc]
            codFilial:=aData[1]["codFilial"]
            codCentroDeCusto:=aData[1]["codCentroDeCusto"]
            descCentroDeCusto:=aData[1]["descCentroDeCusto"]
            with object WItemTabs():New(owRTabs)
               :cFolder:=owRTabs:cId+'-'+codFilial+'-'+codCentroDeCusto
               :cTitle:=codCentroDeCusto
               aData[1]["tabID"]:=:cFolder
               :create()
            end
        next ckeyProc
        :Create()
      end

      for each ckeyProc in hb_HKeys(hkeyProc)

         aSize(aCharLabels,0)
         aSize(aCharColors,0)
         aSize(aChartData,0)

         aData:=hkeyProc[ckeyProc]

         codFilial:=aData[1]["codFilial"]
         codCentroDeCusto:=aData[1]["codCentroDeCusto"]
         descCentroDeCusto:=aData[1]["descCentroDeCusto"]

         nATFilial:=aScan(hDataFil["data"],{|x|x["codFilial"]==codFilial})
         descFilial:=hDataFil["data"][nATFilial]["descFilial"]

         With Object oWBevel0:=WBevel():New(oParent)

            :cId:=aData[1]["tabID"]

            With Object oWLabel:=WLabel():New(oWBevel0)
               :AutoID()
               :nHeaderSize:=6
               :nFontSize:=12
               :lBR:=.T.
               :lBold:=.T.
               :cAlign:=xc_Left
               :cText:="<h12>"
               :cText+="C.Custo: "
               :cText+=codCentroDeCusto
               :cText+="-"
               :cText+=descCentroDeCusto
               :cText+="</h12>"
               :Create()
            End With //oWLabel

            With Object oWBevel1:=WBevel():New(oWBevel0)

             :AutoID()

             nData:=Len(aData)
             for nID:=1 to nData

                With Object oWBevel2:=WBevel():New(oWBevel1)

                   :AutoID()

                   :aWidth[xc_M]:=3
                   :aWidth[xc_L]:=2

                   valor:=aData[nID]["total"]
                   codGrupo:=aData[nID]["codGrupo"]

                   aAdd(aChartData,Val(strTran(valor,",","")))
                   cHtmlColor:=RGBToHTML(rgb(hb_RandomInt(0,255),hb_RandomInt(0,255),hb_RandomInt(0,255)))
                   aAdd(aCharColors,cHtmlColor)

                   With Object oWPanel:=WPanel():New(oWBevel2)

                      :AutoID()

                      With Object oWBevel3:=WBevel():New(oWPanel)

                         :AutoID()
                         :cId+=ckeyProc

                         :cTitle:=aData[nID]["descGrupo"]//codGrupo+"-"+aData[nID]["descGrupo"]
                         AAdd(aCharLabels,:cTitle)

                         :nFontTitle := 10

                         :cTitleAlign:=xc_Center

                         if (lOpenModal)

                            cIDModal:="ChartTotaisGrpMasterVerbasCentroDeCusto"
                            cIDModal+="_"
                            cIDModal:=Lower(cIDModal)

                            hJSONModal:=HB_HClone(aData[nID])
                            HB_HDel(hJSONModal,"total")
                            HB_HDel(hJSONModal,"descGrupo")
                            HB_HDel(hJSONModal,"descCentroDeCusto")
                            cJSONModal:=HB_JsonEncode(hJSONModal,.F.)
                            cJSONModal:=__base64Encode(cJSONModal)

                            :oStyle:cCursor:="pointer"

                            if (.F.)
                               :cOnClick:=nfl_OpenModal(cIDModal,.F.)
                               WITH OBJECT oWBevelModal:=WBevel():New(oWBevel3)
                                  :AutoID()
                                  :cId+=cIDModal
                                  :nStyle:=xc_ModalBottom
                                  :cModalHeight:="90%"
                                  :cModalWidth:="100%"
                                  :cOnClick:=StrTran("#autoformID('"+cJSONModal+"','?FUNCTION=__GrpMasterVerbasCentroDeCusto@cIDModalTotaisGrpMasterVerbasCentroDeCusto="+cJSONModal+"','_parent',true);","@","&")
                                  :Create()
                               END WITH //oWBevelModal
                            else
                               //to decode: __GrpVerbasEmpresa __base64Decode(cJSONModal)
                               :cOnClick:=StrTran("#autoformID('"+cJSONModal+"','?FUNCTION=__GrpMasterVerbasCentroDeCusto@cIDModalTotaisGrpMasterVerbasCentroDeCusto="+cJSONModal+"','_parent',true);","@","&")
                            endif

                         endif

                         :Create()

                      End With //oWBevel3

                      With Object oWBevel4:=WBevel():New(oWPanel)

                         :AutoID()
                         :cId+=ckeyProc

                         With Object oWLabel:=WLabel():New(oWBevel4)
                            :AutoID()
                            :cId+=ckeyProc
                            :nHeaderSize:=6
                            :nFontSize:=10
                            :lBR:=.T.
                            :lBold:=.T.
                            :cAlign:=xc_Center
                            :cText:="<strong><b>"+valor+"</b></strong>"
                            :Create()
                         End With //oWLabel

                         :Create()

                      End With //oWBevel4

                      :Create()

                   End With //oWPanel

                   :Create()

                End With //oWBevel2

             next nID

             :Create()

            End With //oWBevel1

            With Object oWPanel:=WPanel():New(oWBevel0)

               :aWidth[xc_L]   := 12
               :aOffSet[xc_L]  := 0

               With Object wChartJS():New(oWPanel)
                   :cType:="bar"
                   :cID:="ChartTotaisGrpMasterVerbasCentroDeCusto"+strTran(ckeyProc,".","_")
                   :cLabels:=HB_JsonEncode(aCharLabels)
                   :cLabel:=""
                   :cBackColor:=HB_JsonEncode(aCharColors)
                   :cData:=HB_JsonEncode(aChartData)
                   :cTitle:=""
                   :cWidth:="800px"
                   :cHeight:="100px"
                   :Create()
               End With //wChartJS():New(oWPanel)

               :Create()

            End With //oWPanel:=WPanel():New(oWBevel0)

            :Create()

            cHTML+=:cHTML

         End With //oWBevel0

      next ckeyProc

      :Create()

      cHTML+=:cHTML

   end

   oParent:cHTML+=cHTML

return(cHTML)

PROCEDURE ChartTotaisGrpMasterVerbasCentroDeCusto()

   local hUser := LoginUser()

   local cSubTitle:=" :: "+"Consulta dos Dados Totais Por Centro De Custo/Grupo de Verbas"
   local cTitle:=AppData:AppTitle+cSubTitle
   local cIDParameters
   local aParameters

   oCGI:SetUserData("__ChartTotaisGrpMasterVerbasCentroDeCusto:Back",ProcName())

   WITH OBJECT wTWebPage():New()

      :cTitle:=cTitle

      AppMenu(:WO,AppData:AppName,hUser,.F.)

      aParameters:={"codPeriodo","codGrupo","codFilial","codCentroDeCusto"}
      cSubTitle=AppData:AppName+cSubTitle
      GEPParameters(:WO,@cIDParameters,"__ChartTotaisGrpMasterVerbasCentroDeCusto",aParameters,.T.,cSubTitle,.T.):Create()

      :lValign    := .F.
      :lContainer := .F.

      oCgi:SendPage( :Create() )

   END

RETURN