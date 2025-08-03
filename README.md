# This project meant to give an idea how to massive generated 3Dtiles from OSM.
to use this procedure you need to do the following:

1. you need to purchase the following blender add-on (Premium version is required): 
	https://gumroad.com/l/blosm
	https://wiki.openstreetmap.org/wiki/Blender

2. download blender - https://www.blender.org/download/
	It is recommended to download the Portable version and extract it to folder blender in the main root (the blender folder need to be in the same hirrachy of the 3DTiles_Scripts folder). 
	if not you will need to fix the 3dtiles scripts according to the Blender installation.

3. Download the blosm add-on and extract it to the Blender add on folder:
	blender\4.4\scripts\addons_core.

4. Fix the blosm add-ons according to the files in the blosm-files-to-fix folder according to the following (recommnaded to use compare tool):
	1. __init__.py and app\blender.py - add more source to download osm tiles.
	2. app\blender.py - fix clamp to ground for cesium
	3. gui\__init__.py - add responce to extewrnal script.
	4. util\transverse_mercator.py - fix the building position accuracy around the glob (not localy tile) during export

5 Create working enviroment
	the stage can be done by script or manual to do tha following:
	1. Install 3d-tiles-tools (https://github.com/CesiumGS/3d-tiles-tools) - this tool convert GLB files to 3DTiles (.b3dm)
	2. Configure blsom in the blender
	the script to do that is in the 3DTiles_Scripts - ENV_Install.bat

6. Start to create you tiles:
	This script can create multiple areas of 3Dtiles with full indexing. do do that do the following:
	1. Create text areas file:
		in the Areas folder you need to create a file woth the following lines:
			Area_Name=<Name> - any text
			Assets=<blosm_assets_name> - default
			Res=<float> - this represent the size of the tile in decimal dgree. 0.1 is the recommanded size the represent 11 square km or 7 square miles.
			<name_of_sub_area_1>=west,east,north,south
			<name_of_sub_area_2>=west,east,north,south
			.
			.
			.
			
			EX:
			Area_Name=Demo
			Assets=default
			Res=0.1
			Demo_A=-6.5,-5,36.0,34.5
			Demo_B=-4.9,-3,35.5,34.5
			Demo_C=-2.9,-1,35.5,34.5
			Demo_D=-0.9,1,36.5,34.5
			Demo_E=-7,-5,34.4,33.5

		more examples can be found in the folder.

	2. Run the script:
		in the 3DTiles_Scripts run the 3DTiles.bat.
		this script will read the Areas files and according to that will generate a 3DTiles sets fit to stream in ceasium.
		in the end a new folder Cesium3DTileset will create and in it you will find an Area folders with the 3Dtiles.

