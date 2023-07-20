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


PROCEDURE About()

    local hUser := LoginUser()

    local cBGImage:="./connecti/resource/images/"+IF(Time()>="18:00>00".or.Time()<="06:00:00","connecti-consultoria-login-background-at-night.jpg","connecti-consultoria-login-background-in-the-morning.jpg")

    With Object wTWebPage():New()

      :cBackground       := cBGImage
      :cBackgroundColor:="#012444"
      :cBackgroundSize   := "cover"
      :lBackgroundRepeat := .F.

      :cTitle:=("Connecti :: "+AppData:AppTitle+" :: "+Lang(LNG_MAINUSERS))

      AppMenu(:WO,AppData:AppName ,hUser )

      :lValign := .F.

      With Object WPanel():New(:WO)
         :cId  := "about"
         :cClrText:="white"
         :cClrPane:="#012444"
         :cTitle := "Sobre"
         :aWidth[xc_M]  := 8
         :aOffset[xc_M] := 2
         vAbout(:WO)
         :Create()
      End With

     WITH OBJECT WFloatingBtn():New( :WO )
        :cClrPane:="#005FAB"
        :cName:=("WFloatingBtn"+ProcName())
        :cId:=Lower(:cName)
        :cId := "voltar"
        :cText := "Voltar"
        :cOrientation := xc_Top
        :oIcon:cIcon := "arrow_back"
        :oIcon:cClrIcon := "#FED300"
        :cOnClick:="MAINFUNCTION"
        :cClrPane:="#012444"
        :Create()
      END WITH

      oCgi:SendPage( :Create() )        // Se crea el HTML final y se envía al navegador saliendo del ejecutable CGI

    End With

    RETURN

    //------------------------------------------------------------------------------

    FUNCTIOn vAbout(oParent)

    local oWLevel
    local oWPanel
    local oWListView

    WITH OBJECT oWLevel:=WBevel():New(oParent)
        With Object oWPanel:=WPanel():New(oWLevel)
            :cTitleAlign:=xc_Left
            :cTitle:="Planejado por:"
            :nFontTitle := 10
            :cClrText:="white"
            :cClrPane:="#012444"
            WITH OBJECT oWListView:=WListView():New(oWPanel)
                :cOnClickEdit   := "#window.open('http://connecticonsultoria.com.br/','_blank')"
                :lTitleItem     := .T.
                :cTextEdit      := "Sobre Connecti"
                :cClrText:="white"
                :cClrPane:="#012444"
                WITH OBJECT :AddItem() AS WItemListView
                    :nRowId := 1
                    :cClrText:="white"
                    :cClrPane:="#012444"
                    :cTitle := nfl_Tag("b","Connecti Consultoria")
                END WITH
                :Create()
            END WITH
            :Create()
        END WITH
        :Create()
    END WITH

    WITH OBJECT oWLevel:=WBevel():New(oParent)
        With Object oWPanel:=WPanel():New(oWLevel)
            :cTitleAlign:=xc_Left
            :cTitle:="Powered by:"
            :nFontTitle := 10
            :cClrText:="white"
            :cClrPane:="#012444"
            WITH OBJECT oWListView:=WListView():New(oWPanel)

                :lTitleItem     := .T.
                :cTextEdit      := "Sobre Tecnologia"
                :cClrText:="white"
                :cClrPane:="#012444"
                WITH OBJECT :AddItem() AS WItemListView
                    :cOnClickEdit   := "#window.open('https://www.xailer.com/','_blank')"
                    :nRowId := 1
                    :cTitle := nfl_Tag("b",XailerVersion())
                END WITH
                WITH OBJECT :AddItem() AS WItemListView
                    :cOnClickEdit   := "#window.open('https://nefele.dev/','_blank')"
                    :nRowId := 2
                    :cTitle := nfl_Tag("b","Néfele "+Nefele_version)
                END WITH
                WITH OBJECT :AddItem() AS WItemListView
                    :cOnClickEdit   := "#window.open('https://harbour.github.io/','_blank')"
                    :nRowId := 3
                    :cTitle := nfl_Tag("b",HB_Version())
                END WITH
                WITH OBJECT :AddItem() AS WItemListView
                    :cOnClickEdit   := "#window.open('https://www.apachehaus.com/cgi-bin/download.plx','_blank')"
                    :nRowId := 3
                    :cTitle := nfl_Tag("b",oCgi:GetEnv("SERVER_SOFTWARE"))
                END WITH
                :Create()
            END WITH
            :Create()
        END WITH
        :Create()
    END WITH

    WITH OBJECT oWLevel:=WBevel():New(oParent)
        With Object oWPanel:=WPanel():New(oWLevel)
            :cTitleAlign:=xc_Left
            :cTitle:="Desenvolvido por:"
            :nFontTitle := 10
            :cClrText:="white"
            :cClrPane:="#012444"
            WITH OBJECT oWListView:=WListView():New(oWPanel)
                :cClrText:="white"
                :cClrPane:="#012444"
                :cOnClickEdit   := ""
                :lTitleItem     := .T.
                :cTextEdit      := "Sobre Developer"
                :cClrText:="white"
                :cClrPane:="#012444"
                WITH OBJECT :AddItem() AS WItemListView
                    :nRowId := 1
                    :cTitle := "DNA"
                END WITH
                :Create()
            END WITH
            :Create()
        END WITH
        :Create()
        IF HB_IsNIL( oParent )
            RETURN :FullHtml()
        ENDIF
    END WITH

RETURN Nil
