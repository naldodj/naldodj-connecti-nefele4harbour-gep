/*
 * Proyecto:      GEP
 * Fichero:       Main.prg
 * Descricao:   Aplicacao CGI de GEP
 * Autor:         Pedro
 * Fecha:         05/08/2021
 */

#include "Xailer.ch"
#include "Nefele.ch"
#include "LangCGI.ch"

//------------------------------------------------------------------------------
//Arranque y parametrización del CGI. Cada vez que se llama al CGI entra por aquí
PROCEDURE CGI_Init()

   LOCAL hIni := gepIni()
   LOCAL cEmp := hIni[ "rest" ][ "Emp" ]

   LOCAL cHost
   LOCAL cAuth
   LOCAL cFileIMG
   LOCAL cPrintIMG

   ErrorBlock({|oError|errorHandler(oError)})

   // Instanciamos el Objeto TCGI que se encargara de procesar la llamada recibida desde el navegador y
   // que nos ha suministrado Apache al llamar al ejecutable
   IF ( !( Type("oCgi" ) == "O" ) )
      oCgi := TCgi():New()
   ENDIF

   IF ( Empty( oCGI:GetUserData("cEmp" ) ) )
      oCGI:SetUserData( "cEmp", cEmp )
   ENDIF

   cEmp := oCGI:GetUserData( "cEmp", cEmp )

   cHost:=hIni[ cEmp ][ "Host" ]
   cAuth:=hIni[ cEmp ][ "Auth" ]
   cFileIMG:=hIni[ cEmp ][ "PrintIMG" ]
   IF (File(cFileIMG))
      IF (File(cFileIMG+".b64"))
         cPrintIMG:=HB_MemoRead(cFileIMG+".b64")
      else
         cPrintIMG:=HB_Base64Encode(HB_MemoRead(cFileIMG))
         HB_MemoWrit(cFileIMG+".b64",cPrintIMG)
      endif
   else
      cPrintIMG:=""
   endif

   WITH OBJECT AppData
      :AddData( "nLang", 1 )
      :AddData( "aLang", LoadLang() )
      :AddData( "cEmp", "" )
      :AddData( "RootPath", Application:cDirectory + "connecti\" )
      :AddData( "PathScripts", AppData:RootPath + "scripts\" )
      :AddData( "PathCfg", AppData:PathScripts + cEmp + "\cfg\" )
      :AddData( "PathLog", AppData:RootPath + "log\" )
      :AddData( "PathLck", AppData:RootPath + "lck\" )
      :AddData( "PathTmp", AppData:RootPath + "tmp\" )
      :AddData( "PathData", AppData:RootPath + "data\" )
      :AddData( "PathSystem", AppData:RootPath + "system\" )
      :AddData( "CSSDataTable", "" )
      :AddData( "AppTitle", "PAINELRH" )
      :AddData( "AppName", "PAINEL<span style='color:#45DD98'>RH</span>" )
      :AddData( "AppNameLEFT", "PAINEL" )
      :AddData( "AppNameRIGHT", "RH" )
      // Estos parametros se pueden recoger de un fichero json con la configuración
      :AddData( "cHost", cHost )
      :AddData( "cAuth", cAuth )
      :AddData( "cPrintIMG", cPrintIMG )
      :AddData( "tenantId", cEmp )
   END WITH

   AppData:CSSDataTable += ".btn-floating {background: #012444 !Important; color: #fffF !Important;}"

   IF ( !ExistDir( AppData:RootPath ) )
      MakeDir( AppData:RootPath )
   ENDIF

   IF ( !ExistDir( AppData:PathScripts ) )
      MakeDir( AppData:PathScripts )
   ENDIF

   IF ( !ExistDir( AppData:PathCfg ) )
      MakeDir( AppData:PathCfg )
   ENDIF

   IF ( !ExistDir( AppData:PathLog ) )
      MakeDir( AppData:PathLog )
   ENDIF

   IF ( !ExistDir( AppData:PathLck ) )
      MakeDir( AppData:PathLck )
   ENDIF

   IF ( !ExistDir( AppData:PathTmp ) )
      MakeDir( AppData:PathTmp )
   ENDIF

   IF ( !ExistDir( AppData:PathData ) )
      MakeDir( AppData:PathData )
   ENDIF

   IF ( !ExistDir( AppData:PathSystem ) )
      MakeDir( AppData:PathSystem )
   ENDIF

   AppData:nLang := oCGI:GetUserData( "lang", 1, .T. )

   oCGI:SetUserData( "lastip", GetEnv( "REMOTE_ADDR" ) )
   oCGI:SetUserData( "cAuth", AppData:cAuth )
   oCGI:SetUserData( "PathCfg", AppData:PathCfg )
   oCGI:SetUserData( "cPrintIMG", AppData:cPrintIMG)

   // Ejecutamos el objecto
   oCgi:Run()

RETURN

//------------------------------------------------------------------------------
// El RUN anterior entra por aquí y llama al Method correspondiente
CLASS TCgi FROM XCgi

   PROPERTY nDuracionCookie INIT 1200 // 5 minutos
   PROPERTY cSessionCookie  INIT nfl_ProgName()

   // Este es nuestro Router para evitar inyección de código malicioso y aportar la máxima seguridad.
   // Solo se permite la llamada a los Method de oCgi aquí nombrados que a su vez llaman a Procedure,Function o Method's

   METHOD MainFunction() INLINE MainPage()

//-------------------------------------------------------------------------------------------------
   METHOD ControlAcceso() INLINE ControlAcceso()
   METHOD LogOut() INLINE LogOut()

//-------------------------------------------------------------------------------------------------
   METHOD CambiaEmp() INLINE CambiaEmp()
   METHOD CambiaIdioma() INLINE CambiaIdioma()

//-------------------------------------------------------------------------------------------------
   METHOD Usuarios() INLINE MainUsers()
   METHOD EditUser() INLINE EditUser()
   METHOD NewUser() INLINE EditUser( .T. )
   METHOD UpdateUser() INLINE UpdateUser()

//-------------------------------------------------------------------------------------------------
   METHOD About() INLINE About()

//-------------------------------------------------------------------------------------------------
   METHOD webAppManifest() INLINE  oCGI:SendJSon(webAppManifest())
//-------------------------------------------------------------------------------------------------

   METHOD visparam() INLINE visparam()
   METHOD visparamAJAX() INLINE visparam( .T. )

//-------------------------------------------------------------------------------------------------

   METHOD clearUserData() INLINE clearUserData()
   METHOD __clearUserData() INLINE __clearUserData()

//-------------------------------------------------------------------------------------------------

   METHOD __GEPParameters() INLINE __GEPParameters( .T. )
   METHOD GEPParametersShow() INLINE GEPParametersShow()

//-------------------------------------------------------------------------------------------------
   METHOD CadastroFiliais() INLINE CadastroFiliais()
   METHOD __CadastroFiliais() INLINE __CadastroFiliais()
   METHOD __CadastroFiliaisDet() INLINE __CadastroFiliais(nil,nil,-1)
   METHOD GetDataCadastroFiliais() INLINE GetDataCadastroFiliais()

   METHOD CadastroCentrosDeCusto() INLINE CadastroCentrosDeCusto()
   METHOD __CadastroCentrosDeCusto() INLINE __CadastroCentrosDeCusto()
   METHOD __CadastroCentrosDeCustoDet() INLINE __CadastroCentrosDeCusto(nil,nil,-1)
   METHOD GetDataCadastroCentrosDeCusto() INLINE GetDataCadastroCentrosDeCusto()

   METHOD CadastroDepartamentos() INLINE CadastroDepartamentos()
   METHOD __CadastroDepartamentos() INLINE __CadastroDepartamentos()
   METHOD __CadastroDepartamentosDet() INLINE __CadastroDepartamentos(nil,nil,-1)
   METHOD GetDataCadastroDepartamentos() INLINE GetDataCadastroDepartamentos()

   METHOD CadastroFuncoes() INLINE CadastroFuncoes()
   METHOD __CadastroFuncoes() INLINE __CadastroFuncoes()
   METHOD __CadastroFuncoesDet() INLINE __CadastroFuncoes(nil,nil,-1)
   METHOD GetDataCadastroFuncoes() INLINE GetDataCadastroFuncoes()

   METHOD CadastroPeriodosSRD() INLINE CadastroPeriodosSRD()
   METHOD __CadastroPeriodosSRD() INLINE __CadastroPeriodosSRD()
   METHOD __CadastroPeriodosSRDDet() INLINE __CadastroPeriodosSRD(nil,nil,-1)
   METHOD GetDataCadastroPeriodosSRD() INLINE GetDataCadastroPeriodosSRD()

   METHOD CadastroGrupos() INLINE CadastroGrupos()
   METHOD __CadastroGrupos() INLINE __CadastroGrupos()
   METHOD __CadastroGruposDet() INLINE __CadastroGrupos(nil,nil,-1)
   METHOD GetDataCadastroGrupos() INLINE GetDataCadastroGrupos()

   METHOD CadastroGruposMaster() INLINE CadastroGruposMaster()
   METHOD __CadastroGruposMaster() INLINE __CadastroGruposMaster()
   METHOD __CadastroGruposMasterDet() INLINE __CadastroGruposMaster(nil,nil,-1)
   METHOD GetDataCadastroGruposMaster() INLINE GetDataCadastroGruposMaster()

   METHOD CadastroVerbas() INLINE CadastroVerbas()
   METHOD __CadastroVerbas() INLINE __CadastroVerbas()
   METHOD __CadastroVerbasDet() INLINE __CadastroVerbas(nil,nil,-1)
   METHOD GetDataCadastroVerbas() INLINE GetDataCadastroVerbas()

//-------------------------------------------------------------------------------------------------
   METHOD GrpVerbasEmpresa() INLINE ParametersGrpVerbasEmpresaDet( .F. )
   METHOD __GrpVerbasEmpresa() INLINE __GrpVerbasEmpresa()
   METHOD __GrpVerbasEmpresaDet() INLINE __GrpVerbasEmpresa(nil,nil,-1)
   METHOD GetDataGrpVerbasEmpresa() INLINE GetDataGrpVerbasEmpresa()
   METHOD ParametersGrpVerbasEmpresaDet() INLINE ParametersGrpVerbasEmpresaDet( .F. )

   METHOD GrpVerbasFilial() INLINE ParametersGrpVerbasFilialDet( .F. )
   METHOD __GrpVerbasFilial() INLINE __GrpVerbasFilial()
   METHOD __GrpVerbasFilialDet() INLINE __GrpVerbasFilial(nil,nil,-1)
   METHOD GetDataGrpVerbasFilial() INLINE GetDataGrpVerbasFilial()
   METHOD ParametersGrpVerbasFilialDet() INLINE ParametersGrpVerbasFilialDet( .F. )

   METHOD GrpVerbasCentroDeCusto() INLINE ParametersGrpVerbasCentroDeCustoDet( .F. )
   METHOD __GrpVerbasCentroDeCusto() INLINE __GrpVerbasCentroDeCusto()
   METHOD __GrpVerbasCentroDeCustoDet() INLINE __GrpVerbasCentroDeCusto(nil,nil,-1)
   METHOD GetDataGrpVerbasCentroDeCusto() INLINE GetDataGrpVerbasCentroDeCusto()
   METHOD ParametersGrpVerbasCentroDeCustoDet() INLINE ParametersGrpVerbasCentroDeCustoDet( .F. )

   METHOD GrpVerbasVerbas() INLINE ParametersGrpVerbasVerbasDet( .F. )
   METHOD __GrpVerbasVerbas() INLINE __GrpVerbasVerbas()
   METHOD __GrpVerbasVerbasDet() INLINE __GrpVerbasVerbas(nil,nil,-1)
   METHOD GetDataGrpVerbasVerbas() INLINE GetDataGrpVerbasVerbas()
   METHOD ParametersGrpVerbasVerbasDet() INLINE ParametersGrpVerbasVerbasDet( .F. )

   METHOD GrpVerbasFuncao() INLINE ParametersGrpVerbasFuncaoDet( .F. )
   METHOD __GrpVerbasFuncao() INLINE __GrpVerbasFuncao()
   METHOD __GrpVerbasFuncaoDet() INLINE __GrpVerbasFuncao(nil,nil,-1)
   METHOD GetDataGrpVerbasFuncao() INLINE GetDataGrpVerbasFuncao()
   METHOD ParametersGrpVerbasFuncaoDet() INLINE ParametersGrpVerbasFuncaoDet( .F. )

   METHOD GrpVerbasFuncionarios() INLINE ParametersGrpVerbasFuncionariosDet( .F. )
   METHOD __GrpVerbasFuncionarios() INLINE __GrpVerbasFuncionarios()
   METHOD __GrpVerbasFuncionariosDet() INLINE __GrpVerbasFuncionarios(nil,nil,-1)
   METHOD GetDataGrpVerbasFuncionarios() INLINE GetDataGrpVerbasFuncionarios()
   METHOD ParametersGrpVerbasFuncionariosDet() INLINE ParametersGrpVerbasFuncionariosDet( .F. )

   //-------------------------------------------------------------------------------------------------

   METHOD TotaisGrpVerbasEmpresa() INLINE TotaisGrpVerbasEmpresa()
   METHOD __TotaisGrpVerbasEmpresa() INLINE __TotaisGrpVerbasEmpresa()

   METHOD TotaisGrpVerbasEmpresaDet() INLINE TotaisGrpVerbasEmpresaDet( .T. )
   METHOD __TotaisGrpVerbasEmpresaDet() INLINE __TotaisGrpVerbasEmpresaDet()

   METHOD TotaisGrpVerbasFilial() INLINE TotaisGrpVerbasFilial()
   METHOD __TotaisGrpVerbasFilial() INLINE __TotaisGrpVerbasFilial()

   METHOD TotaisGrpVerbasFilialDet() INLINE TotaisGrpVerbasFilialDet( .T. )
   METHOD __TotaisGrpVerbasFilialDet() INLINE __TotaisGrpVerbasFilialDet()

   METHOD TotaisGrpVerbasCentroDeCusto() INLINE TotaisGrpVerbasCentroDeCusto()
   METHOD __TotaisGrpVerbasCentroDeCusto() INLINE __TotaisGrpVerbasCentroDeCusto()

   METHOD TotaisGrpVerbasCentroDeCustoDet() INLINE TotaisGrpVerbasCentroDeCustoDet( .T. )
   METHOD __TotaisGrpVerbasCentroDeCustoDet() INLINE __TotaisGrpVerbasCentroDeCustoDet()

   METHOD TotaisGrpVerbasFuncao() INLINE TotaisGrpVerbasFuncao()
   METHOD __TotaisGrpVerbasFuncao() INLINE __TotaisGrpVerbasFuncao()

   METHOD TotaisGrpVerbasFuncaoDet() INLINE TotaisGrpVerbasFuncaoDet( .T. )
   METHOD __TotaisGrpVerbasFuncaoDet() INLINE __TotaisGrpVerbasFuncaoDet()

   METHOD TotaisGrpVerbasVerbasDet() INLINE TotaisGrpVerbasVerbasDet( .T. )
   METHOD __TotaisGrpVerbasVerbasDet() INLINE __TotaisGrpVerbasVerbasDet()

   METHOD TotaisGrpVerbasFuncionariosDet() INLINE TotaisGrpVerbasFuncionariosDet( .T. )
   METHOD __TotaisGrpVerbasFuncionariosDet() INLINE __TotaisGrpVerbasFuncionariosDet()

//-------------------------------------------------------------------------------------------------

   METHOD PainelGrpVerbasEmpresa() INLINE ParametersPainelGrpVerbasEmpresa()
   METHOD __PainelGrpVerbasEmpresa() INLINE __PainelGrpVerbasEmpresa()
   METHOD __PainelGrpVerbasEmpresaDet() INLINE __PainelGrpVerbasEmpresa(nil,nil,-1)
   METHOD GetDataPainelGrpVerbasEmpresa() INLINE GetDataPainelGrpVerbasEmpresa()
   METHOD ParametersPainelGrpVerbasEmpresa() INLINE ParametersPainelGrpVerbasEmpresa()

   METHOD PainelGrpVerbasFilial() INLINE ParametersPainelGrpVerbasFilial()
   METHOD __PainelGrpVerbasFilial() INLINE __PainelGrpVerbasFilial()
   METHOD __PainelGrpVerbasFilialDet() INLINE __PainelGrpVerbasFilial(nil,nil,-1)
   METHOD GetDataPainelGrpVerbasFilial() INLINE GetDataPainelGrpVerbasFilial()
   METHOD ParametersPainelGrpVerbasFilial() INLINE ParametersPainelGrpVerbasFilial()

   METHOD PainelGrpVerbasCentroDeCusto() INLINE ParametersPainelGrpVerbasCentroDeCusto()
   METHOD __PainelGrpVerbasCentroDeCusto() INLINE __PainelGrpVerbasCentroDeCusto()
   METHOD __PainelGrpVerbasCentroDeCustoDet() INLINE __PainelGrpVerbasCentroDeCusto(nil,nil,-1)
   METHOD GetDataPainelGrpVerbasCentroDeCusto() INLINE GetDataPainelGrpVerbasCentroDeCusto()
   METHOD ParametersPainelGrpVerbasCentroDeCusto() INLINE ParametersPainelGrpVerbasCentroDeCusto()

   METHOD PainelGrpVerbasFuncionarios() INLINE ParametersPainelGrpVerbasFuncionarios()
   METHOD __PainelGrpVerbasFuncionarios() INLINE __PainelGrpVerbasFuncionarios()
   METHOD __PainelGrpVerbasFuncionariosDet() INLINE __PainelGrpVerbasFuncionarios(nil,nil,-1)
   METHOD GetDataPainelGrpVerbasFuncionarios() INLINE GetDataPainelGrpVerbasFuncionarios()
   METHOD ParametersPainelGrpVerbasFuncionarios() INLINE ParametersPainelGrpVerbasFuncionarios()

   //-------------------------------------------------------------------------------------------------
   METHOD GrpMasterDetailVerbasEmpresa() INLINE ParametersGrpMasterDetailVerbasEmpresa()
   METHOD __GrpMasterDetailVerbasEmpresa() INLINE __GrpMasterDetailVerbasEmpresa()
   METHOD __GrpMasterDetailVerbasEmpresaDet() INLINE __GrpMasterDetailVerbasEmpresa(nil,nil,-1)
   METHOD GetDataGrpMasterDetailVerbasEmpresa() INLINE GetDataGrpMasterDetailVerbasEmpresa()
   METHOD ParametersGrpMasterDetailVerbasEmpresa() INLINE ParametersGrpMasterDetailVerbasEmpresa()

   METHOD GrpMasterDetailVerbasFilial() INLINE ParametersGrpMasterDetailVerbasFilial()
   METHOD __GrpMasterDetailVerbasFilial() INLINE __GrpMasterDetailVerbasFilial()
   METHOD __GrpMasterDetailVerbasFilialDet() INLINE __GrpMasterDetailVerbasFilial(nil,nil,-1)
   METHOD GetDataGrpMasterDetailVerbasFilial() INLINE GetDataGrpMasterDetailVerbasFilial()
   METHOD ParametersGrpMasterDetailVerbasFilial() INLINE ParametersGrpMasterDetailVerbasFilial()

   METHOD GrpMasterDetailVerbasCentroDeCusto() INLINE ParametersGrpMasterDetailVerbasCentroDeCusto()
   METHOD __GrpMasterDetailVerbasCentroDeCusto() INLINE __GrpMasterDetailVerbasCentroDeCusto()
   METHOD __GrpMasterDetailVerbasCentroDeCustoDet() INLINE __GrpMasterDetailVerbasCentroDeCusto(nil,nil,-1)
   METHOD GetDataGrpMasterDetailVerbasCentroDeCusto() INLINE GetDataGrpMasterDetailVerbasCentroDeCusto()
   METHOD ParametersGrpMasterDetailVerbasCentroDeCusto() INLINE ParametersGrpMasterDetailVerbasCentroDeCusto()

   METHOD GrpMasterDetailVerbasFuncionarios() INLINE ParametersGrpMasterDetailVerbasFuncionarios()
   METHOD __GrpMasterDetailVerbasFuncionarios() INLINE __GrpMasterDetailVerbasFuncionarios()
   METHOD __GrpMasterDetailVerbasFuncionariosDet() INLINE __GrpMasterDetailVerbasFuncionarios(nil,nil,-1)
   METHOD GetDataGrpMasterDetailVerbasFuncionarios() INLINE GetDataGrpMasterDetailVerbasFuncionarios()
   METHOD ParametersGrpMasterDetailVerbasFuncionarios() INLINE ParametersGrpMasterDetailVerbasFuncionarios()

   //-------------------------------------------------------------------------------------------------
   METHOD GrpMasterVerbasEmpresa() INLINE ParametersGrpMasterVerbasEmpresa()
   METHOD __GrpMasterVerbasEmpresa() INLINE __GrpMasterVerbasEmpresa()
   METHOD __GrpMasterVerbasEmpresaDet() INLINE __GrpMasterVerbasEmpresa(nil,nil,-1)
   METHOD GetDataGrpMasterVerbasEmpresa() INLINE GetDataGrpMasterVerbasEmpresa()
   METHOD ParametersGrpMasterVerbasEmpresa() INLINE ParametersGrpMasterVerbasEmpresa()

   METHOD GrpMasterVerbasFilial() INLINE ParametersGrpMasterVerbasFilial()
   METHOD __GrpMasterVerbasFilial() INLINE __GrpMasterVerbasFilial()
   METHOD __GrpMasterVerbasFilialDet() INLINE __GrpMasterVerbasFilial(nil,nil,-1)
   METHOD GetDataGrpMasterVerbasFilial() INLINE GetDataGrpMasterVerbasFilial()
   METHOD ParametersGrpMasterVerbasFilial() INLINE ParametersGrpMasterVerbasFilial()

   METHOD GrpMasterVerbasCentroDeCusto() INLINE ParametersGrpMasterVerbasCentroDeCusto()
   METHOD __GrpMasterVerbasCentroDeCusto() INLINE __GrpMasterVerbasCentroDeCusto()
   METHOD __GrpMasterVerbasCentroDeCustoDet() INLINE __GrpMasterVerbasCentroDeCusto(nil,nil,-1)
   METHOD GetDataGrpMasterVerbasCentroDeCusto() INLINE GetDataGrpMasterVerbasCentroDeCusto()
   METHOD ParametersGrpMasterVerbasCentroDeCusto() INLINE ParametersGrpMasterVerbasCentroDeCusto()

   METHOD GrpMasterVerbasFuncionarios() INLINE ParametersGrpMasterVerbasFuncionarios()
   METHOD __GrpMasterVerbasFuncionarios() INLINE __GrpMasterVerbasFuncionarios()
   METHOD __GrpMasterVerbasFuncionariosDet() INLINE __GrpMasterVerbasFuncionarios(nil,nil,-1)
   METHOD GetDataGrpMasterVerbasFuncionarios() INLINE GetDataGrpMasterVerbasFuncionarios()
   METHOD ParametersGrpMasterVerbasFuncionarios() INLINE ParametersGrpMasterVerbasFuncionarios()

   //-------------------------------------------------------------------------------------------------

   METHOD TotaisGrpMasterVerbasEmpresa() INLINE TotaisGrpMasterVerbasEmpresa()
   METHOD __TotaisGrpMasterVerbasEmpresa() INLINE __TotaisGrpMasterVerbasEmpresa()

   METHOD TotaisGrpMasterVerbasEmpresaDet() INLINE TotaisGrpMasterVerbasEmpresaDet( .T. )
   METHOD __TotaisGrpMasterVerbasEmpresaDet() INLINE __TotaisGrpMasterVerbasEmpresaDet()
   METHOD ParametersGrpMasterVerbasEmpresaDet() INLINE ParametersGrpMasterVerbasEmpresaDet()

   METHOD TotaisGrpMasterVerbasFilial() INLINE TotaisGrpMasterVerbasFilial()
   METHOD __TotaisGrpMasterVerbasFilial() INLINE __TotaisGrpMasterVerbasFilial()

   METHOD TotaisGrpMasterVerbasFilialDet() INLINE TotaisGrpMasterVerbasFilialDet( .T. )
   METHOD __TotaisGrpMasterVerbasFilialDet() INLINE __TotaisGrpMasterVerbasFilialDet()
   METHOD ParametersGrpMasterVerbasFilialDet() INLINE ParametersGrpMasterVerbasFilialDet()

   METHOD TotaisGrpMasterVerbasCentroDeCusto() INLINE TotaisGrpMasterVerbasCentroDeCusto()
   METHOD __TotaisGrpMasterVerbasCentroDeCusto() INLINE __TotaisGrpMasterVerbasCentroDeCusto()

   METHOD TotaisGrpMasterVerbasCentroDeCustoDet() INLINE TotaisGrpMasterVerbasCentroDeCustoDet( .T. )
   METHOD __TotaisGrpMasterVerbasCentroDeCustoDet() INLINE __TotaisGrpMasterVerbasCentroDeCustoDet()
   METHOD ParametersGrpMasterVerbasCentroDeCustoDet() INLINE ParametersGrpMasterVerbasCentroDeCustoDet()

   //-------------------------------------------------------------------------------------------------

   METHOD PainelGrpMasterVerbasEmpresa() INLINE ParametersPainelGrpMasterVerbasEmpresa()
   METHOD __PainelGrpMasterVerbasEmpresa() INLINE __PainelGrpMasterVerbasEmpresa()
   METHOD __PainelGrpMasterVerbasEmpresaDet() INLINE __PainelGrpMasterVerbasEmpresa(nil,nil,-1)
   METHOD GetDataPainelGrpMasterVerbasEmpresa() INLINE GetDataPainelGrpMasterVerbasEmpresa()
   METHOD ParametersPainelGrpMasterVerbasEmpresa() INLINE ParametersPainelGrpMasterVerbasEmpresa()

   METHOD PainelGrpMasterVerbasFilial() INLINE ParametersPainelGrpMasterVerbasFilial()
   METHOD __PainelGrpMasterVerbasFilial() INLINE __PainelGrpMasterVerbasFilial()
   METHOD __PainelGrpMasterVerbasFilialDet() INLINE __PainelGrpMasterVerbasFilial(nil,nil,-1)
   METHOD GetDataPainelGrpMasterVerbasFilial() INLINE GetDataPainelGrpMasterVerbasFilial()
   METHOD ParametersPainelGrpMasterVerbasFilial() INLINE ParametersPainelGrpMasterVerbasFilial()

   METHOD PainelGrpMasterVerbasCentroDeCusto() INLINE ParametersPainelGrpMasterVerbasCentroDeCusto()
   METHOD __PainelGrpMasterVerbasCentroDeCusto() INLINE __PainelGrpMasterVerbasCentroDeCusto()
   METHOD __PainelGrpMasterVerbasCentroDeCustoDet() INLINE __PainelGrpMasterVerbasCentroDeCusto(nil,nil,-1)
   METHOD GetDataPainelGrpMasterVerbasCentroDeCusto() INLINE GetDataPainelGrpMasterVerbasCentroDeCusto()
   METHOD ParametersPainelGrpMasterVerbasCentroDeCusto() INLINE ParametersPainelGrpMasterVerbasCentroDeCusto()

   METHOD PainelGrpMasterVerbasFuncionarios() INLINE ParametersPainelGrpMasterVerbasFuncionarios()
   METHOD __PainelGrpMasterVerbasFuncionarios() INLINE __PainelGrpMasterVerbasFuncionarios()
   METHOD __PainelGrpMasterVerbasFuncionariosDet() INLINE __PainelGrpMasterVerbasFuncionarios(nil,nil,-1)
   METHOD GetDataPainelGrpMasterVerbasFuncionarios() INLINE GetDataPainelGrpMasterVerbasFuncionarios()
   METHOD ParametersPainelGrpMasterVerbasFuncionarios() INLINE ParametersPainelGrpMasterVerbasFuncionarios()

//-------------------------------------------------------------------------------------------------

   METHOD ChartTotaisGrpVerbasFilial() INLINE ChartTotaisGrpVerbasFilial()
   METHOD __ChartTotaisGrpVerbasFilial() INLINE __ChartTotaisGrpVerbasFilial()

   METHOD ChartTotaisGrpVerbasCentroDeCusto() INLINE ChartTotaisGrpVerbasCentroDeCusto()
   METHOD __ChartTotaisGrpVerbasCentroDeCusto() INLINE __ChartTotaisGrpVerbasCentroDeCusto()

   METHOD ChartTotaisGrpVerbasFuncao() INLINE ChartTotaisGrpVerbasFuncao()
   METHOD __ChartTotaisGrpVerbasFuncao() INLINE __ChartTotaisGrpVerbasFuncao()

//-------------------------------------------------------------------------------------------------
   METHOD ChartTotaisGrpMasterVerbasFilial() INLINE ChartTotaisGrpMasterVerbasFilial()
   METHOD __ChartTotaisGrpMasterVerbasFilial() INLINE __ChartTotaisGrpMasterVerbasFilial()

   METHOD ChartTotaisGrpMasterVerbasCentroDeCusto() INLINE ChartTotaisGrpMasterVerbasCentroDeCusto()
   METHOD __ChartTotaisGrpMasterVerbasCentroDeCusto() INLINE __ChartTotaisGrpMasterVerbasCentroDeCusto()

//-------------------------------------------------------------------------------------------------

   METHOD GrpMasterVerbasAcumuladosEmpresa() INLINE ParametersGrpMasterVerbasAcumuladosEmpresa()
   METHOD __GrpMasterVerbasAcumuladosEmpresa() INLINE __GrpMasterVerbasAcumuladosEmpresa()
   METHOD __GrpMasterVerbasAcumuladosEmpresaDet() INLINE __GrpMasterVerbasAcumuladosEmpresa(nil,nil,-1)
   METHOD GetDataGrpMasterVerbasAcumuladosEmpresa() INLINE GetDataGrpMasterVerbasAcumuladosEmpresa()
   METHOD ParametersGrpMasterVerbasAcumuladosEmpresa() INLINE ParametersGrpMasterVerbasAcumuladosEmpresa()

   METHOD GrpMasterVerbasAcumuladosFilial() INLINE ParametersGrpMasterVerbasAcumuladosFilial()
   METHOD __GrpMasterVerbasAcumuladosFilial() INLINE __GrpMasterVerbasAcumuladosFilial()
   METHOD __GrpMasterVerbasAcumuladosFilialDet() INLINE __GrpMasterVerbasAcumuladosFilial(nil,nil,-1)
   METHOD GetDataGrpMasterVerbasAcumuladosFilial() INLINE GetDataGrpMasterVerbasAcumuladosFilial()
   METHOD ParametersGrpMasterVerbasAcumuladosFilial() INLINE ParametersGrpMasterVerbasAcumuladosFilial()

   METHOD GrpMasterVerbasAcumuladosCentroDeCusto() INLINE ParametersGrpMasterVerbasAcumuladosCentroDeCusto()
   METHOD __GrpMasterVerbasAcumuladosCentroDeCusto() INLINE __GrpMasterVerbasAcumuladosCentroDeCusto()
   METHOD __GrpMasterVerbasAcumuladosCentroDeCustoDet() INLINE __GrpMasterVerbasAcumuladosCentroDeCusto(nil,nil,-1)
   METHOD GetDataGrpMasterVerbasAcumuladosCentroDeCusto() INLINE GetDataGrpMasterVerbasAcumuladosCentroDeCusto()
   METHOD ParametersGrpMasterVerbasAcumuladosCentroDeCusto() INLINE ParametersGrpMasterVerbasAcumuladosCentroDeCusto()

   METHOD GrpMasterVerbasAcumuladosFuncionarios() INLINE ParametersGrpMasterVerbasAcumuladosFuncionarios()
   METHOD __GrpMasterVerbasAcumuladosFuncionarios() INLINE __GrpMasterVerbasAcumuladosFuncionarios()
   METHOD __GrpMasterVerbasAcumuladosFuncionariosDet() INLINE __GrpMasterVerbasAcumuladosFuncionarios(nil,nil,-1)
   METHOD GetDataGrpMasterVerbasAcumuladosFuncionarios() INLINE GetDataGrpMasterVerbasAcumuladosFuncionarios()
   METHOD ParametersGrpMasterVerbasAcumuladosFuncionarios() INLINE ParametersGrpMasterVerbasAcumuladosFuncionarios()

//-------------------------------------------------------------------------------------------------

   METHOD TurnOverGeralEmpresa() INLINE ParametersTurnOverGeralEmpresa()
   METHOD __TurnOverGeralEmpresa() INLINE __TurnOverGeralEmpresa()
   METHOD __TurnOverGeralEmpresaDet() INLINE __TurnOverGeralEmpresa(nil,nil,-1)
   METHOD GetDataTurnOverGeralEmpresa() INLINE GetDataTurnOverGeralEmpresa()
   METHOD ParametersTurnOverGeralEmpresa() INLINE ParametersTurnOverGeralEmpresa()

   METHOD TurnOverGeralFilial() INLINE ParametersTurnOverGeralFilial()
   METHOD __TurnOverGeralFilial() INLINE __TurnOverGeralFilial()
   METHOD __TurnOverGeralFilialDet() INLINE __TurnOverGeralFilial(nil,nil,-1)
   METHOD GetDataTurnOverGeralFilial() INLINE GetDataTurnOverGeralFilial()
   METHOD ParametersTurnOverGeralFilial() INLINE ParametersTurnOverGeralFilial()

   METHOD TurnOverGeralCentroDeCusto() INLINE ParametersTurnOverGeralCentroDeCusto()
   METHOD __TurnOverGeralCentroDeCusto() INLINE __TurnOverGeralCentroDeCusto()
   METHOD __TurnOverGeralCentroDeCustoDet() INLINE __TurnOverGeralCentroDeCusto(nil,nil,-1)
   METHOD GetDataTurnOverGeralCentroDeCusto() INLINE GetDataTurnOverGeralCentroDeCusto()
   METHOD ParametersTurnOverGeralCentroDeCusto() INLINE ParametersTurnOverGeralCentroDeCusto()

   METHOD TurnOverGeralFuncoes() INLINE ParametersTurnOverGeralFuncoes()
   METHOD __TurnOverGeralFuncoes() INLINE __TurnOverGeralFuncoes()
   METHOD __TurnOverGeralFuncoesDet() INLINE __TurnOverGeralFuncoes(nil,nil,-1)
   METHOD GetDataTurnOverGeralFuncoes() INLINE GetDataTurnOverGeralFuncoes()
   METHOD ParametersTurnOverGeralFuncoes() INLINE ParametersTurnOverGeralFuncoes()

   METHOD TurnOverGeralFuncionarios() INLINE ParametersTurnOverGeralFuncionarios()
   METHOD __TurnOverGeralFuncionarios() INLINE __TurnOverGeralFuncionarios()
   METHOD __TurnOverGeralFuncionariosDet() INLINE __TurnOverGeralFuncionarios(nil,nil,-1)
   METHOD GetDataTurnOverGeralFuncionarios() INLINE GetDataTurnOverGeralFuncionarios()
   METHOD ParametersTurnOverGeralFuncionarios() INLINE ParametersTurnOverGeralFuncionarios()

//-------------------------------------------------------------------------------------------------

   METHOD TurnOverGeralEmpresaDashBoard() INLINE TurnOverGeralEmpresaDashBoard()
   METHOD __TurnOverGeralEmpresaDashBoard() INLINE __TurnOverGeralEmpresaDashBoard()
   METHOD __TurnOverGeralEmpresaDashBoardDet() INLINE __TurnOverGeralEmpresaDashBoard()

//-------------------------------------------------------------------------------------------------

   METHOD TurnoverFilFuncPrevXRealizado() INLINE ParametersTurnoverFilFuncPrevXRealizado()
   METHOD __TurnoverFilFuncPrevXRealizado() INLINE __TurnoverFilFuncPrevXRealizado()
   METHOD __TurnoverFilFuncPrevXRealizadoDet() INLINE __TurnoverFilFuncPrevXRealizado(nil,nil,-1)
   METHOD GetDataTurnoverFilFuncPrevXRealizado() INLINE GetDataTurnoverFilFuncPrevXRealizado()
   METHOD ParametersTurnoverFilFuncPrevXRealizado() INLINE ParametersTurnoverFilFuncPrevXRealizado()

//-------------------------------------------------------------------------------------------------

END CLASS

//------------------------------------------------------------------------------
FUNCTION gepIni()

   LOCAL cIni

   LOCAL hIni

   cIni := "gep.ini"
   IF ( File( cIni ) )
      hIni := hb_iniRead( cIni )
   ENDIF

return( hIni )

function errorHandler(e)

   LOCAL i := 1  /* Start are "real" error */

   LOCAL cHTML
   LOCAL cErrorFile

   LOCAL hUser

   LOCAL cErr := "Runtime error" + hb_eol() + ;
      hb_eol() + ;
      "Gencode: " + hb_ntos( e:GenCode ) + hb_eol() + ;
      "Desc: " + e:Description +  + hb_eol() + ;
      "Sub-system: " + hb_ntos( e:SubCode ) + hb_eol() + ;
      "Operation: " + e:operation + hb_eol() + ;
      hb_eol() + ;
      "Call trace:" + hb_eol() + ;
      hb_eol()

   WHILE ! Empty( ProcName( ++i ) )
      cErr += RTrim( ProcName( i ) ) + "(" + hb_ntos( ProcLine( i ) ) + ")" + hb_eol()
   END WHILE

   IF (Type("AppData")=="O")
      cErrorFile:=AppData:PathLog
   ELSE
      cErrorFile:=""
   ENDIF
   cErrorFile+=( DToS(Date() ) ) + "_" + StrTran( Time(),":","_" ) + "_" + hb_ntos( Seconds() ) + "_errorHandler.log"

   hb_MemoWrit( cErrorFile , cErr )

   IF (Type("oCgi")=="O")

      WITH OBJECT wTWebPage():New()

         :cTitle:= "Error Page"

         IF (!stacktools():IsInCallStack("LoginUser"))
            hUser:=LoginUser()
         ELSE
            hUser:={;
               "user"=>"errorHandler",;
               "pass"=>"@#errorHandleradmin!@",;
               "name"=>"errorHandler",;
               "adminuser"=>.F.,;
               "activo"=>.F.;
            }
         ENDIF

         AppMenu(:WO,ProcName(),hUser,.F.,NIL,NIL,NIL,.F.)

         WITH OBJECT WFloatingBtn():New(:WO)
            :cClrPane:="#005FAB"
            :cName:=("WFloatingBtn"+ProcName())
            :cId:=Lower(:cName)
            :cText:="Voltar"
            :oIcon:cIcon:="arrow_back"
            :oIcon:cClrIcon := "#FED300"
            :cOnClick:="MainFunction"
            :Create()
         END WITH

         WITH OBJECT WEdit():New(:WO)
             :cId:="error"
             :cTitle:="error"
             :cIcon:="error"
             :cValue:=cErr
             :SetMemo()
             :Create()
           END WITH

         :Create()

         oCgi:SendPage( :Create() )

         __Quit()

      END

   ENDIF

return(cErr)