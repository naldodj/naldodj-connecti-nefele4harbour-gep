/*
 * Proyecto: GEP
 * Fichero: Traductor.prg
 * Descricao:
 * Autor:
 * Fecha: 06/08/2021
 */

#include "Xailer.ch"
#include "Nefele.ch"
#include "LangCGI.ch"

REQUEST HB_CODEPAGE_PTISO
REQUEST HB_CODEPAGE_PT850
REQUEST HB_LANG_PT

FUNCTION Lang( nText )
RETURN AppData:aLang[nText][AppData:nLang+1]

FUNCTION MonthLang(xMonth,cLang,cCodPage)

   local cMonth

   local __cLang
   local __cCodPage

   HB_Default(@xMonth,Date())
   HB_Default(@cLang,"PT")
   HB_Default(@cCodPage,"PTISO")

   cLang:=Upper(cLang)
   cCodPage:=Upper(cCodPage)

   __cCodPage:=HB_CdpSelect(cCodPage)

   __cLang:=HB_LangSelect(cLang,cCodPage)

   switch (ValType(xMonth))
   CASE ("D")
      cMonth:=cMonth(xMonth)
      exit
   CASE ("C")
      xMonth:=AllTrim(xMonth)
      IF (Len(xMonth)<=2)
         cMonth:=NToCMonth(Val(xMonth))
      ELSEIF ("/"$xMonth)
         cMonth:=cMonth(CToD(xMonth))
      ELSE
         cMonth:=cMonth(SToD(xMonth))
      ENDIF
      exit
   CASE ("N")
      cMonth:=NToCMonth(xMonth)
      exit
   OTHERWISE
      cMonth:=""
   end switch

   HB_LangSelect(__cLang)
   HB_CdpSelect(cCodPage)

   return(cMonth)

//------------------------------------------------------------------------------

FUNCTION LoadLang()
RETURN  {{ LNG_ERRORLOGIN,"Os dados inseridos não estão corretos<br>ou o usuário não foi autorizado.",;
                           "Los datos introducidos no son correctos<br>o el usuario no ha sido autorizado."},;
         { LNG_SI,"Sim","Sí" },;
         { LNG_NO,"Não","No" },;
         { LNG_ESTADO,"Status","Estado" },;
         { LNG_ACEPTAR,"Aceitar","Aceptar" },;
         { LNG_ACEPTAR,"Cancelar","Cancelar" },;
         { LNG_BUSCAR,"Busca","Buscar" },;
         { LNG_MSGLOGIN,"Acessar","Introduzca sus datos de acceso" },;
         { LNG_USERID,"Usuário","Usuario" },;
         { LNG_USERPASS,"Senha","Password" },;
         { LNG_USERNAME,"Nome do usuário","Nombre del usuario" },;
         { LNG_USERADMIN,"Administrador","Administrador" },;
         { LNG_USERUPDATEOK,"Usuário atualizado","Usuario actualizado" },;
         { LNG_USERNEWOK,"Usuário criado","Usuario creado" },;
         { LNG_USERDUPLICATE,"Identificação de usuário já existe!","¡El Usuario ya existe!" },;
         { LNG_IDIOMA,"Idioma","Idioma" },;
         { LNG_ACCEDER,"Acessar","Acceder" },;
         { LNG_INICIO,"Inicio","Inicio" },;
         { LNG_USUARIOS,"Usuários","Usuarios" },;
         { LNG_DATOS,"Dados","Datos" },;
         { LNG_LOGOUT,"Fechar sessão","Cerrar Sesión" },;
         { LNG_MAINUSERS,"Usuários","Usuarios" },;
         { LNG_NEWUSER,"Novo usuário","Nuevo Usuario" },;
         { LNG_EDITUSER,"Editar usuário","Editar Usuario" },;
         { LNG_ACTIVO,"Ativo","Activo" },;
         { LNG_INACTIVO,"Inativo","Inactivo" },;
         { LNG_SSTITLE,"Trabalhando","Trabajando" },;
         { LNG_SSSUBTITLE,"Aguarde...","Aguarde..." },;
         { LNG_AXO,"Ano","Año" },;
         { LNG_MES,"Mês","Mes" },;
         { LNG_ENERO,"Janeiro","Enero" },;
         { LNG_FEBRERO,"Fevereiro","Febrero" },;
         { LNG_MARZO,"Março","Marzo" },;
         { LNG_ABRIL,"Abril","Abril" },;
         { LNG_MAYO,"Maio","Mayo" },;
         { LNG_JUNIO,"Junho","Junio" },;
         { LNG_JULIO,"Julho","Julio" },;
         { LNG_AGOSTO,"Agosto","Agosto" },;
         { LNG_SEPTIEMBRE,"Setembro","Septiembre" },;
         { LNG_OCTUBRE,"Outubro","Octubre" },;
         { LNG_NOVIEMBRE,"Novembro","Noviembre" },;
         { LNG_DICIEMBRE,"Dezembro","Diciembre" },;
         { LNG_CTT,"Centro de Custo","Departamento" },;
         { LNG_SELCTT,"selecione o Centro de Custo","Seleccione Departamento" },;
         { LNG_TOTAL,"Total","Total" },;
         { LNG_FILTROS,"Filtros","Filtros" },;
         { LNG_SINDATOS,"Não há dados","Sin Datos"},;
         { LNG_INIT_RSDETAIL,"Selecione Centro de Custo para fazer a consulta",;
                               "Seleccione Centro de Costo para realizar la consulta"},;
         { LNG_SELECCIONADO,"Selecionado","Seleccionado"},;
         { LNG_CODIGO,"Código","Código"},;
         { LNG_NOMBRE,"Nome","Nombre"},;
         { LNG_FUNCION,"Funcao","Función"},;
         { LNG_EMPRESA,"Empresa","Empresa"};
         }

