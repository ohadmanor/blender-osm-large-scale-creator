echo off
@SETLOCAL enabledelayedexpansion
echo start create 3D tiles Indexing

:: Get the project path
for %%i in ("%~dp0..") do SET Directory=%%~fi
for %%I in (.) do set CurrDirName=%%~nxI

set tiletool=%Directory%\3d-tiles-tools

for /f "delims=" %%d in ('dir /a:d /b') do (
	set /p= -i %%d\tileset.json <nul >>temp.txt
	)

REM set /p command=<temp.txt :: OLD
for /f "tokens=* delims=" %%c in (temp.txt) do set command=!command!%%c
cmd /c npx ts-node %tiletool%\src\cli\main.ts merge %command% -o .\ -f

del /f temp.txt

pause