echo off
echo Install 3D tiles Enviroment

for %%i in ("%~dp0..") do SET Directory=%%~fi

cd /D %Directory%\3d-tiles-tools
cmd /c npm install 3d-tiles-tools

set BlenderFolder=%Directory%\blender
set PATH=%PATH%;%BlenderFolder%
cd /D %Directory%\3DTiles_Scripts
call blender startup.blend --python  setup.py

echo Installation has done

pause
exit