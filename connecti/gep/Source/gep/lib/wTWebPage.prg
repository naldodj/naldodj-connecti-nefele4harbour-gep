/*
 * Proyecto: Connecti
 * Fichero: wDatatablesModificado.prg
 * Descricao?
 * Autor:
 * Fecha: 14/08/2021
 */

#include "Xailer.ch"
#include "nefele.ch"

CLASS wTWebPage FROM TWebPage

   METHOD Create(lBorderDataTable)

ENDCLASS

//------------------------------------------------------------------------------

METHOD Create() CLASS wTWebPage

    local cHtml

    ::Super:cIcon:="./connecti/resource/icons/connecti.ico"

    ::Super:cCSS+=CSS()
    ::Super:cInHead+=inHead()

    AAdd(::Super:aScript,Scripts())

    cHtml:=::Super:Create()

    cHtml:=replaceHtmlText(cHtml)

RETURN(cHtml)

static function CSS()

   local cCSS

   TEXT INTO cCSS
      .centrado {color: white !important;}
   ENDTEXT

   return(cCSS)

static function inHead()
   local cInHead
   TEXT INTO cInHead
      <link href='https://fonts.googleapis.com/css2?family=Material+Icons' rel='stylesheet' />
      <link rel='manifest' href='?webAppManifest' crossorigin='use-credentials' />
   ENDTEXT
   return(cInHead)

static function replaceHtmlText(cHtml)

   local aTextReplace:=Array(0)

   local cCRLF:=HB_OsNewLine()
   local cReplace

   HB_Default(@cHtml,"")

   aAdd(aTextReplace,{"Registros para exibir: ","Exibir:"})
   aAdd(aTextReplace,{"Trabalhando","Processando"})
   TEXT INTO cReplace

   <meta charset='utf-8'/>

   <meta http-equiv='content-type' content='text/css; charset=utf-8' />
   <meta http-equiv='content-type' content='application/json; charset=utf-8'/>
   <meta http-equiv='content-type' content='application/javascript; charset=utf-8'/>
   <meta http-equiv='content-type' content='application/x-javascript; charset=utf-8'/>

   <meta http-equiv='content-type' content='image/png'/>
   <meta http-equiv='content-type' content='image/ico'/>

   <meta http-equiv='content-type' content='application/manifest'/>

   <meta name='keywords' content='ConnecTI, RH, Painel' />
   <meta name='copyright' content='© @yearCopyright@ ConnecTI Consultoria' />
   <meta name='description' content='PAINELRH' />

   <meta http-equiv='cache-control' content='max-age=0' />
   <meta http-equiv='cache-control' content='no-cache' />

   <meta http-equiv='expires' content='0' />
   <meta http-equiv='expires' content='Tue, 15 Dez 1970 1:00:00 GMT' />

   <meta http-equiv='pragma' content='no-cache' />

   <meta name='rating' content='general' />

   <meta http-equiv='content-language' content='pt-br,es-ES,en-US' />

   ENDTEXT
   cReplace:=StrTran(cReplace,"@yearCopyright@",hb_NtoS(Year(Date())))
   aAdd(aTextReplace,{"<head>",cReplace})
   aAdd(aTextReplace,{"<img src='./connecti/resource/images/connecti-consultoria-150x45-white.png' class='responsive-img'>","<img src='./connecti/resource/images/connecti-consultoria-150x45-white.png' alt='connecti-consultoria-150x45-white.png' class='responsive-img'>"})
   aAdd(aTextReplace,{'<img src="./connecti/resource/images/connecti-consultoria-150x45-white.png" class="responsive-img">',"<img src='./connecti/resource/images/connecti-consultoria-150x45-white.png' alt='connecti-consultoria-150x45-white.png' class='responsive-img'>"})
   aAdd(aTextReplace,{"{return autoform","{autoform"})
   aAdd(aTextReplace,{"> <","><"})
   aAdd(aTextReplace,{"><html",">"+cCRLF+"<html"})
   aAdd(aTextReplace,{"><title",">"+cCRLF+"<title"})
   aAdd(aTextReplace,{"><meta",">"+cCRLF+"<meta"})
   aAdd(aTextReplace,{"><script",">"+cCRLF+"<script"})
   aAdd(aTextReplace,{"><link",">"+cCRLF+"<link"})
   aAdd(aTextReplace,{"><!",">"+cCRLF+"<!"})
   aAdd(aTextReplace,{"><main",">"+cCRLF+"<main"})
   aAdd(aTextReplace,{"<script type="+'"text/javascript">'+"console.error('DEPRECATED: Las propiedades directas de los Iconos van a ser eliminadas, cambielas a propiedades de oIcon.');</script>",""})
   aAdd(aTextReplace,{'console.log("FINAL")','/*console.log("FINAL")*/'})
   aAdd(aTextReplace,{'console.log("error")','/*console.log("error")*/'})
   aAdd(aTextReplace,{'console.log("inicio")','/*console.log("inicio")*/'})
   aAdd(aTextReplace,{'<script type="text/javascript" src="https://code.jquery.com/jquery-3.5.1.min.js" integrity="sha256-9/aliU8dGd2tb6OSsuzixeV4y/faTqgFtohetphbbj0=" crossorigin="anonymous"></script>','<script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.6.0/jquery.min.js" integrity="sha512-894YE6QWD5I59HgZOGReFYm4dnWc1Qt5NtvYSaNcOP+u1T9qYdvdihz0PPSiiqn/+/3e7Jo4EaG7TubfWGUrMQ==" crossorigin="anonymous" referrerpolicy="no-referrer"></script>'})

   aEval(aTextReplace,{|t|cHtml:=StrTran(cHtml,t[1],t[2])})

   return(cHtml)

static function Scripts()

   local cScripts

    TEXT INTO cScripts
function autoformID(JSONDataB64 = "", url = location.pathname, target = "", lshadowsheet = false, cSSTitle = null, cSSSubTitle = null ) {
   var form = document.createElement('form');
   form.id = "autoformID";
   console.log(form);
   form.action = url;
   form.target = target;
   form.method = "post";
   try {
         var JSONData=window.atob(JSONDataB64.replace("-_","+/"));
         const oJSONData = JSON.parse(JSONData);
         Object.entries(oJSONData).forEach(entry => {
            const [key, value] = entry;
            var input = document.createElement('input');
            input.type  = 'hidden';
            input.id    = key ;
            input.name  = key ;
            input.value = value;
            form.appendChild(input);
        });
   } catch(error){
      console.log(error);
   }
   document.body.appendChild(form);
   if(lshadowsheet)
   {
      if (cSSTitle ) {
         document.getElementById("shadowsheet_title").innerHTML=cSSTitle;
      }
      if (cSSSubTitle ) {
         document.getElementById("shadowsheet_subtitle").innerHTML=cSSSubTitle;
      }
      document.getElementById("shadowsheet").style.height=document.querySelector("body").offsetHeight+"px";
      document.getElementById("shadowsheet").style.display="block";
   }
   form.submit();
};

function autoformIDAjax(JSONDataB64 = "", url = location.pathname, target = "", lshadowsheet = false, cSSTitle = null, cSSSubTitle = null ) {
   var form = document.createElement("form");
   form.id = "autoformIDAjax";
   form.action = url;
   form.target = target;
   form.method = "post";
   try {
         var JSONData=window.atob(JSONDataB64.replace("-_","+/"));
         const oJSONData = JSON.parse(JSONData);
         Object.entries(oJSONData).forEach(entry => {
            const [key, value] = entry;
            var input = document.createElement('input');
            input.type  = 'hidden';
            input.id    = key ;
            input.name  = key ;
            input.value = value;
            form.appendChild(input);
        });
   } catch(error){
      console.log(error);
   }
   document.body.appendChild(form);
   if (lshadowsheet)
   {
      if (cSSTitle ) {
         document.getElementById("shadowsheet_title").innerHTML=cSSTitle;
      }
      if (cSSSubTitle ) {
         document.getElementById("shadowsheet_subtitle").innerHTML=cSSSubTitle;
      }
      document.getElementById("shadowsheet").style.height= document.querySelector("body").offsetHeight+"px";
      document.getElementById("shadowsheet").style.display="block";
   }
   $(function() {
       $("#autoformIDAjax").submit(function() {
           $.ajax({
               url: this.action,
               type: this.method,
               data: $(this).serialize(),
               success: function(responseData) {
                   $("html").html(responseData);
               }
           });
           return false;
       });
   });
   $("#autoformIDAjax").submit();
};
    ENDTEXT

   return(cScripts)