 * Proyecto: GEP
/*
 * Fichero: TotaisGrpVerbasFuncaoDet.prg
 * Descripción:
 * Autor:
 * Fecha: 14/08/2021
 */

#include "Xailer.ch"
#include "Nefele.ch"
#include "LangCGI.ch"

PROCEDURE __TotaisGrpVerbasFuncaoDet(lGrpViewTotais)
  HB_Default(@lGrpViewTotais,oCGI:GetUserData("lGrpViewTotais",.F.))
  __GrpVerbasFuncao()
  RETURN

function TotaisGrpVerbasFuncaoDet(lGrpViewTotais)
  HB_Default(@lGrpViewTotais,.T.)
  oCGI:SetUserData("lGrpViewTotais",lGrpViewTotais)
return(ParametersGrpVerbasFuncaoDet(lGrpViewTotais))

PROCEDURE ParametersGrpVerbasFuncaoDet(lGrpViewTotais)

   local hUser := LoginUser()

   local cSubTitle:=" :: "+"Consulta dos Dados Totais Por Centro de Custo/Funcao/Sub-Grupo de Verbas"
   local cTitle:=AppData:AppTitle+cSubTitle
   local cIDParameters
   local aParameters

   HB_Default(@lGrpViewTotais,.F.)

   IF (!lGrpViewTotais)
      lGrpViewTotais:=oCGI:GetUserData("GrpVerbasFuncao:Back:lGrpViewTotais",oCGI:GetUserData("lGrpViewTotais",lGrpViewTotais))
   ENDIF

   oCGI:SetUserData("lGrpViewTotais",lGrpViewTotais)

   oCGI:SetUserData("GrpVerbasFuncao:Back",ProcName())
   oCGI:SetUserData("GrpVerbasFuncao:Back:lGrpViewTotais",lGrpViewTotais)

   WITH OBJECT wTWebPage():New()

      :cTitle:=cTitle

      AppMenu(:WO,AppData:AppName,hUser,.F.)

      aParameters:={"codPeriodo","codGrupo","codFilial","codCentroDeCusto","codFuncao"}
      cSubTitle:=AppData:AppName+cSubTitle
      GEPParameters(:WO,@cIDParameters,"__TotaisGrpVerbasFuncaoDet",aParameters,.T.,cSubTitle,.T.):Create()

      :lValign    := .F.
      :lContainer := .F.

      oCgi:SendPage( :Create() )

   END

RETURN