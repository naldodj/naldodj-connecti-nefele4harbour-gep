/*
 * Proyecto:      Gep
 * Fichero:       Gep.prg
 * Descripción:   Módulo de entrada a la aplicación CGI Néfele for Xailer
 * Autor:         Administrator
 * Fecha:         28/07/2021
 */

#include "Xailer.ch"

Procedure Main()

   SET DATE FORMAT TO "dd/mm/yyyy"

   Application:cTitle := "gep"
   Application:oIcon := "nefele.ico"

   CGI_Init()
   TRY
      Application:Run()
   END TRY

Return