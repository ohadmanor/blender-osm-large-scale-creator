echo off
@SETLOCAL enabledelayedexpansion
SET NODE_OPTIONS=--max-old-space-size=8192
echo start create 3D tiles

:: Get the project path
for %%i in ("%~dp0..") do SET Directory=%%~fi
set TilesDir=%~dp0
:: Set Blender folder
set BlenderFolder=%Directory%\blender
set tiletool=%Directory%\3d-tiles-tools
:: Set GLB Folder to Convert
SET GLBFolder=%TilesDir%GLB
if not exist %GLBFolder% mkdir %GLBFolder%
:: Get the folder name
for %%I in (.) do set CurrDirName=%%~nxI
:: Set Finel Tile Folder
SET TileFolder=%TilesDir%%CurrDirName%

if not exist %TileFolder% mkdir %TileFolder%
:: Generat GLB 3D tiles from Blender
rmdir /S /Q %BlenderFolder%\TEMP\osm\osm
rmdir /S /Q %BlenderFolder%\TEMP\osm\texture
call %BlenderFolder%\blender startup.blend --background --python  3D_Tiles.py

:: Generate finle b3dm
for %%f in (%GLBFolder%\*.glb) do (
	echo the file size: %%~zf
	if %%~zf LSS 896 (
		del %GLBFolder%\%%~nf.glb
		del %GLBFolder%\%%~nf.json
		) else (
			if not exist %TileFolder%\t%%~nf mkdir %TileFolder%\t%%~nf
			for /f "delims==" %%x in (%GLBFolder%\%%~nf.json) do set data=%%x
			cmd /c npx ts-node %tiletool%\src\cli\main.ts glbToB3dm -i %GLBFolder%\%%~nf.glb -o %TileFolder%\t%%~nf\%%~nf.b3dm -f
			cmd /c npx ts-node %tiletool%\src\cli\main.ts createTilesetJson -i %TileFolder%\t%%~nf\%%~nf.b3dm -o %TileFolder%\t%%~nf\tileset.json --cartographicPositionDegrees !data! -f
		)
	)

for /f "delims=" %%d in ('dir %CurrDirName% /a:d /b') do (
	set /p= -i %%d\tileset.json <nul >>temp.txt
	)

for /f "tokens=* delims=" %%c in (temp.txt) do set command=!command!%%c

cd %TilesDir%%CurrDirName%
cmd /c npx ts-node %tiletool%\src\cli\main.ts merge %command% -o .\ -f

cd %TilesDir%
del /f temp.txt

pause