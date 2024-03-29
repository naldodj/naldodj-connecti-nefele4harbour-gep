/*
 * Proyecto: GEP
 * Fichero: QueryTotvs.prg
 * Descricao:
 * Autor:
 * Fecha: 14/08/2021
 */

#include "hbcurl.ch"
#include "Xailer.ch"
#include "Nefele.ch"
#include "LangCGI.ch"
#include "directry.ch"

#xtranslate nfl_CreateObject => CreateObject

#define TIMEOUT_Resolve (15*1000)
#define TIMEOUT_Connect (15*1000)
#define TIMEOUT_Send    (15*1000)
#define TIMEOUT_Receive (15*1000)

#define ZGIP_ENABLE .F.

#define FIELDS_CACHE_ENABLE .T.

//------------------------------------------------------------------------------

FUNCTION QueryCodModel( cHost, cModel, cFilter, nItems, nPag, cParModel, lGZipEnabled )
RETURN( QueryTotvs( cHost,"codModel",nil,cModel,cFilter,nItems,nPag,cParModel,@lGZipEnabled ) )

//------------------------------------------------------------------------------

FUNCTION QueryCodAlias( cHost, cAlias, cFilter, nItems, nPag, cParModel, lGZipEnabled )
RETURN( QueryTotvs( cHost,"codAlias",cAlias,nil,cFilter,nItems,nPag,cParModel,@lGZipEnabled ) )

//------------------------------------------------------------------------------

FUNCTION QueryTotvs( cHost, cRest, cAlias, cModel, cFilter, nItems, nPag, cParModel, lGZipEnabled )

   LOCAL oOle, hItem
   LOCAL hDatos := { "status" => 0, "message" => "", "ok" => .F., "response" => { => } }
   LOCAL cAuth
   LOCAL cTenantId
   LOCAL cParameters
   LOCAL lServerXMLHTTP
   LOCAL nResponseCode := 0

   LOCAL uURLGet

   hb_default( @lGZipEnabled, ZGIP_ENABLE )

   AppData:cEmp := oCGI:GetUserData( "cEmp", AppData:cEmp )
   AppData:cAuth := oCGI:GetUserData( "cAuth", AppData:cAuth )
   AppData:tenantId := oCGI:GetUserData( "tenantId", AppData:tenantId )

   cAuth := AppData:cAuth
   cTenantId := AppData:tenantId

   DEFAULT nItems TO 100
   DEFAULT nPag   TO 1

   IF ( !HB_ISNIL( cRest ) )

      cHost += cRest

      cParameters := iif( cRest == "codAlias", "codAlias=" + cAlias, "" )
      cParameters += iif( cRest == "codModel", "codModel=" + cModel, "" )
      cParameters += "&PageNumber=" + Tostring( nPag )
      cParameters += "&RowspPage=" + Tostring( nItems )
      cParameters += iif( !HB_ISNIL( cFilter )  .AND. !Empty( cFilter ), "&Filter64=" + hb_base64Encode( cFilter ), "" )
      cParameters += iif( !HB_ISNIL( cParModel ) .AND. !Empty( cParModel ), "&parModel=" + cParModel, "" )
      cParameters += "&setUTF8=true"
      cParameters += "&setNoAccent=true"
      cParameters += "&setTrimSpace=true"

      cHost += "?"
      cHost += cParameters

      TRY
         uURLGet := cURLGet( cHost, cModel, @nResponseCode, cAuth, cTenantId, lGZipEnabled )
      END TRY

      /*
        Informational responses (100–199)
        Successful responses (200–299)
        Redirection messages (300–399)
        Client error responses (400–499)
        Server error responses (500–599)
        The status codes listed below are defined by RFC 9110.
      */
      IF ( ( nResponseCode >= 200 ) .AND. ( nResponseCode <= 299 ) )

         hDatos[ "status" ]  := nResponseCode

         hDatos[ "message" ] := "ok"
         hDatos[ "ok" ] := .T.

         hb_jsonDecode( IF( lGZipEnabled,hb_ZUncompress(uURLGet ),uURLGet ), @hDatos[ "response" ]  )

      ELSE

         //https://msdn.microsoft.com/es-es/library/ms535874(v=vs.85).aspx#methods
         TRY
            oOle := nfl_CreateObject( 'MSXML2.ServerXMLHTTP.6.0' )
            lServerXMLHTTP := .T.
         CATCH
            hb_MemoWrit( AppData:PathLog + ( DToS(Date() ) ) + "_" + StrTran( Time(),":","_" ) + "_" + hb_ntos( Seconds() ) + "_" + cModel + ".log", "MSXML2.ServerXMLHTTP.6.0:Indisponivel" )
            TRY
               oOle := nfl_CreateObject( 'MSXML2.XMLHTTP' )
            CATCH
               hb_MemoWrit( AppData:PathLog + ( DToS(Date() ) ) + "_" + StrTran( Time(),":","_" ) + "_" + hb_ntos( Seconds() ) + "_" + cModel + ".log", "MSXML2.XMLHTTP:Indisponivel" )
               TRY
                  oOle := nfl_CreateObject( 'Microsoft.XMLHTTP' )
               CATCH
                  hb_MemoWrit( AppData:PathLog + ( DToS(Date() ) ) + "_" + StrTran( Time(),":","_" ) + "_" + hb_ntos( Seconds() ) + "_" + cModel + ".log", "Microsoft.XMLHTTP:Indisponivel" )
               END TRY
            END TRY
         END TRY

         TRY

            hb_default( @lServerXMLHTTP, .F. )

            IF ( lServerXMLHTTP )
               oOle:setTimeouts( TIMEOUT_Resolve, TIMEOUT_Connect, TIMEOUT_Send, TIMEOUT_Receive )
            ENDIF

            oOle:Open( "GET", cHost, .F. )
            oOle:SetRequestHeader( "Content-Type", "application/json;charset=utf-8" )
            oOle:SetRequestHeader( "Authorization", AppData:cAuth )
            oOle:SetRequestHeader( "tenantId", cTenantId )

            IF ( lGZipEnabled )
               oOle:SetRequestHeader( "Accept-Encoding", "gzip,deflate" )
               oOle:SetRequestHeader( "Content-Encoding", "gzip" )
            ENDIF

            oOle:Send()

            hDatos[ "status" ]  := oOle:status
            hDatos[ "message" ] := oOle:statusText

            /*
              Informational responses (100–199)
              Successful responses (200–299)
              Redirection messages (300–399)
              Client error responses (400–499)
              Server error responses (500–599)
              The status codes listed below are defined by RFC 9110.
            */
            IF ( ( oOle:STATUS >= 200 ) .AND. ( oOle:STATUS <= 299 ) )
               hDatos[ "ok" ] := .T.
               hb_jsonDecode( IF( lGZipEnabled,hb_ZUncompress(oOle:ResponseText ),oOle:ResponseText ),  @hDatos[ "response" ]  )
            ELSE
               hb_MemoWrit( AppData:PathLog + ( DToS(Date() ) ) + "_" + StrTran( Time(),":","_" ) + "_" + hb_ntos( Seconds() ) + "_" + cModel + ".log", oOle:statusText + hb_osNewLine() + oOle:ResponseText + hb_osNewLine() + cHost )
            ENDIF
         CATCH
            hb_MemoWrit( AppData:PathLog + ( DToS(Date() ) ) + "_" + StrTran( Time(),":","_" ) + "_" + hb_ntos( Seconds() ) + "_" + cModel + ".log", "Unable to connect to " + cHost )
         END TRY

      ENDIF

   ELSE

      hb_MemoWrit( AppData:PathLog + ( DToS(Date() ) ) + "_" + StrTran( Time(),":","_" ) + "_" + hb_ntos( Seconds() ) + "_" + cModel + ".log", "Invalid rest parameter" )

   ENDIF

RETURN hDatos

STATIC FUNCTION cURLGet( cHost, cModel, nResponseCode, cAuth, cTenantId, lGZipEnabled )

   LOCAL aHeader

   LOCAL hCurl

   LOCAL nError

   LOCAL uValue

   hb_default( @lGZipEnabled, ZGIP_ENABLE )

   curl_global_init()

   TRY

      IF ( !Empty( hCurl := curl_easy_init() ) )

         aHeader := Array( 0 )
         AAdd( aHeader, "Content-Type: application/json;charset=utf-8" )
         IF ( !Empty( cAuth ) )
            AAdd( aHeader, "Authorization: " + cAuth )
         ENDIF
         IF ( !Empty( cTenantId ) )
            AAdd( aHeader, "tenantId: " + cTenantId )
         ENDIF

         IF ( lGZipEnabled )
            AAdd( aHeader, "Accept-Encoding: gzip,deflate" )
            AAdd( aHeader, "Content-Encoding: gzip" )
         ENDIF

         //If there's an authorization token, you attach it to the header like this:
         curl_easy_setopt( hCurl, HB_CURLOPT_HTTPHEADER, aHeader )

         //Set the URL:
         curl_easy_setopt( hCurl, HB_CURLOPT_URL, cHost )

         //Disabling the SSL peer verification (you can use it if you have no SSL certificate yet, but still want to test HTTPS)
         curl_easy_setopt( hCurl, HB_CURLOPT_FOLLOWLOCATION, .T. )
         curl_easy_setopt( hCurl, HB_CURLOPT_SSL_VERIFYPEER, .F. )
         curl_easy_setopt( hCurl, HB_CURLOPT_SSL_VERIFYHOST, .F. )

         curl_easy_setopt( hCurl, HB_CURLOPT_NOPROGRESS, .F. )
         curl_easy_setopt( hCurl, HB_CURLOPT_VERBOSE, .T. )

         //Setting the buffer
         curl_easy_setopt( hCurl, HB_CURLOPT_DL_BUFF_SETUP )

         //Setting the TimeOut
         curl_easy_setopt( hCurl, HB_CURLOPT_TIMEOUT, TIMEOUT_Resolve )
         curl_easy_setopt( hCurl, HB_CURLOPT_CONNECTTIMEOUT, TIMEOUT_Connect )

         //Sending the request and getting the response
         IF ( ( nError := curl_easy_perform(hCurl ) ) == HB_CURLE_OK )
            uValue := curl_easy_getinfo( hCurl, HB_CURLINFO_RESPONSE_CODE, @nError )
            IF ( nError == HB_CURLE_OK )
               uValue := hb_jsonEncode( uValue )
               nResponseCode := Val( uValue )
               IF ( ( nResponseCode >= 200 ) .AND. ( nResponseCode <= 299 ) )
                  uValue := cURL_easy_dl_buff_get( hCurl )
               ENDIF
            ELSE
               nResponseCode := 400
               hb_MemoWrit( AppData:PathLog + ( DToS(Date() ) ) + "_" + StrTran( Time(),":","_" ) + "_" + hb_ntos( Seconds() ) + "_" + cModel + ".log", ProcName() + ":curl_easy_perform: " + hb_ntos( nError ) + hb_eol() + cHost )
            ENDIF
         ELSE
            nResponseCode := 400
            hb_MemoWrit( AppData:PathLog + ( DToS(Date() ) ) + "_" + StrTran( Time(),":","_" ) + "_" + hb_ntos( Seconds() ) + "_" + cModel + ".log", ProcName() + ":curl_easy_perform: " + hb_ntos( nError ) + hb_eol() + cHost )
         ENDIF

      ELSE

         hb_MemoWrit( AppData:PathLog + ( DToS(Date() ) ) + "_" + StrTran( Time(),":","_" ) + "_" + hb_ntos( Seconds() ) + "_" + cModel + ".log", ProcName() + ": Indisponivel" + hb_eol() + cHost )

      ENDIF

   CATCH

      hb_MemoWrit( AppData:PathLog + ( DToS(Date() ) ) + "_" + StrTran( Time(),":","_" ) + "_" + hb_ntos( Seconds() ) + "_" + cModel + ".log", ProcName() + ":Indisponivel" )

   END TRY

   //Cleaning the curl instance
   curl_global_cleanup()

return( uValue )

FUNCTION readFieldDefFromIni( codModel )

   LOCAL aFieldDef
   LOCAL aFieldsDef := Array( 0 )

   LOCAL cIni
   LOCAL cField
   LOCAL cFieldKey
   LOCAL cFieldVal
   LOCAL cFieldName
   LOCAL cFieldKeyDef

   LOCAL hIni
   LOCAL hFields

   LOCAL xValue

   AppData:PathCfg := oCGI:GetUserData( "PathCfg", AppData:PathCfg )

   cIni := AppData:PathCfg
   cIni += "\"
   cIni += codModel
   cIni += ".ini"

   IF ( File( cIni ) )
      hIni := hb_iniRead( cIni )
      IF ( HB_ISHASH( hIni ) )
         cFieldKey := codModel
         cFieldKey += "_Fields"
         IF ( HB_HHasKey( hIni,cFieldKey ) )
            FOR EACH cField in hb_HKeys( hIni[ cFieldKey ] )
               aFieldDef := Array( 0 )
               cFieldName := codModel
               cFieldName += "_"
               cFieldName += hIni[ cFieldKey ][ cField ]
               IF ( HB_HHasKey( hIni[ cFieldKey ],cFieldName ) )
                  FOR EACH cFieldKeyDef in hb_HKeys( hIni[ cFieldName ] )
                     IF ( HB_HHasKey( hIni[ cFieldName ],cFieldKeyDef ) )
                        xValue := hb_HGet( hIni[ cFieldName ], cFieldKeyDef )
                        switch Lower( xValue )
                        CASE "true"
                        CASE ".true."
                        CASE ".T."
                           xValue := .T.
                           EXIT
                        CASE "false"
                        CASE ".false."
                        CASE ".f."
                           xValue := .F.
                           EXIT
                        END switch
                        AAdd( aFieldDef, xValue )
                     ENDIF
                  NEXT EACH //cFieldKeyDef
               ENDIF
               IF ( !Empty( aFieldDef ) )
                  AAdd( aFieldsDef, aFieldDef )
               ENDIF
            NEXT EACH //cField
         ENDIF
         IF ( HB_HHasKey( hIni,"rest" ) )
            IF ( HB_HHasKey( hIni[ "rest" ],"jsonPath" ) )
               oCGI:SetUserData( codModel + ":jsonPath", hIni[ "rest" ][ "jsonPath" ] )
            ENDIF
            IF ( HB_HHasKey( hIni[ "rest" ],"RowspPageMax" ) )
               oCGI:SetUserData( codModel + ":RowspPageMax", Val( hIni[ "rest" ][ "RowspPageMax" ] ) )
            ENDIF
         ENDIF
         IF ( HB_HHasKey( hIni,"dataTable" ) )
            IF ( HB_HHasKey( hIni[ "dataTable" ],"fixedColumns" ) )
               oCGI:SetUserData( codModel + ":fixedColumns", hIni[ "dataTable" ][ "fixedColumns" ] )
            ENDIF
         ENDIF
         IF ( HB_HHasKey( hIni,"jsonserver" ) )
            IF ( HB_HHasKey( hIni[ "jsonserver" ],"db" ) )
               oCGI:SetUserData( codModel + ":jsonServer:db", hIni[ "jsonserver" ][ "db" ] )
            ENDIF
            IF ( HB_HHasKey( hIni[ "jsonserver" ],"Host" ) )
               IF ( !( oCGI:GetUserData(codModel + ":jsonServer:Host","" ) == "DISABLED_JSONSERVER_HOST" ) )
                  oCGI:SetUserData( codModel + ":jsonServer:Host", hIni[ "jsonserver" ][ "Host" ] )
               ENDIF
            ENDIF
         ENDIF
      ENDIF
   ENDIF

return( aFieldsDef )

//------------------------------------------------------------------------------

FUNCTION getDataFieldsDef( codModel, aFieldsADD )

   LOCAL aFieldsDef

   LOCAL nField
   LOCAL nFields

   aFieldsDef := readFieldDefFromIni( codModel )

   IF ( Empty( aFieldsDef ) )

      aFieldsDef := { ;
         { "Filial", "codFilial", .T., .T., "dt-left", .T., "@!" }, ;
         { "Desc. Filial", "descFilial", .T., .T., "dt-left", .T., "@!" }, ;
         { "Periodo", "codPeriodo", .T., .T., "dt-left", .T., "@!" }, ;
         { "Periodo Mes/Ano", "codPeriodoMesAno", .T., .T., "dt-left", .T., "@!" }, ;
         { "Periodo Ano/Mes", "codPeriodoAnoMes", .T., .T., "dt-left", .T., "@!" }, ;
         { "Alias Periodo", "aliasPeriodo", .T., .T., "dt-left", .T., "@!" }, ;
         { "C. Custo", "codCentroDeCusto", .T., .T., "dt-left", .T., "@!" }, ;
         { "Desc. Centro de Custo", "descCentroDeCusto", .T., .T., "dt-left", .T., "@!" }, ;
         { "Grupo", "codGrupo", .T., .T., "dt-left", .T., "@!" }, ;
         { "Desc. Grupo", "descGrupo", .T., .T., "dt-left", .T., "@!" }, ;
         { "Alias Grupo", "aliasGrupo", .T., .T., "dt-left", .T., "@!" }, ;
         { "Grupo Superior", "codGrupoSuperior", .T., .T., "dt-left", .T., "@!" }, ;
         { "Desc. Grupo Superior", "descGrupoSuperior", .T., .T., "dt-left", .T., "@!" }, ;
         { "C.Departamento", "codDepartamento", .T., .T., "dt-left", .T., "@!" }, ;
         { "Desc. Departamento", "descDepartamento", .T., .T., "dt-left", .T., "@!" }, ;
         { "Empresa", "codEmpresa", .T., .T., "dt-left", .T., "@!" }, ;
         { "Desc.Empresa", "descEmpresa", .T., .T., "dt-left", .T., "@!" }, ;
         { "Desc. Empresa Completo", "descEmpresaCompleto", .T., .T., "dt-left", .T., "@!" }, ;
         { "C.Função", "codFuncao", .T., .T., "dt-left", .T., "@!" }, ;
         { "Desc. Função", "descFuncao", .T., .T., "dt-left", .T., "@!" }, ;
         { "Agr.Funcao", "codAgrFuncao", .T., .T., "dt-left", .T., "@!" }, ;
         { "Dsc.Agr.Fun.", "descAgrFuncao", .T., .T., "dt-left", .T., "@!" }, ;
         { "Cod. Verba", "codVerba", .T., .T., "dt-left", .T., "@!" }, ;
         { "Desc. Verba", "descVerba", .T., .T., "dt-left", .T., "@!" }, ;
         { "Matricula", "codMatricula", .T., .T., "dt-left", .T., "@!" }, ;
         { "Dt.Dia", "dataDia", .T., .T., "dt-center", .T., "@D" }, ;
         { "Dt.Admissão", "dataAdmissao", .T., .T., "dt-center", .T., "@D" }, ;
         { "Dt.Demissão", "dataDemissao", .T., .T., "dt-center", .T., "@D" }, ;
         { "Nome Funcionário", "nomeFuncionario", .T., .T., "dt-left", .T., "@!" }, ;
         { "Fat(%) P.Férias", "fatPFerias", .T., .T., "dt-right", .T., "@R 999.999999999" }, ;
         { "Fat(%) P.Rescisão", "fatPRescisao", .T., .T., "dt-right", .T., "@R 999.999999999" }, ;
         { "Fat(%) P.13o.", "fatP13Salario", .T., .T., "dt-right", .T., "@R 999.999999999" }, ;
         { "Prov.13o.", "prov13Salario", .T., .T., "dt-right", .T., "@R 999,999,999.99" }, ;
         { "Prov.Rescisão", "provRescisao", .T., .T., "dt-right", .T., "@R 999,999,999.99" }, ;
         { "Prov.Férias", "provFerias", .T., .T., "dt-right", .T., "@R 999,999,999.99" }, ;
         { "Total Provisões", "provTotal", .T., .T., "dt-right", .T., "@R 999,999,999.99" }, ;
         { "Valor", "valor", .T., .T., "dt-right", .T., "@R 999,999,999.99" }, ;
         { "Sub Total", "subTotal", .T., .T., "dt-right", .T., "@R 999,999,999.99" }, ;
         { "Total", "total", .T., .T., "dt-right", .T., "@R 999,999,999.99" }, ;
         { "Func.Ini.Mes", "totalFuncionariosInicioMes", .T., .T., "dt-right", .T., "@R 999,999,999" }, ;
         { "Admissões", "totalFuncionariosAdmitidos", .T., .T., "dt-right", .T., "@R 999,999,999" }, ;
         { "Func.Mes", "totalFuncionariosMes", .T., .T., "dt-right", .T., "@R 999,999,999" }, ;
         { "Demissões", "totalFuncionariosDemitidos", .T., .T., "dt-right", .T., "@R 999,999,999" }, ;
         { "Func.Fim.Mes", "totalFuncionariosFinalMes", .T., .T., "dt-right", .T., "@R 999,999,999" }, ;
         { "Trf.Saida", "totalTransferenciasSaida", .T., .T., "dt-right", .T., "@R 999,999,999" }, ;
         { "Trf.Entrada", "totalTransferenciasEntrada", .T., .T., "dt-right", .T., "@R 999,999,999" }, ;
         { "TurnOver Geral", "turnOverGeral", .T., .T., "dt-right", .T., "@R 999,999,999.99" }, ;
         { "TurnOver Mov/Dem", "turnOverDemissoes", .T., .T., "dt-right", .T., "@R 999,999,999.99" }, ;
         { "Qtd.Fun.PRE.", "QTDEFUNPRE", .T., .T., "dt-right", .T., "@R 9999" }, ;
         { "Qtd.Fun.FOL.", "QTDEFUNFOL", .T., .T., "dt-right", .T., "@R 9999" }, ;
         { "Qtd.Fun.FER.", "QTDEFUNFER", .T., .T., "dt-right", .T., "@R 9999" }, ;
         { "Qtd.Fun.AFA.", "QTDEFUNAFA", .T., .T., "dt-right", .T., "@R 9999" }, ;
         { "Qtd.Fun.PON.", "QTDEFUNPON", .T., .T., "dt-right", .T., "@R 9999" }, ;
         { "Qtd.Fun.REA.", "QTDEFUNREA", .T., .T., "dt-right", .T., "@R 9999" };
         }

   ENDIF

   hb_default( @aFieldsADD, Array( 0 ) )

   nFields := Len( aFieldsADD )
   IF ( nFields > 0 )
      FOR nField := 1 TO nFields
         AAdd( aFieldsDef, aFieldsADD[ nField ] )
      NEXT nField
   ENDIF

return( aFieldsDef )

FUNCTION GetDataFields( codModel, bFunction, cColsPrint, aFieldsADD )

   LOCAL aFields
   LOCAL aFieldsDef

   LOCAL cKey
   LOCAL cCachedDataFields
   LOCAL cGetDataFields

   LOCAL hData

   LOCAL nAT
   LOCAL nData
   LOCAL nDatas

   LOCAL hGetDataFields

   AppData:cEmp := oCGI:GetUserData( "cEmp", AppData:cEmp )
   hb_default( AppData:cEmp, "" )

   cCachedDataFields := ( AppData:PathData + AppData:cEmp + "_" + Lower( ProcName() ) + "_" + codModel + ".hbserialize" )

   IF ( ( FIELDS_CACHE_ENABLE ) .AND. File( cCachedDataFields ) )
      cGetDataFields := hb_MemoRead( cCachedDataFields )
      IF ( !Empty( cGetDataFields ) )
         hGetDataFields := hb_Deserialize( cGetDataFields )
         IF ( ValType( hGetDataFields ) == "H" )
            IF ( HB_HHasKey( hGetDataFields, "aFields" ) )
               aFields := hGetDataFields[ "aFields" ]
            ENDIF
            IF ( HB_HHasKey( hGetDataFields, "cColsPrint" ) )
               cColsPrint := hGetDataFields[ "cColsPrint" ]
            ENDIF
         ENDIF
      ENDIF
   ENDIF

   aFieldsDef := getDataFieldsDef( codModel, aFieldsADD )

   IF ( Empty( aFields ) )

      aFields := Array( 0 )

      hData := Eval( bFunction )

      cColsPrint := "["

      IF ( !Empty( hData[ "data" ] ) )
         nDatas := Len( hData[ "data" ] )
         FOR nData := 1 TO nDatas
            FOR EACH cKey IN hb_HKeys( hData[ "data" ][ nData ] )
               nAT := hb_AScan( aFieldsDef, {| t | t[ 2 ] == cKey } )
               IF ( nAT > 0 )
                  AAdd( aFields, aFieldsDef[ nAT ] )
                  IF ( aFieldsDef[ nAT ][ 6 ] )
                     cColsPrint += hb_ntos( Len( aFields ) - 1 )
                     cColsPrint += ","
                  ENDIF
               ENDIF
            NEXT EACH
            IF ( Right( cColsPrint,1 ) == "," )
               cColsPrint := SubStr( cColsPrint, 1, Len( cColsPrint ) - 1 )
            ENDIF
            EXIT
         NEXT nData
      ENDIF

      cColsPrint += "]"

      IF ( ( FIELDS_CACHE_ENABLE ) .AND. ( !Empty(aFields ) ) )

         hGetDataFields := { => }
         hGetDataFields[ "aFields" ] := AClone( aFields )
         hGetDataFields[ "cColsPrint" ] := cColsPrint

         cGetDataFields := hb_Serialize( hGetDataFields )

         IF ( !Empty( cGetDataFields ) )
            hb_MemoWrit( cCachedDataFields, cGetDataFields )
         ENDIF

      ENDIF

   ENDIF

return( aFields )

FUNCTION GetDataModel( cModel, nPage, nRecords, nDraw, cSearchFilter, aOrder, lSendJSON, lGetFields, cFile, cParModel, lNoCacheDatos, cGrpFiles, lGZipEnabled )

   LOCAL aRow
   LOCAL aSource
   LOCAL aNotDatos
   LOCAL aFieldsDef
   LOCAL aFieldsADD
   LOCAL aFilesProtheus

   LOCAL cEmp

   LOCAL cKey
   LOCAL cDatos
   LOCAL cFilter
   LOCAL cJSONServer

   LOCAL cPicture
   LOCAL cTmpFilter
   LOCAL cPathProtheus
   LOCAL cFileProtheus
   LOCAL cFilesProtheus

   LOCAL hDet
   LOCAL hRow
   LOCAL hDatos
   LOCAL hDatosTmp
   LOCAL hResultado

   LOCAL lDatos
   LOCAL lFilter
   LOCAL lInclude
   LOCAL lGetFull
   LOCAL lSearchFilter
   LOCAL lFileProtheus
   LOCAL lHasNextPage

   LOCAL nDet
   LOCAL nFile
   LOCAL nFiles
   LOCAL nPagina
   LOCAL nRegPage
   LOCAL nRegTotal
   LOCAL nFieldsDef
   LOCAL nRowspPageMax

   LOCAL uValue

   hb_default( @lGZipEnabled, ZGIP_ENABLE )

   aSource := {}

   hResultado := { => }
   hResultado[ "recordsTotal" ]    := 0
   hResultado[ "recordsFiltered" ] := 0
   hResultado[ "draw" ]            := nDraw
   hResultado[ "data" ]            := aSource

   lGetFull := ( nRecords == ( - 1 ) )

   hb_default( @lGetFields, .F. )

   cEmp := ( AppData:cEmp := oCGI:GetUserData( "cEmp",AppData:cEmp ) )

   BEGIN SEQUENCE

      lSearchFilter := ( !Empty( cSearchFilter ) )
      IF ( lSearchFilter )
         cSearchFilter := Upper( AllTrim( cSearchFilter ) )
         IF ( "SQL:" $ cSearchFilter )
            cTmpFilter := StrTran( cSearchFilter, "SQL:", "" )
            IF ( Empty( cTmpFilter ) )
               cTmpFilter := NIL
            ELSE
               lSearchFilter := .F.
            ENDIF
         ENDIF
      ENDIF

      hb_default( @cFilter, "" )

      IF ( !Empty( cTmpFilter ) )
         IF ( !Empty( cFilter ) )
            cFilter += " AND "
         ENDIF
         cFilter += cTmpFilter
      ENDIF

      lFilter := ( !Empty( cFilter ) )

      hb_default( @cFile, "" )

      lDatos := ( ( lGetFull ) .AND. ( !lFilter ) .AND. File( cFile ) .AND. ( nfl_FileDate(cFile ) == Date() ) )

      lFileProtheus := .F.

      IF ( !lDatos )
         cPathProtheus := oCGI:GetUserData( cModel + ":jsonPath", "" )
         IF ( !Empty( cPathProtheus ) )
            IF ( !Right( cPathProtheus,1 ) == "\" )
               cPathProtheus += "\"
            ENDIF
            cPathProtheus += cEmp
            cPathProtheus += "\"
            cPathProtheus += cModel
            cPathProtheus += "\"
            cFilesProtheus := cPathProtheus
            cFilesProtheus += cEmp
            cFilesProtheus += "_"
            IF ( Empty( cGrpFiles ) )
               cFilesProtheus += cModel
            ELSE
               cFilesProtheus += cGrpFiles
            ENDIF
            cFilesProtheus += "*"
            aFilesProtheus := Directory( cFilesProtheus )
            lFileProtheus := ( ( !Empty(aFilesProtheus ) ) )
            lDatos := lFileProtheus
         ENDIF
      ENDIF

      hb_default( @lNoCacheDatos, .F. )

      lDatos := ( lDatos .AND. ( !lNoCacheDatos ) )
      nRowspPageMax := oCGI:GetUserData( cModel + ":RowspPageMax", 10 )

      IF ( lDatos )
         IF ( !( lFileProtheus ) )
            cDatos := hb_MemoRead( cFile )
            hb_jsonDecode( cDatos, @hDatos )
            lDatos := ( !Empty( hDatos ) )
         ELSE
            nFiles := Len( aFilesProtheus )
            hDatos := { ;
               "status" => 0, ;
               "message" => "", ;
               "ok" => .F., ;
               "response" => { => };
               }
            nPagina := IF( lGetFull, 1, IF( nPage == 0,1,IF(Mod(nPage,nRowspPageMax ) == 0,((nPage / nRowspPageMax ) + 1 ),nPage ) ) )
            FOR nFile := nPagina TO nFiles
               cFileProtheus := cPathProtheus
               cFileProtheus += aFilesProtheus[ nFile ][ F_NAME ]
               hDatosTmp := getCachedFile( cModel, aFilesProtheus[ nFile ][ F_NAME ], cFileProtheus, lGZipEnabled )
               IF ( HB_ISHASH( hDatosTmp ) )
                  IF ( HB_HHasKey( hDatos[ "response" ],"table" ) )
                     IF ( HB_HHasKey( hDatos[ "response" ][ "table" ],"items" ) )
                        AEval( hDatosTmp[ "table" ][ "items" ], {| e | AAdd( hDatos[ "response" ][ "table" ][ "items" ],e ) } )
                     ELSE
                        hDatos[ "response" ][ "table" ][ "items" ] := hDatosTmp[ "table" ][ "items" ]
                     ENDIF
                  ELSE
                     hDatos[ "response" ] := hDatosTmp
                  ENDIF
               ENDIF
               IF ( !( lGetFull ) .OR. ( lGetFields ) )
                  EXIT
               ENDIF
            NEXT nFile
            lDatos := ( !Empty( hDatos ) .AND. HB_HHasKey( hDatos[ "response" ],"table" ) )
            IF ( lDatos )
               hDatos[ "ok" ] := .T.
               IF ( lGetFull )
                  hDatos[ "response" ][ "PageNumber" ] := 1
                  hDatos[ "response" ][ "RowspPage" ] := hDatos[ "response" ][ "TotalPages" ]
                  hDatos[ "response" ][ "TotalPages" ] := 1
                  hDatos[ "response" ][ "hasNextPage" ] := .F.
               ENDIF
            ENDIF
         ENDIF
      ENDIF

      IF ( !lDatos )
         hDatos := QueryCodModel( AppData:cHost, cModel, cFilter, 1, 1, cParModel, @lGZipEnabled )
      ENDIF

      IF ( hDatos[ "ok" ] )

         IF ( HB_HHasKey( hDatos,"response" ) .and. ValType(hDatos[ "response" ] ) =="H" )
            nRegPage := IF( HB_HHasKey( hDatos[ "response" ],"RowspPage" ), hDatos[ "response" ][ "RowspPage" ], 0 )
            nRegTotal := IF( HB_HHasKey( hDatos[ "response" ],"TotalPages" ), hDatos[ "response" ][ "TotalPages" ], 0 )
            lHasNextPage := IF( HB_HHasKey( hDatos[ "response" ],"hasNextPage" ), hDatos[ "response" ][ "hasNextPage" ], .F. )
         ELSE
            nRegPage := 0
            nRegTotal := 0
            lHasNextPage := .F.
         ENDIF

         IF ( !lGetFields )

            IF ( lGetFull )
               nRecords := nRegTotal
            ENDIF

            nPagina := ( if( nRecords == 0,0,Int(nPage / nRecords ) ) + 1 )

            IF ( !lDatos )
               hDatos := QueryCodModel( AppData:cHost, cModel, cFilter, nRecords, nPagina, cParModel, @lGZipEnabled )
            ENDIF

         ENDIF

         IF ( hDatos[ "ok" ] )

            IF ( ( !lFilter ) .AND. ( !lDatos ) .AND. ( nRecords == nRegTotal ) )
               cDatos := hb_jsonEncode( hDatos )
               hb_MemoWrit( cFile, cDatos )
            ENDIF

            hResultado[ "recordsTotal" ]    := nRegTotal
            hResultado[ "recordsFiltered" ] := IF( lGetFull, nRegTotal, IF( lHasNextPage,(nRegPage * nRegTotal ),IF(nRegPage < nRowspPageMax,(nRowspPageMax * nRegTotal ),(nRegPage * nRegTotal ) ) ) )
            hResultado[ "draw" ]            := nDraw

            aFieldsADD := oCGI:GetUserData( "GetDataModel:aFieldsADD", Array( 0 ) )
            aFieldsDef := getDataFieldsDef( cModel, aFieldsADD )
            oCGI:SetUserData( "GetDataModel:aFieldsADD", Array( 0 ) )

            IF ( !lGetFields )
               IF ( !lSearchFilter )
                  cSearchFilter := oCGI:GetUserData( "GetDataModel:cSearchFilter", "" )
                  cSearchFilter := Upper( AllTrim( cSearchFilter ) )
                  IF ( "SQL:" $ cSearchFilter )
                     cSearchFilter := ""
                  ENDIF
                  lSearchFilter := ( !Empty( cSearchFilter ) )
               ENDIF
            ENDIF

            IF HB_HHasKey( hDatos, "response" ) .AND. ValType( hDatos[ "response" ] ) == "H" .AND. ;
                  HB_HHasKey( hDatos[ "response" ], "table" ) .AND. ValType( hDatos[ "response" ][ "table" ] ) == "H" .AND. ;
                  HB_HHasKey( hDatos[ "response" ][ "table" ], "items" ) .AND. ValType( hDatos[ "response" ][ "table" ][ "items" ] ) == "A"

               FOR EACH hRow IN hDatos[ "response" ][ "table" ][ "items" ]

                  hDet := { => }

                  IF HB_HHasKey( hRow, "detail" ) .AND. ValType( hRow[ "detail" ] ) == "H" .AND. ;
                        HB_HHasKey( hRow[ "detail" ], "items" ) .AND. ValType( hRow[ "detail" ][ "items" ] ) == "H"

                     FOR EACH cKey IN hb_HKeys( hRow[ "detail" ][ "items" ] )
                        nFieldsDef := AScan( aFieldsDef, {| x | x[ 2 ] == cKey } )
                        uValue := hRow[ "detail" ][ "items" ][ cKey ]
                        IF ( ( nFieldsDef > 0 ) .AND. !Empty( cPicture := aFieldsDef[ nFieldsDef ][ 7 ] ) )
                           IF ( cPicture == "@D" )
                              setFieldAsDate( cKey )
                              hDet[ cKey ] := Transform( SToD( uValue ), cPicture )
                           ELSE
                              hDet[ cKey ] := Transform( uValue, cPicture )
                           ENDIF
                        ELSE
                           hDet[ cKey ] := uValue
                        ENDIF
                     NEXT EACH //cKey
                  ENDIF

                  lInclude := ( !lSearchFilter )

                  IF ( lSearchFilter )
                     FOR nDet := 1 TO Len( hDet )
                        lInclude := ( At( cSearchFilter,Upper(ToString(hb_HValueAt(hDet,nDet ) ) ) ) > 0 )
                        IF ( lInclude )
                           EXIT
                        ENDIF
                     NEXT nDet
                  ENDIF

                  IF ( lInclude )
                     AAdd( aSource, hDet )
                  ENDIF

               NEXT EACH //hRow

            ENDIF

         ENDIF

      ENDIF

      IF ( !lGetFields )
         aSource := sortDataModel( aSource, aOrder )
      ENDIF

      hResultado[ "data" ] := aSource

      IF ( lGetFields )
         IF ( !lNoCacheDatos )
            IF ( ( !lFilter ) .AND. ( !lDatos ) )
               cDatos := hb_jsonEncode( hDatos )
               hb_MemoWrit( cFile, cDatos )
            ENDIF
         ENDIF
      ENDIF

   END SEQUENCE

RETURN( IF( lSendJSON,hb_jsonEncode(hResultado, .F. ),hResultado ) )

STATIC FUNCTION getCachedFile( cModel, cEndPoint, cFullPathFile, lGZipEnabled )

   LOCAL aDisabledHosts
   LOCAL cDisabledHosts
   LOCAL nDisabledHosts

   LOCAL cHost
   LOCAL cJSON
   LOCAL hJSON

   LOCAL cJSONServer

   LOCAL oOle

   LOCAL lStatusOK := .F.
   LOCAL lServerXMLHTTP

   LOCAL nResponseCode := 0

   hb_default( @lGZipEnabled, ZGIP_ENABLE )

   cJSONServer := StrTran( oCGI:GetUserData( cModel + ":jsonServer:Host","" ), "DISABLED_JSONSERVER_HOST", "" )

   IF ( !Empty( cJSONServer ) )

      hb_default( @cEndPoint, "" )

      cHost := cJSONServer
      cHost += cEndPoint
      IF ( Right( cHost,1 ) != "/" )
         cHost += "/"
      ENDIF
      cHost += "0"
      cJSON := cURLGet( cHost, cModel, @nResponseCode, NIL, NIL, lGZipEnabled )

      lStatusOK := ( !Empty( cJSON ) .AND. ( nResponseCode >= 200 ) .AND. ( nResponseCode <= 299 ) )

      IF ( !lStatusOK )

         TRY
            oOle := nfl_CreateObject( 'MSXML2.ServerXMLHTTP.6.0' )
            lServerXMLHTTP := .T.
         CATCH
            hb_MemoWrit( AppData:PathLog + ( DToS(Date() ) ) + "_" + StrTran( Time(),":","_" ) + "_" + hb_ntos( Seconds() ) + "_" + "cJSONServer_" + cEndPoint + ".log", "MSXML2.ServerXMLHTTP.6.0:Indisponivel" )
            TRY
               oOle := nfl_CreateObject( 'MSXML2.XMLHTTP' )
            CATCH
               hb_MemoWrit( AppData:PathLog + ( DToS(Date() ) ) + "_" + StrTran( Time(),":","_" ) + "_" + hb_ntos( Seconds() ) + "_" + "cJSONServer_" + cEndPoint + ".log", "MSXML2.XMLHTTP:Indisponivel" )
               TRY
                  oOle := nfl_CreateObject( 'Microsoft.XMLHTTP' )
               CATCH
                  hb_MemoWrit( AppData:PathLog + ( DToS(Date() ) ) + "_" + StrTran( Time(),":","_" ) + "_" + hb_ntos( Seconds() ) + "_" + "cJSONServer_" + cEndPoint + ".log", "Microsoft.XMLHTTP:Indisponivel" )
               END TRY
            END TRY
         END TRY

         IF ( ValType( oOle ) == "O" )

            TRY

               hb_default( @lServerXMLHTTP, .F. )
               IF ( lServerXMLHTTP )
                  oOle:setTimeouts( TIMEOUT_Resolve, TIMEOUT_Connect, TIMEOUT_Send, TIMEOUT_Receive )
               ENDIF

               oOle:Open( "GET", cHost, .F. )

               oOle:SetRequestHeader( "Content-Type", "application/json;charset=utf-8" )

               IF ( lGZipEnabled )
                  oOle:SetRequestHeader( "Accept-Encoding", "gzip,deflate" )
                  oOle:SetRequestHeader( "Content-Encoding", "gzip" )
               ENDIF

               oOle:Send()

               SWITCH ( oOle:STATUS )
               CASE 200
               CASE 202
               CASE 304
                  lStatusOK := .T.
                  cJSON := oOle:ResponseText
                  EXIT
               OTHERWISE
                  lStatusOK := .F.
               ENDSWITCH

            CATCH
               hb_MemoWrit( AppData:PathLog + ( DToS(Date() ) ) + "_" + StrTran( Time(),":","_" ) + "_" + hb_ntos( Seconds() ) + "_" + "cJSONServer_" + "cJSONServer_" + ".log", "Unable to connect to " + cHost )
            END TRY

         ENDIF

      ENDIF

      IF ( lStatusOK )
         hb_jsonDecode( IF( lGZipEnabled,hb_ZUncompress(cJSON ),cJSON ), @hJSON )
         IF ( ( HB_HHasKey(hJSON,"id" ) ) .AND. ( HB_HHasKey(hJSON,"data" ) ) )
            IF ( hJSON[ "id" ] == 0 )
               hJSON := hJSON[ "data" ]
            ELSE
               hJSON := nil
            ENDIF
         ELSE
            hJSON := nil
         ENDIF
      ELSE
         hJSON := nil
      ENDIF

   ENDIF

   aDisabledHosts := oCGI:GetUserData( "DISABLED_JSONSERVER_HOST", Array( 0 ) )
   cDisabledHosts := cModel + ":jsonServer:Host"
   IF ( Empty( hJSON ) )
      IF ( AScan( aDisabledHosts,{| c | cDisabledHosts } ) == 0 )
         oCGI:SetUserData( cDisabledHosts, "DISABLED_JSONSERVER_HOST" )
         AAdd( aDisabledHosts, cDisabledHosts )
      ENDIF
      cJSON := hb_MemoRead( cFullPathFile )
      hb_jsonDecode( cJSON, @hJSON )
   ELSE
      nDisabledHosts := AScan( aDisabledHosts, {| c | cDisabledHosts } )
      IF ( nDisabledHosts > 0 )
         oCGI:SetUserData( cDisabledHosts, "" )
         ADel( aDisabledHosts, nDisabledHosts )
         ASize( aDisabledHosts, ( Len(aDisabledHosts ) - 1 ) )
      ENDIF
   ENDIF
   oCGI:SetUserData( "DISABLED_JSONSERVER_HOST", aDisabledHosts )

   hb_default( @hJSON, { => } )

return( hJSON )

FUNCTION sortDataModel( aSource, aOrder )

   LOCAL lHasDate
   LOCAL cHbHKeyAt

   hb_default( @aSource, Array( 0 ) )
   hb_default( @aOrder, Array( 0 ) )

   IF ( !Empty( aOrder ) .AND. ( Len(aOrder ) >= 1 ) .AND. ( aOrder[ 1 ] > 0 ) )
      IF ( !Empty( aSource ) )
         lHasDate := ( Len( aSource ) >= 1 )
         lHasDate := ( lHasDate .AND. ( HB_ISHASH(aSource[ 1 ] ) ) )
         lHasDate := ( lHasDate .AND. ( !Empty(cHbHKeyAt := hb_HKeyAt(aSource[ 1 ],aOrder[ 1 ] ) ) ) )
         lHasDate := ( lHasDate .AND. ( getFieldAsDate( cHbHKeyAt ) .OR. ( Len(hb_ATokens(aSource[ 1 ][ cHbHKeyAt ],"/" ) ) == 3 ) ) )
         IF ( aOrder[ 2 ] == "desc" )
            IF ( lHasDate )
               aSource := ASort( aSource, NIL, NIL, {| x, y | CToD( x[ hb_HKeyAt( x,aOrder[ 1 ] ) ] ) > CToD( y[ hb_HKeyAt( y,aOrder[ 1 ] ) ] ) } )
            ELSE
               aSource := ASort( aSource, NIL, NIL, {| x, y | x[ hb_HKeyAt( x,aOrder[ 1 ] ) ] > y[ hb_HKeyAt( y,aOrder[ 1 ] ) ] } )
            ENDIF
         ELSE
            IF ( lHasDate )
               aSource := ASort( aSource, NIL, NIL, {| x, y | CToD( x[ hb_HKeyAt( x,aOrder[ 1 ] ) ] ) < CToD( y[ hb_HKeyAt( y,aOrder[ 1 ] ) ] ) } )
            ELSE
               aSource := ASort( aSource, NIL, NIL, {| x, y | x[ hb_HKeyAt( x,aOrder[ 1 ] ) ] < y[ hb_HKeyAt( y,aOrder[ 1 ] ) ] } )
            ENDIF
         ENDIF
      ENDIF
   ENDIF

return( aSource )

FUNCTION rebuildDataModel( xData, hFilter, lSendJSON, aOrder, hFilterBetween )

   LOCAL aSource

   LOCAL bAscanMatch

   LOCAL cKey

   LOCAL nRow
   LOCAL nRows

   LOCAL xFilter
   LOCAL xRebuild

   IF ( lSendJSON )
      hb_jsonDecode( xData, @xRebuild )
   ELSE
      xRebuild := hb_HClone( xData )
   ENDIF

   aSource := xRebuild[ "data" ]

   nRows := Len( aSource )

   hb_default( @hFilter, { => } )
   hb_default( @hFilterBetween, { => } )

   FOR EACH cKey IN hb_HKeys( hFilter )
      IF ( HB_HHasKey( hFilterBetween,cKey ) )
         xFilter := hFilterBetween[ cKey ]
         bAscanMatch := {| h | !( h[ cKey ] >= xFilter[ 1 ] .AND. h[ cKey ] <= xFilter[ 2 ] ) }
      ELSE
         xFilter := hFilter[ cKey ]
         IF ( "codFilial" == cKey )
            bAscanMatch := {| h | !( h[ cKey ] == Left( xFilter, Len( h[ cKey ] ) ) ) }
         ELSE
            bAscanMatch := {| h | !( h[ cKey ] == xFilter ) }
         ENDIF
      ENDIF
      IF ( ( nRow := AScan(aSource,{| h | HB_HHasKey(h,cKey ) } ) ) > 0 )
         nRow--
         WHILE ( ( nRow := AScan(aSource,bAscanMatch,++nRow ) ) > 0 )
            ADel( aSource, nRow )
            ASize( aSource, --nRows )
            nRow--
         END WHILE
      ENDIF
   NEXT EACH //cKey

   aSource := sortDataModel( aSource, aOrder )

RETURN( IF( lSendJSON,hb_jsonEncode(xRebuild, .F. ),xRebuild ) )

FUNCTION setFieldAsDate( cField )

   LOCAL aFields := oCGI:GetUserData( "FieldAsDate", NIL )

   hb_default( @aFields, Array( 0 ) )

   IF ( AScan( aFields,{| e | e[ 1 ] == cField } ) == 0 )
      AAdd( aFields, { cField, .T. } )
   ENDIF

   oCGI:SetUserData( "FieldAsDate", aFields )

return( aFields )

FUNCTION getFieldAsDate( cField )

   LOCAL aFields := oCGI:GetUserData( "FieldAsDate", NIL )

   LOCAL lFieldAsDate := .F.

   LOCAL nATField

   hb_default( @aFields, Array( 0 ) )

   IF ( ( nATField := AScan(aFields,{| e | e[ 1 ] == cField } ) ) > 0 )
      lFieldAsDate := aFields[ nATField ][ 2 ]
   ENDIF

return( lFieldAsDate )
