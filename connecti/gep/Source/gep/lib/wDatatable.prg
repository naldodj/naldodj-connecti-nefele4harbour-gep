/*
 * Proyecto: Connecti
 * Fichero: wDatatablesModificado.prg
 * Descricao?
 * Autor:
 * Fecha: 14/08/2021
 */

#include "Xailer.ch"
#include "nefele.ch"

CLASS wDatatable FROM ZDatatable

   CLASSDATA lUsed INIT .f.
   PROPERTY oCustomButton
   METHOD Create

ENDCLASS

//------------------------------------------------------------------------------

METHOD Create   CLASS wDatatable
local cTxt

   if !::lUSed
      ::cCSS += CambiaEstilo() // hay que hacerlo solo la primera vez que se instancia la clase
      ::lUSed := .t.
   endif

   TEXT INTO cTxt
      //bug datatables? si cambiamos de longitud reg mostrados,limpiamos los anteriores + ocultamos seleccionar pagina,porque solo hay una
      let @1_bps =  document.querySelector("#@1_paginate > select")
      if (@1_bps != null){
         let @1_bli = document.querySelector("#@1_filter > label > input[type=search]")
         if (@1_bps != null){
            if (@1_bli != null){
               @1_bli.addEventListener("change",function(){
                  document.querySelector("#@1_paginate > select").innerHTML=""  ;
                  @1_bpt = document.querySelector("#@1_paginate > span.paginate_total").innerText
                  @1_bpt = parseInt(@1_bpt)
                  for (let step = 0 ; step < @1_bpt ; step++) {
                     myOption = document.createElement("option");
                     myOption.text = step+1;
                     myOption.value = step+1;
                     @1_bps.appendChild(myOption);
                  }
               });
            }

         };

         document.querySelector("#@1_length > label > select").addEventListener("change",function(){
            document.querySelector("#@1_paginate > select").innerHTML=""  ;
            if (document.querySelector("#@1_length > label > select").value == "-1"){
               document.querySelector("#@1_paginate").style.visibility="hidden"
            }else{
               document.querySelector("#@1_paginate").style.visibility="visible"
            }
         })
      }
   ENDTEXT

   cTxt := StrTran( cTxt,"@1",::cid)
   ::oParent:cOnReady := cTxt

   ::Super:Create()

   // para que los iconos ordenar salgan pegados al texto. despues de crear el datatables
   TEXT INTO  cTxt
      table@1.columns().iterator('column',function (ctx,idx) {
              $(table@1.column(idx).header()).append('<span class="sort-icon"/>');
          });
   ENDTEXT

   cTxt := StrTran( cTxt,"@1",::cid)
   ::oParent:cOnReady := cTxt
   ::oParent:cInHead += cInHeadDataTable()

RETURN Self

//------------------------------------------------------------------------------
// Modificaciones sobre el css original
STATIC FUNCTION CambiaEstilo( )
local cTxt
TEXT INTO cTxt

h5#WDataTableTitle{
   background:#17eb17;
    padding:10px
}
.bold{
    font-weight: 700;
}
.simple {
    background: transparent !important;
    border: none;
    cursor: pointer;
}


/*Linea verde inferior*/
.dataTables_wrapper.no-footer .dataTables_scrollBody{
    border-bottom: 1px solid #ddd var( --linea) !important;}
/*linea verde superior*/
    table.dataTable thead th {
    padding: 10px 18px;
    /*border-bottom: 1px solid #ddd var( --linea);*/
    border-bottom: 1px solid #ddd var( --linea) !important;
    border-radius: 0px !important;
}

.dataTables_scrollBody>table>thead>tr>th{
    border-bottom: none !important;
    /*poner a border-bottom: 1px solid var( --linea) !important; para doble linea superior*/
}


/*clases de alinaci??abecera*/
.dt-head-center {
    padding-right: 0px !important;
}
.dt-head-left {
    padding-left: 0px !important;
}

table.dataTable.compact tbody th,table.dataTable.compact tbody td {
    padding: 1px;    /*<--*/
    white-space: nowrap; /*<----*/
}
/*thead del table,que está ocultado*/
table.dataTable.compact thead th,table.dataTable.compact thead td {
    padding: 1px 0px !important;

}


/*mensaje de procesando*/
.dataTables_processing{
    z-index:999999999;
    border:1px dashed;
    background:#c3fdc8 !important;
    padding-top:5px  !important;
    width:100%  !important;
    margin-left: -1%  !important;
    border-radius:11px;
    top: 85px  !important;
    left: 1% !important;
}


/*no se*/
.dataTables_wrapper .dataTables_scroll div.dataTables_scrollBody>table>thead>tr>th{
    border-bottom:1px solid #ddd ; /*!important;*/
    padding-left:5px
}

/*no se si lo quito sale barra horizontal*/

td.dt-right{
 padding-right:12px!important
}



.punto{
    border:1px solid #fff!important;
    margin-left:-1px!important;
    text-align:center;
    margin-right:15px;
    background-color:#4caf50;
    cursor:pointer;
    box-shadow:0 0 2px 0 #000;
    min-width:27px; max-width:27px;
    padding:4px 1px;
    font-size:11px; color:#fff; font-weight:700;
    max-height:23px!important
}
.punto.punto2{
    padding:0!important;
    margin-right:-9px
}


/*div contenedor*/
.dtb_topdiv{
    border:1px solid #80808094;
    /*zoom:.8
    -moz-transform: scale(.9);   ;*/
}
/*registros por pagina*/
.dataTables_length{
    max-width:110px;
    float:right !important;
    margin-bottom:18px;
    margin-right: 17px;
    font-size: 11px;
    font-weight: 500;
    font-family: 'Helvetica Neue','Helvetica',-apple-system,BlinkMacSystemFont,'Segoe UI',Roboto,Oxygen-Sans,Ubuntu,Cantarell,'Helvetica Neue',sans-serif !important;
}

/*edit de filtro*/
.dataTables_wrapper .dataTables_filter input{
    text-align:left !important;
    height:15.5px !important
}

.dataTables_filter{
    text-align:left !important;
    margin-right:14px !important;
    font-size: 11px !important;
    font-weight: 500 !important;
    font-family: 'Helvetica Neue','Helvetica',-apple-system,BlinkMacSystemFont,'Segoe UI',Roboto,Oxygen-Sans,Ubuntu,Cantarell,'Helvetica Neue',sans-serif !important;
}
.dt-buttons{
 /*   margin-top: 15px;*/
}

/*Combo selecci??agina*/
select.paginate_select {
    height: 2rem;
    width: 42%;
    margin-bottom: 9px;
    border-bottom: 1px solid var( --color) !important;
    background-color: transparent;
    padding-right: 13px;
    border: none;
    max-width: 70px;
}
.paginate_select option {
    text-align: right;
}

.dataTables_paginate{
    min-width: 173px;
}

/*efecto pijama*/
/*
tr.odd{
    background-color:#f0f8ff!important
}
.even td.sorting_1 {
    BACKGROUND: #e5e9ed4a;
}
.odd td.sorting_1 {
    BACKGROUND: #e5e9ed78;
}
*/

/*fileas con chec*/
table.dataTable tbody>tr.selected,table.dataTable tbody>tr>.selected {
       background-color: var( --selected) !important;
   }

table.dataTable thead th {
    background: transparent !important;
    white-space: nowrap;
}
/*modificaciones a los iconos de ordenacion*/
   /*si centrado o alineado derecha sin ordenar reducimos botones ocultos para que quede bien centrado*/
   th.sorting_disabled._DataTableColumnDef.dt-head-center span.sort-icon {width: 0px;}
   th.sorting_disabled._DataTableColumnDef.dt-head-right span.sort-icon { width: 9px;}
   th.dt-center.dt-head-center.sorting_disabled span.sort-icon { width: 0px;}
table.dataTable thead span.sort-icon {
    display: inline-block;
    padding-left: 5px;
    width: 16px;
    height: 16px;
}
table.dataTable thead .sorting span {   background: url('https://cdn.datatables.net/plug-ins/3cfcc339e89/integration/bootstrap/images/sort_both.png') no-repeat center right; }
table.dataTable thead .sorting_asc span { background: url('https://cdn.datatables.net/plug-ins/3cfcc339e89/integration/bootstrap/images/sort_asc.png') no-repeat center right; }
table.dataTable thead .sorting_desc span {  background: url('https://cdn.datatables.net/plug-ins/3cfcc339e89/integration/bootstrap/images/sort_desc.png') no-repeat center right; }
table.dataTable thead .sorting_asc_disabled span { background: url('https://cdn.datatables.net/plug-ins/3cfcc339e89/integration/bootstrap/images/sort_asc_disabled.png') no-repeat center right;}
table.dataTable thead .sorting_desc_disabled span {  background: url('https://cdn.datatables.net/plug-ins/3cfcc339e89/integration/bootstrap/images/sort_desc_disabled.png') no-repeat center right; }
table.dataTable thead .sorting::before,
table.dataTable thead .sorting_asc::before,
table.dataTable thead .sorting_desc::before,
table.dataTable thead .sorting_asc_disabled::before,
table.dataTable thead .sorting_desc_disabled::before {  content: ""; }
table.dataTable thead .sorting::after,
table.dataTable thead .sorting_asc::after,
table.dataTable thead .sorting_desc::after,
table.dataTable thead .sorting_asc_disabled::after,
table.dataTable thead .sorting_desc_disabled::after {  content: "";  }


button.simple.black {
    VERTICAL-ALIGN: middle;
}

ENDTEXT
RETURN cTxt

//------------------------------------------------------------------------------
*** OJO CON ESTO
CLASS WJsonClass FROM ZJsonClass
//   OJO=1   // HAy que cambiarlo de sitio
ENDCLASS

function cInHeadDataTable()
    local cInHeadDataTable
    TEXT INTO cInHeadDataTable

       <!--jquery-->
       <script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.6.0/jquery.min.js" integrity="sha512-894YE6QWD5I59HgZOGReFYm4dnWc1Qt5NtvYSaNcOP+u1T9qYdvdihz0PPSiiqn/+/3e7Jo4EaG7TubfWGUrMQ==" crossorigin="anonymous" referrerpolicy="no-referrer"></script>
       <script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.6.0/jquery.js" integrity="sha512-n/4gHW3atM3QqRcbCn6ewmpxcLAHGaDjpEBu4xZd47N0W2oQ+6q7oc3PXstrJYXcbNU1OHdQ1T7pAP+gi5Yu8g==" crossorigin="anonymous" referrerpolicy="no-referrer"></script>

       <!--DataTables-->
       <link rel='stylesheet' href='https://cdn.datatables.net/1.11.4/css/jquery.dataTables.min.css'>
       <script src='https://cdn.datatables.net/1.11.4/js/jquery.dataTables.min.js'></script>

       <!--Extensions-->

       <!--AutoFill-->
       <link rel='stylesheet' href='https://cdn.datatables.net/autofill/2.3.9/css/autoFill.dataTables.min.css'>
       <script src='https://cdn.datatables.net/autofill/2.3.9/js/dataTables.autoFill.min.js'></script>

       <!--Buttons-->
       <link rel='stylesheet' href='https://cdn.datatables.net/buttons/2.2.2/css/buttons.dataTables.min.css'>
       <script src='https://cdn.datatables.net/buttons/2.2.2/js/dataTables.buttons.min.js'></script>

       <!--Buttons : Column visibility control-->
       <script src='https://cdn.datatables.net/buttons/2.2.2/js/buttons.colVis.min.js'></script>

       <!--Buttons : HTML5 export buttons-->
       <script src='https://cdn.datatables.net/buttons/2.2.2/js/buttons.html5.min.js'></script>

       <!--Buttons : Print button-->
       <script src='https://cdn.datatables.net/buttons/2.2.2/js/buttons.print.min.js'></script>

       <!--ColReorder-->
       <link rel='stylesheet' href='https://cdn.datatables.net/colreorder/1.5.4/css/colReorder.dataTables.min.css'>
       <script src='https://cdn.datatables.net/colreorder/1.5.4/js/dataTables.colReorder.min.js'></script>

       <!--DateTime-->
       <link rel='stylesheet' href='https://cdn.datatables.net/datetime/1.1.1/css/dataTables.dateTime.min.css'>
       <script src='https://cdn.datatables.net/datetime/1.1.1/js/dataTables.dateTime.min.js'></script>

       <!--FixedColumns-->
       <link rel='stylesheet' href='https://cdn.datatables.net/fixedcolumns/4.0.1/css/fixedColumns.dataTables.min.css'>
       <script src='https://cdn.datatables.net/fixedcolumns/4.0.1/js/dataTables.fixedColumns.min.js'></script>

       <!--FixedHeader-->
       <link rel='stylesheet' href='https://cdn.datatables.net/fixedheader/3.2.1/css/fixedHeader.dataTables.min.css'>
       <script src='https://cdn.datatables.net/fixedheader/3.2.1/js/dataTables.fixedHeader.min.js'></script>

       <!--KeyTable-->
       <link rel='stylesheet' href='https://cdn.datatables.net/keytable/2.6.4/css/keyTable.dataTables.min.css'>
       <script src='https://cdn.datatables.net/keytable/2.6.4/js/dataTables.keyTable.min.js'></script>

       <!--Responsive-->
       <!--<link rel='stylesheet' href='https://cdn.datatables.net/responsive/2.2.9/css/responsive.dataTables.min.css'>-->
       <!--<script src='https://cdn.datatables.net/responsive/2.2.9/js/dataTables.responsive.min.js'></script>-->

       <!--RowGroup-->
       <link rel='stylesheet' href='https://cdn.datatables.net/rowgroup/1.1.4/css/rowGroup.dataTables.min.css'>
       <script src='https://cdn.datatables.net/rowgroup/1.1.4/js/dataTables.rowGroup.min.js'></script>

       <!--RowReorder-->
       <link rel='stylesheet' href='https://cdn.datatables.net/rowreorder/1.2.8/css/rowReorder.dataTables.min.css'>
       <script src='https://cdn.datatables.net/rowreorder/1.2.8/js/dataTables.rowReorder.min.js'></script>

       <!--Scroller-->
       <link rel='stylesheet' href='https://cdn.datatables.net/scroller/2.0.5/css/scroller.dataTables.min.css'>
       <script src='https://cdn.datatables.net/scroller/2.0.5/js/dataTables.scroller.min.js'></script>

       <!--SearchBuilder-->
       <link rel='stylesheet' href='https://cdn.datatables.net/searchbuilder/1.3.0/css/searchBuilder.dataTables.min.css'>
       <script src='https://cdn.datatables.net/searchbuilder/1.3.0/js/dataTables.searchBuilder.min.js'></script>

       <!--SearchPanes-->
       <link rel='stylesheet' href='https://cdn.datatables.net/searchpanes/1.4.0/css/searchPanes.dataTables.min.css'>
       <script src='https://cdn.datatables.net/searchpanes/1.4.0/js/dataTables.searchPanes.min.js'></script>

       <!--Select-->
       <link rel='stylesheet' href='https://cdn.datatables.net/select/1.3.4/css/select.dataTables.min.css'>
       <script src='https://cdn.datatables.net/select/1.3.4/js/dataTables.select.min.js'></script>

       <!--StateRestore-->
       <link rel='stylesheet' href='https://cdn.datatables.net/staterestore/1.1.0/css/stateRestore.dataTables.min.css'>
       <script src='https://cdn.datatables.net/staterestore/1.1.0/js/dataTables.stateRestore.min.js'></script>

    ENDTEXT
    return(cInHeadDataTable)

FUNCTION tableBtnReload( cTable )

   LOCAL cText

   TEXT INTO cText
   <i Title='Recarregar' CLASS='material-icons teal-text darken-4' style='cursor:pointer;float:right;font-size: 1.30em !Important;color:#ffff!important' onclick='table@tb.ajax.reload();'>refresh</i>
   ENDTEXT
   cText := StrTran( cText, "@tb", Lower( cTable ) )
   cText := StrTran( cText, CRLF, "" )

RETURN cText

PROCEDURE DataTableCSS( cID )

   LOCAL cCSS

   cCSS := "#" + cID + " tr.odd {background-color: #f1f1f1 !Important ;background: #f1f1f1 !Important ; text-align: center!Important;}"
   IF ( !( cCSS $ AppData:CSSDataTable ) )
      AppData:CSSDataTable += cCSS
   ENDIF

   cCSS := "#" + cID + "Topdiv tr.odd {background-color: #f1f1f1 !Important ;background: #f1f1f1 !Important ; text-align: center!Important;}"
   IF ( !( cCSS $ AppData:CSSDataTable ) )
      AppData:CSSDataTable += cCSS
   ENDIF

   cCSS := "dt-button {background: #1F4E79 !Important; color: #fffF !Important; line-height: 1.3em !Important;}"
   IF ( !( cCSS $ AppData:CSSDataTable ) )
      AppData:CSSDataTable += cCSS
   ENDIF

   cCSS := "#" + cID + " dt-button {background: #1F4E79 !Important; color: #fffF !Important; line-height: 1.3em !Important;}"
   IF ( !( cCSS $ AppData:CSSDataTable ) )
      AppData:CSSDataTable += cCSS
   ENDIF

   cCSS := "button.dt-button {background: #1F4E79 !Important; color: #fffF !Important; line-height: 1.3em!Important;}"
   IF ( !( cCSS $ AppData:CSSDataTable ) )
      AppData:CSSDataTable += cCSS
   ENDIF

   cCSS := "#" + cID + " button.dt-button {background: #1F4E79 !Important; color: #fffF !Important; line-height: 1.3em!Important;}"
   IF ( !( cCSS $ AppData:CSSDataTable ) )
      AppData:CSSDataTable += cCSS
   ENDIF

   cCSS := "span.dt-down-arrow {background: #1F4E79 !Important; color: #fffF !Important; line-height: 1.3em!Important;}"
   IF ( !( cCSS $ AppData:CSSDataTable ) )
      *AppData:CSSDataTable += cCSS
   ENDIF

   cCSS := "thead {color: #fffF !Important; background:color: #012444 !important; background: #012444 !important; font-size: 11px; font-weight: 500; font-family: 'Helvetica Neue','Helvetica',-apple-system,BlinkMacSystemFont,'Segoe UI',Roboto,Oxygen-Sans,Ubuntu,Cantarell,'Helvetica Neue',sans-serif !important;}"
   IF ( !( cCSS $ AppData:CSSDataTable ) )
      AppData:CSSDataTable += cCSS
   ENDIF

   cCSS := "#" + cID + " thead {color: #fffF !Important; background:color: #012444 !important; background: #012444 !important; font-size: 11px; font-weight: 500; font-family: 'Helvetica Neue','Helvetica',-apple-system,BlinkMacSystemFont,'Segoe UI',Roboto,Oxygen-Sans,Ubuntu,Cantarell,'Helvetica Neue',sans-serif !important;}"
   IF ( !( cCSS $ AppData:CSSDataTable ) )
      AppData:CSSDataTable += cCSS
   ENDIF

   cCSS := "#" + cID + "Topdiv thead {color: #fffF !Important; background:color: #012444 !important; background: #012444 !important; font-size: 11px; font-weight: 500; font-family: 'Helvetica Neue','Helvetica',-apple-system,BlinkMacSystemFont,'Segoe UI',Roboto,Oxygen-Sans,Ubuntu,Cantarell,'Helvetica Neue',sans-serif !important;}"
   IF ( !( cCSS $ AppData:CSSDataTable ) )
      AppData:CSSDataTable += cCSS
   ENDIF

   cCSS := "#" + cID + " th {border-top: .5px solid #ddd;  border-right: 1px solid #ddd;font-size: 11px; font-weight: 500; font-family: 'Helvetica Neue','Helvetica',-apple-system,BlinkMacSystemFont,'Segoe UI',Roboto,Oxygen-Sans,Ubuntu,Cantarell,'Helvetica Neue',sans-serif !important;}"
   IF ( !( cCSS $ AppData:CSSDataTable ) )
      AppData:CSSDataTable += cCSS
   ENDIF

   cCSS := "#" + cID + "Topdiv th {border-top: .5px solid #ddd;  border-right: 1px solid #ddd;font-size: 11px; font-weight: 500; font-family: 'Helvetica Neue','Helvetica',-apple-system,BlinkMacSystemFont,'Segoe UI',Roboto,Oxygen-Sans,Ubuntu,Cantarell,'Helvetica Neue',sans-serif !important;}"
   IF ( !( cCSS $ AppData:CSSDataTable ) )
      AppData:CSSDataTable += cCSS
   ENDIF

   cCSS := "#" + cID + " th.dt-left {font-size: 11px; font-weight: 500; font-family: 'Helvetica Neue','Helvetica',-apple-system,BlinkMacSystemFont,'Segoe UI',Roboto,Oxygen-Sans,Ubuntu,Cantarell,'Helvetica Neue',sans-serif !important;}"
   IF ( !( cCSS $ AppData:CSSDataTable ) )
      AppData:CSSDataTable += cCSS
   ENDIF

   cCSS := "#" + cID + " th.dt-left.sorting.sorting_asc { background-repeat: no-repeat !Imortant; background-position: right !Imortant;}"
   IF ( !( cCSS $ AppData:CSSDataTable ) )
      AppData:CSSDataTable += cCSS
   ENDIF


   cCSS := "#" + cID + " td {border-top: .5px solid #ddd;  border-right: 1px solid #ddd;font-size: 11px; font-weight: 500; font-family: 'Helvetica Neue','Helvetica',-apple-system,BlinkMacSystemFont,'Segoe UI',Roboto,Oxygen-Sans,Ubuntu,Cantarell,'Helvetica Neue',sans-serif !important;}"
   IF ( !( cCSS $ AppData:CSSDataTable ) )
      AppData:CSSDataTable += cCSS
   ENDIF

   cCSS := "#" + cID + "Topdiv td {border-top: .5px solid #ddd;  border-right: 1px solid #ddd; font-size: 11px; font-weight: 500; font-family: 'Helvetica Neue','Helvetica',-apple-system,BlinkMacSystemFont,'Segoe UI',Roboto,Oxygen-Sans,Ubuntu,Cantarell,'Helvetica Neue',sans-serif !important;}"
   IF ( !( cCSS $ AppData:CSSDataTable ) )
      AppData:CSSDataTable += cCSS
   ENDIF

   cCSS := "#" + cID + " td.dt-left {border-top: .5px solid #ddd;  border-right: 1px solid #ddd;font-size: 11px; font-weight: 500; font-family: 'Helvetica Neue','Helvetica',-apple-system,BlinkMacSystemFont,'Segoe UI',Roboto,Oxygen-Sans,Ubuntu,Cantarell,'Helvetica Neue',sans-serif !important;}"
   IF ( !( cCSS $ AppData:CSSDataTable ) )
      AppData:CSSDataTable += cCSS
   ENDIF

   cCSS := "#" + cID + "_info.dataTables_info { font-size: 11px; font-weight: 500; font-family: 'Helvetica Neue','Helvetica',-apple-system,BlinkMacSystemFont,'Segoe UI',Roboto,Oxygen-Sans,Ubuntu,Cantarell,'Helvetica Neue',sans-serif !important;}"
   IF ( !( cCSS $ AppData:CSSDataTable ) )
      AppData:CSSDataTable += cCSS
   ENDIF

   cCSS := "#" + cID + "_paginate.dataTables_paginate { font-size: 11px; font-weight: 500; font-family: 'Helvetica Neue','Helvetica',-apple-system,BlinkMacSystemFont,'Segoe UI',Roboto,Oxygen-Sans,Ubuntu,Cantarell,'Helvetica Neue',sans-serif !important;}"
   IF ( !( cCSS $ AppData:CSSDataTable ) )
      AppData:CSSDataTable += cCSS
   ENDIF

   cCSS := "#" + cID + "_paginate.paging_full_numbers { font-size: 11px; font-weight: 500; font-family: 'Helvetica Neue','Helvetica',-apple-system,BlinkMacSystemFont,'Segoe UI',Roboto,Oxygen-Sans,Ubuntu,Cantarell,'Helvetica Neue',sans-serif !important;}"
   IF ( !( cCSS $ AppData:CSSDataTable ) )
      AppData:CSSDataTable += cCSS
   ENDIF

   cCSS := ".dataTables_wrapper .dataTables_length select { border: none !important; border-bottom: 1px solid !important; height: 27px; font-size: 11px; font-weight: 500; font-family: 'Helvetica Neue','Helvetica',-apple-system,BlinkMacSystemFont,'Segoe UI',Roboto,Oxygen-Sans,Ubuntu,Cantarell,'Helvetica Neue',sans-serif !important;}"
   IF ( !( cCSS $ AppData:CSSDataTable ) )
      AppData:CSSDataTable += cCSS
   ENDIF

   cCSS := ".select-wrapper input.select-dropdown  { height: 27px; font-size: 11px; font-weight: 500; font-family: 'Helvetica Neue','Helvetica',-apple-system,BlinkMacSystemFont,'Segoe UI',Roboto,Oxygen-Sans,Ubuntu,Cantarell,'Helvetica Neue',sans-serif !important;}"
   IF ( !( cCSS $ AppData:CSSDataTable ) )
      AppData:CSSDataTable += cCSS
   ENDIF

   cCSS := ".select-wrapper input.dropdown-trigger { font-size: 11px; font-weight: 500; font-family: 'Helvetica Neue','Helvetica',-apple-system,BlinkMacSystemFont,'Segoe UI',Roboto,Oxygen-Sans,Ubuntu,Cantarell,'Helvetica Neue',sans-serif !important;}"
   IF ( !( cCSS $ AppData:CSSDataTable ) )
      AppData:CSSDataTable += cCSS
   ENDIF


   cCSS := "#" + cID + " .material-icons { font-size: 14px !important; font-weight: 500 !Important ;}"
   IF ( !( cCSS $ AppData:CSSDataTable ) )
      AppData:CSSDataTable += cCSS
   ENDIF

   cCSS := "#" + cID + " .btn-wDatatable { background: #45DD98 !Important; line-height: inherit !Important; font-weight: bold !Important ; font-size: 14px !Important; height: 17px !Important; width: 14px !Important; text-decoration: none; color: #fff; text-align: center; letter-spacing: .5px; -webkit-transition: background-color .2s ease-out; transition: background-color .2s ease-out; cursor: pointer; border-style: solid; border-bottom-width: 0.15px; border-top-width: 0.15px; border-right-width: 0.15px; border-left-width: 0.15px;}"
   IF ( !( cCSS $ AppData:CSSDataTable ) )
      AppData:CSSDataTable += cCSS
   ENDIF

   cCSS := "h5#WDataTableTitle { background: #45DD98 !Important; color: #fffF !Important;font-size: .85em !Important; font-weight: 550 !Important; margin: 0.3533333333rem 0 .2533333333rem 0 !Important; }"
   IF ( !( cCSS $ AppData:CSSDataTable ) )
      AppData:CSSDataTable += cCSS
   ENDIF

   cCSS := "table.dataTable thead .sorting, table.dataTable thead .sorting_asc, table.dataTable thead .sorting_desc, table.dataTable thead .sorting_asc_disabled, table.dataTable thead .sorting_desc_disabled { cursor: pointer; background-repeat: no-repeat !important; background-position: left !important; }"
   IF ( !( cCSS $ AppData:CSSDataTable ) )
      AppData:CSSDataTable += cCSS
   ENDIF

   cCSS := "label { font-family: 'Helvetica Neue','Helvetica',-apple-system,BlinkMacSystemFont,'Segoe UI',Roboto,Oxygen-Sans,Ubuntu,Cantarell,'Helvetica Neue',sans-serif !important;  }"
   IF ( !( cCSS $ AppData:CSSDataTable ) )
      AppData:CSSDataTable += cCSS
   ENDIF

   cCSS := ".dataTables_wrapper .dataTables_filter input { font-size: 11px; font-weight: normal; font-family: 'Helvetica Neue','Helvetica',-apple-system,BlinkMacSystemFont,'Segoe UI',Roboto,Oxygen-Sans,Ubuntu,Cantarell,'Helvetica Neue',sans-serif !important;}"
   IF ( !( cCSS $ AppData:CSSDataTable ) )
      AppData:CSSDataTable += cCSS
   ENDIF

RETURN

function tablefnShowHideCol(cTable)

   local cJS

TEXT INTO cJS
function fnShowHideCol( iCol )
{
    /* Get the DataTables object again - this is not a recreation, just a get of the object */
    var oTable = $('#cTable').dataTable();
    var bVis = oTable.fnSettings().aoColumns[iCol].bVisible;
    oTable.fnSetColumnVis( iCol, bVis ? false : true );
}
ENDTEXT
cJS:=StrTran(cJS,"cTable",cTable)

return(cJS)

function tablefnColsToShowHide(cTable,aCols)

   local cFN
   local cJS
   local cCol

   local nCol
   local nCols

   HB_Default(@cTable,"")
   HB_Default(@aCols,Array(0))

   cFN:="fn_"+cTable+"_dtShowHideCol()"
   cJS:="function "+cFN+"{"
   nCols:=Len(aCols)
   for nCol:=1 to nCols
      cCol:=HB_NToS((aCols[nCol]-1))
      cJS+="fnShowHideCol("+cCol+");"
   next nCol
   cJS+="tablefnAdjustDraw("+cTable+");"
   cJS+="}"

return( { "jsFunction" => cFN+";" , "jsScript" => cJS } )

function tablefnAdjustDraw(cTable)

   local cJS

TEXT INTO cJS
function fnAdjustDraw()
{
    /* Get the DataTables object again - this is not a recreation, just a get of the object */
    var oTable = $('#cTable').dataTable();
    oTable.columns.adjust().draw( false ); // adjust column sizing and redraw
}
ENDTEXT
cJS:=StrTran(cJS,"cTable",cTable)

return(cJS)

function tableBtnTotalAction(cID)

   local cJS

   cID:=Lower(cID)

   TEXT INTO cJS
x=document.getElementById("@cID@_headcontent");
if (x.style.display == "") {
   x.style.display="none"
} else {
x.style.display=""
};
   ENDTEXT
   cJS:=strTran(cJS,"@cID@",cID)

   return(cJS)
