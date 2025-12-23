@echo off
setlocal enabledelayedexpansion

echo === Building wxWidgets if needed ===

REM --- Locate wx build folder ---
set "WX_BUILD_DIR=%~dp0external\wxWidgets\build\msw"
if not exist "%WX_BUILD_DIR%" (
    echo ERROR: wxWidgets build folder not found at %WX_BUILD_DIR%
    exit /b 1
)

REM --- Resolve wxWidgets .sln dynamically ---
set "WX_SLN="
for %%F in ("%WX_BUILD_DIR%\wx_vc*.sln") do (
    set "WX_SLN=%%F"
    goto :found_sln
)

:found_sln
if "%WX_SLN%"=="" (
    echo ERROR: Could not find wxWidgets Visual Studio solution in %WX_BUILD_DIR%
    exit /b 1
)

REM --- Get current submodule commit hash ---
pushd "%~dp0external\wxWidgets" >nul
for /f %%H in ('git rev-parse HEAD') do set "WX_HASH=%%H"
if not defined WX_HASH (
    echo ERROR: Could not read wxWidgets git hash. Is the submodule initialized?
    popd >nul
    exit /b 1
)
popd >nul

REM --- Paths for artifacts and stored hash ---
set "WX_LIB_DIR=%WX_BUILD_DIR%\..\..\lib\vc_lib"
set "HASH_FILE=%WX_LIB_DIR%\.wx_build_hash"

REM --- Flags ---
set "NEED_RELEASE_BUILD=0"
set "NEED_DEBUG_BUILD=0"
set "DID_REBUILD=0"

REM --- Check Release needs rebuild ---
if not exist "%WX_LIB_DIR%\mswu\wx\setup.h" set "NEED_RELEASE_BUILD=1"
if not exist "%HASH_FILE%" set "NEED_RELEASE_BUILD=1"

if exist "%HASH_FILE%" (
    set /p OLD_HASH=<"%HASH_FILE%"
    if not "!OLD_HASH!"=="%WX_HASH%" set "NEED_RELEASE_BUILD=1"
)

REM --- If Release rebuilds, force Debug too ---
if "%NEED_RELEASE_BUILD%"=="1" set "NEED_DEBUG_BUILD=1"

REM --- Otherwise check Debug independently (only if not CI) ---
if /i not "%CI%"=="true" (
    if not exist "%WX_LIB_DIR%\mswud\wx\setup.h" set "NEED_DEBUG_BUILD=1"
    if not exist "%HASH_FILE%" set "NEED_DEBUG_BUILD=1"
    if exist "%HASH_FILE%" (
        set /p OLD_HASH=<"%HASH_FILE%"
        if not "!OLD_HASH!"=="%WX_HASH%" set "NEED_DEBUG_BUILD=1"
    )
)

REM --- If hash is outdated, wipe the lib folder ---
if "%NEED_RELEASE_BUILD%"=="1" (
    echo [wxWidgets] Clearing old libraries...
    rmdir /s /q "%WX_LIB_DIR%" 2>nul
    mkdir "%WX_LIB_DIR%"
)

REM --- Build Release ---
if "%NEED_RELEASE_BUILD%"=="1" (
    echo [wxWidgets] Building Release...
    msbuild "%WX_SLN%" /p:Configuration=Release /p:Platform=Win32 /m /t:Rebuild
    if errorlevel 1 (
        echo ERROR: Release build failed.
        exit /b 1
    )
    set "DID_REBUILD=1"
) else (
    echo [wxWidgets] Release build up to date, skipping.
)

REM --- Build Debug (only if not CI) ---
if /i not "%CI%"=="true" (
    if "%NEED_DEBUG_BUILD%"=="1" (
        echo [wxWidgets] Building Debug...
        msbuild "%WX_SLN%" /p:Configuration=Debug /p:Platform=Win32 /m /t:Rebuild
        if errorlevel 1 (
            echo ERROR: Debug build failed.
            exit /b 1
        )
        set "DID_REBUILD=1"
    ) else (
        echo [wxWidgets] Debug build up to date, skipping.
    )
) else (
    echo [wxWidgets] Skipping Debug build in CI.
)

REM --- Update hash only after all builds succeed ---
if "%DID_REBUILD%"=="1" (
    >"%HASH_FILE%" echo %WX_HASH%
)

echo === wxWidgets build check complete ===
endlocal
