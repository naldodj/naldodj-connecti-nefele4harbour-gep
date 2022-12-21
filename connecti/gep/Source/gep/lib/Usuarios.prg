/*
 * Proyecto: GEP
 * Fichero: Usuarios.prg
 * Descricao:
 * Autor:
 * Fecha: 07/08/2021
 */

#include "Xailer.ch"
#include "Nefele.ch"
#include "LangCGI.ch"


PROCEDURE MainUsers(nMsg,cUser)

   local hUser := LoginUser()

   DEFAULT nMsg TO 0

   With Object wTWebPage():New()

      :cTitle:=("Connecti :: "+AppData:AppTitle+" :: "+Lang(LNG_MAINUSERS))

      AppMenu(:WO,AppData:AppName ,hUser )

      :lValign := .F.

      if nMsg <> 0
         MsgUser( :WO,nMsg,cUser )
      ENDIF

      With Object WPanel():New(:WO)
         :cId  := "Pages"
         :cTitle := Lang(LNG_MAINUSERS)
         :aWidth[xc_M]  := 8
         :aOffset[xc_M] := 2
         vUsers( :WO,1 )
         :Create()
      End With

      WITH OBJECT WButton():New( :WO )
         :cName:=("WFloatingBtn"+ProcName())
         :cId:=Lower(:cName)
         :cText := Lang(LNG_NEWUSER)
         :oIcon:cIcon := "add"
         :oIcon:cClrIcon := "#FED300"
         :cOnClick := "newuser"
         :cClrPane := "#005FAB"
         :Create()
      END WITH

      WITH OBJECT WFloatingBtn():New( :WO )
         :cClrPane:="#005FAB"
         :cName:=("WFloatingBtn"+ProcName()+"Back")
         :cId:=Lower(:cName)
         :cText := "Voltar"
         :cAlign:=xc_Left
         :cOrientation := xc_Top
         :oIcon:cIcon := "arrow_back"
         :oIcon:cClrIcon := "#FED300"
         :oIcon:cClrIcon := "#FED300"
         :cOnClick := "MAINFUNCTION"
         :Create()
      END WITH

      oCgi:SendPage( :Create() )        // Se crea el HTML final y se envía al navegador saliendo del ejecutable CGI

   End With

RETURN

//------------------------------------------------------------------------------

FUNCTIOn vUsers(oParent,nPage)

   local aUsers := GetUsers()
   local hItem,oItem,nItem

   WITH OBJECT WListView():New(oParent)
      :cOnClickEdit   := "edituser"
      :lTitleItem     := .T.
      :cTextEdit      := Lang(LNG_EDITUSER)
      :oIconEdit:cClrText := "orange"
      if Len( aUsers ) > 10
         :cOnChangePage := "AjaxUsersPage"
         :nPage         := nPage
         :nItemInPage   := 10
         :cAjaxPages    := "pages"
      ENDIF
      FOR EACH hItem IN aUsers
         WITH OBJECT :AddItem() AS WItemListView
            :nRowId := hItem:__EnumIndex
            :cTitle := hItem["name"]
            IF !hItem["activo"]
               WITH OBJECT :oBadge AS wBadge
                  :cText := Lang(LNG_INACTIVO)
                  :cOnClick := "edituser"
                  :AddParam( {"nRowId",:nRowId} )
                  :lChips := .T.
                  :oIcon:cIcon := "block"
                  :cToolTip := Lang(LNG_EDITUSER)
                  :oStyle:cMargin_top := "-5px"
               END WITH
            ENDIF
            :lEdit   := hItem["activo"]
         END WITH
      NEXT
      :Create()
      IF HB_IsNIL( oParent )
         RETURN :FullHtml()
      ENDIF
   END WITH

RETURN Nil

//------------------------------------------------------------------------------

PROCEDURE EditUser(lNew,nIdUser,hEdit)

   local hUser := LoginUser()
   local lDuplicado := !HB_IsNIL(hEdit)

   DEFAULT nIdUser TO 0
   DEFAULT lNew TO .F.

   IF !lNew .AND. HB_IsNIL(hEdit)
      nIdUser := Val( oCGI:GetCgiValue("nRowId","0") )
      if nIdUser <> 0
         hEdit := GetUser( nIdUser )
      ELSE
         MainUsers()
         QUIT
      ENDIF
   ENDIF

   With Object wTWebPage():New()

      :cTitle:=Lang(LNG_MAINUSERS)

      AppMenu(:WO,AppData:AppName ,hUser )

      :lValign := .T.

      iF lDuplicado
         MsgUser( :WO,3,hEdit["user"] )
      ENDIF

      With Object WPanel():New(:WO)
         :cTitle := IIF( lNew,Lang(LNG_NEWUSER),Lang(LNG_EDITUSER) )
         :aWidth[xc_M]  := 8
         :aOffset[xc_M] := 2
         With Object WForm():New(:WO)
            :cFunction  := "UpdateUser"
            :AddParam({"iduser",nIdUser})
            :lUniqueId := .T.
            With Object WEdit():New(:WO)
               :cId        := "name"
               :cTitle     := Lang(LNG_USERNAME)
               :cIcon      := "person"
               :cValue     := IIF( lNew .AND. !lDuplicado,"",hEdit["name"] )
               :SetRequired()
               :Create()
            End With
            With Object WEdit():New(:WO)
               :cId        := "user"
               :aWidth[xc_M] := 6
               :cTitle     := Lang(LNG_USERID)
               :cIcon      := "person"
               :cValue     := IIF( lNew .AND. !lDuplicado,"",hEdit["user"] )
               :SetRequired()
               :Create()
            End With
            with object WEdit():New(:WO)
               :cId        := "pass"
               :aWidth[xc_M] := 6
               :cTitle     := Lang(LNG_USERPASS)
               :cValue     := IIF( lNew .AND. !lDuplicado,"",hEdit["pass"] )
               :cIcon      := "lock"
               :SetPassword()
               :SetRequired()
               :Create()
            end with

            WITH OBJECT WSwitch():New(:WO)
               :cId        := "admin"
               :aWidth[xc_M] := 5
               :aOffset[xc_M] := 1
               :aWidth[xc_S] := 11
               :aOffset[xc_S] := 1
               :cTitle     := Lang(LNG_USERADMIN)
               :cTextOff   := Lang(LNG_NO)
               :cTextOn    := Lang(LNG_SI)
               :lChecked   := IIF( lNew .AND. !lDuplicado,.F.,hEdit["adminuser"] )
               :lEnabled   := (nIdUser<>1)
               :Create()
            END WITH

            WITH OBJECT WSwitch():New(:WO)
               :cId        := "activo"
               :aWidth[xc_M] := 5
               :aWidth[xc_S] := 11
               :aOffset[xc_S] := 1
               :cTitle     := Lang(LNG_ESTADO)
               :cTextOff   := Lang(LNG_INACTIVO)
               :cTextOn    := Lang(LNG_ACTIVO)
               :lChecked   := IIF( lNew .AND. !lDuplicado,.T.,hEdit["activo"] )
               :lEnabled   := (nIdUser<>1)
               :Create()
            END WITH

            With Object WSeparator():New(:WO)
               :lBR      := .T.
               :Create()
            End With
            With Object WSeparator():New(:WO)
               :lLine    := .T.
               :Create()
            End With

            With Object WBevel():New(:WO)
               With Object WBevel():New(:WO)
                  :aWidth[xc_S] := 6
                  :aWidth[xc_M] := 4
                  With Object WButton():New(:WO)
                     :cId           := "cancel"
                     :cText         := Lang(LNG_CANCELAR)
                     :lLarge        := .T.
                     :nFix          := "100%"
                     :cOnClick      := "Usuarios"
                     :oIcon:cIcon   := "cancel"
                     :cTextAlign    := xc_Center
                     :Create()
                  End With
                  :Create()
               End With
               With Object WBevel():New(:WO)
                  :aWidth[xc_S] := 0
                  :aWidth[xc_M] := 4
                  :Create()
               End With
               With Object WBevel():New(:WO)
                  :aWidth[xc_S] := 6
                  :aWidth[xc_M] := 4
                  With Object WButton():New(:WO)
                     :cId           := "send"
                     :cText         := Lang(LNG_ACEPTAR)
                     :lLarge        := .T.
                     :nFix          := "100%"
                     :cTextAlign    := xc_Center
                     :lSubmit       := .T.
                     :Create()
                  End With
                  :Create()
               End With
               :Create()
            End With

            :Create()
         End With
         :Create()
      End With

      oCgi:SendPage( :Create() )        // Se crea el HTML final y se envía al navegador saliendo del ejecutable CGI

   End With

RETURN

//------------------------------------------------------------------------------

PROCEDURE UpdateUser()

   local cName := oCGI:GetCgiValue("name","")
   local cUser := oCGI:GetCgiValue("user","")
   local cPass := oCGI:GetCgiValue("pass","")
   local lAdmin := ( oCGI:GetCgiValue("admin","false") == "true" )
   local lActivo := ( oCGI:GetCgiValue("activo","false") == "true" )
   local nIdUser := Val( oCGI:GetCgiValue("iduser",0) )
   local hUser := {"user" => cUser,"pass" => cPass,"name" => cName,"adminuser" => lAdmin,"activo" => lActivo}

   if !nfl_ChkFormUID()
      MainUsers()
      QUIT
   ENDIF

   IF nIdUser == 0
      // New User
      IF CheckUser( cUser ) <> 0
         // El Usuario ya existe
         EditUser( .T.,nIdUser,hUser )
      ELSE
         IF SetUser(0,hUser )
            MainUsers(2,cName)
         ELSE
            // No se pudo crear el usuario
         ENDIF
      ENDIF
   ELSE
      IF CheckUser( cUser ) <> nIdUser
         // El Usuario ya existe
         EditUser( .F.,nIdUser,hUser )
      ELSE
         IF SetUser(nIdUser,hUser )
            MainUsers(1,cName)
         ELSE
            // No se pudo modificar el usuario
         ENDIF
      ENDIF
   ENDIF
RETURN

//------------------------------------------------------------------------------


PROCEDURE MsgUser(oParent,nMsg,cUser)
   local cMsg,oMsg,cType

   SWITCH nMsg
      CASE 1; cMsg := Lang(LNG_USERUPDATEOK); cType := "Info"; EXIT
      CASE 2; cMsg := Lang(LNG_USERNEWOK); cType := "Info"; EXIT
      CASE 3; cMsg := Lang(LNG_USERDUPLICATE); cType := "Error"; EXIT
      OTHERWISE
   END SWITCH

   With Object oMsg := WMsgAlert():New(oParent)
      :lTagScript     := .T.
      :cTitle         := cMsg
      :cText          := cUser
      :cType          := cType
      :nPrimaryDelay  := 2
      :cConfirmButton := Lang(LNG_ACEPTAR)
      :Create()
   End With

RETURN

