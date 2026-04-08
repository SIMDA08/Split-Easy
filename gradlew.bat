@rem Gradle startup script for Windows
@rem
@if "%DEBUG%"=="" @echo off
@rem ##########################################################################
set DIRNAME=%~dp0
set APP_HOME=%DIRNAME%

java %JAVA_OPTS% -classpath "%APP_HOME%\gradle\wrapper\gradle-wrapper.jar" ^
  org.gradle.wrapper.GradleWrapperMain %*
