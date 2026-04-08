@echo off
echo ╔══════════════════════════════════╗
echo ║   SplitEasy — Build Android APK  ║
echo ╚══════════════════════════════════╝

:: Vérifier Java
java -version >nul 2>&1
if errorlevel 1 (
    echo ❌ Java non trouvé. Téléchargez JDK 17:
    echo    https://www.oracle.com/java/technologies/downloads/
    pause
    exit /b 1
)
echo ✅ Java trouvé

:: Chercher Android SDK
if "%ANDROID_HOME%"=="" (
    if exist "%USERPROFILE%\AppData\Local\Android\Sdk" (
        set ANDROID_HOME=%USERPROFILE%\AppData\Local\Android\Sdk
    )
)

if "%ANDROID_HOME%"=="" (
    echo ❌ Android SDK non trouvé.
    echo    Installez Android Studio: https://developer.android.com/studio
    pause
    exit /b 1
)
echo ✅ Android SDK: %ANDROID_HOME%

:: Compiler
echo 🔨 Compilation en cours...
call gradlew.bat assembleDebug --no-daemon

:: Résultat
if exist "app\build\outputs\apk\debug\app-debug.apk" (
    echo.
    echo ✅ APK généré: app\build\outputs\apk\debug\app-debug.apk
    echo.
    echo 📲 Copiez ce fichier sur votre téléphone Android
    echo    et appuyez dessus pour installer.
) else (
    echo ❌ Échec de la compilation.
)
pause
