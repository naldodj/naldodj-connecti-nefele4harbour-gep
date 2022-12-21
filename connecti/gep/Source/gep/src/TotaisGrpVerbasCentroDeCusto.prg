 * Proyecto: GEP
/*
 * Fichero: TotaisGrpVerbasCentroDeCusto.prg
 * Descripción:
 * Autor:
 * Fecha: 14/08/2021
 */

#include "Xailer.ch"
#include "Nefele.ch"
#include "LangCGI.ch"

PROCEDURE __TotaisGrpVerbasCentroDeCusto(oTWebPage,lOpenModal,lSendPage)

   local aData

   local hUser := LoginUser()

   local hRow
   local hData
   local hRowFil
   local hDataFil

   local ckeyProc
   local hkeyProc

   local cTitle:=AppData:AppTitle+" :: "+"Consulta dos Dados Totais Por Centro De Custo/Sub-Grupo de Verbas"

   local cFilter
   local cIDParameters
   local aParameters

   local valor
   local codGrupo
   local codFilial
   local codPeriodo
   local codCentroDeCusto

   local descFilial
   local descCentroDeCusto

   local cIDModal
   local cJSONModal
   local hJSONModal

   local nID
   local nData
   local nATFilial

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

   if (!stacktools():IsInCallStack("__GrpVerbasCentroDeCusto"))
      deleteTmpParameters("__GrpVerbasCentroDeCusto")
   endif

   oCGI:SetUserData( "GrpVerbasCentroDeCusto:Back",ProcName() )

   IF (oCGI:GetUserData("__TotaisGrpVerbasCentroDeCusto:SaveParameters",.F.))
      hFilter:=__GrpVerbasCentroDeCusto(.F.)
      oCGI:SetUserData("__TotaisGrpVerbasCentroDeCusto:SaveParameters",.F.)
      saveTmpParameters("__TotaisGrpVerbasCentroDeCusto",hFilter)
   ELSE
      restoreTmpParameters("__TotaisGrpVerbasCentroDeCusto",@hFilter,.F.)
   ENDIF

   setUserDataTmpParameters("__GrpVerbasCentroDeCusto",hFilter,.T.)

   codGrupo:=oCGI:GetUserData("__GrpVerbasCentroDeCusto:codGrupo",codGrupo)
   codFilial:=oCGI:GetUserData("__GrpVerbasCentroDeCusto:codFilial",codFilial)
   codPeriodo:=oCGI:GetUserData("__GrpVerbasCentroDeCusto:codPeriodo",codPeriodo)
   codCentroDeCusto:=oCGI:GetUserData("__GrpVerbasCentroDeCusto:codCentroDeCusto",codCentroDeCusto)

   HB_Default(@oTWebPage,wTWebPage():New())
   HB_Default(@lOpenModal,.T.)
   HB_Default(@lSendPage,.T.)

   AppData:cEmp:=oCGI:GetUserData("cEmp",AppData:cEmp)

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

      hData:=GetDataTotaisGrpVerbasCentroDeCusto(.F.,.T.,cFilter)

      IF (!Empty(hData))

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

         for each ckeyProc in hb_HKeys(hkeyProc)

            aData:=hkeyProc[ckeyProc]

            codFilial:=aData[1]["codFilial"]
            codCentroDeCusto:=aData[1]["codCentroDeCusto"]
            descCentroDeCusto:=aData[1]["descCentroDeCusto"]

            nATFilial:=aScan(hDataFil["data"],{|x|x["codFilial"]==codFilial})
            descFilial:=hDataFil["data"][nATFilial]["descFilial"]

            With Object oWBevel0:=WBevel():New(oTWebPage)

               :AutoID()

               With Object oWLabel:=WLabel():New(oWBevel0)
                  :AutoID()
                  :nHeaderSize:=6
                  :nFontSize:=12
                  :lBR:=.T.
                  :lBold:=.T.
                  :cAlign:=xc_Left
                  :cText:="<h12>"
                  :cText+="Filial: "
                  :cText+=codFilial
                  :cText+="-"
                  :cText+=descFilial
                  :cText+=" | C.Custo: "
                  :cText+=codCentroDeCusto
                  :cText+="-"
                  :cText+=descCentroDeCusto
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

                        valor:=aData[nID]["valor"]
                        codGrupo:=aData[nID]["codGrupo"]

                        With Object oWPanel:=WPanel():New(oWBevel2)

                           :AutoID()

                           With Object oWBevel3:=WBevel():New(oWPanel)

                              :AutoID()
                              :cId+=ckeyProc

                              :cTitle:=aData[nID]["descGrupo"]//codGrupo+"-"+aData[nID]["descGrupo"]

                              :nFontTitle := 10

                              :cTitleAlign:=xc_Center

                              if (lOpenModal)

                                 cIDModal:="TotaisGrpVerbasCentroDeCusto"
                                 cIDModal+="_"
                                 cIDModal:=Lower(cIDModal)

                                 hJSONModal:=HB_HClone(aData[nID])
                                 HB_HDel(hJSONModal,"valor")
                                 HB_HDel(hJSONModal,"descGrupo")
                                 HB_HDel(hJSONModal,"descGrupoHTML")
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
                                       :cOnClick:=StrTran("#autoformID('"+cJSONModal+"','?FUNCTION=__GrpVerbasCentroDeCusto@cIDModalTotaisGrpVerbasCentroDeCusto="+cJSONModal+"','_parent',true);","@","&")
                                       :Create()
                                    END WITH //oWBevelModal
                                 else
                                    //to decode: __GrpVerbasEmpresa __base64Decode(cJSONModal)
                                    :cOnClick:=StrTran("#autoformID('"+cJSONModal+"','?FUNCTION=__GrpVerbasCentroDeCusto@cIDModalTotaisGrpVerbasCentroDeCusto="+cJSONModal+"','_parent',true);","@","&")
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
                                 :cText:=aData[nID]["valor"]
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

               :Create()

            End With //oWBevel0

         next ckeyProc

      endif

      if (lSendPage)
         :lValign    := .F.
         :lContainer := .F.
         oCgi:SendPage( :Create() )
      endif

   END

   __GrpVerbasCentroDeCusto(.F.,hFilter)

   RETURN

PROCEDURE TotaisGrpVerbasCentroDeCusto()

   local hUser := LoginUser()

   local cSubTitle:=" :: "+"Consulta dos Dados Totais Por Centro De Custo/Sub-Grupo de Verbas"
   local cTitle:=AppData:AppTitle+cSubTitle
   local cIDParameters
   local aParameters

   oCGI:SetUserData("__TotaisGrpVerbasCentroDeCusto:Back",ProcName())
   oCGI:SetUserData("__TotaisGrpVerbasCentroDeCusto:SaveParameters",.T.)

   WITH OBJECT wTWebPage():New()

      :cTitle:=cTitle

      AppMenu(:WO,AppData:AppName,hUser,.F.)

      aParameters:={"codPeriodo","codGrupo","codFilial","codCentroDeCusto"}
      cSubTitle:=AppData:AppName+cSubTitle
      GEPParameters(:WO,@cIDParameters,"__TotaisGrpVerbasCentroDeCusto",aParameters,.T.,cSubTitle,.T.):Create()

      :lValign    := .F.
      :lContainer := .F.

      oCgi:SendPage( :Create() )

   END

RETURN

FUNCTION GetDataTotaisGrpVerbasCentroDeCusto(lSendJSON,lGetFull,cSearchFilter)
return(GetDataGRPVerbasCentroDeCusto(@lSendJSON,@lGetFull,@cSearchFilter))