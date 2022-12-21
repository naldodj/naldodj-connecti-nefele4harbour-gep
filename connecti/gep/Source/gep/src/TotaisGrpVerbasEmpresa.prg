 * Proyecto: GEP
/*
 * Fichero: TotaisGrpVerbasEmpresa.prg
 * Descripción:
 * Autor:
 * Fecha: 14/08/2021
 */

#include "Xailer.ch"
#include "Nefele.ch"
#include "LangCGI.ch"

PROCEDURE __TotaisGrpVerbasEmpresa(oTWebPage,lOpenModal,lSendPage)

   local hUser := LoginUser()

   local aChartData:=Array(0)
   local aCharLabels:=Array(0)
   local aCharColors:=Array(0)

   local hRow
   local hData

   local cTitle:=AppData:AppTitle+" :: "+"Consulta dos Dados Totais Por Empresa/Sub-Grupo de Verbas"
   local cIDParameters
   local aParameters

   local valor
   local codGrupo
   local codPeriodo

   local cHtmlColor

   local cIDModal
   local cJSONModal
   local hJSONModal

   local oWPanel

   local oWLabel

   local oWBevel0
   local oWBevel1
   local oWBevel2
   local oWBevel3
   local oWBevel4

   local oWBevelModal

   local hFilter

   oCGI:SetUserData("lGrpViewTotais",.T.)

   if (!stacktools():IsInCallStack("__GRPVERBASEMPRESA"))
      deleteTmpParameters("__GrpVerbasEmpresa")
   endif

   oCGI:SetUserData("GrpVerbasEmpresa:Back",ProcName())

   hFilter:=__GrpVerbasEmpresa(.F.)

   codGrupo:=oCGI:GetUserData("__GrpVerbasEmpresa:codGrupo",codGrupo)
   codPeriodo:=oCGI:GetUserData("__GrpVerbasEmpresa:codPeriodo",codPeriodo)

   HB_Default(@oTWebPage,wTWebPage():New())
   HB_Default(@lOpenModal,.T.)
   HB_Default(@lSendPage,.T.)

   WITH OBJECT oTWebPage

      :cCSS+="h10 {font-size: 12px; font-weight: lighter; font-family: -apple-system,BlinkMacSystemFont,'Segoe UI',Roboto,Oxygen-Sans,Ubuntu,Cantarell,'Helvetica Neue',sans-serif; !important;}"
      :cCSS+="h12 {font-size: 14px; font-weight: bold; font-family: -apple-system,BlinkMacSystemFont,'Segoe UI',Roboto,Oxygen-Sans,Ubuntu,Cantarell,'Helvetica Neue',sans-serif; !important;}"

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

      hData:=GetDataGrpVerbasEmpresa(.F.,.T.)

      With Object oWBevel0:=WBevel():New(oTWebPage)

         With Object oWLabel:=WLabel():New(oWBevel0)
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

         With Object oWBevel1:=WBevel():New(oWBevel0)

            for each hRow in hData["data"]
               valor:=AllTrim(hRow["valor"])
               aAdd(aChartData,Val(strTran(valor,",","")))
               cHtmlColor:=RGBToHTML(rgb(hb_RandomInt(0,255),hb_RandomInt(0,255),hb_RandomInt(0,255)))
               aAdd(aCharColors,cHtmlColor)
               With Object oWBevel2:=WBevel():New(oWBevel1)
                  switch (len(hData["data"]))
                    case 1
                        :aWidth[xc_M]:=12
                        :aWidth[xc_L]:=12
                        exit
                    case 2
                        :aWidth[xc_M]:=6
                        :aWidth[xc_L]:=6
                        exit
                    case 3
                        :aWidth[xc_M]:=6
                        :aWidth[xc_L]:=4
                        exit
                    case 4
                        :aWidth[xc_M]:=5
                        :aWidth[xc_L]:=3
                        exit
                    case 5
                      :aWidth[xc_M]:=5
                      :aWidth[xc_L]:=3
                        exit
                    otherwise
                      :aWidth[xc_M]:=3
                      :aWidth[xc_L]:=2
                 end
                  With Object oWPanel:=WPanel():New(oWBevel2)
                     With Object oWBevel3:=WBevel():New(oWPanel)
                        :cId:=__AutoID()
                        :cId+=hRow["codPeriodo"]+hRow["codGrupo"]
                        :cTitle:=hRow["descGrupo"]//hRow["codGrupo"]+"-"+hRow["descGrupo"]
                        AAdd(aCharLabels,:cTitle)
                        :nFontTitle := 10
                        :cTitleAlign:=xc_Center

                        if (lOpenModal)

                           cIDModal:="TotaisGrpVerbasEmpresa"
                           cIDModal+="_"
                           cIDModal+=hRow["codPeriodo"]
                           cIDModal+="_"
                           cIDModal+=hRow["codGrupo"]
                           cIDModal:=Lower(cIDModal)

                           hJSONModal:=HB_HClone(hRow)
                           HB_HDel(hJSONModal,"valor")
                           HB_HDel(hJSONModal,"descGrupo")
                           HB_HDel(hJSONModal,"descGrupoHTML")
                           cJSONModal:=HB_JsonEncode(hJSONModal,.F.)
                           cJSONModal:=__base64Encode(cJSONModal)

                           :oStyle:cCursor:="pointer"
                           if (.F.)
                              :cOnClick:=nfl_OpenModal(cIDModal,.F.)
                              WITH OBJECT oWBevelModal:=WBevel():New(oWBevel3)
                                 :cId:=__AutoID()
                                 :cId+=cIDModal
                                 :nStyle:=xc_ModalBottom
                                 :cModalHeight:="90%"
                                 :cModalWidth:="100%"
                                 //to decode: __GrpVerbasEmpresa __base64Decode(cJSONModal)
                                 :cOnClick:=StrTran("#autoformID('"+cJSONModal+"','?FUNCTION=__GrpVerbasEmpresa@cIDModalTotaisGrpVerbasEmpresa="+cJSONModal+"','_parent',true);","@","&")
                                 :Create()
                              END
                           else
                              //to decode: __GrpVerbasEmpresa __base64Decode(cJSONModal)
                              :cOnClick:=StrTran("#autoformID('"+cJSONModal+"','?FUNCTION=__GrpVerbasEmpresa@cIDModalTotaisGrpVerbasEmpresa="+cJSONModal+"','_parent',true);","@","&")
                           endif
                        endif
                        :Create()
                     End With
                     With Object oWBevel4:=WBevel():New(oWPanel)
                        With Object oWLabel:=WLabel():New(oWBevel4)
                           :nHeaderSize:=6
                           :nFontSize:=6
                           :lBR:=.T.
                           :lBold:=.T.
                           :cAlign:=xc_Center
                           :cText:="<strong><b>"+valor+"</b></strong>"
                           :Create()
                        End With
                        :Create()
                     End With
                     :Create()
                  End With
                  :Create()
               End With

        next

        :Create()

        end whith

        With Object oWPanel:=WPanel():New(oWBevel0)

            :aWidth[xc_L]   := 12
            :aOffSet[xc_L]  := 0

            With Object wChartJS():New(oWPanel)
                :cType:="bar"
                :cID:="TotaisGrpVerbasEmpresaBar"
                :cLabels:=HB_JsonEncode(aCharLabels)
                :cLabel:=""
                :cBackColor:=HB_JsonEncode(aCharColors)
                :cData:=HB_JsonEncode(aChartData)
                :cTitle:=""
                :cWidth:="89%"
                :cHeight:="10%"
                :Create()
            End With //wChartJS():New(oWPanel)

            :Create()

        End With //oWPanel:=WPanel():New(oWBevel0)

        :Create()

      End With

      if (lSendPage)
         :lValign    := .F.
         :lContainer := .F.
         oCgi:SendPage( :Create() )
      endif

   END

   __GrpVerbasEmpresa(.F.,hFilter)

   RETURN

PROCEDURE TotaisGrpVerbasEmpresa()

   local hUser := LoginUser()

   local cSubTitle:=" :: "+"Consulta dos Dados Totais Por Empresa/Sub-Grupo de Verbas"
   local cTitle:=AppData:AppTitle+cSubTitle
   local cIDParameters
   local aParameters

   oCGI:SetUserData("__TotaisGrpVerbasEmpresa:Back",ProcName())

   WITH OBJECT wTWebPage():New()

      :cTitle:=cTitle

      AppMenu(:WO,AppData:AppName,hUser,.F.)

      aParameters:={"codPeriodo","codGrupo"}
      cSubTitle:=AppData:AppName+cSubTitle
      GEPParameters(:WO,@cIDParameters,"__TotaisGrpVerbasEmpresa",aParameters,.T.,cSubTitle,.T.):Create()

      :lValign    := .F.
      :lContainer := .F.

      oCgi:SendPage( :Create() )

   END

RETURN