 * Proyecto: GEP
/*
 * Fichero: TotaisGrpMasterVerbasCentroDeCustoDet.prg
 * Descripción:
 * Autor:
 * Fecha: 14/08/2021
 */

#include "Xailer.ch"
#include "Nefele.ch"
#include "LangCGI.ch"

PROCEDURE __TotaisGrpMasterVerbasCentroDeCustoDet(lGrpViewTotais)
  HB_Default(@lGrpViewTotais,oCGI:GetUserData("lGrpViewTotais",.F.))
  __GrpMasterVerbasCentroDeCusto()
  RETURN

FUNCTION TotaisGrpMasterVerbasCentroDeCustoDet(lGrpViewTotais)
   HB_Default(@lGrpViewTotais,.T.)
   oCGI:SetUserData("lGrpViewTotais",lGrpViewTotais)
RETURN(ParametersGrpMasterVerbasCentroDeCustoDet(lGrpViewTotais))

PROCEDURE ParametersGrpMasterVerbasCentroDeCustoDet(lGrpViewTotais)

   local hUser := LoginUser()

   local cSubTitle:=" :: "+"Consulta dos Dados Totais Por Centro de Custo/Grupo de Verbas"
   local cTitle:=AppData:AppTitle+cSubTitle
   local cIDParameters
   local aParameters

   HB_Default(@lGrpViewTotais,.F.)

   IF (!lGrpViewTotais)
      lGrpViewTotais:=oCGI:GetUserData("GrpMasterVerbasCentroDeCusto:Back:lGrpViewTotais",oCGI:GetUserData("lGrpViewTotais",lGrpViewTotais))
   ENDIF

   oCGI:SetUserData("lGrpViewTotais",lGrpViewTotais)

   oCGI:SetUserData("GrpMasterVerbasCentroDeCusto:Back",ProcName())
   oCGI:SetUserData("GrpMasterVerbasCentroDeCusto:Back:lGrpViewTotais",lGrpViewTotais)

   WITH OBJECT wTWebPage():New()

      :cTitle:=cTitle

      AppMenu(:WO,AppData:AppName,hUser,.F.)

      aParameters:={"codPeriodo","codGrupo","codFilial","codCentroDeCusto"}
      cSubTitle:=AppData:AppName+cSubTitle
      GEPParameters(:WO,@cIDParameters,"__TotaisGrpMasterVerbasCentroDeCustoDet",aParameters,.T.,cSubTitle,.T.):Create()

      :lValign    := .F.
      :lContainer := .F.

      oCgi:SendPage( :Create() )

   END

RETURN