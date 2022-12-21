 * Proyecto: GEP
/*
 * Fichero: TotaisGrpVerbasFuncao.prg
 * Descripción:
 * Autor:
 * Fecha: 14/08/2021
 */

#include "Xailer.ch"
#include "Nefele.ch"
#include "LangCGI.ch"

PROCEDURE __TotaisGrpVerbasFuncao(oTWebPage,lOpenModal,lSendPage)

   local hUser := LoginUser()

   local aData

   local hRow
   local hData
   local hFilter
   local hRowFil
   local hDataFil

   local cKeyProc
   local hkeyProc

   local cTitle:=AppData:AppTitle+" :: "+"Consulta dos Dados Totais Por Centro De Custo/Função/Sub-Grupo de Verbas"

   local cFilter
   local cIDParameters
   local aParameters

   local valor
   local codVerba
   local codGrupo
   local codFilial
   local codFuncao
   local codPeriodo
   local codCentroDeCusto

   local descFuncao
   local descCentroDeCusto

   local descFilial

   local cIDModal
   local cJSONModal
   local hJSONModal

   local nID
   local nData
   local nATFilial

   local oWPanel

   local oWLabel

   local oWBevel0
   local oWBevel1
   local oWBevel2
   local oWBevel3
   local oWBevel4

   local oWBevelModal

   oCGI:SetUserData("lGrpViewTotais",.T.)

   if (!stacktools():IsInCallStack("__GrpVerbasFuncao"))
      deleteTmpParameters("__GrpVerbasFuncao")
   endif

   oCGI:SetUserData( "GrpVerbasFuncao:Back",ProcName() )

   IF (oCGI:GetUserData("__TotaisGrpVerbasFuncao:SaveParameters",.F.))
      hFilter:=__GrpVerbasFuncao(.F.)
      oCGI:SetUserData("__TotaisGrpVerbasFuncao:SaveParameters",.F.)
      saveTmpParameters("__TotaisGrpVerbasFuncao",hFilter)
   ELSE
      restoreTmpParameters("__TotaisGrpVerbasFuncao",@hFilter,.F.)
   ENDIF

   setUserDataTmpParameters("__GrpVerbasFuncao",hFilter,.T.)

   codVerba:=oCGI:GetUserData("__GrpVerbasFuncao:codGrupo",codVerba)
   codGrupo:=oCGI:GetUserData("__GrpVerbasFuncao:codGrupo",codGrupo)
   codFuncao:=oCGI:GetUserData("__GrpVerbasFuncao:codFuncao",codFuncao)
   codFilial:=oCGI:GetUserData("__GrpVerbasFuncao:codFilial",codFilial)
   codPeriodo:=oCGI:GetUserData("__GrpVerbasFuncao:codPeriodo",codPeriodo)
   codCentroDeCusto:=oCGI:GetUserData("__GrpVerbasFuncao:codCentroDeCusto",codCentroDeCusto)

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
            :cOnClick := oCGI:GetUserData( ProcName() + ":Back","MAINFUNCTION" )
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

      if (!Empty(codFuncao))
         if (!Empty(cFilter))
            cFilter+=" AND "
         endif
         cFilter+="RJ_FUNCAO='"+codFuncao+"'"
      endif

      if (!Empty(cFilter))
         cFilter:="SQL:"+cFilter
      endif

      hData:=GetDataTotaisGrpVerbasFuncao(.F.,.T.,cFilter)

      IF (!Empty(hData))

         hkeyProc:={=>}

         for each hRowFil in hData["data"]
            cKeyProc:=hRowFil["codFilial"]
            cKeyProc+=hRowFil["codCentroDeCusto"]
            cKeyProc+=hRowFil["codFuncao"]
            if (HB_HPos(hkeyProc,cKeyProc)==0)
               hkeyProc[cKeyProc]:=Array(0)
            endif
            aAdd(hkeyProc[cKeyProc],hRowFil)
         next hRowFil

         HB_HClear(hData)

         for each cKeyProc in hb_HKeys(hkeyProc)

            aData:=hkeyProc[cKeyProc]

            codFilial:=aData[1]["codFilial"]
            codFuncao:=aData[1]["codFuncao"]
            descFuncao:=aData[1]["descFuncao"]
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

                        With Object oWPanel:=WPanel():New(oWBevel2)

                           :AutoID()

                           With Object oWBevel3:=WBevel():New(oWPanel)

                              :AutoID()
                              :cId+=cKeyProc

                              :cTitle:=aData[nID]["descGrupo"]//codGrupo+"-"+aData[nID]["descGrupo"]

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
                              :cId+=cKeyProc

                              With Object oWLabel:=WLabel():New(oWBevel4)
                                 :AutoID()
                                 :cId+=cKeyProc
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

               :Create()

            End With //oWBevel0

         next cKeyProc

      endif

      if (lSendPage)
         :lValign    := .F.
         :lContainer := .F.
         oCgi:SendPage( :Create() )
      endif

   END

   __GrpVerbasFuncao(.F.,hFilter)

   RETURN

PROCEDURE TotaisGrpVerbasFuncao()

   local hUser := LoginUser()

   local cSubTitle:=" :: "+"Consulta dos Dados Totais Por Centro De Custo/Função/Sub-Grupo de Verbas"
   local cTitle:=AppData:AppTitle+cSubTitle
   local cIDParameters
   local aParameters

   oCGI:SetUserData("__TotaisGrpVerbasFuncao:Back",ProcName())
   oCGI:SetUserData("__TotaisGrpVerbasFuncao:SaveParameters",.T.)

   WITH OBJECT wTWebPage():New()

      :cTitle:=cTitle

      AppMenu(:WO,AppData:AppName,hUser,.F.)

      aParameters:={"codPeriodo","codGrupo","codFilial","codCentroDeCusto","codFuncao"}
      cSubTitle:=+AppData:AppNamecSubTitle
      GEPParameters(:WO,@cIDParameters,"__TotaisGrpVerbasFuncao",aParameters,.T.,cSubTitle,.T.):Create()

      :lValign    := .F.
      :lContainer := .F.

      oCgi:SendPage( :Create() )

   END

RETURN

FUNCTION GetDataTotaisGrpVerbasFuncao(lSendJSON,lGetFull,cSearchFilter)
return(GetDataGrpVerbasFuncao(lSendJSON,lGetFull,cSearchFilter))