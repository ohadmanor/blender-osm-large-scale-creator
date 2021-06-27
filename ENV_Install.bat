echo off
echo Install 3D tiles Enviroment

set Directory=%~dp0

cmd /c npm install %Directory%3DTools\3d-tiles-tools\ -g 3d-tiles-tools
cmd /c npm install %Directory%3DTools\obj23dtiles\ -g obj23dtiles

set BlenderFolder=%Directory%\blender
call %BlenderFolder%\blender startup.blend --python  setup.py

echo Installation had done

pause