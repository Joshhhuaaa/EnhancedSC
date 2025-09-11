@echo off
setlocal enabledelayedexpansion

echo === Building Zydis if needed ===

REM --- Detect platform (arg > env var > default x64) ---
set "PLAT=%~1"
if "%PLAT%"=="" set "PLAT=%Platform%"
if "%PLAT%"=="" set "PLAT=x64"

REM --- Locate Zydis project file ---
set "ZY_PROJECT=%~dp0external\zydis\msvc\zydis\Zydis.vcxproj"
if not exist %ZY_PROJECT% (
    echo ERROR: Zydis project file not found at %ZY_PROJECT%
    exit /b 1
)

REM --- Get current submodule commit hash ---
pushd "%~dp0external\zydis" >nul
for /f %%H in ('git rev-parse HEAD') do set "ZY_HASH=%%H"
if not defined ZY_HASH (
    echo ERROR: Could not read Zydis git hash. Is the submodule initialized?
    popd >nul
    exit /b 1
)
popd >nul

REM --- Configure paths ---
if /i "%PLAT%"=="x64" (
    set "ZY_LIB=%~dp0external\zydis\msvc\bin\ReleaseX64\Zydis.lib"
    set "HASH_FILE=%~dp0external\zydis\msvc\bin\ReleaseX64\.zydis_build_hash"
    set "MSBUILD_ARGS=/p:Configuration="Release MT" /p:Platform=x64 /m /nologo /verbosity:minimal"
) else if /i "%PLAT%"=="Win32" (
    set "ZY_LIB=%~dp0external\zydis\msvc\bin\ReleaseX86\Zydis.lib"
    set "HASH_FILE=%~dp0external\zydis\msvc\bin\ReleaseX86\.zydis_build_hash"
    set "MSBUILD_ARGS=/p:Configuration="Release MT" /p:Platform=Win32 /m /nologo /verbosity:minimal"
) else (
    echo ERROR: Unsupported platform %PLAT%
    endlocal
    exit /b 1
)

REM --- Decide if rebuild is needed ---
set "NEED_BUILD=0"
if not exist "%ZY_LIB%" set "NEED_BUILD=1"
if not exist "%HASH_FILE%" set "NEED_BUILD=1"

if exist "%HASH_FILE%" (
    set /p OLD_HASH=<"%HASH_FILE%"
    if not "!OLD_HASH!"=="%ZY_HASH%" set "NEED_BUILD=1"
)

REM --- Build if needed ---
if "%NEED_BUILD%"=="1" (
    echo [Zydis] Building Release MT %PLAT%
    msbuild %ZY_PROJECT% %MSBUILD_ARGS%
    if errorlevel 1 (
        echo ERROR: Zydis Release MT %PLAT% build failed
        exit /b 1
    )
    >"%HASH_FILE%" echo %ZY_HASH%
) else (
    echo [Zydis] Release MT %PLAT% up to date, skipping
)

echo === Zydis build check complete ===
endlocal
exit /b 0
