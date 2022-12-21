#include "Xailer.ch"
#include "Nefele.ch"

CLASS zwebAppManifest FROM wJsonClass

   PROPERTY cClassId INIT "appmanifest"
   PROPERTY cClass   INIT "webappmanifest"

   METHOD New( oParent )
   METHOD CREATE

END CLASS

METHOD New( oParent ) CLASS zwebAppManifest
return( ::Super:New( oParent ) )

METHOD CREATE CLASS zwebAppManifest
   WITH OBJECT ::oHtml

   END

return( ::Super:Create() )

