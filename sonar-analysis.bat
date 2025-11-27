@echo off
REM Script de Analisis SonarQube para Worker_Services_Consumer
REM Proyecto: IF-6201 - Informatica Aplicada a los Negocios 2025

setlocal

set SONAR_TOKEN=sqa_e50c7e2b107711be9edf0114b595f07ca18c6792
set ITERATION=inicial
set PROJECT_KEY=worker-services-consumer
set PROJECT_NAME=Worker Services Consumer
set SONAR_URL=http://localhost:9000

echo ========================================
echo   Analisis SonarQube - Iteracion: %ITERATION%
echo ========================================
echo.

echo Limpiando proyecto...
dotnet clean Worker_Services_Consumer.sln
if %errorlevel% neq 0 (
    echo ERROR: Fallo la limpieza del proyecto
    pause
    exit /b 1
)

echo.
echo Iniciando analisis SonarQube...
dotnet sonarscanner begin /k:"%PROJECT_KEY%" /n:"%PROJECT_NAME%" /d:sonar.host.url="%SONAR_URL%" /d:sonar.token="%SONAR_TOKEN%" /d:sonar.cs.opencover.reportsPaths="**/coverage.opencover.xml" /d:sonar.verbose=true

if %errorlevel% neq 0 (
    echo ERROR: Fallo el inicio del analisis
    pause
    exit /b 1
)

echo.
echo Compilando proyecto...
dotnet build Worker_Services_Consumer.sln --no-incremental

if %errorlevel% neq 0 (
    echo ERROR: Fallo la compilacion
    pause
    exit /b 1
)

echo.
echo Finalizando analisis y enviando a SonarQube...
dotnet sonarscanner end /d:sonar.token="%SONAR_TOKEN%"

if %errorlevel% equ 0 (
    echo.
    echo ========================================
    echo   OK - Analisis completado exitosamente
    echo ========================================
    echo.
    echo Revisa los resultados en: %SONAR_URL%/dashboard?id=%PROJECT_KEY%
    echo.
    echo Iteracion: %ITERATION%
) else (
    echo.
    echo ERROR: Fallo el envio del analisis
    pause
    exit /b 1
)

echo.
pause
