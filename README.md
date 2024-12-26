# This project meant to give an idea how to massive generated 3Dtiles from OSM.
to use this procedure you need to do the following:

1. you need to purchase the following blender add-on (Premium version is required): 
https://gumroad.com/l/blosm
https://wiki.openstreetmap.org/wiki/Blender

2. download blender - https://www.blender.org/download/
I suggest to download the portable version and extract it on this main folder under blender folder.
this result will create the following folder structure:
		blender\4.2
			   \blender.crt
			   \license
			   blender.exe
			   etc.

3. download your blosm premium version and extract it according to the following:
	blender-osm copy to blender\4.2\scripts\addons_core
	assests copy to blender\TEMP (you need to create the TEMP folder in the blender tree)
	
4. Download the GLTF add-on (**OBSOLETE!**)
	I'm not sure why the build in version do not work correctlly with the compression so I'm suggest for you to download it and replce the one that come with blender.

	download it from: https://github.com/KhronosGroup/glTF-Blender-IO/tree/master/addons/io_scene_gltf2
	go to blender\4.2\scripts\addons and delete the io_scene_gltf2 folder then copy the download version to blender\4.2\scripts\addons 

5. Install new version of 3d-tiles-tools
	a. download the latest code of 3d-tiles-tools from here https://github.com/CesiumGS/3d-tiles-tools
	b. extract the 3d-tiles-tools folder in to the 3DTiles folder and run npm install.

6. preaper the blnder enviroment (**OBSOLETE!**)
	run the ENV_Install.bat 
	this bat file do the following:
		1. install a helper tools (see sectionn 5):
			3d-tiles-tools - convert glb to B3dm
			obj23dtiles - tool to generate the tile json file. (**OBSOLETE!**)
		2. config blosm in blender.
	

6. Start to create you tiles:
	in the folder 3DTileScriptTemplet you will finde the following files:
	1. 3DTiles.bat - this start the creation of the 3Dtiles
	2. AreaToExtract.txt - this file contain the rectangle W,E,N,S in decimal number and the tile size the result will be: x1,x2,y1,y2,ts (ex. 35.3,35.8,33.0,32.6,0.1).
	3. 3D_Tiles.py - the script to generate the tile in blender.
	4. startup.blend - blender empty project.
	
	after you set the area to extract run the bat file.


# Blosm code changes after install new version.

## add external command to change the defult assets for 3d realistic
	in gui\__init__.py file under class BLOSM_OT_ReloadAssetPackageList(bpy.types.Operator): add the following function decleration:
		def execute(self, context):
			return self.invoke(context, None)

## fix the location of the building according to the position on the glob
in the util\transverse_mercator.py under class TransverseMercator in function def fromGeographic(self, lat, lon)
aacording to my expireance this fix need to be add according to the latitude position of your area.
if someone can add the correct function to calculate the divation it will be greate.
	
Latitude - 0-15, 15-30, 30-45, 45-60, 60-75

Latitude - 0-15 - Original
        x = 0.5 * self.k * self.radius * math.log((1.+B)/(1.-B))
        y = self.k * self.radius * ( math.atan(math.tan(lat)/math.cos(lon)) - self.latInRadians )

Latitude - 30-35
        x = 0.5005 * self.k * self.radius * math.log((1.+B)/(1.-B))
		y = 0.99616 * self.k * self.radius * ( math.atan(math.tan(lat)/math.cos(lon)) - self.latInRadians )

Latitude - 45-48
        x = 0.5007 * self.k * self.radius * math.log((1.+B)/(1.-B))
        y = 0.9988 * self.k * self.radius * ( math.atan(math.tan(lat)/math.cos(lon)) - self.latInRadians )

Latitude - 46-48
        x = 0.50095 * self.k * self.radius * math.log((1.+B)/(1.-B))
        y = 0.99915 * self.k * self.radius * ( math.atan(math.tan(lat)/math.cos(lon)) - self.latInRadians )

