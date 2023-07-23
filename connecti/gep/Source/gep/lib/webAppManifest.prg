#include "Xailer.ch"
#include "Nefele.ch"

function webAppManifest()

    local cFile:="../htdocs/gep.webmanifest"
    local webAppManifest

    IF (!File(cFile))

       TEXT INTO webAppManifest
{
    "name": "PAINELRH",
    "short_name": "PAINELRH",
    "start_url": "./DigaspiPainelRH",
    "lang": "pt-BR",
    "display": "standalone",
    "background_color": "#ffffff",
    "description": "PAINEL RH",
    "theme_color": "#000000",
    "categories": [
        "business",
        "ERP",
        "Human Resources"
    ],
    "icons": [
        {
            "src": "./connecti/resource/icons/connecti.ico",
            "type": "image/ico",
            "sizes": "128x128"
        },
        {
            "src": "./connecti/resource/images/connecti-consultoria-150x45-white.png",
            "type": "image/png",
            "sizes": "150x45"
        },
        {
            "src": "./connecti/resource/images/connecti-consultoria-login-background.jpg",
            "type": "image/png",
            "sizes": "768x432"
        },
        {
            "src": "./connecti/resource/images/connecti-consultoria-login-background-at-night.jpg",
            "type": "image/png",
            "sizes": "1599x899"
        },
        {
            "src": "./connecti/resource/images/connecti-consultoria-login-background-in-the-morning.jpg",
            "type": "image/png",
            "sizes": "1599x899"
        },
        {
            "src": "./connecti/resource/images/connecti-consultoria-logo.png",
            "type": "image/png",
            "sizes": "250x76"
        }
    ],
    "related_applications": [
        {
            "platform": "web"
        }
    ]
}
      ENDTEXT
      HB_MemoWrit(cFile,webAppManifest)
   ELSE
      webAppManifest:=HB_MemoRead(cFile)
   ENDIF

   return(webAppManifest)