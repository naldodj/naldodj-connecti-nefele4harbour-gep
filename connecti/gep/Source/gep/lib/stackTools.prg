#include "hbclass.ch"

CLASS stacktools FROM hbClass

   METHOD StackCount( cStack,nMaxCount ) as numeric
   METHOD GetCallStack( nStart ) as array
   METHOD IsInCallStack( cStack ) as logical
   METHOD IsInStackCall( aStack,lExitFound ) as logical

END CLASS

METHOD StackCount( cStack,nMaxCount ) CLASS stacktools

   local cPName        as character

   local lStack  as logical
   local lCount  as logical

   local nStack  as numeric
   local nStackCount as numeric

   hb_default( @cStack,"" )
   hb_default( @nMaxCount,0 )

   cStack := Upper( AllTrim( cStack ) )
   nStack := -1
   lStack := .T.
   lCount := ( !Empty( nMaxCount ) )
   nStackCount := 0
   WHILE ( lStack )
      cPName := ProcName( ++nStack )
      lStack := ( !Empty( cPName ) )
      IF ( !lStack )
         EXIT
      ENDIF
      IF ( cStack == cPName )
         nStackCount++
         IF ( lCount )
            IF ( nStackCount >= nMaxCount )
               lStack := .F.
               EXIT
            ENDIF
         ENDIF
      ENDIF
   END WHILE

return( nStackCount )

METHOD IsInCallStack( cStack ) CLASS stacktools

   local lIsInCallStack as logical

   hb_default( cStack,"" )
   lIsInCallStack := IsInCallStack( cStack )

return( lIsInCallStack )

STATIC FUNCTION IsInCallStack( cIsInCallStack as character,cStackExit as character )

   local IsInCallStack := .F.

   local cCallStack    := ""
   local nCallStack    := 0

   hb_default( @cIsInCallStack,"" )
   hb_default( @cStackExit,"" )

   cIsInCallStack := Upper( AllTrim( cIsInCallStack ) )
   cStackExit := Upper( AllTrim( cStackExit ) )

   WHILE ( ;
         !( ( cCallStack := ProcName(++nCallStack ) ) $ cStackExit );
         .AND. ;
         !Empty( cCallStack );
         )
      IF ( IsInCallStack := ( cCallStack == cIsInCallStack ) )
         EXIT
      ENDIF
   END WHILE

return( IsInCallStack )

METHOD IsInStackCall( aStack,lExitFound ) CLASS stacktools

   local cStack            as character
   local lIsInStackCall    as logical
   local nStack            as numeric
   local nStacks           as numeric

   hb_default( @aStack,Array( 0 ) )
   hb_default( @lExitFound,.F. )

   nStacks := Len( aStack )
   FOR nStack := 1 TO nStacks
      cStack := aStack[ nStack ]
      lIsInStackCall := stacktools():IsInCallStack( cStack )
      if (lIsInStackCall.and.lExitFound)
         EXIT
      elseIF ( !lIsInStackCall )
         EXIT
      ENDIF
   NEXT nStack

   HB_Default(@lIsInStackCall,.F.)

return( lIsInStackCall )

METHOD GetCallStack( nStart as numeric ) CLASS stacktools

   local aCallStack as array

   hb_default( @nStart,0 )
   aCallStack := GetCallStack( @nStart )

return( aCallStack )

static function GetCallStack( nStart as numeric )

   local aCallStack    as array

   local cCallStack    as character

   local nCallStack    as numeric

   aCallStack := Array( 0 )

   hb_default( @nStart,0 )

   nCallStack := nStart
   while ( cCallStack := ProcName( ++nCallStack ),( !(Empty(cCallStack ) ) ) )
      aAdd  ( aCallStack,cCallStack )
   end while

return( aCallStack )
