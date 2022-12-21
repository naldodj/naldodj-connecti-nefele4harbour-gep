 * Proyecto: GEP
/*
 * Fichero: TotaisGrpVerbasFilialDet.prg
 * Descripción:
 * Autor:
 * Fecha: 14/08/2021
 */

#include "Xailer.ch"
#include "Nefele.ch"
#include "LangCGI.ch"

PROCEDURE __TotaisGrpVerbasFilialDet(lGrpViewTotais)
   HB_Default(@lGrpViewTotais,oCGI:GetUserData("lGrpViewTotais",.F.))
   __GrpVerbasFilial()
   RETURN

function TotaisGrpVerbasFilialDet(lGrpViewTotais)
   HB_Default(@lGrpViewTotais,.T.)
   oCGI:SetUserData("lGrpViewTotais",lGrpViewTotais)
return(ParametersGrpVerbasFilialDet(lGrpViewTotais))

PROCEDURE ParametersGrpVerbasFilialDet(lGrpViewTotais)

   local hUser := LoginUser()

   local cSubTitle:=" :: "+"Consulta dos Dados Totais Por Filial/Sub-Grupo de Verbas"
   local cTitle:=AppData:AppTitle+cSubTitle
   local cIDParameters
   local aParameters

   HB_Default(@lGrpViewTotais,.F.)

   IF (!lGrpViewTotais)
      lGrpViewTotais:=oCGI:GetUserData("GrpVerbasFilial:Back:lGrpViewTotais",oCGI:GetUserData("lGrpViewTotais",lGrpViewTotais))
   ENDIF

   oCGI:SetUserData("lGrpViewTotais",lGrpViewTotais)

   oCGI:SetUserData("GrpVerbasFilial:Back",ProcName())
   oCGI:SetUserData("GrpVerbasFilial:Back:lGrpViewTotais",lGrpViewTotais)

   WITH OBJECT wTWebPage():New()

      :cTitle:=cTitle

      AppMenu(:WO,AppData:AppName,hUser,.F.)

      aParameters:={"codPeriodo","codGrupo","codFilial"}
      cSubTitle:=AppData:AppName+cSubTitle
      GEPParameters(:WO,@cIDParameters,"__TotaisGrpVerbasFilialDet",aParameters,.T.,cSubTitle,.T.):Create()

      :lValign    := .F.
      :lContainer := .F.

      oCgi:SendPage( :Create() )

   END

RETURN