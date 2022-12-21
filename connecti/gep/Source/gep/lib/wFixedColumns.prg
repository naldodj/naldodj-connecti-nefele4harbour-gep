#include "Xailer.ch"
#include "Nefele.ch"
function fixedColumns(cTable,cfixedColumns)

    local cJS

    TEXT INTO cJS

var fc=new $.fn.dataTable.FixedColumns( table@cTable@,{
    "iLeftColumns": @cfixedColumns@
});

$('#@cTable@').DataTable( {
    fixedColumns: true
} );

$('#@cTable@').DataTable( {
    fixedColumns: {
        left: @cfixedColumns@
    }
} );


    ENDTEXT

    cJS:=strTran(cJS,"@cTable@",cTable)
    cJS:=StrTran(cJS,"@cfixedColumns@",cfixedColumns)

    return(cJS)