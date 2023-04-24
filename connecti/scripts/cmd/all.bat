@Echo Off
FOR %%G in ("*.bat") DO (
    IF NOT %%~nxG==all.bat (
        IF NOT %%~nxG==DEPARTAMENTOS_SRA.bat (
            IF NOT %%~nxG==CreateTasks.bat (
                call %%~nxG || echo.
            )
        )    
    )
)
    