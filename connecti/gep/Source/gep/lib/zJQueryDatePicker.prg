/*
 * Proyecto: GEP
 * Fichero: zJQueryDatePicker.prg
 * Descripción:
 * Autor:
 * Fecha: 28/10/2021
 */

#include "Xailer.ch"
#include "Nefele.ch"

CLASS zJQueryDatePicker FROM wEdit

   PROPERTY cClassId INIT "jqdp"
   PROPERTY cRegional

   PROPERTY cClass   INIT "datepicker"

   PROPERTY hOptions          INIT {=>}
   PROPERTY hRegionalOptions  INIT {=>}

   METHOD New( oParent , cID )

   METHOD CREATE()

   METHOD Script()

   METHOD setOptions(hOptions)

   METHOD setRegional(cRegional)
   METHOD setRegionalOptions(hRegionalOptions)

END CLASS

//------------------------------------------------------------------------------

METHOD New( oParent , cID ) CLASS zJQueryDatePicker

   IF !HB_IsNIL( cID )
      ::cID       := cID
   ENDIF

   ::hOptions  := DefaultOptions( )

   ::setRegional()

return ::Super:New( oParent )

//------------------------------------------------------------------------------

METHOD CREATE() CLASS zJQueryDatePicker

   ::hOptions["container"]:= "#" + ::cId

   WITH OBJECT ::oHtml

      AAdd( :aScript, ::Script() )

      AAdd( :aHeadLinks, '<!-- https://code.jquery.com/ -->' )
      AAdd( :aHeadLinks, '<script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.6.0/jquery.min.js" integrity="sha512-894YE6QWD5I59HgZOGReFYm4dnWc1Qt5NtvYSaNcOP+u1T9qYdvdihz0PPSiiqn/+/3e7Jo4EaG7TubfWGUrMQ==" crossorigin="anonymous" referrerpolicy="no-referrer"></script>' )
      AAdd( :aHeadLinks, '<!-- https://releases.jquery.com/ui/ -->' )
      AAdd( :aHeadLinks, '<script src="https://code.jquery.com/ui/1.13.1/jquery-ui.min.js" integrity="sha256-eTyxS0rkjpLEo16uXTS0uVCS4815lc40K2iVpWDvdSY=" crossorigin="anonymous"></script>' )
      AAdd( :aHeadLinks, '<!-- Themes => https://releases.jquery.com/ui/  -->' )
      AAdd( :aHeadLinks, '<link rel="stylesheet" href="https://code.jquery.com/ui/1.13.0/themes/base/jquery-ui.css">' )

      :cCSS += cDatePickerCSS()

      :cCSS += CRLF + "input#"+::cID+".hasDatepicker { color: black !important; background-color: transparent !important; font-size: 11px !Important; font-weight: 500; font-family: 'Helvetica Neue','Helvetica',-apple-system,BlinkMacSystemFont,'Segoe UI',Roboto,Oxygen-Sans,Ubuntu,Cantarell,'Helvetica Neue',sans-serif !important; height: 2rem !Important; margin-top: 10px !Important; margin-bottom: 10px !Important;}"
      :cCSS += CRLF + "input#"+::cID+".datepicker { color: black !important; background-color: transparent !important; font-size: 11px !Important; font-weight: 500; font-family: 'Helvetica Neue','Helvetica',-apple-system,BlinkMacSystemFont,'Segoe UI',Roboto,Oxygen-Sans,Ubuntu,Cantarell,'Helvetica Neue',sans-serif !important; height: 2rem !Important; margin-top: 10px !Important; margin-bottom: 10px !Important;}"
      :cCSS += CRLF + "select.ui-datepicker-year { display: inline-block !Important; line-height: 1.8em !Important; height: 1.85em !Important;}"
      :cCSS += CRLF + "select.ui-datepicker-month { display: inline-block !Important; line-height: 1.8em !Important; height: 1.85em !Important;}"

	END

return( ::Super:Create() )


//------------------------------------------------------------------------------

METHOD setOptions(hOptions) CLASS zJQueryDatePicker

   local cKey

   DEFAULT hOptions TO {=>}
   for each cKey in HB_HKeys(hOptions)
      ::hOptions[cKey]:=hOptions[cKey]
   next each

return Nil

//------------------------------------------------------------------------------

METHOD setRegionalOptions(hRegionalOptions) CLASS zJQueryDatePicker

   local cKey

   DEFAULT hRegionalOptions TO {=>}

   for each cKey in HB_HKeys(hRegionalOptions)
      ::hRegionalOptions[cKey]:=hRegionalOptions[cKey]
   next each

return Nil

//------------------------------------------------------------------------------

METHOD setRegional(cRegional) CLASS zJQueryDatePicker
   DEFAULT cRegional TO "pt-BR"

   ::cRegional:=cRegional

   SWITCh ::cRegional
      CASE "pt-BR"
         ::hRegionalOptions["closeText"]:="Fechar"
         ::hRegionalOptions["prevText"]:="&#x3c;Anterior"
         ::hRegionalOptions["nextText"]:="Pr&oacute;ximo&#x3e"
         ::hRegionalOptions["currentText"]:="Hoje"
         ::hRegionalOptions["monthNames"]:={"Janeiro","Fevereiro","Mar&ccedil;o","Abril","Maio","Junho","Julho","Agosto","Setembro","Outubro","Novembro","Dezembro"}
         ::hRegionalOptions["monthNamesShort"]:={"Jan","Fev","Mar","Abr","Mai","Jun","Jul","Ago","Set","Out","Nov","Dez"}
         ::hRegionalOptions["dayNames"]:={"Domingo","Segunda-feira","Ter&ccedil;a-feira","Quarta-feira","Quinta-feira","Sexta-feira","Sabado"}
         ::hRegionalOptions["dayNamesShort"]:={"Dom","Seg","Ter","Qua","Qui","Sex","Sab"}
         ::hRegionalOptions["dayNamesMin"]:={"Dom","Seg","Ter","Qua","Qui","Sex","Sab"}
         ::hRegionalOptions["weekHeader"]:="Sm"
         ::hRegionalOptions["dateFormat"]:="dd/mm/yy"
         ::hRegionalOptions["firstDay"]:=0
         ::hRegionalOptions["isRTL"]:=.F.
         ::hRegionalOptions["showMonthAfterYear"]:=.F.
         ::hRegionalOptions["yearSuffix"]:=""
         EXIT
      OTHERWISE
         ::hRegionalOptions["closeText"]:="Aceptar"
         ::hRegionalOptions["prevText"]:="Anterior"
         ::hRegionalOptions["nextText"]:="Siguiente"
         ::hRegionalOptions["currentText"]:="Hoy"
         ::hRegionalOptions["monthNames"]:={"Enero","Febrero","Marzo","Abril","Mayo","Junio","Julio","Agosto","Septiembre","Octubre","Noviembre","Diciembre"}
         ::hRegionalOptions["monthNamesShort"]:={"Ene","Feb","Mar","Abr","May","Jun","Jul","Ago","Sep","Oct","Nov","Dic"}
         ::hRegionalOptions["dayNames"]:={"Domingo","Lunes","Martes","Miercoles","Jueves","Viernes","Sabado"}
         ::hRegionalOptions["dayNamesShort"]:={"Dom","Lun","Mar","Mie","Jue","Vie","Sab"}
         ::hRegionalOptions["dayNamesMin"]:={"Dom","Lun","Mar","Mie","Jue","Vie","Sab"}
         ::hRegionalOptions["weekHeader"]:="Sm"
         ::hRegionalOptions["dateFormat"]:="dd/mm/yy"
         ::hRegionalOptions["firstDay"]:=1
         ::hRegionalOptions["isRTL"]:=.F.
         ::hRegionalOptions["showMonthAfterYear"]:=.F.
         ::hRegionalOptions["yearSuffix"]:=""
         EXIT
   END SWITCH

RETURN Nil

//------------------------------------------------------------------------------


METHOD Script() CLASS zJQueryDatePicker

   local cHTMLScript
   local cDatePikerOptions
   local cDatePikerRegionalOptions

   static tabIndex:=-1

   TEXT INTO cHTMLScript
(function() {

      // Load the script
      const script= document.createElement("script");
      script.src='https://code.jquery.com/ui/1.13.0/jquery-ui.min.js';
      script.type='text/javascript';
      script.addEventListener('load', () => {

         var __$=$;
         var __pbjQAlias;

         function @cIDDatePicker@_datepicker(){

            var __jQAlias=jQuery.noConflict(true);
            __pbjQAlias=__jQAlias;

            var $=__jQAlias;

            var !datePikerOptions!=@datePikerOptions@;
            var !datePickerRegionalOptions!=@datePikerRegionalOptions@;

            try {
               __jQAlias(function($){
                       $.datepicker.regional["@datePikerRegional@"]=!datePickerRegionalOptions!;
                       $.datepicker.setDefaults($.datepicker.regional["@datePikerRegional@"]);
                       //Multiples datepicker class="datepicker"
                       $(".datepicker").datepicker(!datePikerOptions!);
                       $("#@cIDDatePicker@").focus(function(dateText, inst) {
                          $("#@cIDDatePicker@").attr("tabindex","@tabIndex@");
                          $("#@cIDDatePicker@").attr("name","@cIDDatePicker@");
                          $(".datepicker").datepicker(!datePikerOptions!);
                      });
                      $("#@cIDDatePicker@").blur();
               });
            } catch(error){
               console.log(error);
            }
         }

        try {
            @cIDDatePicker@_datepicker();
        } catch(error) {
            console.log(error);
        }

        $=__$;

      });

      document.head.appendChild(script);

})();
   ENDTEXT

   cHTMLScript:=strTran(cHTMLScript,"!datePikerOptions!",::cID)
   cHTMLScript:=strTran(cHTMLScript,"!datePickerRegionalOptions!",::cID+"_RegionalOptions")

   cDatePikerOptions:=HBHashToJSVar(::hOptions)
   cDatePikerRegionalOptions:=HBHashToJSVar(::hRegionalOptions)

   cHTMLScript:=strTran(cHTMLScript,"@datePikerOptions@",cDatePikerOptions)

   cHTMLScript:=strTran(cHTMLScript,"@datePikerRegional@",::cRegional)
   cHTMLScript:=strTran(cHTMLScript,"@datePikerRegionalOptions@",cDatePikerRegionalOptions)

   cHTMLScript:=strTran(cHTMLScript,"@cIDDatePicker@",::cID)

   cHTMLScript:=strTran(cHTMLScript,"@tabIndex@",HB_NToS(++tabIndex))

return cHtmlScript

//------------------------------------------------------------------------------

static function cDatePickerCSS()

   local cCSS

   TEXT INTO cCSS
.ui-datepicker-prev {
   background: #012444 !Important;
}

.ui-datepicker-next {
   background: #012444 !Important;
}

.ui-datepicker-current {
   display: none !important;
}

.ui-datepicker-calendar {
   display: none !important;
}

.ui-datepicker-title {
   position: relative !Important;
   padding: .2em 0 !Important;
}

.ui-widget-header  {
   background: #012444 !Important;
}

.ui-widget-header .ui-icon {
   background-color: #26a69a !Important;
}

.ui-datepicker .ui-datepicker-title select {
   font-size: 1em;
   margin: 1px 2px;
}

.ui-datepicker .ui-datepicker-buttonpane button {
   color: #fff !Important;
   background-color: #26a69a !Important;
   font-size: 12px !Important;
   font-weight: 500 !Important;
   font-family: 'Helvetica Neue','Helvetica',-apple-system,BlinkMacSystemFont,'Segoe UI',Roboto,Oxygen-Sans,Ubuntu,Cantarell,'Helvetica Neue',sans-serif !important;
}

   ENDTEXT

RETURN cCSS

//------------------------------------------------------------------------------

STATIC FUNCTION DefaultOptions()

   LOCAL hOptions := {=>}

   hOptions["format"]:="yymm"
   hOptions["todayHighlight"]:=.T.
   hOptions["yearRange"]:=Left(DToS(Date()),4)+":"+Left(DToS(Date()),4)
   hOptions["orientation"]:="bottom right"
   hOptions["autoclose"]:=.T.
   hOptions["container"]:=""
   hOptions["closeText"]:="Selecionar"
   hOptions["showButtonPanel"]:=.T.
   hOptions["changeMonth"]:=.T.
   hOptions["changeYear"]:=.T.
   hOptions["dateFormat"]:=hOptions["format"]

   TEXT INTO hOptions["onClose"]
function(dateText,inst) {
   try {
      __pbjQAlias(this).datepicker('setDate', new Date(inst.selectedYear,inst.selectedMonth,1));
   } catch(error) {
      console.log(error);
   }
}
   ENDTEXT

RETURN hOptions

//------------------------------------------------------------------------------

static function HBHashToJSVar(hData)

   local cKey
   local cJSVar

   local lHasFunction

   local xValue

   cJSVar:="{"
   for each cKey in HB_HKeys(hData)
      cJSVar+=cKey
      cJSVar+=" : "
      xValue:=hData[cKey]
      IF (ValType(xValue)=="C")
         lHasFunction:="function"$lower(xValue)
      ELSE
         lHasFunction:=.F.
      ENDIF
      IF (lHasFunction)
         cJSVar+=xValue
      ELSE
         cJSVar+=HB_JsonEncode(xValue)
      ENDIF
      cJSVar+=","
   next each
   IF (Right(cJSVar,1)==",")
      cJSVar:=SubStr(cJSVar,1,Len(cJSVar)-1)
   ENDIF
   cJSVar+="}"

   return(cJSVar)