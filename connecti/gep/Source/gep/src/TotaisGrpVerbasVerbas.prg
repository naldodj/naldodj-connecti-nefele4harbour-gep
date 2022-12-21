 * Proyecto: GEP
/*
 * Fichero: TotaisGrpVerbasVerbasDet.prg
 * Descripción:
 * Autor:
 * Fecha: 14/08/2021
 */

#include "Xailer.ch"
#include "Nefele.ch"
#include "LangCGI.ch"

PROCEDURE __TotaisGrpVerbasVerbasDet(lGrpViewTotais)
  HB_Default(@lGrpViewTotais,oCGI:GetUserData("lGrpViewTotais",.F.))
  oCGI:SetUserData("lGrpViewTotais",lGrpViewTotais)
  __GrpVerbasVerbas()
  RETURN

function TotaisGrpVerbasVerbasDet(lGrpViewTotais)
   HB_Default(@lGrpViewTotais,.T.)
   oCGI:SetUserData("lGrpViewTotais",lGrpViewTotais)
return(ParametersGrpVerbasVerbasDet(lGrpViewTotais))

PROCEDURE ParametersGrpVerbasVerbasDet(lGrpViewTotais)

   local hUser := LoginUser()

   local cSubTitle:=" :: "+"Consulta Dados Por Verbas/Sub-Grupo de Verbas"
   local cTitle:=AppData:AppTitle+cSubTitle
   local cIDParameters
   local aParameters

   HB_Default(@lGrpViewTotais,.F.)
   oCGI:SetUserData("lGrpViewTotais",lGrpViewTotais)

   WITH OBJECT wTWebPage():New()

      :cTitle:=cTitle

      AppMenu(:WO,AppData:AppName,hUser,.F.)

      aParameters:={"codPeriodo","codGrupo","codFilial","codCentroDeCusto","codFuncao","codVerba"}
      cSubTitle:=AppData:AppName+cSubTitle
      GEPParameters(:WO,@cIDParameters,"__TotaisGrpVerbasVerbasDet",aParameters,.T.,cSubTitle,.T.):Create()

      :lValign    := .F.
      :lContainer := .F.

      oCgi:SendPage( :Create() )

   END

RETURN