@rem
@rem Copyright 2015 the original author or authors.
@rem
@rem Licensed under the Apache License, Version 2.0 (the "License");
@rem you may not use this file except in compliance with the License.
@rem You may obtain a copy of the License at
@rem
@rem      https://www.apache.org/licenses/LICENSE-2.0
@rem
@rem Unless required by applicable law or agreed to in writing, software
@rem distributed under the License is distributed on an "AS IS" BASIS,
@rem WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
@rem See the License for the specific language governing permissions and
@rem limitations under the License.
@rem

@if "%DEBUG%" == "" @echo off
@rem ##########################################################################
@rem
@rem  jsl-socket startup script for Windows
@rem
@rem ##########################################################################

@rem Set local scope for the variables with windows NT shell
if "%OS%"=="Windows_NT" setlocal

set DIRNAME=%~dp0
if "%DIRNAME%" == "" set DIRNAME=.
set APP_BASE_NAME=%~n0
set APP_HOME=%DIRNAME%..

@rem Resolve any "." and ".." in APP_HOME to make it shorter.
for %%i in ("%APP_HOME%") do set APP_HOME=%%~fi

@rem Add default JVM options here. You can also use JAVA_OPTS and JSL_SOCKET_OPTS to pass JVM options to this script.
set DEFAULT_JVM_OPTS=

@rem Find java.exe
if defined JAVA_HOME goto findJavaFromJavaHome

set JAVA_EXE=java.exe
%JAVA_EXE% -version >NUL 2>&1
if "%ERRORLEVEL%" == "0" goto execute

echo.
echo ERROR: JAVA_HOME is not set and no 'java' command could be found in your PATH.
echo.
echo Please set the JAVA_HOME variable in your environment to match the
echo location of your Java installation.

goto fail

:findJavaFromJavaHome
set JAVA_HOME=%JAVA_HOME:"=%
set JAVA_EXE=%JAVA_HOME%/bin/java.exe

if exist "%JAVA_EXE%" goto execute

echo.
echo ERROR: JAVA_HOME is set to an invalid directory: %JAVA_HOME%
echo.
echo Please set the JAVA_HOME variable in your environment to match the
echo location of your Java installation.

goto fail

:execute
@rem Setup the command line

set CLASSPATH=%APP_HOME%\lib\hu.blackbelt.judo.meta.jsl.ide.common.jar;%APP_HOME%\lib\hu.blackbelt.judo.meta.jsl.model.jar;%APP_HOME%\lib\hu.blackbelt.judo.meta.jsl.server.embedded.jar;%APP_HOME%\lib\org.eclipse.xtext.ide.jar;%APP_HOME%\lib\org.eclipse.xtext.jar;%APP_HOME%\lib\org.eclipse.xtext.util.jar;%APP_HOME%\lib\guice.jar;%APP_HOME%\lib\aopalliance.jar;%APP_HOME%\lib\org.eclipse.lsp4j.jar;%APP_HOME%\lib\org.eclipse.lsp4j.generator.jar;%APP_HOME%\lib\org.eclipse.xtend.lib.jar;%APP_HOME%\lib\org.eclipse.xtend.lib.macro.jar;%APP_HOME%\lib\org.eclipse.xtext.xbase.lib.jar;%APP_HOME%\lib\guava.jar;%APP_HOME%\lib\jsr305.jar;%APP_HOME%\lib\error_prone_annotations.jar;%APP_HOME%\lib\reload4j.jar;%APP_HOME%\lib\antlr-runtime.jar;%APP_HOME%\lib\org.eclipse.emf.ecore.change.jar;%APP_HOME%\lib\org.eclipse.emf.ecore.xmi.jar;%APP_HOME%\lib\org.eclipse.emf.ecore.jar;%APP_HOME%\lib\org.eclipse.emf.common.jar;%APP_HOME%\lib\org.eclipse.lsp4j.jsonrpc.jar;%APP_HOME%\lib\org.eclipse.equinox.common.jar;%APP_HOME%\lib\org.eclipse.osgi.jar;%APP_HOME%\lib\javax.inject.jar;%APP_HOME%\lib\gson.jar;%APP_HOME%\lib\failureaccess.jar;%APP_HOME%\lib\listenablefuture.jar;%APP_HOME%\lib\checker-qual.jar;%APP_HOME%\lib\j2objc-annotations.jar;%APP_HOME%\lib\commons-text.jar;%APP_HOME%\lib\commons-lang3.jar

@rem Execute jsl-socket
"%JAVA_EXE%" %DEFAULT_JVM_OPTS% %JAVA_OPTS% %JSL_SOCKET_OPTS%  -classpath "%CLASSPATH%" hu.blackbelt.judo.jsl.server.RunServer %*

:end
@rem End local scope for the variables with windows NT shell
if "%ERRORLEVEL%"=="0" goto mainEnd

:fail
rem Set variable JSL_SOCKET_EXIT_CONSOLE if you need the _script_ return code instead of
rem the _cmd.exe /c_ return code!
if  not "" == "%JSL_SOCKET_EXIT_CONSOLE%" exit 1
exit /b 1

:mainEnd
if "%OS%"=="Windows_NT" endlocal

:omega
