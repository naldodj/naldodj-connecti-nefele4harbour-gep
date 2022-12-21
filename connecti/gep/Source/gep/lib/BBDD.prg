/*
 * Proyecto: Cartahelamore
 * Fichero: BBDD.prg
 * Descripcion:
 * Autor:
 * Fecha: 18/05/2021
 */

#include "Xailer.ch"
#include "Nefele.ch"
#include "LangCGI.ch"

FUNCTION GetUsers()
   local aData := {}
   local cData

   if !File( AppData:PathSystem + "users.json" )
      aData := {{"user" => "admin","pass" => "admin","name" => "Administrador","adminuser" => .T.,"activo" => .T.}}
      HB_MemoWrit( AppData:PathSystem + "users.json",HB_JsonEncode( aData ) )
   ELSE
      cData := HB_MemoRead( AppData:PathSystem + "users.json" )
      IF !Empty( cData )
         HB_JsonDecode( cData,@aData )
      ENDIF
   ENDIF

RETURN aData

//------------------------------------------------------------------------------

FUNCTION GetUser( xUser )
   local aData := GetUsers()
   local hUser := {=>},nIdx

   IF ValType( xUser ) == "N"
      if Len( aData ) >= xUser
         hUser := aData[xUser]
      ENDIF
   ELSe
      IF (nIdx := HB_Ascan( aData,{|x| x["user"]==xUser} )) <> 0
         hUser := aData[nIdx]
      ENDIF
   ENDIF
RETURN hUser

FUNCTION GetEmp(cEmp)

   local aEmp
   local aData := GetSM0()
   local nAt

   nAt:=aScan(aData,{|x|x[1]==cEmp})
   IF (nAt>0)
      aEmp := aData[nAt]
   ENDIF

   RETURN(aEmp)

//------------------------------------------------------------------------------

FUNCTION CheckUserLogin( cUser,cPass )
RETURN HB_Ascan( GetUsers(),{|x| x["user"]==cUser .AND. x["pass"]==cPass .AND. x["activo"]} )

//------------------------------------------------------------------------------

FUNCTION CheckUser( cUser )
RETURN HB_Ascan( GetUsers(),{|x| x["user"]==cUser} )

//------------------------------------------------------------------------------

FUNCTION SetUser( nId,hUser )
   local aData := GetUsers()

   IF nId == 0
      aAdd( aData,hUser )
   ELSE
      aData[nId] := hUser
   ENDIF

RETURN HB_MemoWrit( AppData:PathSystem + "users.json",HB_JsonEncode( aData ) )

//------------------------------------------------------------------------------

FUNCTION CmbMeses()
RETURN  {{"01",Lang(LNG_ENERO)},{"02",Lang(LNG_FEBRERO)},{"03",Lang(LNG_MARZO)},;
         {"04",Lang(LNG_ABRIL)},{"05",Lang(LNG_MAYO)},{"06",Lang(LNG_JUNIO)},;
         {"07",Lang(LNG_JULIO)},{"08",Lang(LNG_AGOSTO)},{"09",Lang(LNG_SEPTIEMBRE)},;
         {"10",Lang(LNG_OCTUBRE)},{"11",Lang(LNG_NOVIEMBRE)},{"12",Lang(LNG_DICIEMBRE)}}

//------------------------------------------------------------------------------

FUNCTION CmbLastYears( nYears )
   local nYear,aYears := {}
   FOR nYear := Year( Date() ) TO Year(Date()) - ( nYears -1 ) STEP -1
      aAdd( aYears,ToString( nYear ) )
   NEXT
RETURN aYears

function __AutoID()

   local cAutoID

   cAutoID:="id"
   cAutoID+=DToS(Date())
   cAutoID+=StrTran(Time(),":","")
   cAutoID+=HB_NToS(HB_Random())
   cAutoID+=HB_NToS(HB_MilliSeconds())

   cAutoID:=StrTran(cAutoID,".","")

   return(cAutoID)