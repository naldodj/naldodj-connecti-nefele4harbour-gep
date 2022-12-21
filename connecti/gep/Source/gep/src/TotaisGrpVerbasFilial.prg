 * Proyecto: GEP
/*
 * Fichero: TotaisGrpVerbasFilial.prg
 * Descripción:
 * Autor:
 * Fecha: 14/08/2021
 */

#include "Xailer.ch"
#include "Nefele.ch"
#include "LangCGI.ch"

PROCEDURE __TotaisGrpVerbasFilial(oTWebPage,lOpenModal,lSendPage)

   local hUser := LoginUser()

   local hRow
   local hData
   local hRowFil
   local hDataFil

   local cTitle:=AppData:AppTitle+" :: "+"Consulta dos Dados Totais Por Filial/Sub-Grupo de Verbas"

   local cFilter
   local cIDParameters
   local aParameters

   local valor
   local codGrupo
   local codFilial
   local codPeriodo

   local cIDModal
   local cJSONModal
   local hJSONModal

   local hFilter

   local oWPanel

   local oWLabel

   local oWBevel0
   local oWBevel1
   local oWBevel2
   local oWBevel3
   local oWBevel4

   local oWBevelModal

   oCGI:SetUserData("lGrpViewTotais",.T.)

   if (!stacktools():IsInCallStack("__GrpVerbasFilial"))
      deleteTmpParameters("__GrpVerbasFilial")
   endif

   oCGI:SetUserData( "GrpVerbasFilial:Back",ProcName() )

   hFilter:=__GrpVerbasFilial(.F.)

   codGrupo:=oCGI:GetUserData("__GrpVerbasFilial:codGrupo",codGrupo)
   codFilial:=oCGI:GetUserData("__GrpVerbasFilial:codFilial",codFilial)
   codPeriodo:=oCGI:GetUserData("__GrpVerbasFilial:codPeriodo",codPeriodo)

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
            :cOnClick := oCGI:GetUserData( ProcName() + ":Back","MAINFUNCTION" )
            :Create()
         END WITH

      endif

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

      for each hRowFil in hDataFil["data"]

         codFilial:=hRowFil["codFilial"]

         oCGI:SetUserData("__GrpVerbasFilial:codFilial",codFilial)

         hData:=GetDataGRPVerbasFilial(.F.,.T.)

         IF (Empty(hData["data"]))
            loop
         endif

         With Object oWBevel0:=WBevel():New(oTWebPage)

            With Object oWLabel:=WLabel():New(oWBevel0)
               :nHeaderSize:=6
               :nFontSize:=12
               :lBR:=.T.
               :lBold:=.T.
               :cAlign:=xc_Left
               :cText:="<h12>"
               :cText+="Filial: "
               :cText+=codFilial
               :cText+="-"
               :cText+=hRowFil["descFilial"]
               :cText+="</h12>"
               :Create()
            End With

            With Object oWBevel1:=WBevel():New(oWBevel0)

               for each hRow in hData["data"]
                  valor:=AllTrim(hRow["valor"])
                  With Object oWBevel2:=WBevel():New(oWBevel1)
                      :aWidth[xc_M]:=3
                      :aWidth[xc_L]:=2
                     With Object oWPanel:=WPanel():New(oWBevel2)
                        With Object oWBevel3:=WBevel():New(oWPanel)
                           :cId:=__AutoID()
                           :cId+=hRow["codFilial"]+hRow["codPeriodo"]+hRow["codGrupo"]
                           :cTitle:=hRow["descGrupo"]//hRow["codGrupo"]+"-"+hRow["descGrupo"]
                           :nFontTitle := 10
                           :cTitleAlign:=xc_Center

                           if (lOpenModal)

                              cIDModal:="TotaisGrpVerbasFilial"
                              cIDModal+="_"
                              cIDModal+=hRow["codPeriodo"]
                              cIDModal+="_"
                              cIDModal+=hRow["codFilial"]
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
                                    :cId:=cIDModal
                                    :nStyle:=xc_ModalBottom
                                    :cModalHeight:="90%"
                                    :cModalWidth:="100%"
                                    :cOnClick:=StrTran("#autoformID('"+cJSONModal+"','?FUNCTION=__GrpVerbasFilial@cIDModalTotaisGrpVerbasFilial="+cJSONModal+"','_parent',true);","@","&")
                                    :Create()
                                 END
                              else
                                 //to decode: __GrpVerbasEmpresa __base64Decode(cJSONModal)
                                 :cOnClick:=StrTran("#autoformID('"+cJSONModal+"','?FUNCTION=__GrpVerbasFilial@cIDModalTotaisGrpVerbasFilial="+cJSONModal+"','_parent',true);","@","&")
                              endif

                           endif
                           :Create()
                        End With

                        With Object oWBevel4:=WBevel():New(oWPanel)
                           With Object oWLabel:=WLabel():New(oWBevel4)
                              :nHeaderSize:=6
                              :nFontSize:=10
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

               next hRow

               :Create()

            End With

            :Create()

         End With

      next hRowFil

      if (lSendPage)
         :lValign    := .F.
         :lContainer := .F.
         oCgi:SendPage( :Create() )
      endif

   END

   __GrpVerbasFilial(.F.,hFilter)

   RETURN

PROCEDURE TotaisGrpVerbasFilial()

   local hUser := LoginUser()

   local cSubTitle:=" :: "+"Consulta dos Dados Totais Por Filial/Sub-Grupo de Verbas"
   local cTitle:=AppData:AppTitle+cSubTitle
   local cIDParameters
   local aParameters

   oCGI:SetUserData( "__TotaisGrpVerbasFilial:Back",ProcName() )

   WITH OBJECT wTWebPage():New()

      :cTitle:=cTitle

      AppMenu(:WO,AppData:AppName,hUser,.F.)

      aParameters:={"codPeriodo","codGrupo","codFilial"}
      cSubTitle:=AppData:AppName+cSubTitle
      GEPParameters(:WO,@cIDParameters,"__TotaisGrpVerbasFilial",aParameters,.T.,cSubTitle,.T.):Create()

      :lValign    := .F.
      :lContainer := .F.

      oCgi:SendPage( :Create() )

   END

RETURN