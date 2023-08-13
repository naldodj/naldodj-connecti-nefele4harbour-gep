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

#define __MAXCOOKIETIME__ 99999999

PROCEDURE Login( aParams )

   LOCAL hIni
   LOCAL cEmp
   LOCAL cBGImage := "./connecti/resource/images/" + IF( Time() >= "18:00>00" .OR. Time() <= "06:00:00", "connecti-consultoria-login-background-at-night.jpg", "connecti-consultoria-login-background-in-the-morning.jpg" )

   IF ( Empty( oCGI:GetUserData("cEmp" ) ) )
      hIni := gepIni()
      cEmp := hIni[ "rest" ][ "Emp" ]
      oCGI:SetUserData( "cEmp", cEmp )
   ENDIF

   // Comenzamos instanciando la Página Web que queremos crear
   WITH OBJECT wTWebPage():New()

      :cTitle            := ( "Connecti :: " + AppData:AppTitle )
      :lValign           := .T.
      :cSubTitle         := ""
      :lFooterContainer  := .F.
      :cClrFootPane      := "#012444"//"#45DD98"
      :lBackgroundRepeat := .F.
      :cBackgroundSize   := "cover"
      :cBackground       := cBGImage
      :cLanguage         := { "pt-BR", "es-ES" }[ AppData:nLang ]
      :cInMain           += HistoryReplaceState()
      :cInMain           += localStorageClear()

      StyleFooter( :WO )
      RebarMobil( :WO )
      Footer( :WO, "./connecti/resource/images/connecti-consultoria-150x45-white.png", "#E1D9D1"  )

      //Como la Procedure se llama a si misma controlamos si recibe error de identificación
      IF !Empty( aParams )
         IF aParams[ 1, 1 ] == "ERROR"
            WITH OBJECT WMsgAlert():New( :WO )
               :lTagScript       := .T.
               :cText            := Lang( LNG_ERRORLOGIN )
               :cType            := "error"
               :nPrimaryDelay    := 5
               :cConfirmButton   := Lang( LNG_ACEPTAR )
               :Create()
            END WITH
         ENDIF
      ENDIF

      WITH OBJECT WPanel():New( :WO )

         :aWidth[ xc_L ]   := 8
         :aOffSet[ xc_L ]  := 2
         :oStyle:cBorder_radius := "20px"
         :oStyle:cBorder_style  := "ridge"
         :oStyle:cBorder_color  := "#012444"//"#45DD98"
         :oStyle:cBackground  := "rgb(0,0,0,.8) !important"//"#45DD98"

         // Un texto de tamaño grande tendrá un título
         WITH OBJECT WLabel():New( :WO )
            :nFontSize     := 5
            :lBold         := .T.
            :cAlign        := xc_Center
            :cText         := "Bem Vindo!"//Lang(LNG_MSGLOGIN)
            :cClrText      := "#808080"
            :Create()
         END WITH

         WITH OBJECT WForm():New( :WO )

            //Al tener un botón lSubmit:=.T.
            //esta cFunction pasa a la función llamada
            //el contenido de todas las variables en un array aParams
            :cFunction  := "ControlAcceso"
            :lUniqueId  := .T.

            :AddHTML('<input type="hidden" name="lChkFormUID" id="lchkformuid" value="1">')

            WITH OBJECT WEdit():New( :WO )
               :cId        := "usuario"
               WITH OBJECT:oStyle
                  :cFont := "Helvetica"
                  :cFont_family := "'Helvetica Neue','Helvetica',-apple-system,BlinkMacSystemFont,'Segoe UI',Roboto,Oxygen-Sans,Ubuntu,Cantarell,'Helvetica Neue',sans-serif !important;"
                  :cColor := "#fff"
               END
               :cTitle     := "<b><span style='color:#808080'>" + nfl_Tag( "b", Lang( LNG_USERID ) ) + "</span></b>"
               :cValue     := oCGI:GetCgiValue( "usuario", "" )
               :aWidth[ xc_M ]  := 6
               :cHintClrText := "#808080"
               :cTitleClrText := "#808080"
               :cIcon      := "person"
               :SetRequired()
               :Create()
            END WITH

            WITH OBJECT WEdit():New( :WO )
               :cId           := "password"
               WITH OBJECT:oStyle
                  :cFont := "Helvetica"
                  :cFont_face := "Helvetica"
                  :cFont_family := "'Helvetica Neue','Helvetica',-apple-system,BlinkMacSystemFont,'Segoe UI',Roboto,Oxygen-Sans,Ubuntu,Cantarell,'Helvetica Neue',sans-serif !important;"
                  :cColor := "#fff"
               END WITH
               :cTitleClrText := :oStyle:cColor
               :cTitle        := "<b><span>" + nfl_Tag( "b", Lang( LNG_USERPASS ) ) + "</span></b>"
               :cValue        := oCGI:GetCgiValue( "password", "" )
               :aWidth[ xc_M ]  := 6
               :cIcon         := "lock"
               :SetPassword()
               :SetRequired()
               :Create()
            END WITH

            WITH OBJECT WComboBox():New( :WO )
               :cId := "cEmp"
               WITH OBJECT:oStyle
                  :cFont := "Helvetica"
                  :cFont_face := "Helvetica"
                  :cFont_family := "'Helvetica Neue','Helvetica',-apple-system,BlinkMacSystemFont,'Segoe UI',Roboto,Oxygen-Sans,Ubuntu,Cantarell,'Helvetica Neue',sans-serif !important;"
                  :cColor := "#808080"
               END WITH
               :cTitleClrText := :oStyle:cColor
               :cIcon           := "business"
               :oIcon:cIcon := :cIcon
               :oIcon:cClrIcon := "#FED300"
               :cTitle          := "<b><span style='color:" + :cTitleClrText + " !important'>" + nfl_Tag( "b", Lang( LNG_EMPRESA ) ) + "</span></b>"
               :aItems          := GetSM0()
               :cSelected       := :aItems[ 1 ][ 1 ]
               :aWidth[ xc_M ]    := 12
               :cOnChange       := "CambiaEmp"
               :cCSS += '.select-wrapper input.select-dropdown {color:white !important;}'
               :cCSS += '.dropdown-content {background-color:#808080 !important;}'
               :Create()
            END WITH

            WITH OBJECT WComboBox():New( :WO )
               :cId := "idioma"
               WITH OBJECT:oStyle
                  :cFont := "Helvetica"
                  :cFont_face := "Helvetica"
                  :cFont_family := "'Helvetica Neue','Helvetica',-apple-system,BlinkMacSystemFont,'Segoe UI',Roboto,Oxygen-Sans,Ubuntu,Cantarell,'Helvetica Neue',sans-serif !important;"
                  :cColor := "#808080"
               END WITH
               :cTitleClrText  := :oStyle:cColor
               :cIcon          := "g_translate"
               :oIcon:cIcon    := :cIcon
               :oIcon:cClrIcon := "#FED300"
               :cTitle         := "<b><span style='color:" + :cTitleClrText + "'>" + nfl_Tag( "b", Lang( LNG_IDIOMA ) ) + "</span></b>"
               :AddItem( 1, "Português/Brasileiro",, "./idiomas/br.png" )
               :AddItem( 2, "Español",, "./idiomas/es.png" )
               :cSelected      := AppData:nLang
               :aWidth[ xc_M ] := 12
               :cOnChange      := "CambiaIdioma"
               :Create()
            END WITH

            /*WITH OBJECT WSeparator():New( :WO )
               :lBR  := .T.
               :Create()
            END WITH*/

            WITH OBJECT WButton():New( :WO )
               :cId        := "submit"
               :cText      := nfl_Tag( "b", "Entrar" )//Lang(LNG_ACCEDER)
               :lSubmit    := .T.
               :lVisible   := .T.
               :lLarge     := .F.
               :lCenter    := .T.
               :lBold      := .T.
               :cClrText   := "white"
               :oStyle:cBackground_color := "#45DD98"
               :cIcon := "check_circle"
               :cIconSize := Lower( "large" )
               :cIconAlign := "right"
               :cPosition := "center"
               :Create()
            END WITH

            :Create()

         END WITH

         :AddParam( { "usuario", "#usuario" } )
         :AddParam( { "password", "#password" } )
         :AddParam( { "cEmp", "#cEmp:selected" } )
         :AddParam( { "lChkFormUID", "#lChkFormUID" } )

         :Create()

      END WITH

      // Se crea el HTML final y se envía al navegador saliendo del ejecutable CGI
      oCgi:SendPageNoCache( :Create() )

   END WITH

RETURN

//------------------------------------------------------------------------------
//Controlar que el usuario y la contraseña sean correctos

PROCEDURE ControlAcceso()

   LOCAL nId   := 0
   LOCAL cEmp  := oCgi:GetCGIValue( "cEmp", "" )
   LOCAL cUser := oCgi:GetCGIValue( "usuario", "" )
   LOCAL cPass := oCgi:GetCgiValue( "password", "" )
   LOCAL lChkFormUID := ( oCgi:GetCgiValue( "lChkFormUID",oCGI:GetUserData("lChkFormUID" , "1" )) == "1" )

   oCGI:SetUserData("lChkFormUID",IF(lChkFormUID,"1","0"))

   IF ( !Empty( cEmp ) )
      AppData:cEmp := cEmp
      oCGI:SetUserData( "cEmp", AppData:cEmp )
      AppData:tenantId := cEmp
      oCGI:SetUserData( "tenantId", AppData:tenantId )
      AppData:PathCfg := AppData:PathScripts + cEmp + "\cfg\"
      oCGI:SetUserData( "PathCfg", AppData:PathCfg )
   ENDIF

   oCGI:DeleteCookie( "appccuser" )

   IF ( lChkFormUID .AND. !nfl_ChkFormUID() )
      nId := 0
   ELSE
      //Comprobar usuario y password
      nId := CheckUserLogin( cUser, cPass )
      IF (!lChkFormUID)
         oCGI:nDuracionCookie:=__MAXCOOKIETIME__
      ENDIF
   ENDIF

   IF nId == 0
      Sleep( 2000 )
      Login( { { "ERROR","ERROR" } } ) //Rellama a Login con el parámetro ERROR := "ERROR" para que sea mostrado y vuelva a pedir el login
      QUIT                             //Aborta el Cgi para que deje de ejecutar lo que podría estar debajo
   ELSE
      //Alimentamos una cookie con los datos de la persona validada
      //Le damos una caducidad por defecto son 5 min.
      oCGI:SendCodefCookie( "appccuser", nId, oCGI:nDuracionCookie )
      AppData:nLang := Val( oCgi:GetCgiValue( "idioma","1" ) )
      MainPage()
      QUIT
   ENDIF

RETURN

//------------------------------------------------------------------------------

PROCEDURE LogOut()

   LOCAL hIni := gepIni()
   LOCAL cEmp := hIni[ "rest" ][ "Emp" ]
   LOCAL aDisabledHosts := oCGI:GetUserData( "DISABLED_JSONSERVER_HOST", Array( 0 ) )

   LOCAL cfluidIni
   LOCAL cfluidFile
   LOCAL cFileSession

   LOCAL dfluidLast

   LOCAL hfluidIni
   LOCAL hfluidFiles := { => }

   LOCAL nAT
   LOCAL nFiles

   oCGI:DeleteCookie( "gep" )
   oCGI:DeleteCookie( "appccuser" )
   oCGI:SetUserData( "cEmp", cEmp )

   __clearUserData()

   AEval( aDisabledHosts, {| cDisabledHost | oCGI:SetUserData( cDisabledHost,"" ) } )
   ASize( aDisabledHosts, 0 )
   oCGI:SetUserData( "DISABLED_JSONSERVER_HOST", aDisabledHosts )

   cfluidIni := oCGI:cPathTmp + "nfluid.log"
   IF ( File( cfluidIni ) )
      hfluidIni := hb_iniRead( cfluidIni )
      dfluidLast := CToD( hfluidIni[ "nfluid" ][ "last" ] )
      hfluidFiles[ "cFiles" ] := oCGI:cPathTmp + "*.nfluid"
      nFiles := Len( Directory( hfluidFiles[ "cFiles" ] ) )
      hfluidFiles[ "aNames" ] := Array( nFiles )
      hfluidFiles[ "aSizes" ] := Array( nFiles )
      hfluidFiles[ "aDates" ] := Array( nFiles )
      hfluidFiles[ "aTimes" ] := Array( nFiles )
      hfluidFiles[ "aAttributes" ] := Array( nFiles )
      IF ( ADir( hfluidFiles[ "cFiles" ],@hfluidFiles[ "aNames" ],@hfluidFiles[ "aSizes" ],@hfluidFiles[ "aDates" ],@hfluidFiles[ "aTimes" ],@hfluidFiles[ "aAttributes" ] ) > 0 )
         WHILE ( ( nAT := hb_AScan(hfluidFiles[ "aDates" ],{| date | date < dfluidLast } ) ) > 0 )
            cfluidFile := oCGI:cPathTmp
            cfluidFile += hfluidFiles[ "aNames" ][ nAT ]
            FErase( cfluidFile )
            hb_ADel( hfluidFiles[ "aNames" ], nAT, .T. )
            hb_ADel( hfluidFiles[ "aSizes" ], nAT, .T. )
            hb_ADel( hfluidFiles[ "aDates" ], nAT, .T. )
            hb_ADel( hfluidFiles[ "aTimes" ], nAT, .T. )
            hb_ADel( hfluidFiles[ "aAttributes" ], nAT, .T. )
         END WHILE
      ENDIF
   ENDIF

   TRY
      cFileSession := ( oCGI:cPathSession + oCGI:cServerSession )
   END TRY

   oCGI:CloseSession()

   IF ( !Empty(cFileSession) .and. File( cFileSession ) )
      FErase( cFileSession )
   ENDIF

   Login()

   QUIT

RETURN

//------------------------------------------------------------------------------

FUNCTION LoginUser()

   LOCAL oUser := oCGI:GetCodefCookie( "appccuser" )
   LOCAL nUser, hUser
   LOCAL lChkFormUID := ( oCgi:GetCgiValue( "lChkFormUID",oCGI:GetUserData("lChkFormUID" , "1" )) == "1" )

   IF HB_ISNIL( oUser )
      LogOut()
   ELSE
      IF oUser:ErrorCode[ 1 ] == 0
         nUser := Val(oUser:Value)
         IF HB_ISNIL( hUser := GetUser( nUser ) )
            LogOut()
         ELSE
            lChkFormUID:=(lChkFormUID.OR.(oCGI:nDuracionCookie==__MAXCOOKIETIME__))
            IF (lChkFormUID)
               oCGI:nDuracionCookie:=__MAXCOOKIETIME__
            ENDIF
            //Alimentamos una cookie con los datos de la persona validada
            //Le damos una caducidad por defecto son 5 min.
            oCGI:SendCodefCookie( "appccuser", nUser, oCGI:nDuracionCookie )
         ENDIF
      ELSE
         LogOut()
      ENDIF
   ENDIF

RETURN hUser

//------------------------------------------------------------------------------

STATIC PROCEDURE StyleFooter( oParent )

   WITH OBJECT wStyle():New( oParent )
      :cId := ".flex-container"
      :cDisplay := "flex"
      :cFlex_direction := "row"
      WITH OBJECT :AddMedia(, 400 )
         :ostyle:cFlex_direction := "column"
      END WITH
      :Create()
   END WITH

RETURN

//------------------------------------------------------------------------------

STATIC PROCEDURE RebarMobil( oParent )

   WITH OBJECT WRow():New( oParent )
      :cClass := "top-nav"
      :lBeforeMain := .T.
      :aWidth := { 12, 0, 0, 0 }
      :oStyle:cFlex_direction := "row"
      :oStyle:cDisplay := "flex"
      :cBackgroundColor := "#012444"//"#45DD98"
      WITH OBJECT WImage():New( :WO )
         :aWidth[ xc_L ] := 6
         :cImage := "./connecti/resource/images/connecti-consultoria-150x45-white.png"
         :cName := "connecti-consultoria-150x45-white.png"
         :cAlt := "connecti-consultoria-150x45-white.png"
         WITH OBJECT :oStyle
            :cHeight := "30px"
            :cMargin_top := "2px"
            :cPadding    :=  0
         END WITH
         :Create()
      END WITH
      WITH OBJECT WBevel():New( :WO )
         :aWidth[ xc_L ] := 6
         WITH OBJECT :oStyle
            :cPadding_left :=  0
            :cText_align := "right"
            :cDisplay := "flex"
         END WITH
         :lValing := .T.
         WITH OBJECT WLabel():New( :WO )
            WITH OBJECT :oStyle
               :cPadding :=  0
               :cMargin  := 0
               :cColor := "white !important"
            END WITH
            :nHeaderSize   := 6
            :lBold         := .T.
            :lBR           := .T.
            :cText         := AppData:AppName
            :Create()
         END WITH
         :Create()
      END WITH
      :Create()
   END WITH

RETURN

//------------------------------------------------------------------------------

PROCEDURE Footer( oParent, cImage, cClrText )

   hb_default( @cImage, "./connecti/resource/images/connecti-consultoria-logo.png" )
   hb_default( @cClrText, "black" )
   WITH OBJECT WRow():New( oParent )
      :lInFooter := .T.
      :oStyle:cDisplay := "flex"
      WITH OBJECT WBevel():New( :WO )
         :aWidth := { 0, 4, 4, 4 }
         WITH OBJECT WImage():New( :WO )
            :cImage       := cImage
            :lResponsive  := .T.
            :cOnClick := "#window.open('http://connecticonsultoria.com.br/','_blank');"
            :cCursor := "pointer"
            WITH OBJECT :oStyle
               :cHeight := "35px"
               :cMargin_top := "1px"
            END WITH
            :Create()
         END WITH
         :Create()
      END WITH
      WITH OBJECT WBevel():New( :WO )
         :aWidth[ xc_M ] := 8
         :oStyle:cDisplay := "flex"
         WITH OBJECT WBevel():New( :WO )
            :aWidth[ xc_M ] := 6
            :aWidth[ xc_S ] := 0
            :oStyle:cDisplay := "flex"
            :lValing := .T.
            WITH OBJECT WLabel():New( :WO )
               :oStyle:cMargin := 0
               :nHeaderSize   := 6
               :lBold         := .T.
               :cAlign        := xc_Center
               :lBR           := .T.
               :cText         := "<span style=color:" + cClrText + ">" + AppData:AppName + "</span>"
               :Create()
            END WITH
            :Create()
         END WITH
         WITH OBJECT WBevel():New( :WO )
            :aWidth[ xc_M ] := 6
            :oStyle:cText_align := "right"
            :oStyle:cPadding   := 0
            :oStyle:cDisplay := "flex"
            :oStyle:cAlign_items := "flex-end"
            WITH OBJECT WLabel():New( :WO )
               :oStyle:cFont_size := "1.5vh"
               :oStyle:cPadding   := 0
               :cAlign        := xc_Right
               :cText         := "<span style=color:" + cClrText + ">" + "© Connecti Consultoria " + ToString( Year( Date() ) ) + "</span>"
               :Create()
            END WITH
            :Create()
         END WITH
         :Create()
      END WITH
      :Create()
   END WITH

RETURN

//------------------------------------------------------------------------------

PROCEDURE CambiaIdioma()

   AppData:nLang := Val( oCGI:GetCgiValue( "idioma","1" ) )
   oCGI:SetUserData( "lang", AppData:nLang )
   Login()

RETURN

//------------------------------------------------------------------------------

PROCEDURE CambiaEmp()

   LOCAL cEmp := oCgi:GetCgiValue( "cEmp", "" )

   IF ( !Empty( cEmp ) )
      AppData:cEmp := cEmp
      oCGI:SetUserData( "cEmp", AppData:cEmp )
      AppData:tenantId := cEmp
      oCGI:SetUserData( "tenantId", AppData:tenantId )
   ENDIF

RETURN

FUNCTION GetSM0()

   LOCAL aSource := Array( 0 )

   LOCAL cEmp
   LOCAL cFile := ( AppData:PathData + Lower( ProcName() ) + ".json" )
   LOCAL codModel := "EMPRESAS"

   LOCAL hRow
   LOCAL hDatos

   getDataFieldsDef( codModel )
   hDatos := GetDataModel( codModel, 1, - 1, 0, "", {}, .F., .F., cFile, "", .F., codModel )

   IF ( !Empty( hDatos[ "data" ] ) )
      FOR EACH hRow in hDatos[ "data" ]
         cEmp := hRow[ "codEmpresa" ]
         IF ( AScan( aSource,{| x | (x[ 1 ] == cEmp ) } ) == 0 )
            AAdd( aSource, { cEmp, cEmp + "-" + hRow[ "descEmpresa" ] } )
         ENDIF
      NEXT EACH
   ENDIF

return( aSource )
