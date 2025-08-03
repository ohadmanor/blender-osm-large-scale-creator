echo off
@SETLOCAL enabledelayedexpansion
SET NODE_OPTIONS=--max-old-space-size=8192
if not defined iammaximized (
    set iammaximized=1
    start /max "" "%0" "%*"
    exit
)
call :setESC
set startTime1="%time: =0%"

echo %ESC%[41m
echo **********************************************************************
echo                           start create 3D tiles                       
echo **********************************************************************
echo %ESC%[0m

:: Get the project path
for %%i in ("%~dp0..") do SET Directory=%%~fi
:: Generat GLB 3D tiles from Blender
set tiletool=%Directory%\3d-tiles-tools
set AreaCmd=%Directory%\Areas
set BlenderFolder=%Directory%\blender
set PATH=%PATH%;%BlenderFolder%

for %%h in (%AreaCmd%\*.txt) do (
	echo Area Name: %%~nh
	SET commandFile=%AreaCmd%\%%~nh.txt
	echo Reading and executing commands from !commandFile!...

	for /F "delims== tokens=1,2" %%a in (!commandFile!) do (
		set ver=%%a
		set val=%%b
		
		if !ver!==Area_Name (
			set Main_Folder=!val!
			if not exist %Directory%\Cesium3DTileset\!Main_Folder! mkdir %Directory%\Cesium3DTileset\!Main_Folder!
		)
		if !ver!==Assets set AreaAssete=!val!
		if !ver!==Res set AreaRes=!val!
		if NOT !ver!==Area_Name (
			if NOT !ver!==Assets (
				if NOT !ver!==Res (
					set Sub_Area=!ver!
					:: Set Finel Tile Folder
					set Sub_Area_Folder=%Directory%\Cesium3DTileset\!Main_Folder!\!Sub_Area!
					if not exist !Sub_Area_Folder! mkdir !Sub_Area_Folder!
					:: Set GLB Folder to Convert
					set GLB_Folder=!Sub_Area_Folder!\GLB
					if not exist !GLB_Folder! mkdir !GLB_Folder!
					:: Clean Cahce Folders
					rmdir /S /Q %Directory%\3D_Assets\osm\osm
					rmdir /S /Q %Directory%\3D_Assets\osm\texture
					set p_values=!val!,!AreaRes!,!AreaAssete!,!Sub_Area!,!Main_Folder!
					echo %ESC%[41m
					echo ******  Start Blender  *******
					echo %ESC%[0m
					call blender -b startup.blend --background -P 3D_Tiles.py -- !p_values!
					echo %ESC%[41m
					echo ******  Stop Blender  *******
					echo %ESC%[0m
					REM :: Generate finle b3dm
					for %%f in (!GLB_Folder!\*.glb) do (
						echo the file size: %%~zf
						if %%~zf LSS 896 (
							del !GLB_Folder!\%%~nf.glb
							del !GLB_Folder!\%%~nf.json
							) else (
								if not exist !Sub_Area_Folder!\t%%~nf mkdir !Sub_Area_Folder!\t%%~nf
								for /f "delims==" %%x in (!GLB_Folder!\%%~nf.json) do set data=%%x
								cmd /c npx ts-node !tiletool!\src\cli\main.ts glbToB3dm -i !GLB_Folder!\%%~nf.glb -o !Sub_Area_Folder!\t%%~nf\%%~nf.b3dm -f
								cmd /c npx ts-node !tiletool!\src\cli\main.ts createTilesetJson -i !Sub_Area_Folder!\t%%~nf\%%~nf.b3dm -o !Sub_Area_Folder!\t%%~nf\tileset.json --cartographicPositionDegrees !data! -f
						)
					)
					
					rmdir /S /Q !GLB_Folder!
					echo !Sub_Area_Folder!
					cd !Sub_Area_Folder!
					call :indexing		
					cd %Directory%\3DTiles_Scripts
				)
			)
		)
	)
	cd %Directory%\Cesium3DTileset\!Main_Folder!
	if !Main_Folder!==ISR (
		mkdir %Directory%\Cesium3DTileset\!Main_Folder!\malatiles
		XCOPY %Directory%\3D_Assets\malatiles\* %Directory%\Cesium3DTileset\!Main_Folder!\malatiles /s /i /q /y
	)
	call :Indexing
	cd %Directory%\3DTiles_Scripts
)
echo %ESC%[41m
echo All commands executed.
echo %ESC%[m

pause
exit


:setESC
for /F "tokens=1,2 delims=#" %%a in ('"prompt #$H#$E# & echo on & for %%b in (1) do rem"') do (
  set ESC=%%b
  exit /B 0
)
exit /B 0

:indexing
for /f "delims=" %%d in ('dir /a:d /b') do (
	set /p= -i %%d\tileset.json <nul >>temp.txt
)
for /f "tokens=* delims=" %%c in (temp.txt) do set command=!command!%%c
cmd /c npx ts-node !tiletool!\src\cli\main.ts merge !command! -o .\ -f
set command=
del /f temp.txt
exit /B 0


endlocal