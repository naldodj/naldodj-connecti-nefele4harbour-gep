@Echo Off
FOR %%G in ("..\tsk\*.xml") DO (
    schtasks.exe /Create /XML "%%G" /RU "SYSTEM" /TN "%%~nG" || echo.
)
 
 
