 * Proyecto: GEP
/*
 * Fichero: TotaisGrpVerbasEmpresaDet.prg
 * Descripción:
 * Autor:
 * Fecha: 14/08/2021
 */

#include "Xailer.ch"
#include "Nefele.ch"
#include "LangCGI.ch"

PROCEDURE __TotaisGrpVerbasEmpresaDet(lGrpViewTotais)
   HB_Default(@lGrpViewTotais,oCGI:GetUserData("lGrpViewTotais",.F.))
   __GrpVerbasEmpresa()
   RETURN

FUNCTION TotaisGrpVerbasEmpresaDet(lGrpViewTotais)
    HB_Default(@lGrpViewTotais,.T.)
    oCGI:SetUserData("lGrpViewTotais",lGrpViewTotais)
RETURN(ParametersGrpVerbasEmpresaDet(lGrpViewTotais))

PROCEDURE ParametersGrpVerbasEmpresaDet(lGrpViewTotais)

   local hUser := LoginUser()

   local cSubTitle:=" :: "+"Consulta dos Dados Totais Por Empresa/Sub-Grupo de Verbas"
   local cTitle:=AppData:AppTitle+cSubTitle
   local cIDParameters
   local aParameters

   HB_Default(@lGrpViewTotais,.F.)

   IF (!lGrpViewTotais)
      lGrpViewTotais:=oCGI:GetUserData("GrpVerbasEmpresa:Back:lGrpViewTotais",oCGI:GetUserData("lGrpViewTotais",lGrpViewTotais))
   ENDIF

   oCGI:SetUserData("__GrpVerbasEmpresa:lGrpViewTotais",lGrpViewTotais)

   deleteTmpParameters("__GrpVerbasEmpresa")

   oCGI:SetUserData("GrpVerbasEmpresa:Back",ProcName())
   oCGI:SetUserData("GrpVerbasEmpresa:Back:lGrpViewTotais",lGrpViewTotais)

   WITH OBJECT wTWebPage():New()

      :cTitle:=cTitle

      AppMenu(:WO,AppData:AppName,hUser,.F.)

      aParameters:={"codPeriodo","codGrupo"}
      cSubTitle:=AppData:AppName+cSubTitle
      GEPParameters(:WO,@cIDParameters,"__TotaisGrpVerbasEmpresaDet",aParameters,.T.,cSubTitle,.T.):Create()

      :lValign    := .F.
      :lContainer := .F.

      oCgi:SendPage( :Create() )

   END

RETURN