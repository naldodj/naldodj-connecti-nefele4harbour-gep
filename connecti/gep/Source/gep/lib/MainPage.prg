/*
 * Proyecto:      GEP
 * Fichero:       MainPage.prg
 * Descricao:   Aplicacao CGI de GEP
 * Autor:         Pedro
 * Fecha:         05/08/2021
 */

#include "Xailer.ch"
#include "Nefele.ch"
#include "LangCGI.ch"
#include "hbthread.ch"

//------------------------------------------------------------------------------
//Función principal de la app Web
PROCEDURE MainPage()

   LOCAL hUser := LoginUser()

   LOCAL cCall

   local cBGImage:="./connecti/resource/images/"+IF(Time()>="18:00>00","connecti-consultoria-login-background-at-night.jpg","connecti-consultoria-login-background-in-the-morning.jpg")

   oCGI:__clearUserData()

   // Comenzamos instanciando la Página Web que queremos crear
   WITH Object wTWebPage():New()

      :cTitle := ("Connecti :: " + AppData:AppTitle)
      :cInMain+=localStorageClear()

      AppMenu(:WO,AppData:AppName ,hUser,.T.)

      :lValign := .T.
      :lContainer := .F.

      :cBackground       := cBGImage
      :cBackgroundSize   := "cover"
      :lBackgroundRepeat := .F.

      // Dentro de la web montamos un primer contenedor bEvel que ocupa 4/12 anchura en pantallas grandes
      // en una mediana o pequeña se adaptará responsivamente ya que no le damos tamaño
      /*
      With Object WImage():New(:WO)
         :cImage:="./connecti/resource/images/connecti-consultoria-logo.png"
         :cOnClick:="#window.open('http://connecticonsultoria.com.br/','_blank');"
         :cCursor:="pointer"
         :Create()
      End With
      */

      Footer(:WO,"./connecti/resource/images/connecti-consultoria-150x45-white.png","#E1D9D1")

      oCgi:SendPage(:Create())        // Se crea el HTML final y se envía al navegador saliendo del ejecutable CGI

   END WITH

RETURN

//------------------------------------------------------------------------------
// Aquí contruyo el wRebar y el wSideNav,al estar en un PROCEDURE aparte puedo crearlos dentro de cualquiera de
// las tWebPage del proyecto
// Necesito tWebPage donde he de crearlos,asi que se lo paso como parametro en oParent
PROCEDURE AppMenu(oParent,cTitle,hUser,lOpen,lFixed,lRemoveParam,lWBadge)

   LOCAL cCSS
   LOCAL cEmp := oCGI:GetUserData("cEmp",AppData:cEmp)
   LOCAL aEmp := GetEmp(cEmp)
   LOCAL cCopyright

   DEFAULT cTitle TO AppData:AppName
   DEFAULT lOpen  TO .F.
   DEFAULT lFixed TO .F.

   cCopyright := "<a href='http://connecticonsultoria.com.br/' target='_blank' style='color: #FFFFFF'><b>Connec<span style='color:#45DD98'>ti</span> Consultoria</b></a>"
   cCopyright += " | "
   cCopyright += "Copyright © "
   cCopyright += ToString(Year(Date()))
   cCopyright += " | Todos os direitos reservados"

   hb_default(@lRemoveParam,.T.)
   lRemoveParam := (lRemoveParam .AND. oCGI:GetUserData("HistoryRemoveParams",lRemoveParam))

   // Voy ha aprobechar para asignarle propiedades a tWebPage que se repiten en todas las páginas
   WITH object oParent AS TWebPage
      :lContainer       := .T.
      :lValign          := .T.
      :cClrFootPane     := "#012444"
      :lFooterContainer := .F.
      :cTitleFooter     := ""
      :cSubTitle        := ""
      :cCopyright       := "<span style='font-size:75%'>" + cCopyright + "</style>"
      :cShadowSheetTitle    := Lang(LNG_SSTITLE)
      :cShadowSheetSubTitle := Lang(LNG_SSSUBTITLE)
      :lMenuFixed       := .F. //lFixed .or. lOpen
      :cLanguage         := { "pt-BR","es-ES" }[ AppData:nLang ]
      :cInHead          := '<meta name="google" content="notranslate" />'
      :cInMain          += HistoryReplaceState(lRemoveParam)
      IF (!lRemoveParam)
         :cInMain := HistoryNoRaplaceParams(:cInMain)
      ENDIF
   END WITH

   // Instanciamos el wSideNav (El menú lateral)
   //https://materializecss.com/icons.html
   //https://fonts.google.com/icons
   WITH object WSideNav():New(oParent)

      //BackGround Color dos Itens
      cCSS:="ul {background-color:#012444 !important;}"
      if !(cCSS$:cCSS)
         :cCSS+=cCSS
      endif

      //Alinhamento da Imagem de Titulo
      cCSS :="#menu_imagetitle {text-align: left !important;}"
      if !(cCSS$:cCSS)
         :cCSS+=cCSS
      endif

      //Tamanho da Linha entre a Imagem de Titulo de o Nome do Usuario
      cCSS :=".sidenav li { line-height: 2px !important;}"
      if !(cCSS$:cCSS)
         :cCSS+=cCSS
      endif

      //Largura do Menu
      cCSS :=".sidenav { width: 350px !important;}"
      if !(cCSS$:cCSS)
         :cCSS+=cCSS
      endif

      :oStyle:cFont_family:="'Helvetica Neue','Helvetica',-apple-system,BlinkMacSystemFont,'Segoe UI',Roboto,Oxygen-Sans,Ubuntu,Cantarell,'Helvetica Neue',sans-serif"

      // Como todas las propiedades image de Néfele podemos asiganerle una URL,un path de nuestro Apache o un BASE64
      :cImageTitle  := "./connecti/resource/images/connecti-consultoria-150x45-white.png"
      :oStyleTitle:cText_align:=xc_Left

      :cId          := "Menu"
      :lShadowSheet := .T.
      :lCompress    := .T.

      :cBackgroundColor := "#012444"
      :cClrText := "#E1D9D1"

      :AddHeader(hUser[ "name" ],"#012444","#E1D9D1")

      :AddDivider("#12BAEB")

      IF (!Empty(aEmp))
         :AddHeader(aEmp[ 2 ],"#012444","#E1D9D1")
         :AddDivider("#17202A")
      ENDIF

      :AddItem(Lang(LNG_INICIO),"MainFunction","home",/*nStyle*/,/*aParams*/,/*cAction*/,/*aBadge*/,"#012444"/*cClrPane*/,"#E1D9D1"/*cClrText*/,/*lShadowSheet*/)

      :AddDivider("#17202A")

      IF (hUser["adminuser"])
         :AddItem(Lang(LNG_USUARIOS),"Usuarios","people",/*nStyle*/,/*aParams*/,/*cAction*/,/*aBadge*/,"#012444"/*cClrPane*/,"#E1D9D1"/*cClrText*/,/*lShadowSheet*/)
         :AddDivider("#17202A")
      ENDIF

      :AddSubMenu("Parâmetros",/*aBadge*/,"settings"/*cIcon*/,"#012444"/*cClrPane*/,"#E1D9D1"/*cClrText*/,/*lOpen*/)
      :AddItem("Parâmetros","GEPParametersShow","settings",/*nStyle*/,/*aParams*/,/*cAction*/,/*aBadge*/,"#012444"/*cClrPane*/,"#E1D9D1"/*cClrText*/,/*lShadowSheet*/)
      :EndSubMenu()

      :AddDivider("#17202A")

      :AddSubMenu("Cadastros",/*aBadge*/,"storage"/*cIcon*/,"#012444"/*cClrPane*/,"#E1D9D1"/*cClrText*/,/*lOpen*/)

      :AddItem("Filiais","CadastroFiliais","business",/*nStyle*/,/*aParams*/,/*cAction*/,/*aBadge*/,"#012444"/*cClrPane*/,"#E1D9D1"/*cClrText*/,/*lShadowSheet*/)
      :AddItem("C.Custo","CadastroCentrosDeCusto","business_center",/*nStyle*/,/*aParams*/,/*cAction*/,/*aBadge*/,"#012444"/*cClrPane*/,"#E1D9D1"/*cClrText*/,/*lShadowSheet*/)
*      :AddItem("Departamentos","CadastroDepartamentos","",/*nStyle*/,/*aParams*/,/*cAction*/,/*aBadge*/,"#012444"/*cClrPane*/,"#E1D9D1"/*cClrText*/,/*lShadowSheet*/)
      :AddItem("Funcoes","CadastroFuncoes","work",/*nStyle*/,/*aParams*/,/*cAction*/,/*aBadge*/,"#012444"/*cClrPane*/,"#E1D9D1"/*cClrText*/,/*lShadowSheet*/)
      :AddItem("Periodos","CadastroPeriodosSRD","date_range",/*nStyle*/,/*aParams*/,/*cAction*/,/*aBadge*/,"#012444"/*cClrPane*/,"#E1D9D1"/*cClrText*/,/*lShadowSheet*/)
      :AddDivider("#17202A")
      :AddSubMenu("Verbas",/*aBadge*/,"money"/*cIcon*/,"#012444"/*cClrPane*/,"#E1D9D1"/*cClrText*/,/*lOpen*/)
      :AddItem("Grupos","CadastroGruposMaster","group",/*nStyle*/,/*aParams*/,/*cAction*/,/*aBadge*/,"#012444"/*cClrPane*/,"#E1D9D1"/*cClrText*/,/*lShadowSheet*/)
      :AddItem("SubGrupos","CadastroGrupos","group_add",/*nStyle*/,/*aParams*/,/*cAction*/,/*aBadge*/,"#012444"/*cClrPane*/,"#E1D9D1"/*cClrText*/,/*lShadowSheet*/)
      :AddItem("Verbas","CadastroVerbas","attach_money",/*nStyle*/,/*aParams*/,/*cAction*/,/*aBadge*/,"#012444"/*cClrPane*/,"#E1D9D1"/*cClrText*/,/*lShadowSheet*/)
      :EndSubMenu()
      :EndSubMenu()

      :AddDivider("#17202A")

      :AddSubMenu("Consultas :: Grupo",/*aBadge*/,"group"/*cIcon*/,"#012444"/*cClrPane*/,"#E1D9D1"/*cClrText*/,/*lOpen*/)

      :AddSubMenu("Detalhes",/*aBadge*/,/*cIcon*/,"#012444"/*cClrPane*/,"#E1D9D1"/*cClrText*/,/*lOpen*/)
      :AddItem("Empresa","GrpMasterVerbasEmpresa","",/*nStyle*/,/*aParams*/,/*cAction*/,/*aBadge*/,"#012444"/*cClrPane*/,"#E1D9D1"/*cClrText*/,/*lShadowSheet*/)
      :AddItem("Filial","GrpMasterVerbasFilial","",/*nStyle*/,/*aParams*/,/*cAction*/,/*aBadge*/,"#012444"/*cClrPane*/,"#E1D9D1"/*cClrText*/,/*lShadowSheet*/)
      :AddItem("C. Custo","GrpMasterVerbasCentroDeCusto","",/*nStyle*/,/*aParams*/,/*cAction*/,/*aBadge*/,"#012444"/*cClrPane*/,"#E1D9D1"/*cClrText*/,/*lShadowSheet*/)
      :AddItem("Funcionarios","GrpMasterVerbasFuncionarios","",/*nStyle*/,/*aParams*/,/*cAction*/,/*aBadge*/,"#012444"/*cClrPane*/,"#E1D9D1"/*cClrText*/,/*lShadowSheet*/)
      :EndSubMenu()

      :AddDivider("#17202A")

      :AddSubMenu("Totais",/*aBadge*/,/*cIcon*/,"#012444"/*cClrPane*/,"#E1D9D1"/*cClrText*/,/*lOpen*/)
      :AddItem("Empresa","TotaisGrpMasterVerbasEmpresa","",/*nStyle*/,/*aParams*/,/*cAction*/,/*aBadge*/,"#012444"/*cClrPane*/,"#E1D9D1"/*cClrText*/,/*lShadowSheet*/)
      :AddItem("Empresa Det","TotaisGrpMasterVerbasEmpresaDet","",/*nStyle*/,/*aParams*/,/*cAction*/,/*aBadge*/,"#012444"/*cClrPane*/,"#E1D9D1"/*cClrText*/,/*lShadowSheet*/)
      :AddItem("Filial","TotaisGrpMasterVerbasFilial","",/*nStyle*/,/*aParams*/,/*cAction*/,/*aBadge*/,"#012444"/*cClrPane*/,"#E1D9D1"/*cClrText*/,/*lShadowSheet*/)
      :AddItem("Filial Det","TotaisGrpMasterVerbasFilialDet","",/*nStyle*/,/*aParams*/,/*cAction*/,/*aBadge*/,"#012444"/*cClrPane*/,"#E1D9D1"/*cClrText*/,/*lShadowSheet*/)
      :AddItem("C. Custo","TotaisGrpMasterVerbasCentroDeCusto","",/*nStyle*/,/*aParams*/,/*cAction*/,/*aBadge*/,"#012444"/*cClrPane*/,"#E1D9D1"/*cClrText*/,/*lShadowSheet*/)
      :AddItem("C. Custo Det","TotaisGrpMasterVerbasCentroDeCustoDet","",/*nStyle*/,/*aParams*/,/*cAction*/,/*aBadge*/,"#012444"/*cClrPane*/,"#E1D9D1"/*cClrText*/,/*lShadowSheet*/)
      :EndSubMenu()

      :AddDivider("#17202A")

      :AddSubMenu("Graficos",/*aBadge*/,"show_chart"/*cIcon*/,"#012444"/*cClrPane*/,"#E1D9D1"/*cClrText*/,/*lOpen*/)
      :AddItem("Empresa","TotaisGrpMasterVerbasEmpresa","",/*nStyle*/,/*aParams*/,/*cAction*/,/*aBadge*/,"#012444"/*cClrPane*/,"#E1D9D1"/*cClrText*/,/*lShadowSheet*/)
      :AddItem("Filial","ChartTotaisGrpMasterVerbasFilial","",/*nStyle*/,/*aParams*/,/*cAction*/,/*aBadge*/,"#012444"/*cClrPane*/,"#E1D9D1"/*cClrText*/,/*lShadowSheet*/)
      :AddItem("C.Custo","ChartTotaisGrpMasterVerbasCentroDeCusto","",/*nStyle*/,/*aParams*/,/*cAction*/,/*aBadge*/,"#012444"/*cClrPane*/,"#E1D9D1"/*cClrText*/,/*lShadowSheet*/)
      :EndSubMenu()

      :AddDivider("#17202A")

      :AddSubMenu("Provisões",/*aBadge*/,/*cIcon*/,"#012444"/*cClrPane*/,"#E1D9D1"/*cClrText*/,/*lOpen*/)
      :AddItem("Empresa","PainelGrpMasterVerbasEmpresa","",/*nStyle*/,/*aParams*/,/*cAction*/,/*aBadge*/,"#012444"/*cClrPane*/,"#E1D9D1"/*cClrText*/,/*lShadowSheet*/)
      :AddItem("Filial","PainelGrpMasterVerbasFilial","",/*nStyle*/,/*aParams*/,/*cAction*/,/*aBadge*/,"#012444"/*cClrPane*/,"#E1D9D1"/*cClrText*/,/*lShadowSheet*/)
      :AddItem("C. Custo","PainelGrpMasterVerbasCentroDeCusto","",/*nStyle*/,/*aParams*/,/*cAction*/,/*aBadge*/,"#012444"/*cClrPane*/,"#E1D9D1"/*cClrText*/,/*lShadowSheet*/)
      :AddItem("Funcionarios","PainelGrpMasterVerbasFuncionarios","",/*nStyle*/,/*aParams*/,/*cAction*/,/*aBadge*/,"#012444"/*cClrPane*/,"#E1D9D1"/*cClrText*/,/*lShadowSheet*/)
      :EndSubMenu()

      :EndSubMenu()

      :AddDivider("#17202A")

      :AddSubMenu("Consultas :: SubGrupo",/*aBadge*/,"group_add"/*cIcon*/,"#012444"/*cClrPane*/,"#E1D9D1"/*cClrText*/,/*lOpen*/)

      :AddSubMenu("Detalhes",/*aBadge*/,/*cIcon*/,"#012444"/*cClrPane*/,"#E1D9D1"/*cClrText*/,/*lOpen*/)

      :AddItem("Empresa","GrpVerbasEmpresa","",/*nStyle*/,/*aParams*/,/*cAction*/,/*aBadge*/,"#012444"/*cClrPane*/,"#E1D9D1"/*cClrText*/,/*lShadowSheet*/)
      :AddItem("Filial","GrpVerbasFilial","",/*nStyle*/,/*aParams*/,/*cAction*/,/*aBadge*/,"#012444"/*cClrPane*/,"#E1D9D1"/*cClrText*/,/*lShadowSheet*/)
      :AddItem("C.Custo","GrpVerbasCentroDeCusto","",/*nStyle*/,/*aParams*/,/*cAction*/,/*aBadge*/,"#012444"/*cClrPane*/,"#E1D9D1"/*cClrText*/,/*lShadowSheet*/)
      :AddItem("Verbas","GrpVerbasVerbas","",/*nStyle*/,/*aParams*/,/*cAction*/,/*aBadge*/,"#012444"/*cClrPane*/,"#E1D9D1"/*cClrText*/,/*lShadowSheet*/)
      :AddItem("Funcao","GrpVerbasFuncao","",/*nStyle*/,/*aParams*/,/*cAction*/,/*aBadge*/,"#012444"/*cClrPane*/,"#E1D9D1"/*cClrText*/,/*lShadowSheet*/)
      :AddItem("Funcionarios","GrpVerbasFuncionarios","",/*nStyle*/,/*aParams*/,/*cAction*/,/*aBadge*/,"#012444"/*cClrPane*/,"#E1D9D1"/*cClrText*/,/*lShadowSheet*/)

      :EndSubMenu()

      :AddDivider("#17202A")

      :AddSubMenu("Totais",/*aBadge*/,/*cIcon*/,"#012444"/*cClrPane*/,"#E1D9D1"/*cClrText*/,/*lOpen*/)
      :AddItem("Empresa","TotaisGrpVerbasEmpresa","",/*nStyle*/,/*aParams*/,/*cAction*/,/*aBadge*/,"#012444"/*cClrPane*/,"#E1D9D1"/*cClrText*/,/*lShadowSheet*/)
      :AddItem("Empresa Det","TotaisGrpVerbasEmpresaDet","",/*nStyle*/,/*aParams*/,/*cAction*/,/*aBadge*/,"#012444"/*cClrPane*/,"#E1D9D1"/*cClrText*/,/*lShadowSheet*/)
      :AddItem("Filial","TotaisGrpVerbasFilial","",/*nStyle*/,/*aParams*/,/*cAction*/,/*aBadge*/,"#012444"/*cClrPane*/,"#E1D9D1"/*cClrText*/,/*lShadowSheet*/)
      :AddItem("Filial Det","TotaisGrpVerbasFilialDet","",/*nStyle*/,/*aParams*/,/*cAction*/,/*aBadge*/,"#012444"/*cClrPane*/,"#E1D9D1"/*cClrText*/,/*lShadowSheet*/)
      :AddItem("C.Custo","TotaisGrpVerbasCentroDeCusto","",/*nStyle*/,/*aParams*/,/*cAction*/,/*aBadge*/,"#012444"/*cClrPane*/,"#E1D9D1"/*cClrText*/,/*lShadowSheet*/)
      :AddItem("C.Custo Det","TotaisGrpVerbasCentroDeCustoDet","",/*nStyle*/,/*aParams*/,/*cAction*/,/*aBadge*/,"#012444"/*cClrPane*/,"#E1D9D1"/*cClrText*/,/*lShadowSheet*/)
      :AddItem("Funcao","TotaisGrpVerbasFuncao","",/*nStyle*/,/*aParams*/,/*cAction*/,/*aBadge*/,"#012444"/*cClrPane*/,"#E1D9D1"/*cClrText*/,/*lShadowSheet*/)
      :AddItem("Funcao Det","TotaisGrpVerbasFuncaoDet","",/*nStyle*/,/*aParams*/,/*cAction*/,/*aBadge*/,"#012444"/*cClrPane*/,"#E1D9D1"/*cClrText*/,/*lShadowSheet*/)
      :EndSubMenu()

      :AddDivider("#17202A")

      :AddSubMenu("Graficos",/*aBadge*/,"show_chart"/*cIcon*/,"#012444"/*cClrPane*/,"#E1D9D1"/*cClrText*/,/*lOpen*/)
      :AddItem("Empresa","TotaisGrpVerbasEmpresa","",/*nStyle*/,/*aParams*/,/*cAction*/,/*aBadge*/,"#012444"/*cClrPane*/,"#E1D9D1"/*cClrText*/,/*lShadowSheet*/)
      :AddItem("Filial","ChartTotaisGrpVerbasFilial","",/*nStyle*/,/*aParams*/,/*cAction*/,/*aBadge*/,"#012444"/*cClrPane*/,"#E1D9D1"/*cClrText*/,/*lShadowSheet*/)
      :AddItem("C.Custo","ChartTotaisGrpVerbasCentroDeCusto","",/*nStyle*/,/*aParams*/,/*cAction*/,/*aBadge*/,"#012444"/*cClrPane*/,"#E1D9D1"/*cClrText*/,/*lShadowSheet*/)
      :AddItem("Funcao","ChartTotaisGrpVerbasFuncao","",/*nStyle*/,/*aParams*/,/*cAction*/,/*aBadge*/,"#012444"/*cClrPane*/,"#E1D9D1"/*cClrText*/,/*lShadowSheet*/)
      :EndSubMenu()

      :AddDivider("#17202A")

      :AddSubMenu("Provisões",/*aBadge*/,/*cIcon*/,"#012444"/*cClrPane*/,"#E1D9D1"/*cClrText*/,/*lOpen*/)
      :AddItem("Empresa","PainelGrpVerbasEmpresa","",/*nStyle*/,/*aParams*/,/*cAction*/,/*aBadge*/,"#012444"/*cClrPane*/,"#E1D9D1"/*cClrText*/,/*lShadowSheet*/)
      :AddItem("Filial","PainelGrpVerbasFilial","",/*nStyle*/,/*aParams*/,/*cAction*/,/*aBadge*/,"#012444"/*cClrPane*/,"#E1D9D1"/*cClrText*/,/*lShadowSheet*/)
      :AddItem("C.Custo","PainelGrpVerbasCentroDeCusto","",/*nStyle*/,/*aParams*/,/*cAction*/,/*aBadge*/,"#012444"/*cClrPane*/,"#E1D9D1"/*cClrText*/,/*lShadowSheet*/)
      :AddItem("Funcionarios","PainelGrpVerbasFuncionarios","",/*nStyle*/,/*aParams*/,/*cAction*/,/*aBadge*/,"#012444"/*cClrPane*/,"#E1D9D1"/*cClrText*/,/*lShadowSheet*/)
      :EndSubMenu()

      :EndSubMenu()

      :AddDivider("#17202A")

      :AddSubMenu("Consultas :: Grupo & SubGrupo",/*aBadge*/,"view_compact"/*cIcon*/,"#012444"/*cClrPane*/,"#E1D9D1"/*cClrText*/,/*lOpen*/)
      :AddSubMenu("Detalhes",/*aBadge*/,/*cIcon*/,"#012444"/*cClrPane*/,"#E1D9D1"/*cClrText*/,/*lOpen*/)
      :AddItem("Empresa","GrpMasterDetailVerbasEmpresa","",/*nStyle*/,/*aParams*/,/*cAction*/,/*aBadge*/,"#012444"/*cClrPane*/,"#E1D9D1"/*cClrText*/,/*lShadowSheet*/)
      :AddItem("Filial","GrpMasterDetailVerbasFilial","",/*nStyle*/,/*aParams*/,/*cAction*/,/*aBadge*/,"#012444"/*cClrPane*/,"#E1D9D1"/*cClrText*/,/*lShadowSheet*/)
      :AddItem("C.Custo","GrpMasterDetailVerbasCentroDeCusto","",/*nStyle*/,/*aParams*/,/*cAction*/,/*aBadge*/,"#012444"/*cClrPane*/,"#E1D9D1"/*cClrText*/,/*lShadowSheet*/)
      :AddItem("Funcionarios","GrpMasterDetailVerbasFuncionarios","",/*nStyle*/,/*aParams*/,/*cAction*/,/*aBadge*/,"#012444"/*cClrPane*/,"#E1D9D1"/*cClrText*/,/*lShadowSheet*/)
      :EndSubMenu()
      :EndSubMenu()

      :AddDivider("#17202A")

      :AddSubMenu("Consultas :: Acumulados Grupo",/*aBadge*/,"group"/*cIcon*/,"#012444"/*cClrPane*/,"#E1D9D1"/*cClrText*/,/*lOpen*/)
      :AddItem("Empresa","GrpMasterVerbasAcumuladosEmpresa","",/*nStyle*/,/*aParams*/,/*cAction*/,/*aBadge*/,"#012444"/*cClrPane*/,"#E1D9D1"/*cClrText*/,/*lShadowSheet*/)
      :AddItem("Filial","GrpMasterVerbasAcumuladosFilial","",/*nStyle*/,/*aParams*/,/*cAction*/,/*aBadge*/,"#012444"/*cClrPane*/,"#E1D9D1"/*cClrText*/,/*lShadowSheet*/)
      :AddItem("C. Custo","GrpMasterVerbasAcumuladosCentroDeCusto","",/*nStyle*/,/*aParams*/,/*cAction*/,/*aBadge*/,"#012444"/*cClrPane*/,"#E1D9D1"/*cClrText*/,/*lShadowSheet*/)
      :AddItem("Funcionarios","GrpMasterVerbasAcumuladosFuncionarios","",/*nStyle*/,/*aParams*/,/*cAction*/,/*aBadge*/,"#012444"/*cClrPane*/,"#E1D9D1"/*cClrText*/,/*lShadowSheet*/)
      :EndSubMenu()

      :AddDivider("#17202A")

      :AddSubMenu("Consultas :: TurnOver Geral",/*aBadge*/,"import_export"/*cIcon*/,"#012444"/*cClrPane*/,"#E1D9D1"/*cClrText*/,/*lOpen*/)
      :AddItem("Empresa","TurnOverGeralEmpresa","",/*nStyle*/,/*aParams*/,/*cAction*/,/*aBadge*/,"#012444"/*cClrPane*/,"#E1D9D1"/*cClrText*/,/*lShadowSheet*/)
      :AddItem("Filial","TurnOverGeralFilial","",/*nStyle*/,/*aParams*/,/*cAction*/,/*aBadge*/,"#012444"/*cClrPane*/,"#E1D9D1"/*cClrText*/,/*lShadowSheet*/)
      :AddItem("C. Custo","TurnOverGeralCentroDeCusto","",/*nStyle*/,/*aParams*/,/*cAction*/,/*aBadge*/,"#012444"/*cClrPane*/,"#E1D9D1"/*cClrText*/,/*lShadowSheet*/)
      :AddItem("Funções","TurnOverGeralFuncoes","",/*nStyle*/,/*aParams*/,/*cAction*/,/*aBadge*/,"#012444"/*cClrPane*/,"#E1D9D1"/*cClrText*/,/*lShadowSheet*/)
      :AddItem("Funcionários","TurnOverGeralFuncionarios","",/*nStyle*/,/*aParams*/,/*cAction*/,/*aBadge*/,"#012444"/*cClrPane*/,"#E1D9D1"/*cClrText*/,/*lShadowSheet*/)
      :EndSubMenu()

      :AddDivider("#17202A")

      :AddItem("Sobre","About","info",/*nStyle*/,/*aParams*/,/*cAction*/,/*aBadge*/,"#012444"/*cClrPane*/,"#E1D9D1"/*cClrText*/,/*lShadowSheet*/)

      :AddDivider("#12BAEB")

      :AddItem(Lang(LNG_LOGOUT),"LogOut","exit_to_app",/*nStyle*/,/*aParams*/,/*cAction*/,/*aBadge*/,"#012444"/*cClrPane*/,"#E1D9D1"/*cClrText*/,/*lShadowSheet*/)

      :Create()

   END WITH

   // Vamos con el wRebar
   WITH object WRebar():New(oParent)

      // Por defecto el wRebar esta creado para estar dividido en 3 areas,MenuNav,Titulo y Logo
      // Podemos no poner cualquiera de los tres elementos,e incluso podemos utilizar el wRebar como un contenedor
      // y crear dentro de el otros controles.
      :cClrPane    := "#012444"
      :cClrTitle   := "#E1D9D1"
      :lBeforeMain := .T.     // Forzamos a que el wRebar este fuera del <main>
      :lMenuNav    := .T.     // Lleva el icono de apertuta del wSideNav
      :lBlock      := .T.     // Se queda fijo en la parte alta aunque se produzca un scroll
      :cTitle      := cTitle
      :cTitleAlign := xc_Left // Podemos colocar el MenuNav,el Titulo y el Logo en cualquira de las tres posiciones left,center y right
      :lShowMenuInDesktop := !lOpen

      HB_Default(@lWBadge,.T.)
      IF (lWBadge)
         WITH OBJECT WBadge():New(:WO)
            :cClass := "hide-on-small-only"
            :cText := hUser[ "user" ]
            :lChips := .T.
            :oIcon:cIcon:= "person"
            :oStyle:cMargin_top := ".9rem"
            :oStyle:cMargin_right := 4
            :cToolTip := Lang(LNG_LOGOUT)
            :cClrPane := "orange"
            :cOnClick := "logout"
            :Create()
         END WITH
      ENDIF
      :Create()
   END WITH

RETURN

PROCEDURE __clearcodModelFilter()

   LOCAL aFilters

   LOCAL cFilter

   LOCAL nFilter
   LOCAL nFilters

   aFilters := codModelFilter()
   nFilters := Len(aFilters)

   FOR nFilter := 1 TO nFilters
      cFilter := aFilters[ nFilter ]
      oCGI:SetUserData(cFilter + ":hFilter",{ => })
   NEXT nModel

RETURN

FUNCTION codModelFilter(cFilter)

   LOCAL aFilters

   LOCAL nATFilter

   aFilters := oCGI:GetUserData("FilterModel:hFilter",Array(0))

   IF (!Empty(cFilter))

      nATFilter := AScan(aFilters,{| x | (x == cFilter) })

      IF (nATFilter == 0)
         AAdd(aFilters,cFilter)
      ENDIF

      oCGI:SetUserData("FilterModel:hFilter",aFilters)

   ENDIF

return(aFilters)

PROCEDURE __clearUserData()

   __clearCadastroGrupos()
   __clearCadastroVerbas()
   __clearCadastroFiliais()
   __clearCadastroFuncoes()
   __clearCadastroPeriodosSRD()
   __clearCadastroGruposMaster()
   __clearCadastroCentrosDeCusto()

   __clearGrpVerbasFilial()
   __clearGrpVerbasFuncao()
   __clearGrpVerbasVerbas()
   __clearGrpVerbasEmpresa()
   __clearGrpVerbasCentroDeCusto()
   __clearGrpVerbasFuncionarios()

   __clearGrpMasterVerbasFilial()
   __clearGrpMasterVerbasEmpresa()
   __clearGrpMasterVerbasCentroDeCusto()
   __clearGrpMasterVerbasFuncionarios()

   __clearPainelGrpVerbasFilial()
   __clearPainelGrpVerbasEmpresa()
   __clearPainelGrpVerbasFuncionarios()
   __clearPainelGrpVerbasCentroDeCusto()

   __clearGrpMasterVerbasAcumuladosFuncionarios()

   __clearGEPParameters()

   __clearcodModelFilter()

   __clearPainelGrpVerbasFilial()
   __clearPainelGrpVerbasEmpresa()
   __clearPainelGrpVerbasFuncionarios()
   __clearPainelGrpVerbasCentroDeCusto()

   __clearPainelGrpMasterVerbasFuncionarios()
   __clearPainelGrpMasterVerbasCentroDeCusto()

   __clearGrpMasterVerbasAcumuladosFilial()
   __clearGrpMasterVerbasAcumuladosCentroDeCusto()
   __clearGrpMasterVerbasAcumuladosFuncionarios()

   __clearTurnOverGeralFilial()
   __clearTurnOverGeralFuncoes()
   __clearTurnOverGeralEmpresa()
   __clearTurnOverGeralFuncionarios()
   __clearTurnOverGeralCentroDeCusto()

   oCGI:SetUserData("lGrupoHasSuper",.F.)
   oCGI:SetUserData("lGrpViewTotais",.F.)
   oCGI:SetUserData("HistoryRemoveParams",.T.)
   oCGI:SetUserData("GetDataModel:cSearchFilter","")

RETURN

FUNCTION clearUserData()
return(__clearUserData())
