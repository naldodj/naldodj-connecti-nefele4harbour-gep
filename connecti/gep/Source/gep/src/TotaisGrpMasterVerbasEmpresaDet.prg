 * Proyecto: GEP
/*
 * Fichero: TotaisGrpMasterVerbasEmpresaDet.prg
 * Descripción:
 * Autor:
 * Fecha: 14/08/2021
 */

#include "Xailer.ch"
#include "Nefele.ch"
#include "LangCGI.ch"

PROCEDURE __TotaisGrpMasterVerbasEmpresaDet(lGrpViewTotais)
   HB_Default(@lGrpViewTotais,oCGI:GetUserData("lGrpViewTotais",.F.))
  __GrpMasterVerbasEmpresa()
   RETURN

FUNCTION TotaisGrpMasterVerbasEmpresaDet(lGrpViewTotais)
    HB_Default(@lGrpViewTotais,.T.)
    oCGI:SetUserData("lGrpViewTotais",lGrpViewTotais)
RETURN(ParametersGrpMasterVerbasEmpresaDet(lGrpViewTotais))

PROCEDURE ParametersGrpMasterVerbasEmpresaDet(lGrpViewTotais)

   local hUser := LoginUser()

   local cSubTitle:=" :: "+"Consulta dos Dados Totais Por Empresa/Grupo de Verbas"
   local cTitle:=AppData:AppTitle+cSubTitle
   local cIDParameters
   local aParameters

   HB_Default(@lGrpViewTotais,.F.)

   IF (!lGrpViewTotais)
      lGrpViewTotais:=oCGI:GetUserData("GrpMasterVerbasEmpresa:Back:lGrpViewTotais",oCGI:GetUserData("lGrpViewTotais",lGrpViewTotais))
   ENDIF

   oCGI:SetUserData("__GrpMasterVerbasEmpresa:lGrpViewTotais",lGrpViewTotais)

   oCGI:SetUserData("GrpMasterVerbasEmpresa:Back",ProcName())
   oCGI:SetUserData("GrpMasterVerbasEmpresa:Back:lGrpViewTotais",lGrpViewTotais)

   WITH OBJECT wTWebPage():New()

      :cTitle:=cTitle

      AppMenu(:WO,AppData:AppName,hUser,.F.)

      aParameters:={"codPeriodo","codGrupo"}
      cSubTitle:=AppData:AppName+cSubTitle
      GEPParameters(:WO,@cIDParameters,"__TotaisGrpMasterVerbasEmpresaDet",aParameters,.T.,cSubTitle,.T.):Create()

      :lValign    := .F.
      :lContainer := .F.

      oCgi:SendPage( :Create() )

   END

RETURN