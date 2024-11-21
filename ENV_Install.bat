echo off
echo Install 3D tiles Enviroment

set Directory=%~dp0

set BlenderFolder=%Directory%\blender
call %BlenderFolder%\blender startup.blend --python  setup.py

echo Installation has done

pause