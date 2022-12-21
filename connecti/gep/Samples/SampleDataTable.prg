/*
 * Proyecto: GEP
 * Fichero: SampleDataTable.prg
 * Descricao:
 * Autor:
 * Fecha: 14/08/2021
 */

#include "Xailer.ch"
#include "Nefele.ch"
#include "LangCGI.ch"

PROCEDURE MainDataTable(lOffline)

   LOCAL hUser := LoginUser()
   Local hRow
   Local hData
   LOCAL nPageLen := 3   // Lineas a mostrar inicialmente
   LOCAL cTmp,cJS

   // Datos por defecto de la barra superior
   LOCAL cIcon := "https://api.iconify.design/ic/outline-signal-wifi-4-bar.svg?color=teal&width=24"
   LOCAL cRef  := "/GEP?offline"
   LOCAL cTitle := "Off Line"
   Local cIDParameters
   Local aParameters
   Local cPeriodo

   IF lOffline
      cIcon := "https://api.iconify.design/ic/sharp-signal-wifi-connected-no-internet-4.svg?color=teal&width=24"
      cRef  := "/GEP?online"
      cTitle := "On Line"
   ENDIF

   WITH OBJECT TWebPage():New()

      :cIcon:= "connecti.ico"
      :cTitle:=" GEP :: Connecti"

      AppMenu(:WO,AppData:AppName,hUser,.F.)

      :lValign    := .F.
      :lContainer := .f.

      aParameters:={"codPeriodo","codGrupo"}
      GEPParameters(:WO,@cIDParameters,/*"CadastroCentrosDeCusto"*/,aParameters,.F.," :: ("+cTitle+")"):Create()

      // hacemos scroll si hay más de 10 registros
      aAdd(:aScript,'function fn_click(e){ if( document.querySelector("#datas").offsetTop > window.innerHeight) {document.getElementById("datas").scrollIntoView()}     }')

      With Object WSeparator():New(:WO)
         :Create()
      End With

      WITH OBJECT WDataTable():New(:WO)

         :cId     := "browsemaindatatable"

         // Botones Datatable
         WITH OBject :AddButton("Exportar")
            :cCustom := "{extend: 'collection',text: 'Exportar',buttons: [ 'csv',{extend: 'excel',exportOptions: {columns: [1,2,3,4]}},{extend: 'pdf',exportOptions: {columns: [1,2,3,4]}},'csv' ]}"
         END WITH

         :AddButton("{extend: 'print',text: 'Imprimir',exportOptions: {columns: [  1,2,3,4]}}")

         WITH OBject :AddButton("Par&acirc;metros")
            :cAction := nfl_OpenModal(cIDParameters,.T.)
         END WITH

         TEXT INTO cJS
x= document.getElementById("browsemaindatatable_headcontent"); if (x.style.display == "") { x.style.display = "none" } else { x.style.display = "" }
         ENDTEXT

         WITH OBject :AddButton("Totais")
            :cAction := cJS
         END WITH

         :cInMain := "<script>"+cJS+"</script>"

         :cTitle  := "Api jSon " + ButtonTitle(cRef,cTitle,cIcon)

         __GrpVerbasEmpresa(.F.)
         hData:=GetDataGrpVerbasEmpresa(.F.,.T.)

         for each hRow in hData["data"]

            cPeriodo:=hRow["codPeriodo"]

            With Object WBevel():New(:WO)
               :cId:=cPeriodo+":"+hRow["codGrupo"]
               :aWidth[xc_M]  := 7
               :aWidth[xc_L]  := 6
               With Object WPanel():New(:WO)     // :WO   o  :__WithObject() indica que el parent del objeto es el del nivel anterior no cerrado,en este caso Webpage
                  :cTitle := cPeriodo+" :: "+hRow["codGrupo"]+" - "+hRow["descGrupo"]
                  :nFontTitle := 8
                  With Object WBevel():New(:WO)
                     With Object WLabel():New(:WO)
                        :nHeaderSize   := 5
                        :lBR           := .T.
                        :lBold         := .T.
                        :cAlign        := xc_Center
                        :cText:=  hRow["valor"]
                        :Create()
                     End With
                     :Create()
                  End With
                  :Create()
               End With
               :Create()
            End With

         next

         // Configurar opciones
         WITH OBJECT :Configure()
            :SetLanguage({"Portugues","Spanish"}[AppData:nLang])
            :sPaginationType := "listbox" //full_numbers
            :paging          := .T.
            :pageLength      :=  nPageLen
            :serverSide      := .T.
            :info            := .T.
            :lengthChange    := .T.
            :lengthMenu      := { {3,5,10,25,50,100,500,-1},{3,5,10,25,50,100,500,{"Mostre tudo","Mostrar todos"}[AppData:nLang]} }
            :searching       := .T.
            :ordering        := .T.
            :order           := { {0,'asc'} }  // Columna por defecto

            // Columnas del browse
            WITH OBJECT :AddColumn("ID",xc_Right)
               :data       := "row"                    ;  :orderable  := .T. ; :searchable := .t.
            END
            WITH OBJECT :AddColumn(Lang(LNG_CODIGO))
               :data       := "key"                    ;  :orderable  := .T. ; :searchable := .t. ; :className  := "dt-right"
            END
            WITH OBJECT :AddColumn(Lang(LNG_NOMBRE))
               :data       := "Nome"                   ;  :orderable  := .T. ; :searchable := .t.
            END
            WITH OBJECT :AddColumn(Lang(LNG_FUNCION))
               :data       := "DescricaoFuncao"        ;  :orderable  := .T. ; :searchable := .t.
            END
            WITH OBJECT :AddColumn(Lang(LNG_CTT))
               :data       := "DescricaoCentroDeCusto" ;  :orderable  := .T. ; :searchable := .t.
            END

            cTmp := {"Acesso através de novo formulário","Acceso mediante formulario nuevo"}[AppData:nLang]
            :AddColumnButton("loupe",cTmp,"punto punto2 blue","visparam" ,"dt-center")

            cTmp := {"Acesso via ajax","Acceso a través de ajax"}[AppData:nLang]
            :AddColumnButton("loupe",cTmp,"btn-wDatatable ;","visparamajax","dt-center","datas",'fn_click')

            cTmp := {"Acessando uma função javaScrip","Acceso a una función javaScript"}[AppData:nLang]
            :AddColumnButton("loupe",cTmp,"punto punto2 red",'@otrotexto' )

            // Los datos serán servidos por el CGI con una llamada
            IF lOffline
               :ajax := { "cgi" => "GetDataHash2" }
            ELSE
               :ajax := { "cgi" => "GetDataHash" }
            ENDIF
         END

         :Create()
      END

      WITH OBJECT WBevel():New(:WO)
         :cId     :="datas"
         :cClass  := "z-depth-4"

         WITH OBJECT:oStyle
            :cMargin_Top :=  20
            :cMin_Height := 400
            :cMax_Height := 400
            :cOverflow   := "auto"
         END

         :cInMain := '<script> function otrotexto(e){document.querySelector("#WDataTableTitle").innerText="' + Upper(Lang(LNG_SELECCIONADO)) +': "+e.Nome} </script>'

         :Create()
      END

      oCgi:SendPage( :Create() )
   END

RETURN

//---------------------------------------------

STATIC FUNCTION ButtonTitle(cRef,cTitle,cIcon)
   LOCAL cText
   TEXT INTO cText
      <i Title='Recargar' class='material-icons teal-text darken-4' style='cursor:pointer;float:right' onclick='table@tb.ajax.reload();'>refresh</i>
      <a href='@1' title='mudar para o modo @2'>
      <img style='float:right; margin-right: 12px; margin-top: -1px' class='teal-text darken-4' src=@3>
      </a>
   ENDTEXT
   cText := StrTran( cText,"@1",cRef )
   cText := StrTran( cText,"@2",cTitle )
   cText := StrTran( cText,"@3",cIcon )
   cText := StrTran( cText,CRLF,"" )
RETURN cText


//------------------------------------------------------------------------------

FUNCTION GetDataHash(nRows,lAjax,lOffLine)

   LOCAL aRecords,aRow,hRow
   LOCAL hParams,nStart,nLimit
   LOCAL cJSONData
   LOCAL cSearchFilter,aOrder

   hParams   := oCGI:aParamsToHash(.T.)
   nStart    := Val(hParams['START'])
   nLimit    := Val(hParams['LENGTH'])

   cSearchFilter  := hParams['SEARCH[VALUE]']
   aOrder    := {Val(hParams['order[0][column]'])+1,hParams['order[0][dir]']} // datatables empieza en columna 0. segundo elemento asc o desc
   cJSONData := Extraer( nStart,nLimit,hParams['DRAW'],lOffLine,cSearchFilter,aOrder)

RETURN(oCGI:SendJson(cJSONData))

//-------------------------------------------
// Recuperamos los datos
FUNCTION Extraer( nPage,nRecords,nDraw,lOffLine,cSearchFilter,aOrder)

   LOCAL oOle,hDatos
   LOCAL hResultado,aRow,hRow,aSource := {}
   LOCAL nPagina
   LOCAL nRegTotal
   Local aJson
   Local nPrimero,n

   nPagina:=(if(nRecords==0,0,Int(nPage/nRecords))+1)

   IF lOffLine

      aJson := xJson( cSearchFilter,aOrder )

      hResultado := {=>}
      hResultado["recordsTotal"]    := Len(aJson)
      hResultado["recordsFiltered"] := Len(aJson)
      hResultado['draw']            := nDraw
      IF (nRecords==-1)
         nRecords = Len(aJson)
      ENDIF

      FOR n := nPrimero TO Min( Len(aJson),nPrimero+ nRecords  -1)
         hRow              := {=>}
        // hRow["id"]                     := "<div class='punto'"+IF(n=4," style='background:red' ","")+">"+ToString(aJson[n,1]) +"</div>"
         hRow["row"]                    := aJson[n,1]
         hRow["key"]                    := aJson[n,2]
         hRow["Nome"]                   := aJson[n,5]
         hRow["DescricaoFuncao"]        := aJson[n,7]
         hRow["DescricaoCentroDeCusto"] := aJson[n,10]
         hRow["Admissao"]               := aJson[n,13]

         aAdd( aSource,hRow )
      NEXT
   ELSE

      hDatos := QueryCodModel(AppData:cHost,"FUNCIONARIOS",,1,1)

      if hDatos["ok"]

         nRegTotal := hDatos["response","TotalPages"]

         IF (nRecords==-1)
            nRecords:=nRegTotal
         ENDIF

         hDatos := QueryCodModel(AppData:cHost,"FUNCIONARIOS",,nRecords,nPagina)

         if hDatos["ok"]

            hResultado := {=>}
            hResultado["recordsTotal"]    := nRegTotal
            hResultado["recordsFiltered"] := nRegTotal
            hResultado['draw']            := nDraw

            FOR EACH aRow IN hDatos["response","table","items"]
               hRow              := {=>}
               hRow["row"]                    := aRow["detail","recNo"]
               hRow["key"]                    := aRow["detail","key"]
               hRow["Nome"]                   := aRow["detail","items","Nome"]
               hRow["DescricaoFuncao"]        := aRow["detail","items","DescricaoFuncao"]
               hRow["DescricaoCentroDeCusto"] := aRow["detail","items","DescricaoCentroDeCusto"]

               aAdd( aSource,hRow )
            NEXT
         ENDIF
      ENDIF
   ENDIF

   hResultado['data'] := aSource

RETURN(HB_JsonEncode(hResultado,.T.))

//------------------------------------------------------------------------------
// procesamos el jSon
FUNCTION xJson( cSearchFilter,aOrder )
LOCAL hDatos,aRow
LOCAL hItem,m,aItems,aDatos  := {}

LOCAL lInclude
LOCAL cRuta    := AppData:PathData
LOCAL aCorrespondencias := { {1,1},{2,2},{3,5},{4,7},{5,10}}  // nº columna visualizada,nº campo en tabla de datos

   HB_JsonDecode( MemoRead( cRuta+"Funcionarios.json"),@hDatos)

   FOR EACH hItem IN hDatos
      aRow   := { hItem["detail","recNo"],hItem["detail","key"] }
      aItems := hItem["detail","items"]

      lInclude := If( Empty(cSearchFilter),.t.,.f.)
      FOR m := 1 TO len(aItems)
         IF At(Upper(cSearchFilter),Upper(ToString(hb_HValueAt(aItems,m)))) > 0
            lInclude := .t.
         END
         aAdd(aRow,hb_HValueAt(aItems,m) )
      NEXT

      IF lInclude
         aAdd(aDatos,aRow)
      END
   NEXT

   IF aOrder[1] > 0
      IF aOrder[2]= "asc"
         aDatos := aSort(aDatos,,,{ |x,y| x[aCorrespondencias[aOrder[1],2]] < y[aCorrespondencias[aOrder[1],2]] })
      ELSE
         aDatos := aSort(aDatos,,,{ |x,y| x[aCorrespondencias[aOrder[1],2]] > y[aCorrespondencias[aOrder[1],2]] })
      ENDIF
   ENDIF

RETURN aDatos

