SELECT
 DISTINCT ZY_.ZY__FILIAL
         ,ZY_.ZY__CODIGO
         ,ZY_.ZY__SQLFLD
         ,ZY_.ZY__DESC
		 ,RTRIM(LTRIM(CONVERT(VARCHAR(1024),ZY_.ZY__HTML))) ZY__HTML
    FROM ZY_990 ZY_
    JOIN (
       SELECT
     DISTINCT ZY_.ZY__FILIAL
             ,ZY_.ZY__MASTER
         FROM ZY_990 ZY_
         JOIN SRV990 SRV ON (ZY_.ZY__CODIGO=SRV.RV_ZY__COD)
         JOIN SRD990 SRD ON (SRV.RV_COD=SRD.RD_PD)
        WHERE ZY_.D_E_L_E_T_=''
          AND SRV.D_E_L_E_T_=''
          AND SRD.D_E_L_E_T_=''
          AND ZY_.ZY__FILIAL=(CASE ZY_.ZY__FILIAL WHEN '' THEN '' ELSE LEFT(SRV.RV_FILIAL,LEN(ZY_.ZY__FILIAL)) END)
          AND SRV.RV_FILIAL=(CASE SRV.RV_FILIAL WHEN '' THEN '' ELSE LEFT(SRD.RD_FILIAL,LEN(SRV.RV_FILIAL)) END)
   ) t
    ON (ZY_.ZY__FILIAL=t.ZY__FILIAL AND ZY_.ZY__CODIGO=t.ZY__MASTER)
WHERE ZY_.D_E_L_E_T_=''