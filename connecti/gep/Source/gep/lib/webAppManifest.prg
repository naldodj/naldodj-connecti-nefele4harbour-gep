#include "Xailer.ch"
#include "Nefele.ch"

function webAppManifest()

    local webAppManifest

    TEXT INTO webAppManifest
{
  "short_name": "PAINELRH",
  "name": "PAINELRH",
  "lang": "pt-BR",
  "description": "PAINEL RH",
  "categories": ["business", "ERP", "Human Resources"],
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
      "src": "./connecti/resource/images/connecti-consultoria-logo.png",
      "type": "image/png",
      "sizes": "250x76"
    }
  ],
  "start_url": "./PainelRH",
  "display": "standalone",
  "theme_color": "#000000",
  "background_color": "#ffffff"
}
   ENDTEXT

   HB_MemoWrit("gep.webmanifest",webAppManifest)

   return(webAppManifest)