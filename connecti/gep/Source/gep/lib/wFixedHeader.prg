#include "Xailer.ch"
#include "Nefele.ch"
function FixedHeader(cTable)

    local cJS

    TEXT INTO cJS

    ENDTEXT

    cJS:=strTran(cJS,"@cTable@",cTable)

    return(cJS)