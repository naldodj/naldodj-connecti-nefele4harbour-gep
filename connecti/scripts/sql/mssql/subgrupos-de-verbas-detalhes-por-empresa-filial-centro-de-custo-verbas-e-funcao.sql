WITH _CTE AS (
    SELECT SRA.RA_FILIAL
          ,SRD.RD_FILIAL
          ,SRD.RD_DATARQ
          ,SRD.RD_CC
          ,SRD.RD_PD
          ,SRA.RA_CODFUNC
          ,SUM(SRD.RD_VALOR) RD_VALOR
      FROM SRD010 SRD 
      JOIN SRA010 SRA ON (SRA.RA_FILIAL=SRD.RD_FILIAL AND SRA.RA_MAT=SRD.RD_MAT)
     WHERE SRD.D_E_L_E_T_= ' '
       AND SRA.D_E_L_E_T_= '' 
       AND SRA.RA_FILIAL=SRD.RD_FILIAL
       AND SRD.RD_FILIAL BETWEEN !FILIALDE! AND !FILIALATE!
       AND SRD.RD_DATARQ BETWEEN !DATARQDE! AND !DATARQATE!
       AND SRD.RD_PD BETWEEN !VERBADE! AND !VERBAATE!
       AND SRD.RD_CC BETWEEN !CCDE! AND !CCATE!
       AND SRA.RA_FILIAL BETWEEN !FILIALDE! AND !FILIALATE!
       AND SRA.RA_CODFUNC BETWEEN !FUNCAODE! AND !FUNCAOATE!
  GROUP BY SRA.RA_FILIAL
          ,SRD.RD_FILIAL
          ,SRD.RD_DATARQ
          ,SRD.RD_CC
          ,SRD.RD_PD
          ,SRA.RA_CODFUNC
  )
  SELECT _CTE.RA_FILIAL
        ,_CTE.RD_DATARQ
        ,_CTE.RD_CC
        ,CTT.CTT_DESC01
        ,ZY_.ZY__MASTER
        ,ZY_.ZY__CODIGO
        ,ZY_.ZY__DESC
        ,RTRIM(LTRIM(CONVERT(VARCHAR(1024),ZY_.ZY__HTML))) ZY__HTML
        ,SRV.RV_COD
        ,SRV.RV_DESC
        ,SRJ.RJ_FUNCAO
        ,SRJ.RJ_DESC
        ,SUM(_CTE.RD_VALOR) RD_VALOR
  INTO !TABLENAME!      
  FROM _CTE
  JOIN CTT010 CTT ON (CTT.CTT_CUSTO=_CTE.RD_CC)
  JOIN SRV010 SRV ON (_CTE.RD_PD=SRV.RV_COD)
  JOIN ZY_010 ZY_ ON (SRV.RV_ZY__COD=ZY_.ZY__CODIGO)
  JOIN SRJ010 SRJ ON (_CTE.RA_CODFUNC=SRJ.RJ_FUNCAO)
 WHERE SRV.D_E_L_E_T_=' '
   AND ZY_.D_E_L_E_T_=' '
   AND SRJ.D_E_L_E_T_=''
   AND CTT.CTT_FILIAL=(CASE CTT.CTT_FILIAL WHEN '' THEN '' ELSE LEFT(_CTE.RD_FILIAL,LEN(CTT.CTT_FILIAL)) END)
   AND SRV.RV_FILIAL=(CASE SRV.RV_FILIAL WHEN '' THEN '' ELSE LEFT(_CTE.RD_FILIAL,LEN(SRV.RV_FILIAL)) END)
   AND SRJ.RJ_FILIAL=(CASE SRJ.RJ_FILIAL WHEN '' THEN '' ELSE LEFT(_CTE.RA_FILIAL,LEN(SRJ.RJ_FILIAL)) END)
   AND SRV.RV_ZY__COD<>''
   AND _CTE.RD_DATARQ BETWEEN !DATARQDE! AND !DATARQATE!
   AND _CTE.RD_CC BETWEEN !CCDE! AND !CCATE!
   AND _CTE.RD_FILIAL BETWEEN !FILIALDE! AND !FILIALATE!
   AND _CTE.RA_FILIAL BETWEEN !FILIALDE! AND !FILIALATE!
   AND ZY_.ZY__CODIGO BETWEEN !GRUPODE! AND !GRUPOATE!
   AND SRJ.RJ_FUNCAO BETWEEN !FUNCAODE! AND !FUNCAOATE!
   AND SRV.RV_COD BETWEEN !VERBADE! AND !VERBAATE!
GROUP BY _CTE.RA_FILIAL
        ,_CTE.RD_DATARQ
        ,_CTE.RD_CC
        ,CTT.CTT_DESC01
        ,ZY_.ZY__MASTER
        ,ZY_.ZY__CODIGO
        ,ZY_.ZY__DESC
        ,RTRIM(LTRIM(CONVERT(VARCHAR(1024),ZY_.ZY__HTML)))
        ,SRV.RV_COD
        ,SRV.RV_DESC
        ,SRJ.RJ_FUNCAO
        ,SRJ.RJ_DESC