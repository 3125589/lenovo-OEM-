@echo off
@:init
@setlocal DisableDelayedExpansion
@set "batchPath=%~0"
@for %%k in (%0) do set batchName=%%~nk
@set "vbsGetPrivileges=%temp%\OEgetPriv_%batchName%.vbs"
@setlocal EnableDelayedExpansion

@:checkPrivileges
@NET FILE 1>NUL 2>NUL
@if '%errorlevel%' == '0' ( goto gotPrivileges ) else ( goto getPrivileges )

@:getPrivileges
@if '%1'=='ELEV' (echo ELEV & shift /1 & goto gotPrivileges)
@ECHO.
@ECHO **************************************
@ECHO 获取Administrator权限中，请点击同意！
@ECHO **************************************

@ECHO Set UAC = CreateObject^("Shell.Application"^) > "%vbsGetPrivileges%"
@ECHO args = "ELEV " >> "%vbsGetPrivileges%"
@ECHO For Each strArg in WScript.Arguments >> "%vbsGetPrivileges%"
@ECHO args = args ^& strArg ^& " "  >> "%vbsGetPrivileges%"
@ECHO Next >> "%vbsGetPrivileges%"
@ECHO UAC.ShellExecute "!batchPath!", args, "", "runas", 1 >> "%vbsGetPrivileges%"
@"%SystemRoot%\System32\WScript.exe" "%vbsGetPrivileges%" %*
@exit /B

@:gotPrivileges
@setlocal & pushd .
@cd /d %~dp0
@if '%1'=='ELEV' (del "%vbsGetPrivileges%" 1>nul 2>nul  &  shift /1)

@::::::::::::::::::::::::::::
@::START
@::::::::::::::::::::::::::::
(for /f "delims=" %%i in ('diskpart /s %cd%\b.txt') do echo %%i)>a.txt
for /f "tokens=*" %%i in ('findstr "20"  %cd%\a.txt') do set T=%%i
for /f %%i in ("%T:~8,1%") do (echo %%i>%cd%\pn.txt)
@echo off&&setlocal enabledelayedexpansion
for /f "tokens=*" %%i in (%cd%\disk_s.txt) do (
set var=%%i
set "var=!var:9999= %T:~8,1%!"
echo !var!>>%cd%\disk_s_fin.txt
)

diskpart /s %cd%\disk_s_fin.txt

@del %cd%\disk_s_fin.txt
@del %cd%\a.txt