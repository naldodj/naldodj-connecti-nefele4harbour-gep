/*
 * Proyecto: GEP
 * Fichero: GEPFunctions.prg
 * Descripcion:
 * Autor:
 * Fecha: 18/05/2021
 */

#include "Xailer.ch"
#include "Nefele.ch"
#include "LangCGI.ch"

function __base64Encode(cEncode)
return(hb_StrReplace(hb_base64Encode(cEncode),"+/=","-_"))

function __base64Decode(cDecode)
return(hb_base64Decode(hb_StrReplace(cDecode,"-_","+/")))