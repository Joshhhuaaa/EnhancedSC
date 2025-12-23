@echo off

:: Create Inc folders if they don't exist
if not exist .\Core\Inc\ mkdir .\Core\Inc
if not exist .\Echelon\Inc\ mkdir .\Echelon\Inc
if not exist .\EchelonCharacter\Inc\ mkdir .\EchelonCharacter\Inc
if not exist .\EchelonEffect\Inc\ mkdir .\EchelonEffect\Inc
if not exist .\EchelonGameObject\Inc\ mkdir .\EchelonGameObject\Inc
if not exist .\EchelonHUD\Inc\ mkdir .\EchelonHUD\Inc
if not exist .\EchelonIngredient\Inc\ mkdir .\EchelonIngredient\Inc
if not exist .\EchelonMenus\Inc\ mkdir .\EchelonMenus\Inc
if not exist .\EchelonPattern\Inc\ mkdir .\EchelonPattern\Inc
if not exist .\Editor\Inc\ mkdir .\Editor\Inc
if not exist .\Engine\Inc\ mkdir .\Engine\Inc
if not exist .\UDebugMenu\Inc\ mkdir .\UDebugMenu\Inc
if not exist .\UWindow\Inc\ mkdir .\UWindow\Inc
if not exist .\Enhanced\Inc\ mkdir .\Enhanced\Inc

del ".\System\Core.u"
del ".\System\Engine.u"
del ".\System\Editor.u"
del ".\System\EchelonEffect.u"
del ".\System\Echelon.u"
del ".\System\EchelonGameObject.u"
del ".\System\EchelonIngredient.u"
del ".\System\EchelonCharacter.u"
del ".\System\EchelonHUD.u"
del ".\System\EchelonPattern.u"
del ".\System\UWindow.u"
del ".\System\UDebugMenu.u"
del ".\System\EchelonMenus.u"
del ".\System\Enhanced.u"

echo Compiling scripts for Enhanced SC

cd .\System\
UCC.exe make -nobind
cd ..

echo Finished compiling Enhanced SC

PAUSE