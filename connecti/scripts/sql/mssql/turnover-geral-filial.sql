BEGIN
    WITH PERIODO AS
             (
                        SELECT 
                      DISTINCT SRD.RD_DATARQ PERIODO
                             , SRA.RA_FILIAL
                          FROM SRD990 SRD
						  JOIN SRA990 SRA ON (SRD.RD_FILIAL=SRA.RA_FILIAL AND SRD.RD_MAT=SRA.RA_MAT)           
                         WHERE SRD.D_E_L_E_T_=''
                           AND SRA.D_E_L_E_T_=''
						   AND SRD.RD_FILIAL<>''
						   AND SRA.RA_FILIAL<>''
						   AND SRD.RD_FILIAL=SRA.RA_FILIAL
						   AND SRD.RD_MAT=SRA.RA_MAT
                      GROUP BY SRD.RD_DATARQ
                             , SRA.RA_FILIAL
                      UNION 
                        SELECT 
                      DISTINCT LEFT(SRA.RA_ADMISSA,6) PERIODO
                             , SRA.RA_FILIAL
                         FROM SRA990 SRA
                        WHERE SRA.D_E_L_E_T_=''
                          AND SRA.RA_FILIAL<>''
                     GROUP BY LEFT(SRA.RA_ADMISSA,6)
                             , SRA.RA_FILIAL
             )
      ,TURNOVER AS (
            SELECT
                   PERIODO.PERIODO
                 , PERIODO.RA_FILIAL
                 , ISNULL((
                          SELECT
                                 SUM(TTRFSAI)
                          FROM
                                 (
                                          SELECT
                                                   COUNT(1) AS TTRFSAI
                                          FROM
                                                   SRE990 SRE_T
                                          WHERE
                                                   SRE_T.D_E_L_E_T_= ''
                                                   AND SRE_T.RE_EMPD=!EMPRESA!
                                                   AND LEFT(SRE_T.RE_DATA,6)=PERIODO.PERIODO
												   AND SRE_T.RE_FILIALD=PERIODO.RA_FILIAL
                                          GROUP BY
                                                   LEFT(SRE_T.RE_DATA,6)
                                                 , SRE_T.RE_EMPD
												 , SRE_T.RE_FILIALD
                                 )
                                 T
                   ),0)
                   TTRFSAI
                 , ISNULL((
                          SELECT
                                 SUM(TTRFENT)
                          FROM
                                 (
                                          SELECT
                                                   COUNT(1) AS TTRFENT
                                          FROM
                                                   SRE990 SRE_T
                                          WHERE
                                                   SRE_T.D_E_L_E_T_= ''
                                                   AND SRE_T.RE_EMPP=!EMPRESA!
                                                   AND LEFT(SRE_T.RE_DATA,6)=PERIODO.PERIODO
												   AND SRE_T.RE_FILIALP=PERIODO.RA_FILIAL
                                          GROUP BY
                                                   LEFT(SRE_T.RE_DATA,6)
                                                 , SRE_T.RE_EMPP
												 , SRE_T.RE_FILIALP
                                 )
                                 T
                   ),0)
                   TTRFENT
                 , ISNULL((
                          SELECT
                                 SUM(TFUNMES)
                          FROM
                                 (
                                          SELECT
                                                   COUNT(1) AS TFUNMES
                                          FROM
                                                   SRA990 SRA_T
                                          WHERE
                                                   SRA_T.D_E_L_E_T_= ''
                                                   AND LEFT(SRA_T.RA_ADMISSA,6)<=PERIODO.PERIODO
                                                   AND (
                                                            SRA_T.RA_DEMISSA=''
                                                            OR
                                                            ( 
                                                                 LEFT(SRA_T.RA_ADMISSA,6)<=PERIODO.PERIODO
                                                                 AND (
                                                                          LEFT(SRA_T.RA_ADMISSA,6)<=LEFT(SRA_T.RA_DEMISSA,6)
                                                                      AND LEFT(SRA_T.RA_DEMISSA,6)>=PERIODO.PERIODO
                                                                 )
                                                            )
                                                    )
                                                   AND SRA_T.RA_FILIAL=PERIODO.RA_FILIAL
                                 )
                                 T
                   ),0)
                   TFUNMES
                 , ISNULL((
                          SELECT
                                 SUM(ADMISSAO)
                          FROM
                                 (
                                          SELECT
                                                 COUNT(SRA_A.RA_ADMISSA) AS ADMISSAO
                                            FROM SRA990 SRA_A
                                           WHERE LEFT(SRA_A.RA_ADMISSA,6)=PERIODO.PERIODO
                                             AND SRA_A.RA_FILIAL=PERIODO.RA_FILIAL
                                        GROUP BY LEFT(SRA_A.RA_ADMISSA,6)
                                                 , SRA_A.RA_FILIAL
                                 )
                                 T
                   ),0)
                   TFUNADMMES
                 , ISNULL((
                          SELECT
                                 SUM(DEMISSAO)
                          FROM
                                 (
                                          SELECT COUNT(RA_DEMISSA) AS DEMISSAO
                                            FROM SRA990 SRA_D
                                           WHERE SRA_D.RA_DEMISSA<>''
                                             AND LEFT(SRA_D.RA_DEMISSA,6)=PERIODO.PERIODO
                                             AND SRA_D.RA_FILIAL=PERIODO.RA_FILIAL
                                             AND SRA_D.RA_DEMISSA<>''
                                         GROUP BY LEFT(SRA_D.RA_DEMISSA,6)
                                                 , SRA_D.RA_FILIAL
                                 )
                                 T
                   ),0)
                   TFUNDEMMES
            FROM PERIODO
           WHERE PERIODO.PERIODO BETWEEN !DATARQDE! AND !DATARQATE! 
             AND  PERIODO.RA_FILIAL BETWEEN !FILIALDE! AND !FILIALATE! 
    )
    , TURNOVERT AS (
    SELECT TURNOVER.PERIODO
          ,TURNOVER.RA_FILIAL
          ,TURNOVER.TTRFSAI
          ,TURNOVER.TTRFENT
          ,TFUNIMES=CAST((TURNOVER.TFUNMES-TURNOVER.TFUNADMMES) AS FLOAT)
          ,TFUNADMMES=CAST(TURNOVER.TFUNADMMES AS FLOAT) 
          ,TFUNMES=CAST(TURNOVER.TFUNMES AS FLOAT) 
          ,TFUNDEMMES=CAST(TURNOVER.TFUNDEMMES AS FLOAT) 
          ,TFUNFMES=CAST((TURNOVER.TFUNMES-TURNOVER.TFUNDEMMES) AS FLOAT) 
    FROM TURNOVER
    )
    SELECT TURNOVERT.PERIODO
          ,TURNOVERT.RA_FILIAL
          ,TURNOVERT.TTRFSAI
          ,TURNOVERT.TTRFENT
          ,TURNOVERT.TFUNIMES
          ,TURNOVERT.TFUNADMMES
          ,TURNOVERT.TFUNMES
          ,TURNOVERT.TFUNDEMMES
          ,TURNOVERT.TFUNFMES
          ,TURNOVER=ROUND(((CASE TFUNIMES WHEN 0 THEN 0 ELSE ((TURNOVERT.TFUNADMMES+TURNOVERT.TFUNDEMMES)/2/TURNOVERT.TFUNIMES) END)*100),2)
          ,TURNMOVF=ROUND(((CASE TFUNIMES WHEN 0 THEN 0 ELSE (TURNOVERT.TFUNDEMMES)/2/TURNOVERT.TFUNIMES END)*100),2)
    INTO !TABLENAME!
    FROM TURNOVERT
END