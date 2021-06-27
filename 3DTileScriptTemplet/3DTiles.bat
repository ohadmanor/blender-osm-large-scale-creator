echo off
echo start create 3D tiles

:: Get the project path
for %%i in ("%~dp0..") do SET Directory=%%~fi
set TilesDir=%~dp0
:: Set Blender folder
set BlenderFolder=%Directory%\blender
:: Set GLB Folder to Convert
SET GLBFolder=%TilesDir%GLB
if not exist %GLBFolder% mkdir %GLBFolder%
:: Set OBJ Folder to Convert
SET OBJFolder=%TilesDir%OBJ
if not exist %OBJFolder% mkdir %OBJFolder%
:: Get the folder name
for %%I in (.) do set CurrDirName=%%~nxI
:: Set Finel Tile Folder
SET TileFolder=%TilesDir%%CurrDirName%
if not exist %TileFolder% mkdir %TileFolder%

:: Generat OBJ, GLB 3D tiles from Blender
rmdir /S /Q %BlenderFolder%\TEMP\osm\osm
rmdir /S /Q %BlenderFolder%\TEMP\osm\texture
call %BlenderFolder%\blender startup.blend --background --python  3D_Tiles.py

:: Generate basic strcture of 3Dtiles based on OBJ2b3dm with tileset.json
for %%f in (%OBJFolder%\*.obj) do (
	cmd /c obj23dtiles -i %%f --tileset -p %OBJFolder%\%%~nf.json --output %CurrDirName%\Folder
)
cmd /c obj23dtiles combine -i  %CurrDirName%\

:: Generate finle b3dm
for %%f in (%GLBFolder%\*.glb) do (
	echo the file size . . . 
	echo %%~zf
	if %%~zf LSS 3000 (
		del %%f
		) else (
			cmd /c 3d-tiles-tools glbToB3dm -i %GLBFolder%\%%~nf.glb -f
			XCOPY /y %GLBFolder%\%%~nf.b3dm %TileFolder%\Tiles%%~nf\
		)
	)
pause