/*
 * Proyecto: GEP
 * Fichero: zDashBoardTurnOver.prg
 * Descripción:
 * Autor:
 * Fecha: 28/10/2021
 */

#include "Xailer.ch"
#include "Nefele.ch"

CLASS zDashBoardTurnOver FROM WBevel

   PROPERTY cClassId INIT "zdbt"
   PROPERTY cRegional

   PROPERTY cClass   INIT "dashboardturnover"

   PROPERTY yearDashBoard

   PROPERTY monthsData

   PROPERTY colorPaletteData

   PROPERTY transfEntData
   PROPERTY transfSaiData
   PROPERTY admissoesData
   PROPERTY demissoesData
   PROPERTY totalfuncIMesData
   PROPERTY totalfuncFMesData

   PROPERTY turnOverGeralData
   PROPERTY turnOverDemissoesData

   PROPERTY totalFuncIMes

   PROPERTY totalFuncIPer
   PROPERTY totalFuncFPer

   PROPERTY totalAdmissoes
   PROPERTY totalDemissoes

   PROPERTY totalTurnOverGeral
   PROPERTY totalTurnOverDemissoes

   METHOD New( oParent )

   METHOD CREATE()

   METHOD Body()
   METHOD Script()

END CLASS

//------------------------------------------------------------------------------

METHOD New( oParent ) CLASS zDashBoardTurnOver

   HB_Default(@::monthsData,{'JAN','FEV','MAR','ABR','MAI','JUN','JUL','AGO','SET','OUT','NOV','DEZ'})
   HB_Default(@::colorPaletteData,{'#00D8B6','#008FFB','#FEB019','#FF4560','#775DD0','#01BFD6','#5564BE','#F7A600','#EDCD12','#F74F58','#45DD98','#012444'})

return ::Super:New( oParent )

//------------------------------------------------------------------------------

METHOD CREATE() CLASS zDashBoardTurnOver

   WITH OBJECT ::oHtml

      AAdd( :aScript, ::Script() )

      AAdd( :aHeadLinks, '<meta http-equiv="X-UA-Compatible" content="IE=edge"/>' )
      AAdd( :aHeadLinks, '<meta name="viewport" content="width=device-width, initial-scale=1"/>' )

      AAdd( :aHeadLinks, '<link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.2.1/css/bootstrap.min.css"/>' )
      AAdd( :aHeadLinks, '<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/font-awesome/4.7.0/css/font-awesome.min.css"/>' )
      AAdd( :aHeadLinks, '<link href="https://fonts.googleapis.com/css?family=Titillium+Web:400,600,700" rel="stylesheet"/>' )

      AAdd( :aHeadLinks, '<script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.2.1/jquery.slim.min.js"></script>' )
      AAdd( :aHeadLinks, '<script src="https://cdn.jsdelivr.net/npm/apexcharts"></script>' )

      :cCSS += cDashBoardTurnOverCSS()

	END

   ::Super:oParent:AddHTML( ::Body() )

return( ::Super:Create() )

METHOD Body() CLASS zDashBoardTurnOver

   local cHTMLBody

   TEXT INTO cHTMLBody
    <div id="zDashBoardTurnOver" align="center" style="text-align:center;width:100%">
      <div class="row sparkboxes">
        <div class="col-md-3">
          <div class="box">
            <div id="totalfuncIMesData_spark0"></div>
          </div>
        </div>
        <div class="col-md-3">
          <div class="box">
            <div id="admissoesData_spark1"></div>
          </div>
        </div>
        <div class="col-md-3">
          <div class="box">
            <div id="demissoesData_spark2"></div>
          </div>
        </div>
        <div class="col-md-3">
          <div class="box">
            <div id="totalfuncFMesData_spark3"></div>
          </div>
        </div>
      </div>
      <div class="mt-3 mb-3 d-fixed">
      </div>
      <div class="row sparkboxes">
        <div class="col-md-6">
          <div class="box">
            <div id="turnOverGeralData_spark1"></div>
          </div>
        </div>
        <div class="col-md-6">
          <div class="box">
            <div id="turnOverDemissoesData_spark2"></div>
          </div>
        </div>
      </div>
      <div class="row mt-5 mb-4">
        <div class="col-md-6">
          <div class="box">
            <div id="bar"></div>
          </div>
        </div>
        <div class="col-md-6">
          <div class="box">
            <div id="donut"></div>
          </div>
        </div>
      </div>
   </div>
   ENDTEXT

   cHTMLBody:=StrTran(cHTMLBody,"zDashBoardTurnOver","zDashBoardTurnOver"+::cID)

return( cHTMLBody )

METHOD Script() CLASS zDashBoardTurnOver

   local cHTMLScript

   TEXT INTO cHTMLScript
     Apex.grid = {
       padding: {
         right: 0,
         left: 0
       }
     }

     Apex.dataLabels = {
       enabled: false
     }

     var transfEntData = @transfEntData@;
     var transfSaiData = @transfSaiData@;
     var admissoesData = @admissoesData@;
     var demissoesData = @demissoesData@;
     var totalfuncIMesData = @totalfuncIMesData@;
     var totalfuncFMesData = @totalfuncFMesData@;

     var turnOverGeralData = @turnOverGeralData@;
     var turnOverDemissoesData = @turnOverDemissoesData@;

     var monthsData = @monthsData@;

     var colorPaletteData = @colorPaletteData@;

     var totalfuncIMesData_spark0 = {
       chart: {
         id: 'totalfuncIMesData_sparkline0',
         group: 'sparklines',
         type: 'area',
         height: 160,
         sparkline: {
           enabled: true
         },
       },
       stroke: {
         curve: 'straight'
       },
       fill: {
         opacity: 1,
       },
       series: [{
         name: 'Funcionários',
         data: totalfuncIMesData
       }],
       labels: [...Array(monthsData.length).keys()].map(n => monthsData[n]),
       xaxis: {
         type: 'text',
       },
       yaxis: {
         min: 0
       },
       colors: ['#00D8B6'],
       title: {
         text: '@totalFuncIPer@ Funcionários :: '+monthsData[0]+'/@yearDashBoard@',
         offsetX: 30,
         style: {
           fontSize: '12px',
           cssClass: 'apexcharts-yaxis-title'
         }
       },
       subtitle: {
         text: '',
         offsetX: 30,
         style: {
           fontSize: '14px',
           cssClass: 'apexcharts-yaxis-title'
         }
       }
     }

     var admissoesData_spark1 = {
       chart: {
         id: 'admissoesData_sparkline1',
         group: 'sparklines',
         type: 'area',
         height: 160,
         sparkline: {
           enabled: true
         },
       },
       stroke: {
         curve: 'straight'
       },
       fill: {
         opacity: 1,
       },
       series: [{
         name: 'Admissões',
         data: admissoesData
       }],
       labels: [...Array(monthsData.length).keys()].map(n => monthsData[n]),
       xaxis: {
         type: 'text',
       },
       yaxis: {
         min: 0
       },
       colors: ['darkgreen'],
       title: {
         text: '(+) @totalAdmissoes@ Admissões',
         offsetX: 30,
         style: {
           fontSize: '12px',
           cssClass: 'apexcharts-yaxis-title'
         }
       },
       subtitle: {
         text: '',
         offsetX: 30,
         style: {
           fontSize: '14px',
           cssClass: 'apexcharts-yaxis-title'
         }
       }
     }

     var demissoesData_spark2 = {
       chart: {
         id: 'demissoesData_sparkline2',
         group: 'sparklines',
         type: 'area',
         height: 160,
         sparkline: {
           enabled: true
         },
       },
       stroke: {
         curve: 'straight'
       },
       fill: {
         opacity: 1,
       },
       series: [{
         name: 'Demissões',
         data: demissoesData
       }],
       labels: [...Array(monthsData.length).keys()].map(n => monthsData[n]),
       xaxis: {
         type: 'text',
       },
       yaxis: {
         min: 0
       },
       colors: ['darkred'],
       title: {
         text: '(-) @totalDemissoes@ Demissões',
         offsetX: 30,
         style: {
           fontSize: '12px',
           cssClass: 'apexcharts-yaxis-title'
         }
       },
       subtitle: {
         text: '',
         offsetX: 30,
         style: {
           fontSize: '14px',
           cssClass: 'apexcharts-yaxis-title'
         }
       }
     }

     var totalfuncFMesData_spark3 = {
       chart: {
         id: 'totalfuncFMesData_sparkline3',
         group: 'sparklines',
         type: 'area',
         height: 160,
         sparkline: {
           enabled: true
         },
       },
       stroke: {
         curve: 'straight'
       },
       fill: {
         opacity: 1,
       },
       series: [{
         name: 'Funcionários',
         data: totalfuncFMesData
       }],
       labels: [...Array(monthsData.length).keys()].map(n => monthsData[n]),
       xaxis: {
         type: 'text',
       },
       yaxis: {
         min: 0
       },
       colors: ['#012444'],
       title: {
         text: '@totalFuncFPer@ Funcionários :: '+monthsData[totalfuncFMesData.length-1]+'/@yearDashBoard@',
         offsetX: 30,
         style: {
           fontSize: '12px',
           cssClass: 'apexcharts-yaxis-title'
         }
       },
       subtitle: {
         text: '',
         offsetX: 30,
         style: {
           fontSize: '14px',
           cssClass: 'apexcharts-yaxis-title'
         }
       }
     }

     new ApexCharts(document.querySelector("#totalfuncIMesData_spark0"), totalfuncIMesData_spark0).render();
     new ApexCharts(document.querySelector("#admissoesData_spark1"), admissoesData_spark1).render();
     new ApexCharts(document.querySelector("#demissoesData_spark2"), demissoesData_spark2).render();
     new ApexCharts(document.querySelector("#totalfuncFMesData_spark3"), totalfuncFMesData_spark3).render();

     var turnOverGeralData_spark1 = {
       chart: {
         id: 'turnOverGeralData_sparkline1',
         group: 'turnOver_sparklines',
         type: 'area',
         height: 160,
         sparkline: {
           enabled: true
         },
       },
       stroke: {
         curve: 'straight'
       },
       fill: {
         opacity: 1,
       },
       series: [{
         name: '(%) TurnOver Geral :: @yearDashBoard@',
         data: turnOverGeralData
       }],
       labels: [...Array(monthsData.length).keys()].map(n => monthsData[n]),
       xaxis: {
         type: 'text',
       },
       yaxis: {
         min: 0
       },
       colors: ['#5564BE'],
       title: {
         text: '@totalTurnOverGeral@ (%) TurnOver Geral :: @yearDashBoard@',
         offsetX: 30,
         style: {
           fontSize: '12px',
           cssClass: 'apexcharts-yaxis-title'
         }
       },
       subtitle: {
         text: '',
         offsetX: 30,
         style: {
           fontSize: '14px',
           cssClass: 'apexcharts-yaxis-title'
         }
       }
     }

     var turnOverDemissoesData_spark2 = {
       chart: {
         id: 'turnOver_sparkline2',
         group: 'turnOver_sparklines',
         type: 'area',
         height: 160,
         sparkline: {
           enabled: true
         },
       },
       stroke: {
         curve: 'straight'
       },
       fill: {
         opacity: 1,
       },
       series: [{
         name: '(%) TurnOver Demissões :: @yearDashBoard@',
         data: turnOverDemissoesData
       }],
       labels: [...Array(monthsData.length).keys()].map(n => monthsData[n]),
       xaxis: {
         type: 'text',
       },
       yaxis: {
         min: 0
       },
       colors: ['#5564BE'],
       title: {
         text: '@totalTurnOverDemissoes@ (%) TurnOver Demissões :: @yearDashBoard@',
         offsetX: 30,
         style: {
           fontSize: '12px',
           cssClass: 'apexcharts-yaxis-title'
         }
       },
       subtitle: {
         text: '',
         offsetX: 30,
         style: {
           fontSize: '14px',
           cssClass: 'apexcharts-yaxis-title'
         }
       }
     }

     new ApexCharts(document.querySelector("#turnOverGeralData_spark1"), turnOverGeralData_spark1).render();
     new ApexCharts(document.querySelector("#turnOverDemissoesData_spark2"), turnOverDemissoesData_spark2).render();

     var optionsBar = {
       chart: {
         type: 'bar',
         height: 400,
         width: '100%',
         stacked: false,
       },
       plotOptions: {
         bar: {
           columnWidth: '45%',
         }
       },
       colors: colorPaletteData,
       series: [
           {
             name: "Admissões",
             data: admissoesData,
           },
           {
             name: "Demissões",
             data: demissoesData,
           },
           {
             name: "Transf. Entrada",
             data: transfEntData,
           },
           {
             name: "Transf. Saida",
             data: transfSaiData,
           }
       ],
       labels: [...Array(monthsData.length).keys()].map(n => monthsData[n]),
       xaxis: {
         labels: {
           show: false
         },
         axisBorder: {
           show: false
         },
         axisTicks: {
           show: false
         },
       },
       yaxis: {
         axisBorder: {
           show: false
         },
         axisTicks: {
           show: false
         },
         labels: {
           style: {
             colors: '#78909c'
           }
         }
       },
       title: {
         text: 'Movimentações :: @yearDashBoard@',
         align: 'left',
         style: {
           fontSize: '14px'
         }
       }

     }

     var chartBar = new ApexCharts(document.querySelector('#bar'), optionsBar);
     chartBar.render();

     var optionDonut = {
       chart: {
           type: 'donut',
           width: '100%',
           height: 400
       },
       dataLabels: {
         enabled: false,
       },
       plotOptions: {
         pie: {
           customScale: 0.8,
           donut: {
             size: '75%',
           },
           offsetY: 20,
         },
         stroke: {
           colors: undefined
         }
       },
       colors: colorPaletteData,
       title: {
         text: 'Número de Funcionários por Mês :: @yearDashBoard@',
         style: {
           fontSize: '14px'
         }
       },
       series: totalfuncFMesData,
       labels: [...Array(monthsData.length).keys()].map(n => monthsData[n]),
       legend: {
         position: 'left',
         offsetY: 80
       }
     }

     var donut = new ApexCharts(
       document.querySelector("#donut"),
       optionDonut
     )
     donut.render();

     // on smaller screen, change the legends position for donut
     var mobileDonut = function() {
       if($(window).width() < 768) {
         donut.updateOptions({
           plotOptions: {
             pie: {
               offsetY: -15,
             }
           },
           legend: {
             position: 'bottom'
           }
         }, false, false)
       }
       else {
         donut.updateOptions({
           plotOptions: {
             pie: {
               offsetY: 20,
             }
           },
           legend: {
             position: 'left'
           }
         }, false, false)
       }
     }

     $(window).resize(function() {
       mobileDonut()
     });
   ENDTEXT

   cHTMLScript:=strTran(cHTMLScript,"@yearDashBoard@",::yearDashBoard)

   cHTMLScript:=strTran(cHTMLScript,"@monthsData@",HB_JsonEncode(::monthsData))

   cHTMLScript:=strTran(cHTMLScript,"@colorPaletteData@",HB_JsonEncode(::colorPaletteData))

   cHTMLScript:=strTran(cHTMLScript,"@transfEntData@",HB_JsonEncode(::transfEntData))
   cHTMLScript:=strTran(cHTMLScript,"@transfSaiData@",HB_JsonEncode(::transfSaiData))
   cHTMLScript:=strTran(cHTMLScript,"@admissoesData@",HB_JsonEncode(::admissoesData))
   cHTMLScript:=strTran(cHTMLScript,"@demissoesData@",HB_JsonEncode(::demissoesData))
   cHTMLScript:=strTran(cHTMLScript,"@totalfuncIMesData@",HB_JsonEncode(::totalfuncIMesData))
   cHTMLScript:=strTran(cHTMLScript,"@totalfuncFMesData@",HB_JsonEncode(::totalfuncFMesData))

   cHTMLScript:=strTran(cHTMLScript,"@turnOverGeralData@",HB_JsonEncode(::turnOverGeralData))
   cHTMLScript:=strTran(cHTMLScript,"@turnOverDemissoesData@",HB_JsonEncode(::turnOverDemissoesData))

   cHTMLScript:=strTran(cHTMLScript,"@totalFuncIMes@",HB_JsonEncode(::totalFuncIMes))

   cHTMLScript:=strTran(cHTMLScript,"@totalFuncIPer@",HB_JsonEncode(::totalFuncIPer))
   cHTMLScript:=strTran(cHTMLScript,"@totalFuncFPer@",HB_JsonEncode(::totalFuncFPer))

   cHTMLScript:=strTran(cHTMLScript,"@totalAdmissoes@",HB_JsonEncode(::totalAdmissoes))
   cHTMLScript:=strTran(cHTMLScript,"@totalDemissoes@",HB_JsonEncode(::totalDemissoes))

   cHTMLScript:=strTran(cHTMLScript,"@totalTurnOverGeral@",HB_JsonEncode(::totalTurnOverGeral))
   cHTMLScript:=strTran(cHTMLScript,"@totalTurnOverDemissoes@",HB_JsonEncode(::totalTurnOverDemissoes))

return( cHTMLScript )

static function cDashBoardTurnOverCSS()

   local cCSS

   TEXT INTO cCSS
body {
   background-color: #eff4f7;
   color: #777;
   font-family:  Helvetica, sans-serif ,'Titillium Web', Arial;
}

h1, h2, h3, h4, h5, h6, strong {
   font-weight: 600;
}

.content-area {
   max-width: 1070px;
   margin: 0 auto;
}

#topnav {
   background: #37474f;
   height: 60px;
   display: flex;
   flex-direction: row;
   align-items: center;
   font-size: 14px;
}

.admin-menu {
   color: #fff;
   font-size: 16px;
   display: flex;
   justify-content: center;
   align-items: center;
   padding: 15px;
   flex: 0.05 0 0;
}

.logo {
   display: flex;
   flex-direction: row;
   align-items: center;
   flex: 1 0 0;
}

.logo-t {
   width: 32px;
   height: 32px;
   border: 2px solid #26c6da;
   text-align: center;
   line-height: 28px;
   border-radius: 50%;
   margin-right: 15px;
   margin-left: 5px;
   padding-left: 3px;
}

.search-bar {
   flex: 2 0 0;
   align-items: center;
   justify-content: space-between;
   background: #232e34;
   overflow: hidden;
   display: flex;
   height: 36px;
   border-radius: 35px;
   color: rgba(255,255,255,0.5);
}

.search-bar-dropdown {
   flex: 1 0 0;
   height: 40px;
   line-height: 40px;
   padding: 0 18px;
   margin-right: 15px;
   background: #2c393f;
}
.search-bar-input {
   flex: 2 0 0;
   display: flex;
   justify-content: flex-end;
   padding: 0 18px;
   line-height: 40px;
   align-items: center;
}

.search-bar-input input[type="text"] {
   width: 100%;
   background: transparent;
   border: 0;
   color: rgba(255,255,255,0.5);
}
.search-bar-input input:focus{
   outline: none;
}

.box.banana_map {
   color: #fff;
   background: #eff4f7;
   padding: 0;
   box-shadow: none;
}
.box.banana_map .title {
   padding-top: 40px;
   padding-left: 25px;
   font-size: 16px;
}
.box.banana_map .subtitle {
   font-weight: 700;
   padding-top: 10px;
   padding-left: 25px;
   font-size: 22px;
}

.box {
   max-height: 444px;
}

.box .banana {
   min-height: 404px;
   background-image: url('img/banana.png');
   background-size: cover;
}
.box .map {
   min-height: 404px;
   background-image: url('img/map.png');
   background-size: cover;
}
.box .cog-icon {
   cursor: pointer;
   position: absolute;
   right: 55px;
   top: 25px;
   z-index: 10;
}

@media screen and (max-width:760px) {
   #topnav { flex-wrap: wrap; }
   .admin-menu { flex-basis: 20%; }
   .logo { justify-content: flex-end; padding-right: 10px; }
   .logo { flex-basis: 80%; }
   .topnav-rightmenu, .search-bar { display: none; }
}

.box {
   box-shadow: 0px 1px 22px -12px #607D8B;
   background-color: #fff;
   padding: 25px 35px 25px 30px;
}

#apexcharts-canvas {
   position: relative;
}

#apexcharts-canvas:after {
   content: "";
   position: absolute;
   left: 0;
   right: 58%;
   top: 0;
   bottom: 0;
   background: #24bdd3;
   opacity: 0.65;
}

#apexcharts-title-text {
   font-weight: 600 !important;
}

#apexcharts-subtitle-text {
   font-weight: 700 !important;
}

.chart-title h5 {
   font-size: 18px;
   color: rgba(51,51,51,1);
   margin-bottom: 38px;
}

@media screen and (max-width:760px) {
   .box {
     padding: 25px 0;
   }
}

.sparkboxes .box {
   padding: 3px 0 0 0;
   position: relative;
}

#totalfuncIMesData_spark0, #admissoesData_spark1, #demissoesData_spark2, #totalfuncFMesData_spark3, #turnOverGeralData_spark1, #turnOverDemissoesData_spark2 {
   position: relative;
   padding-top: 15px;
}

/* overrides */
.sparkboxes #apexcharts-subtitle-text { fill: #8799a2 !important; }

.spinner-border {
   display: none;
}
   ENDTEXT

   return(cCSS)