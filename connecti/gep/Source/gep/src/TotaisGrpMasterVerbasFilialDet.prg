 * Proyecto: GEP
/*
 * Fichero: TotaisGrpMasterVerbasFilialDet.prg
 * Descripción:
 * Autor:
 * Fecha: 14/08/2021
 */

#include "Xailer.ch"
#include "Nefele.ch"
#include "LangCGI.ch"

PROCEDURE __TotaisGrpMasterVerbasFilialDet(lGrpViewTotais)
   HB_Default(@lGrpViewTotais,oCGI:GetUserData("lGrpViewTotais",.F.))
  __GrpMasterVerbasFilial()
   RETURN

function TotaisGrpMasterVerbasFilialDet(lGrpViewTotais)
   HB_Default(@lGrpViewTotais,.T.)
   oCGI:SetUserData("lGrpViewTotais",lGrpViewTotais)
return(ParametersGrpMasterVerbasFilialDet(lGrpViewTotais))

PROCEDURE ParametersGrpMasterVerbasFilialDet(lGrpViewTotais)

   local hUser := LoginUser()

   local cSubTitle:=" :: "+"Consulta dos Dados Totais Por Filial/Grupo de Verbas"
   local cTitle:=AppData:AppTitle+cSubTitle
   local cIDParameters
   local aParameters

   HB_Default(@lGrpViewTotais,.F.)

   IF (!lGrpViewTotais)
      lGrpViewTotais:=oCGI:GetUserData("GrpMasterVerbasFilial:Back:lGrpViewTotais",oCGI:GetUserData("lGrpViewTotais",lGrpViewTotais))
   ENDIF

   oCGI:SetUserData("lGrpViewTotais",lGrpViewTotais)

   oCGI:SetUserData("GrpMasterVerbasFilial:Back",ProcName())
   oCGI:SetUserData("GrpMasterVerbasFilial:Back:lGrpViewTotais",lGrpViewTotais)

   WITH OBJECT wTWebPage():New()

      :cTitle:=cTitle

      AppMenu(:WO,AppData:AppName,hUser,.F.)

      aParameters:={"codPeriodo","codGrupo","codFilial"}
      cSubTitle:=AppData:AppName+cSubTitle
      GEPParameters(:WO,@cIDParameters,"__TotaisGrpMasterVerbasFilialDet",aParameters,.T.,cSubTitle,.T.):Create()

      :lValign    := .F.
      :lContainer := .F.

      oCgi:SendPage( :Create() )

   END

RETURN