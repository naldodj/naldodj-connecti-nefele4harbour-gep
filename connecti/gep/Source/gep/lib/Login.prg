/*
 * Proyecto: Cartahelamore
 * Fichero: Login.prg
 * Descricao:
 * Autor:
 * Fecha: 18/05/2021
 */

#include "Xailer.ch"
#include "Nefele.ch"
#include "LangCGI.ch"


PROCEDURE Login(aParams)

   local cBGImage:="./connecti/resource/images/"+IF(Time()>="18:00>00".or.Time()<="06:00:00","connecti-consultoria-login-background-at-night.jpg","connecti-consultoria-login-background-in-the-morning.jpg")

   // Comenzamos instanciando la Página Web que queremos crear
   With Object wTWebPage():New()

      :cTitle            := ("Connecti :: "+AppData:AppTitle)
      :lValign           := .T.
      :cSubTitle         := ""
      :lFooterContainer  := .F.
      :cClrFootPane      := "#012444"//"#45DD98"
      :lBackgroundRepeat := .F.
      :cBackgroundSize   := "cover"
      :cBackground       := cBGImage
      :cLanguage         := {"pt-BR","es-ES"}[AppData:nLang]
      :cInHead          := '<meta name="google" content="notranslate" />'
      :cInMain          += HistoryReplaceState()
      :cInMain          += localStorageClear()

      StyleFooter(:WO)
      RebarMobil(:WO)
      Footer( :WO , "./connecti/resource/images/connecti-consultoria-150x45-white.png" , "#E1D9D1"  )

      //Como la Procedure se llama a si misma controlamos si recibe error de identificación
      if !Empty(aParams)
         if aParams[1,1] == "ERROR"
            WITH OBJECT WMsgAlert():New(:WO)
               :lTagScript       := .T.
               :cText            := Lang(LNG_ERRORLOGIN)
               :cType            := "error"
               :nPrimaryDelay    := 5
               :cConfirmButton   := Lang(LNG_ACEPTAR)
               :Create()
            END WITH
         endif
      endif

      With Object WPanel():New(:WO)
         :aWidth[xc_L]   := 8
         :aOffSet[xc_L]  := 2
         :oStyle:cBorder_radius := "20px"
         :oStyle:cBorder_style  := "ridge"
         :oStyle:cBorder_color  := "#012444"//"#45DD98"
         :oStyle:cBackground  := "rgb(0,0,0,.8) !important"//"#45DD98"

         // Un texto de tamaño grande tendrá un título
         With Object WLabel():New(:WO)
            :nFontSize     := 5
            :lBold         := .T.
            :cAlign        := xc_Center
            :cText         := "Bem Vindo!"//Lang(LNG_MSGLOGIN)
            :cClrText      := "#808080"
            :Create()
         End With

         with object WForm():New(:WO)
            :cFunction  := "ControlAcceso"   //Al tener un botón lSubmit:=.T. esta cFunction pasa a la función llamada el contenido de todas las variables en un array aParams
            :lUniqueId  := .T.
            with object WEdit():New(:WO)
               :cId        := "usuario"
               WITH OBJECT:oStyle
                  :cFont:="Helvetica"
                  :cFont_family:="'Helvetica Neue','Helvetica',-apple-system,BlinkMacSystemFont,'Segoe UI',Roboto,Oxygen-Sans,Ubuntu,Cantarell,'Helvetica Neue',sans-serif !important;"
                  :cColor:="#fff"
               END
               :cTitle     := "<b><span style='color:#808080'>"+nfl_Tag("b",Lang(LNG_USERID))+"</span></b>"
               :cValue     := oCGI:GetCgiValue("usuario","")
               :aWidth[xc_M]  := 6
               :cHintClrText := "#808080"
               :cTitleClrText := "#808080"
               :cIcon      := "person"
               :SetRequired()
               :Create()
            endwith

            with object WEdit():New(:WO)
               :cId           := "password"
               WITH OBJECT:oStyle
                  :cFont:="Helvetica"
                  :cFont_face:="Helvetica"
                  :cFont_family:="'Helvetica Neue','Helvetica',-apple-system,BlinkMacSystemFont,'Segoe UI',Roboto,Oxygen-Sans,Ubuntu,Cantarell,'Helvetica Neue',sans-serif !important;"
                  :cColor:="#fff"
               END WITH
               :cTitleClrText := :oStyle:cColor
               :cTitle        := "<b><span>"+nfl_Tag("b",Lang(LNG_USERPASS))+"</span></b>"
               :cValue        := oCGI:GetCgiValue("password","")
               :aWidth[xc_M]  := 6
               :cIcon         := "lock"
               :SetPassword()
               :SetRequired()
               :Create()
            endwith

           With Object WComboBox():New(:WO)
               :cId             := "cEmp"
               WITH OBJECT:oStyle
                  :cFont:="Helvetica"
                  :cFont_face:="Helvetica"
                  :cFont_family:="'Helvetica Neue','Helvetica',-apple-system,BlinkMacSystemFont,'Segoe UI',Roboto,Oxygen-Sans,Ubuntu,Cantarell,'Helvetica Neue',sans-serif !important;"
                  :cColor:="#808080"
               END WITH
               :cTitleClrText := :oStyle:cColor
               :cIcon           := "business"
               :oIcon:cIcon:=:cIcon
               :oIcon:cClrIcon := "#FED300"
               :cTitle          := "<b><span style='color:"+:cTitleClrText+" !important'>"+nfl_Tag("b",Lang(LNG_EMPRESA))+"</span></b>"
               :aItems          := GetSM0()
               :cSelected       := :aItems[1][1]
               :aWidth[xc_M]    := 12
               :cOnChange       := "CambiaEmp"
               :cCSS+='.select-wrapper input.select-dropdown {color:white !important;}'
               :cCSS+='.dropdown-content {background-color:#808080 !important;}'
               :Create()
            End With

            With Object WComboBox():New(:WO)
               :cId             := "idioma"
               WITH OBJECT:oStyle
                  :cFont:="Helvetica"
                  :cFont_face:="Helvetica"
                  :cFont_family:="'Helvetica Neue','Helvetica',-apple-system,BlinkMacSystemFont,'Segoe UI',Roboto,Oxygen-Sans,Ubuntu,Cantarell,'Helvetica Neue',sans-serif !important;"
                  :cColor:="#808080"
               END WITH
               :cTitleClrText := :oStyle:cColor
               :cIcon           := "g_translate"
               :oIcon:cIcon:=:cIcon
               :oIcon:cClrIcon := "#FED300"
               :cTitle          := "<b><span style='color:"+:cTitleClrText+"'>"+nfl_Tag("b",Lang(LNG_IDIOMA))+"</span></b>"
               :AddItem(1,"Português/Brasileiro",,"./idiomas/br.png")
               :AddItem(2,"Español",,"./idiomas/es.png")
               :cSelected       := AppData:nLang
               :aWidth[xc_M]    := 12
               :cOnChange       := "CambiaIdioma"
               :Create()
            End With

            With Object WSeparator():New(:WO)
               :lBR  := .T.
               :Create()
            End With

            with object WButton():New(:WO)
               :cId        := "submit"
               :cText      := nfl_Tag("b","Entrar")//Lang(LNG_ACCEDER)
               :lSubmit    := .T.
               :lVisible   := .T.
               :lLarge     := .F.
               :lCenter    := .T.
               :lBold      :=.T.
               :cClrText   :="white"
               :oStyle:cBackground_color:="#45DD98" //"#012444"
               :cIcon:="check_circle"//"navigate_next"
               :cIconSize:=Lower("large")
               :cIconAlign:="right"
               :cPosition := "center"
               :Create()
            endwith

            :Create()
         end with

         :AddParam({"usuario","#usuario"})
         :AddParam({"password","#password"})
         :AddParam({"cEmp","#cEmp:selected"})

         :Create()

      End With

      oCgi:SendPageNoCache( :Create() )        // Se crea el HTML final y se envía al navegador saliendo del ejecutable CGI

   End With

RETURN

//------------------------------------------------------------------------------
//Controlar que el usuario y la contraseña sean correctos
Procedure ControlAcceso()

   local nId   := 0
   local cEmp  := oCgi:GetCGIValue( "cEmp","" )
   local cUser := oCgi:GetCGIValue( "usuario","" )
   local cPass := oCgi:GetCgiValue( "password","" )

   IF (!Empty(cEmp))
      AppData:cEmp:=cEmp
      oCGI:SetUserData("cEmp",AppData:cEmp)
      AppData:tenantId:=cEmp
      oCGI:SetUserData("tenantId",AppData:tenantId)
      AppData:PathCfg:=AppData:PathScripts+cEmp+"\cfg\"
      oCGI:SetUserData("PathCfg",AppData:PathCfg)
   endif

   oCGI:DeleteCookie("appccuser")

   IF (!nfl_ChkFormUID())
      nId := 0
   ELSE
      //Comprobar usuario y password
      nId:=CheckUserLogin(cUser,cPass)
   ENDIF

   if nId == 0
      Sleep(2000)
      Login({{"ERROR","ERROR"}})       //Rellama a Login con el parámetro ERROR := "ERROR" para que sea mostrado y vuelva a pedir el login
      Quit                             //Aborta el Cgi para que deje de ejecutar lo que podría estar debajo
   else
      //Alimentamos una cookie con los datos de la persona validada
      oCGI:SendCodefCookie("appccuser",cUser,oCGI:nDuracionCookie)   //Le damos una caducidad por defecto son 5 min.
      AppData:nLang:=Val(oCgi:GetCgiValue("idioma","1"))
      MainPage()
      QUIT
   ENDIF

Return

//------------------------------------------------------------------------------

PROCEDURE LogOut()
   local hIni:=gepIni()
   local cEmp:=hIni["rest"]["Emp"]
   local aDisabledHosts:=oCGI:GetUserData("DISABLED_JSONSERVER_HOST",Array(0))
   oCGI:DeleteCookie("appccuser")
   oCGI:SetUserData("cEmp",cEmp)
   __clearUserData()
   AEval(aDisabledHosts,{|cDisabledHost|oCGI:SetUserData(cDisabledHost,"")})
   ASize(aDisabledHosts,0)
   oCGI:SetUserData("DISABLED_JSONSERVER_HOST",aDisabledHosts)
   Login()
   QUIT
RETURN

//------------------------------------------------------------------------------

FUNCTION LoginUser()

   local oUser := oCGI:GetCodefCookie("appccuser")
   local cUser,hUser

   IF HB_IsNIL( oUser )
      LogOut()
   ELSE
      IF oUser:ErrorCode[1] == 0
         cUser := oUser:Value
         IF HB_IsNIL( hUser := GetUser( cUser ) )
            LogOut()
         ELSE
            oCGI:SendCodefCookie("appccuser",cUser,oCGI:nDuracionCookie)
         ENDIF
      ELSE
         LogOut()
      ENDIF
   ENDIF

RETURN hUser

//------------------------------------------------------------------------------

STATIC PROCEDURE StyleFooter( oParent )
   WITH OBJECT wStyle():New(oParent)
      :cId := ".flex-container"
      :cDisplay := "flex"
      :cFlex_direction := "row"
      WITH OBjECT :AddMedia(,400)
         :ostyle:cFlex_direction := "column"
      END WITH
      :Create()
   END WITH
RETURN

//------------------------------------------------------------------------------

STATIC PROCEDURE RebarMobil( oParent )
   With Object WRow():New(oParent)
      :cClass := "top-nav"
      :lBeforeMain := .T.
      :aWidth := {12,0,0,0}
      :oStyle:cFlex_direction := "row"
      :oStyle:cDisplay := "flex"
      :cBackgroundColor:="#012444"//"#45DD98"
      With Object WImage():New(:WO)
         :aWidth[xc_L] := 6
         :cImage:= "./connecti/resource/images/connecti-consultoria-150x45-white.png"
         :cName:="connecti-consultoria-150x45-white.png"
         :cAlt:="connecti-consultoria-150x45-white.png"
         with OBJECT :oStyle
            :cHeight := "30px"
            :cMargin_top := "2px"
            :cPadding    :=  0
         END WITH
         :Create()
      End With
      With Object WBevel():New(:WO)
         :aWidth[xc_L] := 6
         with OBJECT :oStyle
            :cPadding_left :=  0
            :cText_align := "right"
            :cDisplay := "flex"
         END WITH
         :lValing := .T.
         With Object WLabel():New(:WO)
         with OBJECT :oStyle
            :cPadding :=  0
            :cMargin  := 0
            :cColor:="white !important"
         END WITH
            :nHeaderSize   := 6
            :lBold         := .T.
            :lBR           := .T.
            :cText         := AppData:AppName
            :Create()
         End With
         :Create()
      END WITH
      :Create()
   END WITH

RETURN

//------------------------------------------------------------------------------

PROCEDURE Footer( oParent , cImage , cClrText )
   HB_Default(@cImage,"./connecti/resource/images/connecti-consultoria-logo.png")
   HB_Default(@cClrText,"black")
   With Object WRow():New( oParent )
      :lInFooter := .T.
      :oStyle:cDisplay := "flex"
      With Object WBevel():New(:WO)
         :aWidth := { 0,4,4,4 }
         With Object WImage():New(:WO)
            :cImage       := cImage
            :lResponsive  := .T.
            :cOnClick:="#window.open('http://connecticonsultoria.com.br/','_blank');"
            :cCursor:="pointer"
            with OBJECT :oStyle
                :cHeight := "35px"
                :cMargin_top := "1px"
            END WITH
            :Create()
         End With
         :Create()
      END WITH
      With Object WBevel():New(:WO)
         :aWidth[xc_M] := 8
         :oStyle:cDisplay := "flex"
         With Object WBevel():New(:WO)
            :aWidth[xc_M] := 6
            :aWidth[xc_S] := 0
            :oStyle:cDisplay := "flex"
            :lValing := .T.
            With Object WLabel():New(:WO)
               :oStyle:cMargin := 0
               :nHeaderSize   := 6
               :lBold         := .T.
               :cAlign        := xc_Center
               :lBR           := .T.
               :cText         := "<span style=color:"+cClrText+">"+AppData:AppName+"</span>"
               :Create()
            End With
            :Create()
         END WITH
         With Object WBevel():New(:WO)
            :aWidth[xc_M] := 6
            :oStyle:cText_align := "right"
            :oStyle:cPadding   := 0
            :oStyle:cDisplay := "flex"
            :oStyle:cAlign_items := "flex-end"
            With Object WLabel():New(:WO)
               :oStyle:cFont_size := "1.5vh"
               :oStyle:cPadding   := 0
               :cAlign        := xc_Right
               :cText         := "<span style=color:"+cClrText+">"+"© Connecti Consultoria " + ToString( Year(Date()) )+"</span>"
               :Create()
            End With
            :Create()
         End With
         :Create()
      End With
      :Create()
   End With
RETURN

//------------------------------------------------------------------------------

PROCEDURE CambiaIdioma()
   AppData:nLang:=Val( oCGI:GetCgiValue("idioma","1") )
   oCGI:SetUserData("lang",AppData:nLang)
   Login()
RETURN

//------------------------------------------------------------------------------

PROCEDURE CambiaEmp()
   local cEmp:=oCgi:GetCgiValue("cEmp","")
   if (!Empty(cEmp))
      AppData:cEmp:=cEmp
      oCGI:SetUserData("cEmp",AppData:cEmp)
      AppData:tenantId:=cEmp
      oCGI:SetUserData("tenantId",AppData:tenantId)
   endif
RETURN

FUNCTION GetSM0()

    local aSource:=Array(0)

    local cEmp
    local cFile:=(AppData:RootPath+"data\"+Lower(ProcName())+".json")
    local codModel:="EMPRESAS"

    local hRow
    local hDatos

    getDataFieldsDef( codModel )
    hDatos:=GetDataModel(codModel,1,-1,0,"",{},.F.,.F.,cFile,"",.F.,codModel)

    if (!Empty(hDatos["data"]))
        for each hRow in hDatos["data"]
            cEmp:=hRow["codEmpresa"]
            if (ascan(aSource,{|x|(x[1]==cEmp)})==0)
                aAdd(aSource,{cEmp,cEmp+"-"+hRow["descEmpresa"]})
            endif
        next each
   endif

   return(aSource)

//------------------------------------------------------------------------------