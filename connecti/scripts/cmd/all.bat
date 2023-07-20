@echo off

:: Interrompe o servico de REST do Protheus
pskill -t appserver_rest.exe

:: Redundancia, apenas para verificar que o servico foi parado
psservice stop "02 - Protheus12Teste_Rest"

:: Aguarda n segundos
PowerShell -Command "&{Start-Sleep 15}"

:: Inicia o servico de REST do Protheus
psservice start "02 - Protheus12Teste_Rest"

:: Aguarda n segundos
PowerShell -Command "&{Start-Sleep 120}"

:: Define o Arquivo Inicial para Processamento
SET "ConstStartFile=GRPVERBASCC.bat"

:: Loop através de todos os arquivos .bat no diretório atual
FOR %%G in ("*.bat") DO (

    :: Verificando se o arquivo .bat não é 'all.bat'
    IF NOT %%~nxG==all.bat (

        :: Verificando se o arquivo .bat não é 'DEPARTAMENTOS_SRA.bat'
        IF NOT %%~nxG==DEPARTAMENTOS_SRA.bat (
        
            :: Verificando se o arquivo .bat não é 'TURNOVERFILFUNCPREVXREALIZADO.bat'
            IF NOT %%~nxG==TURNOVERFILFUNCPREVXREALIZADO.bat (

                :: Verificando se o arquivo .bat não é 'CreateTasks.bat'
                IF NOT %%~nxG==CreateTasks.bat (

                    :: Verificando se o arquivo .bat não é 'CreateTasks.bat'
                    IF "%%~nxG" GEQ "%ConstStartFile%" (

                        :: Chamando o arquivo .bat e exibindo uma linha vazia em caso de erro
                        call %%~nxG || echo.
                        
                        :: Interrompe o servico de REST do Protheus
    rem                    pskill -t appserver_rest.exe
    rem                    psservice stop "02 - Protheus12Teste_Rest"
                        
                        :: Aguarda n segundos
    rem                    PowerShell -Command "&{Start-Sleep 15}"
                        
                        :: Inicia o servico de REST do Protheus
    rem                    psservice start "02 - Protheus12Teste_Rest"
                        
                        :: Aguarda n segundos
    rem                    PowerShell -Command "&{Start-Sleep 120}"
                    )
                )
            )
        )
    )
)
