 * Proyecto: GEP
/*
 * Fichero: ChartTotaisGrpVerbasFuncao.prg
 * Descripción:
 * Autor:
 * Fecha: 14/08/2021
 */

#include "Xailer.ch"
#include "Nefele.ch"
#include "LangCGI.ch"

PROCEDURE __ChartTotaisGrpVerbasFuncao(oTWebPage,lOpenModal,lSendPage)

   local hUser := LoginUser()

   local hData
   local hFilter
   local hRowFil
   local hDataFil

   local cTitle:=AppData:AppTitle+" :: "+"Consulta dos Dados Totais Por Centro De Custo/Função/Sub-Grupo de Verbas"

   local cFilter

   local codVerba
   local codGrupo
   local codFilial
   local codFuncao
   local codPeriodo
   local codCentroDeCusto

   Local owRTabs
   local oWLabel
   local oWbevel
   local oWBevel0

   deleteTmpParameters("__GrpVerbasFuncao")
   oCGI:SetUserData( "GrpVerbasFuncao:Back",ProcName() )

   IF (oCGI:GetUserData("__ChartTotaisGrpVerbasFuncao:SaveParameters",.F.))
      hFilter:=__GrpVerbasFuncao(.F.)
      oCGI:SetUserData("__ChartTotaisGrpVerbasFuncao:SaveParameters",.F.)
      saveTmpParameters("__ChartTotaisGrpVerbasFuncao",hFilter)
   ELSE
      restoreTmpParameters("__ChartTotaisGrpVerbasFuncao",@hFilter,.F.)
      setUserDataTmpParameters("__GrpVerbasFuncao",hFilter,.T.)
   ENDIF

   codGrupo:=oCGI:GetUserData("__GrpVerbasFuncao:codGrupo",codGrupo)
   codVerba:=oCGI:GetUserData("__GrpVerbasFuncao:codVerba",codVerba)
   codFuncao:=oCGI:GetUserData("__GrpVerbasFuncao:codFuncao",codFuncao)
   codFilial:=oCGI:GetUserData("__GrpVerbasFuncao:codFilial",codFilial)
   codPeriodo:=oCGI:GetUserData("__GrpVerbasFuncao:codPeriodo",codPeriodo)
   codCentroDeCusto:=oCGI:GetUserData("__GrpVerbasFuncao:codCentroDeCusto",codCentroDeCusto)

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

    oCGI:SetUserData("__CadastroFiliais:codFilial",codFilial)
    hDataFil:=GetDataCadastroFiliais(.F.,.T.,cFilter)
    oCGI:SetUserData("__CadastroFiliais:codFilial","")

    With Object oWBevel0:=WBevel():New(oTWebPage)

      with object owRTabs:=wRTabs():New(oWBevel0)

           :cId:="Tabs_ChartTotaisGrpVerbasFuncao"

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

                 if (!Empty(codFuncao))
                    if (!Empty(cFilter))
                       cFilter+=" AND "
                    endif
                    cFilter+="ZY__CODIGO='"+codFuncao+"'"
                 endif

                 if (!Empty(cFilter))
                    cFilter:="SQL:"+cFilter
                 endif

                 oCGI:SetUserData("__GrpVerbasFuncao:codGrupo",codGrupo)
                 oCGI:SetUserData("__GrpVerbasFuncao:codFuncao",codFuncao)
                 oCGI:SetUserData("__GrpVerbasFuncao:codFilial",codFilial)
                 oCGI:SetUserData("__GrpVerbasFuncao:codPeriodo",codPeriodo)
                 oCGI:SetUserData("__GrpVerbasFuncao:codCentroDeCusto",codCentroDeCusto)

                 hData:=GetDataTotaisGrpVerbasFuncao(.F.,.T.,cFilter)

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

              if (!Empty(codFuncao))
                 if (!Empty(cFilter))
                    cFilter+=" AND "
                 endif
                 cFilter+="ZY__CODIGO='"+codFuncao+"'"
              endif

              if (!Empty(codFuncao))
                 if (!Empty(cFilter))
                    cFilter+=" AND "
                 endif
                 cFilter+="RJ_FUNCAO='"+codFuncao+"'"
              endif

              if (!Empty(cFilter))
                 cFilter:="SQL:"+cFilter
              endif

              oCGI:SetUserData("__GrpVerbasFuncao:codGrupo",codGrupo)
              oCGI:SetUserData("__GrpVerbasFuncao:codFuncao",codFuncao)
              oCGI:SetUserData("__GrpVerbasFuncao:codFilial",codFilial)
              oCGI:SetUserData("__GrpVerbasFuncao:codPeriodo",codPeriodo)
              oCGI:SetUserData("__GrpVerbasFuncao:codCentroDeCusto",codCentroDeCusto)

              hData:=GetDataTotaisGrpVerbasFuncao(.F.,.T.,cFilter)

              IF (Empty(hData["data"]))
                loop
              endif

             with object oWbevel:=WBevel():New(oWBevel0)
               :cID:=owRTabs:cId+'-'+codFilial
               ChartGrpVerbasFuncao(oWbevel,hData,hDataFil,lOpenModal)
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

   __GrpVerbasFuncao(.F.,hFilter)

   RETURN

static function ChartGrpVerbasFuncao(oParent,hData,hDataFil,lOpenModal)

  local aData

  local aChartData:=Array(0)
  local aCharLabels:=Array(0)
  local aCharColors:=Array(0)

  local aParameters

  local valor

  local cHTML

  local codGrupo
  local codFilial
  local codFuncao
  local codCentroDeCusto

  local cHtmlColor

  local ckeyProc
  local hkeyProc

  local hRow
  local hRowFil

  local cIDParameters

  local descFilial
  local descFuncao
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
    ckeyProc+=hRowFil["codFuncao"]
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
            codFuncao:=aData[1]["codFuncao"]
            codCentroDeCusto:=aData[1]["codCentroDeCusto"]
            descCentroDeCusto:=aData[1]["descCentroDeCusto"]
            with object WItemTabs():New(owRTabs)
               :cFolder:=owRTabs:cId+'-'+codFilial+'-'+codCentroDeCusto+'-'+codFuncao
               :cTitle:=codCentroDeCusto+'-'+codFuncao
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
       codFuncao:=aData[1]["codFuncao"]
       descFuncao:=aData[1]["descFuncao"]
       codCentroDeCusto:=aData[1]["codCentroDeCusto"]
       descCentroDeCusto:=aData[1]["descCentroDeCusto"]

       nATFilial:=aScan(hDataFil["data"],{|x|x["codFilial"]==codFilial})
       descFilial:=hDataFil["data"][nATFilial]["descFilial"]

       With Object oWBevel0:=WBevel():New(oWBevel)

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
             :cText+=" | Funcao: "
             :cText+=codFuncao
             :cText+="-"
             :cText+=descFuncao
             :cText+="</h12>"
             :Create()
          End With

          With Object oWBevel1:=WBevel():New(oWBevel0)

             :AutoID()

             nData:=Len(aData)
             for nID:=1 to nData

                With Object oWBevel2:=WBevel():New(oWBevel1)

                   :AutoID()

                  :aWidth[xc_M]:=3
                  :aWidth[xc_L]:=2

                   valor:=AllTrim(aData[nID]["valor"])
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

                            cIDModal:="TotaisGrpVerbasFuncao"
                            cIDModal+="_"
                            cIDModal:=Lower(cIDModal)

                            hJSONModal:=HB_HClone(aData[nID])
                            HB_HDel(hJSONModal,"valor")
                            HB_HDel(hJSONModal,"descGrupo")
                            HB_HDel(hJSONModal,"descGrupoHTML")
                            HB_HDel(hJSONModal,"descFuncao")
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
                                  :cOnClick:=StrTran("#autoformID('"+cJSONModal+"','?FUNCTION=__GrpVerbasFuncao@cIDModalTotaisGrpVerbasFuncao="+cJSONModal+"','_parent',true);","@","&")
                                  :Create()
                               END WITH //oWBevelModal
                            else
                               //to decode: __GrpVerbasEmpresa __base64Decode(cJSONModal)
                               :cOnClick:=StrTran("#autoformID('"+cJSONModal+"','?FUNCTION=__GrpVerbasFuncao@cIDModalTotaisGrpVerbasFuncao="+cJSONModal+"','_parent',true);","@","&")
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
                   :cID:="ChartTotaisGrpVerbasFuncao"+strTran(ckeyProc,".","_")
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

    :create()

    cHTML+=:cHTML

  end

 oParent:cHTML+=cHTML

return(cHTML)

PROCEDURE ChartTotaisGrpVerbasFuncao()

   local hUser := LoginUser()

   local cSubTitle:=" :: "+"Consulta dos Dados Totais Por Centro De Custo/Função/Sub-Grupo de Verbas"
   local cTitle:=AppData:AppTitle+cSubTitle
   local cIDParameters
   local aParameters

   oCGI:SetUserData("__ChartTotaisGrpVerbasFuncao:Back",ProcName())
   oCGI:SetUserData("__ChartTotaisGrpVerbasFuncao:SaveParameters",.T.)

   WITH OBJECT wTWebPage():New()

      :cTitle:=cTitle

      AppMenu(:WO,AppData:AppName,hUser,.F.)

      aParameters:={"codPeriodo","codGrupo","codFilial","codCentroDeCusto","codFuncao"}
      cSubTitle:=AppData:AppName+cSubTitle
      GEPParameters(:WO,@cIDParameters,"__ChartTotaisGrpVerbasFuncao",aParameters,.T.,cSubTitle,.T.):Create()

      :lValign    := .F.
      :lContainer := .F.

      oCgi:SendPage( :Create() )

   END

RETURN