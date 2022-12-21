/*
 * Proyecto:      Gep
 * Fichero:       Gep.prg
 * Descripción:   Parametros GEP
 * Autor:         Administrator
 * Fecha:         28/07/2021
 */

#include "Xailer.ch"
#include "Nefele.ch"
#include "LangCGI.ch"

PROCEDURE __GEPParametersModal()

   local codGrupo:=oCGI:GetCgiValue("codGrupo","")
   local codVerba:=oCGI:GetCgiValue("codVerba","")
   local codFilial:=oCGI:GetCgiValue("codFilial","")
   local codFuncao:=oCGI:GetCgiValue("codFuncao","")
   local codPeriodo:=oCGI:GetCgiValue("codPeriodo","")
   local codCentroDeCusto:=oCGI:GetCgiValue("codCentroDeCusto","")

   if (Empty(codVerba))
      codVerba:=oCGI:GetCgiValue("gepparameters_codverba","")
   endif

   if (Empty(codGrupo))
      codGrupo:=oCGI:GetCgiValue("gepparameters_codgrupo","")
   endif

   if (Empty(codFuncao))
      codFuncao:=oCGI:GetCgiValue("gepparameters_codfuncao","")
   endif

   if (Empty(codFilial))
      codFilial:=oCGI:GetCgiValue("gepparameters_codfilial","")
   endif

   if (Empty(codPeriodo))
      codPeriodo:=oCGI:GetCgiValue("gepparameters_codperiodo","")
   endif

   if (Empty(codCentroDeCusto))
      codCentroDeCusto:=oCGI:GetCgiValue("gepparameters_codcentrodecusto","")
   endif

   oCGI:SetUserData("__GEPParameters:codGrupo",codGrupo)
   oCGI:SetUserData("__GEPParameters:codVerba",codVerba)
   oCGI:SetUserData("__GEPParameters:codFuncao",codFuncao)
   oCGI:SetUserData("__GEPParameters:codFilial",codFilial)
   oCGI:SetUserData("__GEPParameters:codPeriodo",codPeriodo)
   oCGI:SetUserData("__GEPParameters:codCentroDeCusto",codCentroDeCusto)

   MainPage()

   RETURN

FUNCTION GEPParametersModal(oWO,cID,cAction,aParameters,lNoStyle,cSubTitle)

   local cIDParameters:=Lower(ProcName())

   local oWForm
   local oWBevel
   local oWPanel

   hb_default( @cID,Lower( ProcName(1 ) ) + "_parameters" )
   hb_default( @cAction,"VisParam" )
   hb_default( @aParameters,Array(0))

   WITH Object oWBevel := WBevel():New( oWO )
      :cID := cID
      :aWidth[xc_M]  := 10
      :aOffset[xc_M] := 1
      :nStyle := xc_Row
      HB_Default(@cSubTitle,"")
      :cTitle := "Par&acirc;metros"
      if !Empty(cSubTitle)
         :cTitle+=cSubTitle
      endif
      :cTitleAlign := xc_Center
      :lLine := .T.
      WITH Object oWForm := WForm():New( oWBevel )
         :cID:=(cIDParameters+"_form")
         :cFunction := cAction
         :lCompress := .T.
         :lShadowSheet := .T.
         if (aScan(aParameters,{|x|Lower(x)$Lower("codFilial")})>0)
            WITH Object WComboBox():New( oWForm )
               :cID:=(cIDParameters+"_codFilial")
               :AddParam({:cID,"#"+:cID+":selected"})
               :cTitle := "Filial"
               :cText  := "Selecione uma Filial"
               //https://materializecss.com/icons.html
               :cIcon  := "business"
               :cHelp  := "Este parametro sera utilizado para Filtrar a Filial"
               :aItems := GetFiliais()
               :cSelected:=:aItems[1][2]
               :lCompress := .T.
               :Create()
            END WITH
         endif
         if (aScan(aParameters,{|x|Lower(x)$Lower("codPeriodo")})>0)
            WITH Object WComboBox():New( oWForm )
               :cID := (cIDParameters+"_codPeriodo")
               :AddParam({:cID,"#"+:cID+":selected"})
               :cTitle := "Periodo"
               :cText  := "Selecione um Periodo"
               //https://materializecss.com/icons.html
               :cIcon  := "date_range"
               :cHelp  := "Este parametro sera utilizado para Filtrar o Periodo"
               :aItems := getPeriodos()
               :cSelected:=:aItems[1][2]
               :lCompress := .T.
               :Create()
            END WITH
         endif
         if (aScan(aParameters,{|x|Lower(x)$Lower("codCentroDeCusto")})>0)
            WITH Object WComboBox():New( oWForm )
               :cID:=(cIDParameters+"_codCentroDeCusto")
               :AddParam({:cID,"#"+:cID+":selected"})
               :cTitle := "Centro de Custo"
               :cText  := "Selecione um Centro de Custo"
               //https://materializecss.com/icons.html
               :cIcon  := "business_center"
               :cHelp  := "Este parametro sera utilizado para Filtrar o Centro de Custo"
               :aItems := getCentrodeCusto()
               :cSelected:=:aItems[1][2]
               :lCompress := .T.
               :Create()
            END WITH
         endif
         if (aScan(aParameters,{|x|Lower(x)$Lower("codGrupo")})>0)
            WITH Object WComboBox():New( oWForm )
               :cID:=(cIDParameters+"_codGrupo")
               :AddParam({:cID,"#"+:cID+":selected"})
               :cTitle := "Grupo da Verba"
               :cText  := "Selecione um Grupo"
               //https://materializecss.com/icons.html
               :cIcon  := "group"
               :cHelp  := "Este parametro sera utilizado para Filtrar o Grupo de Verbas"
               :aItems := getGrupos()
               :cSelected:=:aItems[1][2]
               :lCompress := .T.
               :Create()
            END WITH
         endif
         if (aScan(aParameters,{|x|Lower(x)$Lower("codVerba")})>0)
            WITH Object WComboBox():New( oWForm )
               :cID:=(cIDParameters+"_codVerba")
               :AddParam({:cID,"#"+:cID+":selected"})
               :cTitle := "Verba"
               :cText  := "Selecione uma Verba"
               //https://materializecss.com/icons.html
               :cIcon  := "money"
               :cHelp  := "Este parametro sera utilizado para Filtrar a Verba"
               :aItems := getVerbas()
               :cSelected:=:aItems[1][2]
               :lCompress := .T.
               :Create()
            END WITH
         endif
         if (aScan(aParameters,{|x|Lower(x)$Lower("codFuncao")})>0)
            WITH Object WComboBox():New( oWForm )
               :cID:=(cIDParameters+"_codFuncao")
               :AddParam({:cID,"#"+:cID+":selected"})
               :cTitle := "Funcao"
               :cText  := "Selecione uma Funcao"
               //https://materializecss.com/icons.html
               :cIcon  := "work"
               :cHelp  := "Este parametro sera utilizado para Filtrar a Funcao"
               :aItems := getFuncoes()
               :cSelected:=:aItems[1][2]
               :lCompress := .T.
               :Create()
            END WITH
         endif
         WITH Object WButton():New( oWForm )
            :cID:=(cIDParameters+"_submit")
            :cText:="OK"
            :lSubmit:=.T.
            :cPosition:="center"
            :Create()
         END WITH
         oWForm:Create()
         END WITH
   END WITH

   __clearGEPParameters(oCGI)

RETURN( oWBevel )

static function getFiliais()

   local aSource:=Array(0)

   local cFile:=(AppData:RootPath+"data\"+oCGI:GetUserData("cEmp")+"_"+Lower(ProcName())+".json")

   local cDatos
   local lDatos

   local nRegTotal

   local hRow
   local hDatos

   nfl_console(cFile)

   lDatos:=(File(cFile).and.(nfl_FileDate(cFile)==Date()))
   if (lDatos)
      cDatos:=HB_MemoRead(cFile)
      hDatos:=hb_jsonDecode(cDatos)
      lDatos:=(!Empty(hDatos))
   endif

   if (!lDatos)
      hDatos:=QueryCodModel(AppData:cHost,"FILIAIS_SM0_SRD",nil,1,1)
   endif

   IF (hDatos["ok"])

      if (!lDatos)
         nRegTotal:=hDatos["response","TotalPages"]
         hDatos:=QueryCodModel(AppData:cHost,"FILIAIS_SM0_SRD",nil,nRegTotal,1)
      endif

      if (hDatos["ok"])
         if (!lDatos)
            cDatos:=hb_jsonEncode(hDatos)
            HB_MemoWrit(cFile,cDatos)
         endif
         aAdd(aSource,{"",""})
         for each hRow in hDatos["response","table","items"]
            aAdd(aSource,{hRow["detail","items","codFilial"],hRow["detail","items","codFilial"]+"-"+hRow["detail","items","descFilial"]})
         next
      endif

   endif

   return(aSource)

static function getPeriodos()

   local aSource:=Array(0)

   local cFile:=(AppData:RootPath+"data\"+oCGI:GetUserData("cEmp")+"_"+Lower(ProcName())+".json")

   local cDatos
   local lDatos

   local nRegTotal

   local hRow
   local hDatos

   lDatos:=(File(cFile).and.(nfl_FileDate(cFile)==Date()))
   if (lDatos)
      cDatos:=HB_MemoRead(cFile)
      hDatos:=hb_jsonDecode(cDatos)
      lDatos:=(!Empty(hDatos))
   endif

   if (!lDatos)
      hDatos:=QueryCodModel(AppData:cHost,"PERIODOS_SRD",nil,1,1)
   endif

   IF (hDatos["ok"])

      if (!lDatos)
         nRegTotal := hDatos["response","TotalPages"]
         hDatos:=QueryCodModel(AppData:cHost,"PERIODOS_SRD",nil,nRegTotal,1)
      endif

      if (hDatos["ok"])
         if (!lDatos)
            cDatos:=hb_jsonEncode(hDatos)
            HB_MemoWrit(cFile,cDatos)
         endif
         for each hRow in hDatos["response","table","items"]
            aAdd(aSource,{hRow["detail","items","codPeriodo"],hRow["detail","items","codPeriodoMesAno"]})
         next
         aSource:=aSort(aSource,nil,nil,{|x,y|x[1]>y[1]})
      endif

   endif

   return(aSource)

static function getCentrodeCusto()

   local aSource:=Array(0)

   local cFile:=(AppData:RootPath+"data\"+oCGI:GetUserData("cEmp")+"_"+Lower(ProcName())+".json")

   local cDatos
   local lDatos

   local nRegTotal

   local hRow
   local hDatos

   lDatos:=(File(cFile).and.(nfl_FileDate(cFile)==Date()))
   if (lDatos)
      cDatos:=HB_MemoRead(cFile)
      hDatos:=hb_jsonDecode(cDatos)
      lDatos:=(!Empty(hDatos))
   endif

   if (!lDatos)
      hDatos:=QueryCodModel(AppData:cHost,"CTTSRD",nil,1,1)
   endif

   if (hDatos["ok"])

      nRegTotal:=hDatos["response","TotalPages"]

      if (!lDatos)
         hDatos:=QueryCodModel(AppData:cHost,"CTTSRD",nil,nRegTotal,1)
      endif

      if (hDatos["ok"])
         if (!lDatos)
            cDatos:=hb_jsonEncode(hDatos)
            HB_MemoWrit(cFile,cDatos)
         endif
         aAdd(aSource,{"",""})
         for each hRow in hDatos["response","table","items"]
            aAdd(aSource,{hRow["detail","items","codCentroDeCusto"],hRow["detail","items","codCentroDeCusto"]+"-"+hRow["detail","items","descCentroDeCusto"]})
         next
      endif

   endif

   return(aSource)

static function getGrupos()

   local aSource:=Array(0)

   local cFile:=(AppData:RootPath+"data\"+oCGI:GetUserData("cEmp")+"_"+Lower(ProcName())+".json")

   local cDatos
   local lDatos

   local nRegTotal

   local hRow
   local hDatos

   lDatos:=(File(cFile).and.(nfl_FileDate(cFile)==Date()))
   if (lDatos)
      cDatos:=HB_MemoRead(cFile)
      hDatos:=hb_jsonDecode(cDatos)
      lDatos:=(!Empty(hDatos))
   endif

   if (!lDatos)
      hDatos:=QueryCodModel(AppData:cHost,"GRUPOS_ZX_SRV_SRD",nil,1,1)
   endif

   if (hDatos["ok"])

      nRegTotal:=hDatos["response","TotalPages"]

      if (!lDatos)
         hDatos:=QueryCodModel(AppData:cHost,"GRUPOS_ZX_SRV_SRD",nil,nRegTotal,1)
      endif

      if (hDatos["ok"])
         if (!lDatos)
            cDatos:=hb_jsonEncode(hDatos)
            HB_MemoWrit(cFile,cDatos)
         endif
         aAdd(aSource,{"",""})
         for each hRow in hDatos["response","table","items"]
            aAdd(aSource,{hRow["detail","items","codGrupo"],hRow["detail","items","codGrupo"]+"-"+hRow["detail","items","descGrupo"]})
         next
      endif

   endif

   return(aSource)

static function getVerbas()

   local aSource:=Array(0)

   local cFile:=(AppData:RootPath+"data\"+oCGI:GetUserData("cEmp")+"_"+Lower(ProcName())+".json")

   local cDatos
   local lDatos

   local nRegTotal

   local hRow
   local hDatos

   lDatos:=(File(cFile).and.(nfl_FileDate(cFile)==Date()))
   if (lDatos)
      cDatos:=HB_MemoRead(cFile)
      hDatos:=hb_jsonDecode(cDatos)
      lDatos:=(!Empty(hDatos))
   endif

   if (!lDatos)
      hDatos:=QueryCodModel(AppData:cHost,"VERBAS_SRV_ZY_SRD",nil,1,1)
   endif

   if (hDatos["ok"])

      nRegTotal:=hDatos["response","TotalPages"]

      if (!lDatos)
         hDatos:=QueryCodModel(AppData:cHost,"VERBAS_SRV_ZY_SRD",nil,nRegTotal,1)
      endif

      if (hDatos["ok"])
         if (!lDatos)
            cDatos:=hb_jsonEncode(hDatos)
            HB_MemoWrit(cFile,cDatos)
         endif
         aAdd(aSource,{"",""})
         for each hRow in hDatos["response","table","items"]
            aAdd(aSource,{hRow["detail","items","codVerba"],hRow["detail","items","codVerba"]+"-"+hRow["detail","items","descVerba"]})
         next
      endif

   endif

   return(aSource)

static function getFuncoes()

   local aSource:=Array(0)

   local cFile:=(AppData:RootPath+"data\"+oCGI:GetUserData("cEmp")+"_"+Lower(ProcName())+".json")

   local cDatos
   local lDatos

   local nRegTotal

   local hRow
   local hDatos

   lDatos:=(File(cFile).and.(nfl_FileDate(cFile)==Date()))
   if (lDatos)
      cDatos:=HB_MemoRead(cFile)
      hDatos:=hb_jsonDecode(cDatos)
      lDatos:=(!Empty(hDatos))
   endif

   if (!lDatos)
      hDatos:=QueryCodModel(AppData:cHost,"FUNCOES_SRA",nil,1,1)
   endif

   if (hDatos["ok"])

      nRegTotal:=hDatos["response","TotalPages"]

      if (!lDatos)
         hDatos:=QueryCodModel(AppData:cHost,"FUNCOES_SRA",nil,nRegTotal,1)
      endif

      if (hDatos["ok"])
         if (!lDatos)
            cDatos:=hb_jsonEncode(hDatos)
            HB_MemoWrit(cFile,cDatos)
         endif
         aAdd(aSource,{"",""})
         for each hRow in hDatos["response","table","items"]
            aAdd(aSource,{hRow["detail","items","codFuncao"],hRow["detail","items","codFuncao"]+"-"+hRow["detail","items","descFuncao"]})
         next
      endif

   endif

   return(aSource)

   procedure __clearGEPParameters(oCGI)
      oCGI:SetUserData("gepparameters_codVerba","")
      oCGI:SetUserData("gepparameters_codgrupo","")
      oCGI:SetUserData("gepparameters_codfuncao","")
      oCGI:SetUserData("gepparameters_codfilial","")
      oCGI:SetUserData("gepparameters_codperiodo","")
      oCGI:SetUserData("gepparameters_codcentrodecusto","")
      return