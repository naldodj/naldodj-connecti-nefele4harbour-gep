#include "Xailer.ch"
#include "Nefele.ch"

class wRTabs from WTabs
   method Create()
end class

method Create() class wRTabs
   WITH OBJECT ::oHtml
      :cCSS+=CSS()
	END
return(::Super:Create())

static function CSS()
   local cCSS
   TEXT INTO cCSS
h10 {font-size: 12px; font-weight: lighter; font-family: -apple-system,BlinkMacSystemFont,'Segoe UI',Roboto,Oxygen-Sans,Ubuntu,Cantarell,'Helvetica Neue',sans-serif; !important;}
h12 {font-size: 14px; font-weight: bold; font-family: -apple-system,BlinkMacSystemFont,'Segoe UI',Roboto,Oxygen-Sans,Ubuntu,Cantarell,'Helvetica Neue',sans-serif; !important;}

.tabs .tab a:hover, .tabs .tab a.active { background-color: transparent !important; color: #45DD98 !important;}
.tabs .tab a { color: #45DD98 !important;}
.tabs .indicator { background-color: #45DD98 !important;}
   ENDTEXT
   return(cCSS)