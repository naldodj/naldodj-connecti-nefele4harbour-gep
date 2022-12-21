#include "Xailer.ch"
#include "Nefele.ch"

function HistoryReplaceState(lRemoveUrlParams)

    local cJS

    HB_Default(@lRemoveUrlParams,.T.)

    TEXT INTO cJS
<script>
    if ( window.history.replaceState ) {
        window.history.replaceState( null,null,window.location.href );
        var lRemoveUrlParams = new Boolean(@lRemoveUrlParams@);
        if ((lRemoveUrlParams)&(lRemoveUrlParams==@lRemoveUrlParams@)) {
            if(window.location.href.indexOf("?") > -1) {
                window.history.replaceState({},document.title,window.location.replace(window.location.pathname) );
            };
        };
    }
</script>
    ENDTEXT

    cJS:=StrTran(cJS,"@lRemoveUrlParams@",HB_JsonEncode(lRemoveUrlParams))

    return(cJS)

function HistoryNoRaplaceParams(cHTML)
    HB_Default(@cHTML,"")
    return(StrTran(cHTML,"(lRemoveUrlParams==true)","(lRemoveUrlParams==false"))

function localStorageClear()

local cJS

TEXT INTO cJS
<script>
   window.sessionStorage.clear();
   window.localStorage.clear();
</script>
ENDTEXT

return(cJS)