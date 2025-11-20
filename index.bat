@echo off

color 3
title ASSISTANCE WINDOWS MULTI TACHES

goto start
:start
echo ===============================================
echo           ASSISTANCE WINDOWS
echo ===============================================
echo.
echo 1 - Verifier la connexion internet
echo 2 - Nettoyer les fichier temporaires
echo 3 - Sauvegarder un fichier sur une cle USB
echo 4 - Generer un mot de passe aleatoire
echo 5 - Compresser un dossier
echo 6 - Afficher l'usage CPU / RAM
echo 7 - Redemarrage / Arret rapide du PC
echo 0 - quitter le tools
echo.
set choiceinput=
set /p choiceinput= Merci de bien vouloir faire un choix : 
if %choiceinput%==1 goto choice1
if %choiceinput%==2 goto choice2
if %choiceinput%==3 goto choice3
if %choiceinput%==4 goto choice4
if %choiceinput%==5 goto choice5
if %choiceinput%==6 goto choice6
if %choiceinput%==7 goto choice7
if %choiceinput%==8 goto choice8
if %choiceinput%==0 goto choice0

:choice0
exit

:choice1
cls
timeout /t 5
echo.
echo Un Ping vas etre fait merci de cliquez sur une touche pour confirmer.
echo.
pause
cls
ping -n 1 www.google.com >nul
IF %errorlevel%==0 goto ConnexionOK
IF NOT %errorlevel%==0 goto ConnexionKO
:ConnexionOK
cls
echo C est bon vous etez bien connecter a internet.
:ConnexionKO
cls
echo Vous n etez pas connecter a internet merci de verifier vos parametre.
timeout /t 10
goto start

:choice2
cls
timeout /t 5
echo.
cls
echo Suppression des fichiers temporaires en cours...
del /s /f /q "%TEMP%\*.*" >nul 2>&1
for /d %%i in ("%TEMP%\*") do rd /s /q "%%i" >nul 2>&1
del /s /f /q "C:\Windows\Temp\*.*" >nul 2>&1
for /d %%i in ("C:\Windows\Temp\*") do rd /s /q "%%i" >nul 2>&1
PowerShell.exe -Command "Clear-RecycleBin -Force" >nul 2>&1
echo Nettoyage termine !
pause
cls
goto start

:choice3
cls
timeout /t 5
echo.
cls
setlocal

REM === CONFIGURATION ===
set "NOM_CLE_USB=MaCleUSB"  REM Nom affiché dans l’explorateur (volume label)

REM === DEMANDE DU FICHIER À L'UTILISATEUR ===
set /p FICHIER_SOURCE=Entrez le chemin complet du fichier à sauvegarder :

REM === VÉRIFICATION DU FICHIER ===
if not exist "%FICHIER_SOURCE%" (
    echo Le fichier "%FICHIER_SOURCE%" n'existe pas.
    pause
    exit /b
)

REM === DÉTECTION DE LA CLÉ USB ===
set "CLE_USB="

for /f "tokens=1,2*" %%i in ('wmic logicaldisk get name^, volumename ^| findstr /R /C:"[A-Z]:"') do (
    if /i "%%k"=="%NOM_CLE_USB%" (
        set "CLE_USB=%%i"
    )
)

if not defined CLE_USB (
    echo  Clé USB "%NOM_CLE_USB%" non détectée.
    pause
    exit /b
)

REM === COPIE DU FICHIER ===
echo  Clé USB détectée sur %CLE_USB%
echo  Copie de "%FICHIER_SOURCE%" vers "%CLE_USB%\"

copy "%FICHIER_SOURCE%" "%CLE_USB%\" /Y >nul
if %errorlevel%==0 (
    echo  Sauvegarde réussie !
) else (
    echo erreur lors de la copie.
)

pause
endlocal
goto start