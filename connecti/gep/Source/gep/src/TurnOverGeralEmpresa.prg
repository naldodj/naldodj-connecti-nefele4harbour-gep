// Proyecto: GEP
/*
 * Fichero: TurnOverGeralEmpresa.prg
 * Descripción:
 * Autor:
 * Fecha: 14/08/2021
 */
///

#include "Xailer.ch"
#include "Nefele.ch"
#include "LangCGI.ch"

#define __CODMODEL__ "TURNOVERGERALEMPRESA"

PROCEDURE ParametersTurnOverGeralEmpresa( lGrpViewTotais )

   LOCAL hUser := LoginUser()

   LOCAL cSubTitle := " :: " + "Consulta TurnOver Geral por Empresa "
   LOCAL cTitle := AppData:AppTitle + cSubTitle
   LOCAL cIDParameters
   LOCAL aParameters

   hb_default( @lGrpViewTotais, .F. )
   oCGI:SetUserData( "__TurnOverGeralEmpresa:lGrpViewTotais", lGrpViewTotais )

   oCGI:SetUserData( "TurnOverGeralEmpresa:Back", ProcName() )

   WITH OBJECT wTWebPage():New()

      :cTitle := cTitle

      AppMenu( :WO, AppData:AppName, hUser, .F. )

      aParameters := { "codPeriodo", "codPeriodoAte" }
      cSubTitle := AppData:AppName + cSubTitle
      GEPParameters( :WO, @cIDParameters, "__TurnOverGeralEmpresa", aParameters, .T., cSubTitle, .T. ):Create()

      :lValign    := .F.
      :lContainer := .F.

      oCgi:SendPage( :Create() )

   END

RETURN

FUNCTION __TurnOverGeralEmpresa(lExecute,hFilter,nMaxRowspPage)

   LOCAL cIDModal

   LOCAL codPeriodo
   LOCAL codPeriodoAte

   LOCAL hIDModal

   LOCAL lFilter

   hb_default( @lExecute, .T. )
   lFilter := ( HB_ISHASH( hFilter ) .AND. !Empty( hFilter ) )
   hb_default( @hFilter, { => } )

   IF (existsTmpParameters("__TurnOverGeralEmpresa"))
      IF (stacktools():IsInCallStack("TCGI:__TURNOVERGERALEMPRESADET"))
         deleteTmpParameters("__TurnOverGeralEmpresa")
      ELSE
         restoreTmpParameters("__TurnOverGeralEmpresa",@hFilter,.T.)
      ENDIF
   ENDIF

   IF ( lExecute )
      cIDModal := oCGI:GetCgiValue( "cIDModalTotaisTurnOverGeralEmpresa", "" )
      IF ( !Empty( cIDModal ) )
         oCGI:SetUserData( "HistoryRemoveParams", .F. )
         cIDModal := __base64Decode( cIDModal )
         hb_jsonDecode( cIDModal, @hIDModal )
         saveTmpParameters( "__TurnOverGeralEmpresa", hIDModal )
         IF ( hb_HHasKey( hIDModal,"codPeriodo" ) )
            codPeriodo := hIDModal[ "codPeriodo" ]
         ENDIF
         IF ( hb_HHasKey( hIDModal,"codPeriodoAte" ) )
            codPeriodoAte := hIDModal[ "codPeriodoAte" ]
         ENDIF
      ELSE
         IF ( hb_HHasKey( hFilter,"codPeriodo" ) )
            codPeriodo := hFilter[ "codPeriodo" ]
            oCGI:SetUserData( "__TurnOverGeralEmpresa:codPeriodo", codPeriodo )
         ELSE
            codPeriodo := oCGI:GetCgiValue( "codPeriodo", "" )
         ENDIF
         IF ( hb_HHasKey( hFilter,"codPeriodoAte" ) )
            codPeriodoAte := hFilter[ "codPeriodoAte" ]
            oCGI:SetUserData( "__TurnOverGeralEmpresa:codPeriodoAte", codPeriodoAte )
         ELSE
            codPeriodoAte := oCGI:GetCgiValue( "codPeriodoAte", "" )
         ENDIF
      ENDIF
   ELSE
      IF ( hb_HHasKey( hFilter,"codPeriodo" ) )
         codPeriodo := hFilter[ "codPeriodo" ]
         oCGI:SetUserData( "__TurnOverGeralEmpresa:codPeriodo", codPeriodo )
      ELSE
         codPeriodo := oCGI:GetCgiValue( "codPeriodo", "" )
      ENDIF
      IF ( hb_HHasKey( hFilter,"codPeriodoAte" ) )
         codPeriodoAte := hFilter[ "codPeriodoAte" ]
         oCGI:SetUserData( "__TurnOverGeralEmpresa:codPeriodoAte", codPeriodoAte )
      ELSE
         codPeriodoAte := oCGI:GetCgiValue( "codPeriodoAte", "" )
      ENDIF
   ENDIF

   IF ( ( !lFilter ) .AND. Empty( cIDModal ) )

      IF ( Empty( codPeriodo ) )
         codPeriodo := oCGI:GetCgiValue( "GEPParameters_codPeriodo", "" )
         IF ( Empty( codPeriodo ) )
            codPeriodo := oCGI:GetUserData( "__GEPParameters:codPeriodo", codPeriodo )
         ENDIF
      ENDIF

      IF ( Empty( codPeriodoAte ) )
         codPeriodoAte := oCGI:GetCgiValue( "GEPParameters_codPeriodoAte", "" )
         IF ( Empty( codPeriodoAte ) )
            codPeriodoAte := oCGI:GetUserData( "__GEPParameters:codPeriodoAte", codPeriodoAte )
         ENDIF
      ENDIF

   ENDIF

   hFilter[ "codPeriodo" ] := codPeriodo
   oCGI:SetUserData( "__TurnOverGeralEmpresa:codPeriodo", codPeriodo )

   hFilter[ "codPeriodoAte" ] := codPeriodoAte
   oCGI:SetUserData( "__TurnOverGeralEmpresa:codPeriodoAte", codPeriodoAte )

   saveTmpParameters( "__TurnOverGeralEmpresa", @hFilter )

   IF ( lExecute )
      saveTmpParameters( "__TurnOverGeralFilial", @hFilter )
      oCGI:SetUserData( "TurnOverGeralFilial:Back", ProcName() )
      oCGI:SetUserData("__TurnOverGeralEmpresaDashBoard:Back",ProcName())
      TurnOverGeralEmpresa(nMaxRowspPage)
   ENDIF

RETURN( hFilter )

PROCEDURE TurnOverGeralEmpresa(nMaxRowspPage)

   LOCAL hUser := LoginUser()

   LOCAL cSubTitle := " :: " + "Consulta TurnOver Geral por Empresa "
   LOCAL cTitle := AppData:AppTitle + cSubTitle
   LOCAL cColsPrint
   LOCAL cIDParameters
   LOCAL aParameters

   LOCAL nField
   LOCAL aFields
   LOCAL nFields
   LOCAL nRowspPageMax

   LOCAL cTmp

   LOCAL cPrintIMG

   LOCAL cFilter
   LOCAL hFilter

   LOCAL codPeriodo
   LOCAL codPeriodoAte

   LOCAL owDataTable

   IF ( !stackTools():IsInCallStack( "__TurnOverGeralEmpresa" ) )
      hFilter:=__TurnOverGeralEmpresa( .F. )
   ELSE
      restoreTmpParameters("__TurnOverGeralEmpresa",@hFilter,.T.)
   ENDIF

   cFilter:=HB_JsonEncode(hFilter,.F.)
   cFilter:=__base64Encode(cFilter)

   WITH OBJECT wTWebPage():New()

      :cTitle := cTitle

      AppMenu( :WO, AppData:AppName, hUser, .F. )

      WITH OBJECT WFloatingBtn():New( :WO )
         :cClrPane := "#005FAB"
         :cName := ( "WFloatingBtn" + ProcName() )
         :cId := Lower( :cName )
         :cText := "Voltar"
         :oIcon:cIcon := "arrow_back"
         :oIcon:cClrIcon := "#FED300"
         :cOnClick := oCGI:GetUserData( ProcName() + ":Back", "MAINFUNCTION" )
         :Create()
      END WITH

      codPeriodo := oCGI:GetUserData( "__TurnOverGeralEmpresa:codPeriodo" )
      codPeriodoAte := oCGI:GetUserData( "__TurnOverGeralEmpresa:codPeriodoAte" )

      IF ((codPeriodoAte<codPeriodo )).or.(Left(codPeriodoAte,4)<>Left(codPeriodo,4))

         WITH OBJECT WMsgAlert():New(:WO)
            :lTagScript       := .T.
            :cText            := "Período Inválido. Informe um período Válido."
            :cType            := "info"
            :nPrimaryDelay    := 15
            :cConfirmButton   := Lang(LNG_ACEPTAR)
            :Create()
         END WITH

      ELSE

         aParameters := { "codPeriodo", "codPeriodoAte" }
         cSubTitle := AppData:AppName
         GEPParameters( :WO, @cIDParameters, "__TurnOverGeralEmpresaDet", aParameters, .F., cSubTitle ):Create()

         :lValign    := .F.
         :lContainer := .F.

         aFields := GetDataFieldsTurnOverGeralEmpresa( @cColsPrint )
         nRowspPageMax := oCGI:GetUserData(__CODMODEL__+":RowspPageMax",10)
         HB_Default(@nMaxRowspPage,nRowspPageMax)

         WITH OBJECT owDataTable:=wDatatable():New( :WO )

            :cId := Lower("browseTurnOverGeralEmpresa")

            DataTableCSS( :cID )

            :cCSS += AppData:CSSDataTable

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
                                    if (column<=0) {
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
                           }
                        },
                        {
                           extend: 'pdfHtml5',
                           orientation: 'landscape',
                           pageSize: 'A4',
                           customize : function(doc) {
                              doc.pageMargins = [20,20,20,20];
                              doc.styles.title = {
                                 color: 'black',
                                 fontSize: '16',
                                 background: 'white',
                                 alignment: 'center'
                              };
                              doc.defaultStyle.fontSize = 13;
                              doc.styles.tableHeader.fontSize = 13;
                              doc.styles.tableFooter.fontSize = 13;
                              var rowCount = doc.content[1].table.body.length;
                              for (c = 1; c < doc.content[1].table.body[0].length; c++) { // right align headers for numeric cols
                                 doc.content[1].table.body[0][c].alignment = 'right';
                              }
                              for (i = 1; i < rowCount; i++) {
                                  for (c = 1; c < doc.content[1].table.body[i].length; c++) { // right align numeric cols
                                       doc.content[1].table.body[i][c].alignment = 'right';
                                  }
                              }
                              var tbl = $('#@tbl@');
                              var colCount = new Array();
                              $(tbl).find('tbody tr:first-child td, tbody tr:first-child th').each(function(){
                                   if($(this).attr('colspan')){
                                       for(var i=1;i<=$(this).attr('colspan');$i++){
                                           colCount.push('auto');
                                       }
                                   }else{ colCount.push('auto'); }
                               });
                               if (!colCount.length===0){
                                 doc.content[1].table.widths = colCount;
                               }
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
                                       margin: [20, 0]
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
                                       margin: [20, 0]
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
                     orientation: 'landscape',
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

            WITH OBject :AddButton( "Parâmetros" )
               :cAction := nfl_OpenModal( cIDParameters, .T. )
            END WITH

            WITH OBject :AddButton( "DashBoard" )
               :cAction :="autoformID('"+cFilter+"','?FUNCTION=__TurnOverGeralEmpresaDashBoardDet','_parent',true);"
            END WITH

            :cTitle  := cTitle + tableBtnReload( :cId )

            // Configurar opciones
            WITH OBJECT :Configure()
               :SetLanguage( { "Portugues", "Spanish" }[ AppData:nLang ] )
               :sPaginationType := "full_numbers" //"listbox"
               :paging          := .T.
               :pageLength      :=  nMaxRowspPage
               :serverSide      := .T.
               :info            := .T.
               :lengthChange    := .T.
               :lengthMenu      := { { 0,nRowspPageMax, - 1 }, { 0,nRowspPageMax,{"Todos","Todos"}[ AppData:nLang ] } }
               :searching       := .T.
               :ordering        := .T.
               :ORDER           := { { 0,'asc' } }  // Columna por defecto
               :ScrollX:=.T.
               :ScrollY:=.T.

               // Columnas del browse
               nFields := Len( aFields )
               FOR nField := 1 TO nFields
                  WITH OBJECT :AddColumn( aFields[ nField ][ 1 ] )
                     :DATA       := aFields[ nField ][ 2 ]
                     :orderable  := aFields[ nField ][ 3 ]
                     :searchable := aFields[ nField ][ 4 ]
                     :className  := aFields[ nField ][ 5 ]
                  END
               NEXT nField

               cTmp := { "Detalhes", "Detalhes" }[ AppData:nLang ]
               :AddColumnButton( "loupe", cTmp, "btn-wDatatable ;", "__TurnOverGeralFilialDet", "dt-center", "", /*,'fn_click'*/ )
               :AddColumnDef( nField ):width := '14px'

               :ajax := { "cgi" => "GetDataTurnOverGeralEmpresa" }

            END

            AAdd( :aScript, fixedColumns( :cID,oCGI:GetUserData( __CODMODEL__+":fixedColumns","-1" ) ) )

            :Create()

         END

      ENDIF

      oCgi:SendPage( :Create() )

   END

RETURN

//------------------------------------------------------------------------------

FUNCTION GetDataTurnOverGeralEmpresa( lSendJSON, lGetFull, cSearchFilter )

   LOCAL aRow
   LOCAL aOrder
   LOCAL aRecords

   LOCAL codModel := __CODMODEL__

   LOCAL hRow
   LOCAL hParams

   LOCAL nDraw
   LOCAL nStart
   LOCAL nLimit

   LOCAL xJSONData

   hb_default( @lGetFull, .F. )

   IF ( lGetFull )

      nStart := 1
      nLimit := -1

   ELSE

      hParams := oCGI:aParamsToHash( .T. )

      nStart := Val( hParams[ 'START' ] )

      nLimit := Val( hParams[ 'LENGTH' ] )

      nDraw := hParams[ 'DRAW' ]
      aOrder := { Val( hParams[ 'order[0][column]' ] ) + 1, hParams[ 'order[0][dir]' ] } // datatables empieza en columna 0. segundo elemento asc o desc
      cSearchFilter := hParams[ 'SEARCH[VALUE]' ]
      oCGI:SetUserData( "GetDataModel:cSearchFilter", cSearchFilter )

   ENDIF

   hb_default( @lSendJSON, .T. )

   IF ( !nLimit == 0 )
      GetDataFieldsTurnOverGeralEmpresa()
      xJSONData := Extraer( codModel, nStart, nLimit, nDraw, cSearchFilter, aOrder, lSendJSON, .F. )
   ENDIF

RETURN( if( lSendJSON,oCGI:SendJson(xJSONData ),xJSONData ) )

FUNCTION GetDataFieldsTurnOverGeralEmpresa( cColsPrint )
   local aFields
   local codModel:=__CODMODEL__
   local bFunction:={||Extraer(codModel,1,1,1,"",{},.F.,.T.)}
   aFields:=GetDataFields(codModel,bFunction,@cColsPrint)
   return(aFields)

//-------------------------------------------
// Recuperamos los datos
STATIC FUNCTION Extraer( codModel, nPage, nRecords, nDraw, cSearchFilter, aOrder, lSendJSON, lGetFields )

   LOCAL cFile
   LOCAL cFilter
   LOCAL cParModel
   LOCAL cGrpFiles

   LOCAL codPeriodo
   LOCAL codPeriodoAte

   LOCAL hFilter
   LOCAL hFilterBetween

   LOCAL xData

   AppData:cEmp := oCGI:GetUserData( "cEmp", AppData:cEmp )
   hb_default( AppData:cEmp, "" )
   cFile := ( AppData:PathData + AppData:cEmp + "_" + Lower( ProcName(1 ) ) + ".json" )

   hFilter := { => }
   hFilterBetween := { => }

   restoreTmpParameters( "__TurnOverGeralEmpresa", @hFilter, .T. )

   codPeriodo := oCGI:GetUserData( "__TurnOverGeralEmpresa:codPeriodo" )
   codPeriodoAte := oCGI:GetUserData( "__TurnOverGeralEmpresa:codPeriodoAte" )

   hb_default( @cFilter, "" )

   IF ( !Empty( codPeriodo ) )
      hFilter[ "codPeriodo" ] := codPeriodo
   ELSE
      IF ( hb_HHasKey( hFilter,"codPeriodo" ) )
         hb_HDel( hFilter, "codPeriodo" )
      ENDIF
   ENDIF

   IF ( !Empty( codPeriodoAte ) )
      hFilter[ "codPeriodoAte" ] := codPeriodoAte
   ELSE
      IF ( hb_HHasKey( hFilter,"codPeriodoAte" ) )
         hb_HDel( hFilter, "codPeriodoAte" )
      ENDIF
   ENDIF

   IF ( !Empty( codPeriodo ) .and. !Empty( codPeriodoAte ) )
      IF ( !Empty( cFilter ) )
         cFilter += " AND "
      ENDIF
      cFilter += "PERIODO BETWEEN '" + codPeriodo + "' AND '"+codPeriodoAte+"'"
      hFilterBetween["codPeriodo"]:={codPeriodo,codPeriodoAte}
      hFilterBetween["codPeriodoAte"]:={codPeriodo,codPeriodoAte}
   ENDIF

   cParModel := setParModel( hFilter )

   IF ( !Empty( cFilter ) )
      cFilter := "SQL:" + cFilter
   ELSE
      cFilter := cSearchFilter
   ENDIF

   cGrpFiles := codModel
   IF ( !Empty( codPeriodo ) )
      cGrpFiles += "_"
      cGrpFiles += Left(codPeriodo,4)
   ENDIF

   xData := GetDataModel( codModel, nPage, nRecords, nDraw, cFilter, aOrder, lSendJSON, lGetFields, cFile, cParModel, .F., cGrpFiles )

   IF ( !Empty( hFilter ) )
      hb_default( @lGetFields, .F. )
      IF ( !lGetFields )
         xData := rebuildDataModel( xData, hFilter, lSendJSON, aOrder , hFilterBetween )
      ENDIF
   ENDIF

RETURN( xData )

PROCEDURE __clearTurnOverGeralEmpresa()

   oCGI:SetUserData( "__TurnOverGeralEmpresa:codPeriodo", "" )
   oCGI:SetUserData( "__TurnOverGeralEmpresa:codPeriodoAte", "" )

   oCGI:SetUserData( "TurnOverGeralEmpresa:Back", "ParametersTurnOverGeralEmpresa" )

   deleteTmpParameters( "__TurnOverGeralEmpresa" )

RETURN