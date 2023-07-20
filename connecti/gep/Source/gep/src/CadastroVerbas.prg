 * Proyecto: GEP
/*
 * Fichero: CadastroVerbas.prg
 * Descripción:
 * Autor:
 * Fecha: 14/08/2021
 */
#include "Xailer.ch"
#include "Nefele.ch"
#include "LangCGI.ch"

#define __CODMODEL__ "VERBAS_SRV_ZY_SRD"

function __CadastroVerbas(lExecute,hFilter,nMaxRowspPage)

   local cIDModal

   local codGrupo
   local codVerba
   local codFilial

   local hIDModal

   local lFilter

   HB_Default(@lExecute,.T.)
   lFilter:=(HB_IsHash(hFilter).AND.!Empty(hFilter))
   HB_Default(@hFilter,{=>})

   IF (lExecute)
      cIDModal:=oCGI:GetCgiValue("cIDModalTotaisCadastroVerbas","")
      IF (!Empty(cIDModal))
         oCGI:SetUserData("HistoryRemoveParams",.F.)
         cIDModal:=__base64Decode(cIDModal)
         HB_JsonDecode(cIDModal,@hIDModal)
         saveTmpParameters("__CadastroVerbas",hIDModal)
         IF (HB_HHasKey(hIDModal,"codGrupo"))
            codGrupo:=hIDModal["codGrupo"]
         ENDIF
         IF (HB_HHasKey(hIDModal,"codFilial"))
            codFilial:=hIDModal["codFilial"]
         ENDIF
         IF (HB_HHasKey(hIDModal,"codVerba"))
            codVerba:=hIDModal["codVerba"]
         ENDIF
      ELSE
         IF (HB_HHasKey(hFilter,"codGrupo"))
            codGrupo:=hFilter["codGrupo"]
            oCGI:SetUserData("__CadastroVerbas:codGrupo",codGrupo)
         ELSE
            codGrupo:=oCGI:GetCgiValue("codGrupo","")
         ENDIF
         IF (HB_HHasKey(hFilter,"codFilial"))
            codFilial:=hFilter["codFilial"]
            oCGI:SetUserData("__CadastroVerbas:codFilial",codFilial)
         ELSE
            codFilial:=oCGI:GetCgiValue("codFilial","")
         ENDIF
         IF (HB_HHasKey(hFilter,"codVerba"))
            codVerba:=hFilter["codVerba"]
            oCGI:SetUserData("__CadastroVerbas:codVerba",codVerba)
         ELSE
            codVerba:=oCGI:GetCgiValue("codVerba","")
         ENDIF
      endif
   else
        IF (HB_HHasKey(hFilter,"codGrupo"))
            codGrupo:=hFilter["codGrupo"]
            oCGI:SetUserData("__CadastroVerbas:codGrupo",codGrupo)
         ELSE
            codGrupo:=oCGI:GetCgiValue("codGrupo","")
         ENDIF
         IF (HB_HHasKey(hFilter,"codFilial"))
            codFilial:=hFilter["codFilial"]
            oCGI:SetUserData("__CadastroVerbas:codFilial",codFilial)
         ELSE
            codFilial:=oCGI:GetCgiValue("codFilial","")
         ENDIF
         IF (HB_HHasKey(hFilter,"codVerba"))
            codVerba:=hFilter["codVerba"]
            oCGI:SetUserData("__CadastroVerbas:codVerba",codVerba)
         ELSE
            codVerba:=oCGI:GetCgiValue("codVerba","")
         ENDIF
    endif

    if ((!lFilter).and.Empty(cIDModal))

       if (Empty(codGrupo))
          codGrupo:=oCGI:GetCgiValue("GEPParameters_codGrupo","")
          if (Empty(codGrupo))
             codGrupo:=oCGI:GetUserData("__GEPParameters:codGrupo",codGrupo)
          endif
       endif

       if (Empty(codFilial))
          codFilial:=oCGI:GetCgiValue("GEPParameters_codFilial","")
          if (Empty(codFilial))
             codFilial:=oCGI:GetUserData("__GEPParameters:codFilial",codFilial)
          endif
       endif

       if (Empty(codVerba))
          codVerba:=oCGI:GetCgiValue("GEPParameters_codVerba","")
          if (Empty(codVerba))
             codVerba:=oCGI:GetUserData("__GEPParameters:codVerba",codVerba)
          endif
       endif

    endif

   hFilter["codGrupo"]:=codGrupo
   oCGI:SetUserData("__CadastroVerbas:codGrupo",codGrupo)

   hFilter["codFilial"]:=codFilial
   oCGI:SetUserData("__CadastroVerbas:codFilial",codFilial)

   hFilter["codVerba"]:=codVerba
   oCGI:SetUserData("__CadastroVerbas:codVerba",codVerba)

   if (lExecute)
      CadastroVerbas(nMaxRowspPage)
   endif

   RETURN(hFilter)

PROCEDURE CadastroVerbas(nMaxRowspPage)

   local hUser := LoginUser()

   local cSubTitle:=" :: "+"Cadastro de Verbas"
   local cTitle:=AppData:AppTitle+cSubTitle
   local cColsPrint
   local cPrintIMG

   local cIDParameters
   local aParameters

   local nField
   local aFields
   local nFields
   local nRowspPageMax

   local cTmp

   local owDataTable

   WITH OBJECT wTWebPage():New()

     :cTitle:= cTitle

     AppMenu(:WO,AppData:AppName,hUser,.F.)

     WITH OBJECT WFloatingBtn():New(:WO)
        :cClrPane:="#005FAB"
        :cName:=("WFloatingBtn"+ProcName())
        :cId:=Lower(:cName)
        :cText:="Voltar"
        :oIcon:cIcon:="arrow_back"
        :oIcon:cClrIcon := "#FED300"
        :cOnClick:=oCGI:GetUserData(ProcName()+":Back","MAINFUNCTION")
       :Create()
     END WITH

      aParameters:={"codFilial","codGrupo","codVerba"}
      cSubTitle:=AppData:AppName+cSubTitle
      GEPParameters(:WO,@cIDParameters,"__CadastroVerbas",aParameters,.F.,cSubTitle):Create()

      :lValign    := .F.
      :lContainer := .F.

      // hacemos scroll si hay m�s de 10 registros
      *aAdd(:aScript,'function fn_click(e){ if( document.querySelector("#datas").offsetTop > window.innerHeight) {document.getElementById("datas").scrollIntoView()}     }')

      aFields:=GetDataFieldsCadastroVerbas(@cColsPrint)
      nRowspPageMax:=oCGI:GetUserData(__CODMODEL__+":RowspPageMax",10)
      HB_Default(@nMaxRowspPage,nRowspPageMax)

      WITH OBJECT owDataTable:=wDatatable():New(:WO)

         :cId:=Lower("browseCadastroVerbas")

         DataTableCSS(:cID)

         :cCSS+=AppData:CSSDataTable

         cPrintIMG:=oCGI:GetUserData("cPrintIMG")

         // Botones Datatable
         WITH OBject :AddButton( "Exportar" )
            TEXT INTO :cCustom
               {
                  extend: 'collection',
                  text: 'Exportar',
                  buttons:
                  [ 'csv',
                     {
                        extend: 'excelHtml5',
                        autoFilter: true,
                        exportOptions: {
                           columns: cColsPrint,
                           format: {
                              body: function ( data, row, column, node ) {
                                 if (column<=5) {
                                    //Text Value
                                    data="\u200C"+data;
                                 }
                                 return data;
                              }
                           }
                        },
                        customize: function(xlsx) {
                           var sheet = xlsx.xl.worksheets['sheet1.xml'];
                           $('row', sheet).each(function(x) {
                              if (x===2) {
                                 //Header Color
                                 $('row:nth-child('+x+') c', sheet).attr('s', '7');
                              }
                           });
                           //Text Value
                           $('row:gt(1) c[r^="A"]',sheet).attr('s','50');
                           $('row:gt(1) c[r^="B"]',sheet).attr('s','50');
                           $('row:gt(1) c[r^="C"]',sheet).attr('s','50');
                           $('row:gt(1) c[r^="D"]',sheet).attr('s','50');
                           $('row:gt(1) c[r^="E"]',sheet).attr('s','50');
                           $('row:gt(1) c[r^="F"]',sheet).attr('s','50');
                        }
                     },
                     {
                        extend: 'pdfHtml5',
                        orientation: 'landscape'/*'portrait'*/,
                        pageSize: 'A4',
                        customize : function(doc) {
                           doc.pageMargins = [20,20,20,20];
                           doc.styles.title = {
                              color: 'black',
                              fontSize: '16',
                              background: 'white',
                              alignment: 'center'
                           };
                           doc.defaultStyle.fontSize = 13.5;
                           doc.styles.tableHeader.fontSize = 13.5;
                           doc.styles.tableFooter.fontSize = 13.5;
                           var rowCount = doc.content[1].table.body.length;
                           //Add Image Header
                           doc['header']=(function(page, pages) {
                              if (page===1) {
                                 return {
                                    columns: [
                                       {
                                          image: 'data:image/png;base64,cPrintIMG',
                                          position: 'absolute',
                                          alignment: 'left',
                                          width: 75,
                                          height: 23
                                       }
                                    ],
                                    margin: [20,15,20,20]
                                 }
                              }
                              else {
                                 return {
                                    columns: [
                                       {
                                          image: 'data:image/png;base64,cPrintIMG',
                                          position: 'absolute',
                                          alignment: 'left',
                                          width: 75,
                                          height: 23
                                       },
                                       {
                                          alignment: 'center',
                                          text: [ '@cTitle@' ],
                                          fontSize: 16,
                                       }
                                    ],
                                    margin: [20,0,0,0]
                                 }
                              }
                            });
                            doc['footer'] = (function(page, pages) {
                              return {
                                         columns: [
                                             {
                                                alignment: 'center',
                                                text: [
                                                   { text: page.toString(), italics: true },
                                                   ' of ',
                                                   { text: pages.toString(), italics: true }
                                                ]
                                             }
                                          ],
                                         margin: [20, 0]
                                       }
                            });
                        },
                        exportOptions: {
                           columns: cColsPrint
                        }
                     }
                  ]
               }
            ENDTEXT
            :cCustom:=strTran(:cCustom,"cColsPrint",cColsPrint)
            :cCustom:=strTran(:cCustom,"@tbl@",owDataTable:cID)
            :cCustom:=strTran(:cCustom,"cPrintIMG",cPrintIMG)
            :cCustom:=strTran(:cCustom,"@cTitle@",cTitle)
         END WITH

         WITH OBject :AddButton( "Imprimir" )
            TEXT INTO :cCustom
               {
                  extend: 'print',
                  text: 'Imprimir',
                  orientation: 'landscape'/*'portrait'*/,
                  pageSize: 'A4',
                  exportOptions: {columns: cColsPrint },
                  customize: function ( win ) {
                     $(win.document.body).find('h1').css('text-align','center');
                     $(win.document.body).find('h1').css('font-size', '12pt');
                     $(win.document.body).find('tr:nth-child(odd) td').each(function(index){
                        $(this).css('background-color','#D0D0D0');
                     });
                     $(win.document.body)
                        .css( 'font-size', '10pt' )
                        .prepend('<img src="data:image/png;base64,cPrintIMG" style="position:absolute; top:0; left:0;" />');
                     $(win.document.body).find( 'table' )
                        .addClass( 'compact' )
                        .css( 'font-size', 'inherit' );
                  }
               }
            ENDTEXT
            :cCustom:=strTran(:cCustom,"cColsPrint",cColsPrint)
            :cCustom:=strTran(:cCustom,"cPrintIMG",cPrintIMG)
         END WITH

         WITH OBject :AddButton("Parâmetros")
            :cAction := nfl_OpenModal(cIDParameters,.T.)
         END WITH

         :cTitle  := cTitle + tableBtnReload(:cId)

         // Configurar opciones
         WITH OBJECT :Configure()
            :SetLanguage({"Portugues","Spanish"}[AppData:nLang])
            :sPaginationType := "full_numbers" //"listbox"
            :paging          := .T.
            :pageLength      :=  nMaxRowspPage
            :serverSide      := .T.
            :info            := .T.
            :lengthChange    := .T.
            :lengthMenu      := { {0,nRowspPageMax,-1},{0,nRowspPageMax,{"Todos","Todos"}[AppData:nLang]} }
            :searching       := .T.
            :ordering        := .T.
            :order           := { {0,'asc'} }  // Columna por defecto

            // Columnas del browse
            nFields:=Len(aFields)
            for nField:=1 to nFields
              WITH OBJECT :AddColumn(aFields[nField][1])
                  :data       := aFields[nField][2]
                  :orderable  := aFields[nField][3]
                  :searchable := aFields[nField][4]
                  :className  := aFields[nField][5]
               END
            next nField

 *           cTmp := {"Detalhes","Detalhes"}[AppData:nLang]
 *           :AddColumnButton("loupe",cTmp,"btn-wDatatable ;",/*"visparamajax"*/,"dt-center",/*"datas"*/,/*,'fn_click'*/)
 *           :AddColumnDef( nField ):width := '30px'

            :ajax := { "cgi" => "GetDataCadastroVerbas" }

         END

         :Create()

      END
 /*
      WITH OBJECT WBevel():New(:WO)
         :cId     :="datas"
         WITH OBJECT:oStyle
            :cMargin_Top :=  20
            :cMin_Height := 400
            :cMax_Height := 400
            :cOverflow   := "auto"
         END
         :Create()
      END
*/
      oCgi:SendPage( :Create() )

   END

RETURN

//------------------------------------------------------------------------------

FUNCTION GetDataCadastroVerbas(lSendJSON,lGetFull,cSearchFilter)

   local aRow
   local aOrder
   local aRecords

   local codModel:=__CODMODEL__

   local xJSONData

   local hRow
   local hParams

   local nDraw
   local nStart
   local nLimit

   HB_Default(@lGetFull,.F.)

   if (lGetFull)

      nStart:=1
      nLimit:=-1

   else

      hParams:=oCGI:aParamsToHash(.T.)

      nStart:=Val(hParams['START'])

      nLimit:=Val(hParams['LENGTH'])

      nDraw:=hParams['DRAW']
      aOrder:={Val(hParams['order[0][column]'])+1,hParams['order[0][dir]']} // datatables empieza en columna 0. segundo elemento asc o desc
      cSearchFilter:=hParams['SEARCH[VALUE]']
      oCGI:SetUserData( "GetDataModel:cSearchFilter",cSearchFilter )

   endif

   HB_Default(@lSendJSON,.T.)

   if (!Empty(nLimit))
      GetDataFieldsCadastroVerbas()
      xJSONData:=Extraer(codModel,nStart,nLimit,nDraw,cSearchFilter,aOrder,lSendJSON,.F.)
   endif

RETURN(if(lSendJSON,oCGI:SendJson(xJSONData),xJSONData))

function GetDataFieldsCadastroVerbas(cColsPrint)
   local aFields
   local codModel:=__CODMODEL__
   local bFunction:={||Extraer(codModel,1,1,1,"",{},.F.,.T.)}
   aFields:=GetDataFields(codModel,bFunction,@cColsPrint)
   return(aFields)

//-------------------------------------------
// Recuperamos los datos
STATIC FUNCTION Extraer(codModel,nPage,nRecords,nDraw,cSearchFilter,aOrder,lSendJSON,lGetFields)

   local cFile
   local cFilter
   local cParModel
   local cGrpFiles

   local codVerba
   local codGrupo
   local codFilial

   local hFilter

   local xData

   AppData:cEmp:=oCGI:GetUserData("cEmp",AppData:cEmp)
   HB_Default(AppData:cEmp,"")

   cFile:=(AppData:PathData+AppData:cEmp+"_"+Lower(ProcName(1))+".json")

   hFilter:={=>}

   IF (!stacktools():IsInCallStack("GEPParameters"))

      restoreTmpParameters("__CadastroVerbas",@hFilter,.T.)

      codGrupo:=oCGI:GetUserData("__CadastroVerbas:codGrupo","")
      codVerba:=oCGI:GetUserData("__CadastroVerbas:codVerba","")
      codFilial:=oCGI:GetUserData("__CadastroVerbas:codFilial","")

      IF (!Empty(codGrupo))
         hFilter["codGrupo"]:=codGrupo
      ELSE
         IF (HB_HHasKey(hFilter,"codGrupo"))
            HB_HDel(hFilter,"codGrupo")
         ENDIF
      ENDIF

      IF (!Empty(codFilial))
         hFilter["codFilial"]:=codFilial
      ELSE
         IF (HB_HHasKey(hFilter,"codFilial"))
            HB_HDel(hFilter,"codFilial")
         ENDIF
      ENDIF

      IF (!Empty(codVerba))
         hFilter["codVerba"]:=codVerba
      ELSE
         IF (HB_HHasKey(hFilter,"codVerba"))
            HB_HDel(hFilter,"codVerba")
         ENDIF
      ENDIF

   ENDIF

   cParModel:=setParModel(hFilter)

   IF (!Empty(cFilter))
      cFilter:="SQL:"+cFilter
   else
      cFilter:=cSearchFilter
   endif

   cGrpFiles:=codModel

   xData:=GetDataModel(codModel,nPage,nRecords,nDraw,cFilter,aOrder,lSendJSON,lGetFields,cFile,cParModel,.F.,cGrpFiles)

   IF (!Empty(hFilter))
      HB_Default(@lGetFields,.F.)
      IF (!lGetFields)
        xData:=rebuildDataModel(xData,hFilter,lSendJSON,aOrder)
      ENDIF
   ENDIF

RETURN(xData)

procedure __clearCadastroVerbas()

   oCGI:SetUserData("__CadastroVerbas:codGrupo","")
   oCGI:SetUserData("__CadastroVerbas:codVerba","")
   oCGI:SetUserData("__CadastroVerbas:codFilial","")

   oCGI:SetUserData("CadastroVerbas:Back","MAINFUNCTION")

   deleteTmpParameters("__CadastroVerbas")

   return