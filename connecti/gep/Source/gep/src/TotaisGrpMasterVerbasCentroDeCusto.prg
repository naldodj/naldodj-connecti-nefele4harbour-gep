// Proyecto: GEP
/*
 * Fichero: TotaisGrpMasterVerbasCentroDeCusto.prg
 * Descripción:
 * Autor:
 * Fecha: 14/08/2021
 */

#include "Xailer.ch"
#include "Nefele.ch"
#include "LangCGI.ch"

PROCEDURE __TotaisGrpMasterVerbasCentroDeCusto( oTWebPage,lOpenModal,lSendPage )

   LOCAL aData

   LOCAL hUser := LoginUser()

   LOCAL hRow
   LOCAL hData
   local hFilter
   LOCAL hRowFil
   LOCAL hDataFil

   LOCAL ckeyProc
   LOCAL hkeyProc

   LOCAL cTitle := AppData:AppTitle+" :: "+"Consulta dos Dados Totais Por Centro De Custo/Grupo de Verbas"

   LOCAL cFilter
   LOCAL cIDParameters
   LOCAL aParameters

   LOCAL valor
   LOCAL codGrupo
   LOCAL codFilial
   LOCAL codPeriodo
   LOCAL codCentroDeCusto

   LOCAL descFilial
   LOCAL descCentroDeCusto

   LOCAL cIDModal
   LOCAL cJSONModal
   LOCAL hJSONModal

   LOCAL nID
   LOCAL nData
   LOCAL nATFilial

   LOCAL oWPanel

   LOCAL oWLabel

   LOCAL oWBevel0
   LOCAL oWBevel1
   LOCAL oWBevel2
   LOCAL oWBevel3
   LOCAL oWBevel4

   LOCAL oWBevelModal

   oCGI:SetUserData("lGrpViewTotais",.T.)

   if (!stacktools():IsInCallStack("__GrpMasterVerbasCentroDeCusto"))
      deleteTmpParameters("__GrpMasterVerbasCentroDeCusto")
   endif

   IF (oCGI:GetUserData("__TotaisGrpMasterVerbasCentroDeCusto:SaveParameters",.F.))
      hFilter:=__GrpMasterVerbasCentroDeCusto(.F.)
      oCGI:SetUserData("__TotaisGrpMasterVerbasCentroDeCusto:SaveParameters",.F.)
      saveTmpParameters("__TotaisGrpMasterVerbasCentroDeCusto",hFilter)
   ELSE
      restoreTmpParameters("__TotaisGrpMasterVerbasCentroDeCusto",@hFilter,.F.)
   ENDIF

   setUserDataTmpParameters("__GrpMasterVerbasCentroDeCusto",hFilter,.T.)

   codGrupo := oCGI:GetUserData( "__GrpMasterVerbasCentroDeCusto:codGrupo",codGrupo )
   codFilial := oCGI:GetUserData( "__GrpMasterVerbasCentroDeCusto:codFilial",codFilial )
   codPeriodo := oCGI:GetUserData( "__GrpMasterVerbasCentroDeCusto:codPeriodo",codPeriodo )
   codCentroDeCusto := oCGI:GetUserData( "__GrpMasterVerbasCentroDeCusto:codCentroDeCusto",codCentroDeCusto )

   hb_default( @oTWebPage,wTWebPage():New() )
   hb_default( @lOpenModal,.T. )
   hb_default( @lSendPage,.T. )

   AppData:cEmp := oCGI:GetUserData( "cEmp",AppData:cEmp )

   WITH OBJECT oTWebPage

      :cCSS += "h10 {font-size: 12px; font-weight: lighter; font-family: -apple-system,BlinkMacSystemFont,'Segoe UI',Roboto,Oxygen-Sans,Ubuntu,Cantarell,'Helvetica Neue',sans-serif; !important;}"
      :cCSS += "h12 {font-size: 14px; font-weight: bold; font-family: -apple-system,BlinkMacSystemFont,'Segoe UI',Roboto,Oxygen-Sans,Ubuntu,Cantarell,'Helvetica Neue',sans-serif; !important;}"

      IF ( lSendPage )

         :cTitle := cTitle

         AppMenu(oTWebPage,AppData:AppName,hUser,.F.)

         WITH OBJECT WFloatingBtn():New( oTWebPage )
            :cClrPane:="#005FAB"
            :cName := ( "WFloatingBtn" + ProcName() )
            :cId := Lower( :cName )
            :cText := "Voltar"
            :oIcon:cIcon := "arrow_back"
            :oIcon:cClrIcon := "#FED300"
            :cOnClick:=oCGI:GetUserData(ProcName()+":Back","MAINFUNCTION")
            :Create()
         END WITH

      ENDIF

      WITH Object oWLabel := WLabel():New( oTWebPage )
         :nHeaderSize := 6
         :nFontSize := 12
         :lBR := .T.
         :lBold := .T.
         :cAlign := xc_Left
         :cText := "<h12>"
         :cText += "Competência: " + Right( codPeriodo,2 ) + "/" + Left( codPeriodo,4 )
         :cText += "</h12>"
         :Create()
      END WITH

      cFilter := ""

      IF ( !Empty( codFilial ) )
         IF ( !Empty( cFilter ) )
            cFilter += " AND "
         ENDIF
         cFilter += "M0_CODFIL='" + codFilial + "'"
      ENDIF

      IF ( !Empty( cFilter ) )
         cFilter := "SQL:" + cFilter
      ENDIF

      oCGI:SetUserData( "__CadastroFiliais:codFilial",codFilial )
      hDataFil := GetDataCadastroFiliais( .F.,.T.,cFilter )
      oCGI:SetUserData( "__CadastroFiliais:codFilial","" )

      cFilter := ""

      IF ( !Empty( codFilial ) )
         IF ( !Empty( cFilter ) )
            cFilter += " AND "
         ENDIF
         cFilter += "RD_FILIAL='" + codFilial + "'"
      ENDIF

      IF ( !Empty( codPeriodo ) )
         IF ( !Empty( cFilter ) )
            cFilter += " AND "
         ENDIF
         cFilter += "RD_DATARQ='" + codPeriodo + "'"
      ENDIF

      IF ( !Empty( codCentroDeCusto ) )
         IF ( !Empty( cFilter ) )
            cFilter += " AND "
         ENDIF
         cFilter += "RD_CC='" + codCentroDeCusto + "'"
      ENDIF

      IF ( !Empty( codGrupo ) )
         IF ( !Empty( cFilter ) )
            cFilter += " AND "
         ENDIF
         cFilter += "ZY__CODIGO='" + codGrupo + "'"
      ENDIF

      IF ( !Empty( cFilter ) )
         cFilter := "SQL:" + cFilter
      ENDIF

      hData := GetDataTotaisGrpMasterVerbasCentroDeCusto( .F.,.T.,cFilter )

      IF ( !Empty( hData ) )

         hkeyProc := { => }

         FOR EACH hRowFil in hData[ "data" ]
            ckeyProc := hRowFil[ "codFilial" ]
            ckeyProc += hRowFil[ "codCentroDeCusto" ]
            IF ( hb_HPos( hkeyProc,ckeyProc ) == 0 )
               hkeyProc[ ckeyProc ] := Array( 0 )
            ENDIF
            AAdd( hkeyProc[ ckeyProc ],hRowFil )
         NEXT hRowFil

         hb_HClear( hData )

         FOR EACH ckeyProc in hb_HKeys( hkeyProc )

            aData := hkeyProc[ ckeyProc ]

            codFilial := aData[ 1 ][ "codFilial" ]
            codCentroDeCusto := aData[ 1 ][ "codCentroDeCusto" ]
            descCentroDeCusto := aData[ 1 ][ "descCentroDeCusto" ]

            nATFilial := AScan( hDataFil[ "data" ],{| x | x[ "codFilial" ] == codFilial } )
            descFilial := hDataFil[ "data" ][ nATFilial ][ "descFilial" ]

            WITH Object oWBevel0 := WBevel():New( oTWebPage )

               :AutoID()

               WITH Object oWLabel := WLabel():New( oWBevel0 )
                  :AutoID()
                  :nHeaderSize := 6
                  :nFontSize := 12
                  :lBR := .T.
                  :lBold := .T.
                  :cAlign := xc_Left
                  :cText := "<h12>"
                  :cText += "Filial: "
                  :cText += codFilial
                  :cText += "-"
                  :cText += descFilial
                  :cText += " | C.Custo: "
                  :cText += codCentroDeCusto
                  :cText += "-"
                  :cText += descCentroDeCusto
                  :cText += "</h12>"
                  :Create()
               END WITH

               WITH Object oWBevel1 := WBevel():New( oWBevel0 )

                  :AutoID()

                  nData := Len( aData )
                  FOR nID := 1 TO nData

                     WITH Object oWBevel2 := WBevel():New( oWBevel1 )

                        :AutoID()

                        :aWidth[ xc_M ] := 3
                        :aWidth[ xc_L ] := 2

                        valor := aData[ nID ][ "total" ]
                        codGrupo := aData[ nID ][ "codGrupo" ]

                        WITH Object oWPanel := WPanel():New( oWBevel2 )

                           :AutoID()

                           WITH Object oWBevel3 := WBevel():New( oWPanel )

                              :AutoID()
                              :cId += ckeyProc

                              :cTitle := aData[ nID ][ "descGrupo" ]//codGrupo+"-"+aData[nID]["descGrupo"]

                              :nFontTitle := 10

                              :cTitleAlign := xc_Center

                              IF ( lOpenModal )

                                 cIDModal := "TotaisGrpMasterVerbasCentroDeCusto"
                                 cIDModal += "_"
                                 cIDModal := Lower( cIDModal )


                                 hJSONModal := hb_HClone( aData[ nID ] )
                                 hb_HDel(hJSONModal,"total")
                                 hb_HDel(hJSONModal,"descGrupo")
                                 HB_HDel(hJSONModal,"descGrupoHTML")
                                 hb_HDel(hJSONModal,"descCentroDeCusto")
                                 cJSONModal := hb_jsonEncode( hJSONModal,.F. )
                                 cJSONModal := __base64Encode( cJSONModal )

                                 :oStyle:cCursor := "pointer"

                                 IF ( .F. )
                                    :cOnClick := nfl_OpenModal( cIDModal,.F. )
                                    WITH OBJECT oWBevelModal := WBevel():New( oWBevel3 )
                                       :AutoID()
                                       :cId += cIDModal
                                       :nStyle := xc_ModalBottom
                                       :cModalHeight := "90%"
                                       :cModalWidth := "100%"
                                       :cOnClick := StrTran( "#autoformID('"+cJSONModal+"','?FUNCTION=__GrpMasterVerbasCentroDeCusto@cIDModalTotaisGrpMasterVerbasCentroDeCusto="+cJSONModal+"','_parent',true);","@","&" )
                                       :Create()
                                    END WITH //oWBevelModal
                                 ELSE
                                    //to decode: __GrpVerbasEmpresa __base64Decode(cJSONModal)
                                    :cOnClick := StrTran( "#autoformID('"+cJSONModal+"','?FUNCTION=__GrpMasterVerbasCentroDeCusto@cIDModalTotaisGrpMasterVerbasCentroDeCusto="+cJSONModal+"','_parent',true);","@","&" )
                                 ENDIF

                              ENDIF

                              :Create()

                           END WITH //oWBevel3

                           WITH Object oWBevel4 := WBevel():New( oWPanel )

                              :AutoID()
                              :cId += ckeyProc

                              WITH Object oWLabel := WLabel():New( oWBevel4 )
                                 :AutoID()
                                 :cId += ckeyProc
                                 :nHeaderSize := 6
                                 :nFontSize := 10
                                 :lBR := .T.
                                 :lBold := .T.
                                 :cAlign := xc_Center
                                 :cText := "<strong><b>" + valor + "</b></strong>"
                                 :Create()
                              END WITH //oWLabel

                              :Create()

                           END WITH //oWBevel4

                           :Create()

                        END WITH //oWPanel

                        :Create()

                     END WITH //oWBevel2

                  NEXT nID

                  :Create()

               END WITH //oWBevel1

               :Create()

            END WITH //oWBevel0

         NEXT ckeyProc

      ENDIF

      IF ( lSendPage )
         :lValign    := .F.
         :lContainer := .F.
         oCgi:SendPage( :Create() )
      ENDIF

   END

   __GrpMasterVerbasCentroDeCusto( .F. , hFilter )

RETURN

PROCEDURE TotaisGrpMasterVerbasCentroDeCusto()

   LOCAL hUser := LoginUser()

   LOCAL cSubTitle:=" :: "+"Consulta dos Dados Totais Por Centro De Custo/Grupo de Verbas"
   LOCAL cTitle := AppData:AppTitle+cSubTitle
   LOCAL cIDParameters
   LOCAL aParameters

   oCGI:SetUserData("__TotaisGrpMasterVerbasCentroDeCusto:Back",ProcName())
   oCGI:SetUserData("__TotaisGrpMasterVerbasCentroDeCusto:SaveParameters",.T.)

   WITH OBJECT wTWebPage():New()

      :cTitle := cTitle

      AppMenu(:WO,AppData:AppName ,hUser,.F. )

      aParameters := { "codPeriodo","codGrupo","codFilial","codCentroDeCusto" }
      cSubTitle:=AppData:AppName+cSubTitle
      GEPParameters( :WO,@cIDParameters,"__TotaisGrpMasterVerbasCentroDeCusto",aParameters,.T.,cSubTitle,.T. ):Create()

      :lValign    := .F.
      :lContainer := .F.

      oCgi:SendPage( :Create() )

   END

RETURN

FUNCTION GetDataTotaisGrpMasterVerbasCentroDeCusto( lSendJSON,lGetFull,cSearchFilter )
return(GetDataGrpMasterVerbasCentroDeCusto(@lSendJSON,@lGetFull,@cSearchFilter))