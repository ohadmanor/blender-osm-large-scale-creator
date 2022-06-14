import os
import sys
import bpy
import pathlib
import math
import json
import requests
from pathlib import Path

# Functions
os.system("")

class style():
    RED = '\033[91m'
    BCKRED = '\033[101m'
    GREEN = '\033[92m'
    BCKGREEN = '\033[102m'
    YELLOW = '\033[93m'
    BCKYELLOW = '\033[103m'
    BLUE = '\033[34m'
    BCKBLUE = '\033[44m'
    WHITE = '\033[97m'
    CBLINK = '\033[5m'
    CBLINK2 = '\033[6m'
    RESET = '\033[0m'

def pause():
    programPause = input("Press the <ENTER> key to continue...")

def Coord_X(startX, endX, stepX):
    while startX <= endX:
        yield startX
        startX += stepX

def Coord_Y(startY, endY, stepY):
    while endY < startY:
        yield startY
        startY -= stepY

def ImportTerrain():
    bpy.context.scene.blosm.dataType = 'terrain'
    bpy.context.scene.blosm.ignoreGeoreferencing = True
    bpy.context.scene.blosm.terrainReductionRatio = '1'
    bpy.ops.object.shade_smooth()
    bpy.ops.blosm.import_data()      

def ImportOSM():
    bpy.context.scene.blosm.dataType = 'osm'
    bpy.context.scene.blosm.osmSource = 'server'
    bpy.context.scene.blosm.terrainObject = "Terrain"
    bpy.context.scene.blosm.mode = '3Drealistic'
    bpy.context.scene.blosm.assetPackage = 'ISR_Buildings_2'
    bpy.context.scene.blosm.importForExport = True
    bpy.context.scene.blosm.buildings = True
    bpy.context.scene.blosm.forests = True
    bpy.context.scene.blosm.treeDensity = 30
    bpy.context.scene.blosm.singleObject = True
    bpy.context.scene.blosm.ignoreGeoreferencing = True
    bpy.ops.blosm.import_data()

def ConvertForest():
    bpy.data.objects['Terrain'].select_set(True)
    bpy.data.particles["forest"].display_percentage = 100
    bpy.ops.object.duplicates_make_real()
    bpy.ops.object.select_all(action='DESELECT')

def reset_blend():
    for scene in bpy.data.scenes:
        for obj in scene.objects:
            bpy.data.objects.remove(obj)

    for scene in bpy.context.scene.collection.children:
        bpy.context.scene.collection.children.unlink(scene)

def ChnageOSMServer():
    global OSMServer
    if OSMServer == "overpass-api.de":
        OSMServer = "openstreetmap.tw"
    elif OSMServer == "openstreetmap.tw":
        OSMServer = "vk-maps"
    elif OSMServer == "vk-maps":
        OSMServer = "kumi.systems"
    elif OSMServer == "kumi.systems":
        OSMServer = "openstreetmap.fr"  
    elif OSMServer == "openstreetmap.fr":
        OSMServer = "overpass-api.ru"
    elif OSMServer == "overpass-api.ru":
        OSMServer = "overpass-api.de-NEW"        
    elif OSMServer == "overpass-api.de-NEW":
        OSMServer = "overpass-api.de-NEW2"        
    else:
        OSMServer = "overpass-api.de"
    bpy.context.preferences.addons["blender-osm"].preferences.osmServer = OSMServer
    print(style.BCKRED + "*** The New OSM Server is:" + OSMServer + style.RESET)
    
def CreateTile(GLBFileName, OBJFileName):
    # Clear unnessesry objects
    for layerScene in bpy.data.collections:
        layerScene.name
        layerName = layerScene.name.split('.')[0] + ".osm_forest"
        for layerObjects in layerScene.objects:
            layerObjects.name 
            if layerObjects.name == layerName:
				# Add Forest to the tiles
                ConvertForest()
                bpy.data.objects.remove(bpy.context.scene.objects[layerObjects.name], do_unlink = True)
                print(style.BLUE)
                print("*********************************************")
                print("**********  Clean Layer: " + layerName)
                print("*********************************************")
                print(style.RESET)
    bpy.data.objects.remove(bpy.context.scene.objects["Terrain_envelope"], do_unlink = True)
    # Clear Terrain
    bpy.data.objects['Terrain'].select_set(True)
    bpy.ops.object.delete()
    # Export
    # Export to GLB file
    bpy.ops.export_scene.gltf(
        export_format='GLB',
        export_texture_dir='',
        export_copyright='',
        will_save_settings=True,
        ui_tab='GENERAL',
        # Include
        use_mesh_edges = True,
        use_mesh_vertices = False,
        export_selected=False,
        use_selection = False,
        use_visible = False,
        use_renderable = False,
        use_active_collection = False,
        export_extras=False,
        export_cameras=False,
        export_lights=False,
        # Transform
        export_yup=True,
        # Geometry
        export_apply=False,
        export_texcoords=True,
        export_normals=True,
        export_tangents=False,
        export_colors=False,
        export_materials='EXPORT',
        export_image_format='AUTO',
        # Geometry Compression     
        # export_draco_mesh_compression_enable (boolean, (optional)) – Draco mesh compression, Compress mesh using Draco
        # export_draco_mesh_compression_level [0, 10] {6}– Compression level, Compression level 0 = most speed, 6 = most compression, higher values currently not supported
        # export_draco_position_quantization [0, 30] {14} – Position quantization bits, Quantization bits for position values (0 = no quantization)
        # export_draco_normal_quantization [0, 30] {10} – Normal quantization bits, Quantization bits for normal values (0 = no quantization)
        # export_draco_texcoord_quantization [0, 30] {12} – Texcoord quantization bits, Quantization bits for texture coordinate values (0 = no quantization)
        # export_draco_color_quantization [0, 30] – Color quantization bits, Quantization bits for color values (0 = no quantization)
        # export_draco_generic_quantization [0, 30] {12} – Generic quantization bits, Quantization bits for generic coordinate values like weights or joints (0 = no quantization)
  
        export_draco_mesh_compression_enable=True,
        export_draco_mesh_compression_level=6,
        export_draco_position_quantization=0,
        export_draco_normal_quantization=10,
        export_draco_color_quantization=0,
        export_draco_texcoord_quantization=12,
        export_draco_generic_quantization=12,
        # Animation
        export_current_frame=False,
        export_animations=False,
        export_frame_range=False,
        export_frame_step=1,
        export_force_sampling=False,
        export_nla_strips=False,
        export_def_bones=False,
        # Animation Shape Keys
        export_morph=False,
        export_morph_normal=False,
        export_morph_tangent=False,
        # Animation Skinning
        export_skins=False,
        export_all_influences=False,
        export_displacement=False,
        filepath = GLBFileName
        )

    # Export to OBJ
    bpy.ops.export_scene.obj(
        filepath=OBJFileName,
        use_selection=False,
        use_animation=False,
        use_mesh_modifiers=False,
        use_edges=True,
        use_smooth_groups=False,
        use_smooth_groups_bitflags=False,
        use_normals=False,
        use_uvs=False,
        use_materials=False,
        use_triangles=True,
        use_nurbs=False,
        use_vertex_groups=True,
        use_blen_objects=False,
        group_by_object=False,
        group_by_material=False,
        keep_vertex_order=True,
        global_scale=1.0,
        path_mode='AUTO',
        axis_forward='-Z',
        axis_up='Y'
        )

### Main
# Find the current working folder
(ParentFolder, WorkingFolder) = os.path.split(os.getcwd())
dirname = os.path.dirname(__file__)

# Read Data set polygon to generate 3D tiles the formant is X-left,X-right,Y-up,Y-down,Tile-Size and phrsing to X1,X2,Y1,Y2,T
coord = open("AreaToExtract.txt", "r")
for Value in coord:
    Value = Value.rstrip()
    X1, X2, Y1, Y2, T = Value.split(',')
# Convert string to float
Cxl = float(X1)
Cxr = float(X2)
Cyu = float(Y1)
Cyd = float(Y2)
Size = float(T)
print (style.BCKBLUE)
print ("***********************************************************************")
print ("             X coordinat - Left / Right:", Cxl, " / ", Cxr)
print ("             Y coordinat - Up / Down:", Cyu, " / ", Cyd)
print ("             Tile Size:", Size)
print ("***********************************************************************")
print (style.RESET)

# set OSM server
OSMServer = ""
ChnageOSMServer()
DD = os.path.join(ParentFolder + '/blender/TEMP/osm/')
AD = os.path.join(ParentFolder + '/blender/TEMP/assets/')
bpy.context.preferences.addons["blender-osm"].preferences.dataDir = DD
bpy.context.preferences.addons["blender-osm"].preferences.assetsDir = AD
bpy.context.preferences.addons["blender-osm"].preferences.enableExperimentalFeatures = True
bpy.ops.blosm.reload_asset_package_list("INVOKE_DEFAULT")
# Create Tiles with the json files
for Lon in Coord_X(Cxl, Cxr, Size):
    for Lat in Coord_Y(Cyu, Cyd, Size):
        print(style.BCKGREEN)
        print(round(Lon, 3),round(Lat, 3))
        print(style.RESET)
        #pause()
        GLBTileName = os.path.join(dirname, 'GLB', str(round(Lon, 3))+'_'+str(round(Lat, 3)))
        OBJTileName = os.path.join(dirname, 'OBJ', str(round(Lon, 3))+'_'+str(round(Lat, 3))+'.obj')
        JsonTileName = os.path.join(dirname, 'OBJ', str(round(Lon, 3))+'_'+str(round(Lat, 3))+'.json')
        filePath = Path(GLBTileName+'.glb')
        if filePath.is_file():
            print(style.YELLOW)
            print ("******** The File " + GLBTileName + " exists, move to next file  ********")
            print(style.RESET)
        else:
            # Create the tiles 
            # Set Tile coordinate
            bpy.context.scene.blosm.maxLat = round(Lat, 3)
            bpy.context.scene.blosm.minLat = round(Lat, 3) - round(Size, 3)
            bpy.context.scene.blosm.maxLon = round(Lon, 3) + round(Size, 3)
            bpy.context.scene.blosm.minLon = round(Lon, 3)
            while True:
                try:
                    
                    ImportTerrain()
                    ImportOSM()
                    break
                except:
                    print(style.BCKRED)
                    print("**** OSM Tile Import Fail . . . ****")
                    print(style.RESET)
                    reset_blend()
                    ChnageOSMServer()
            CreateTile(GLBTileName, OBJTileName)
            reset_blend()
            # Create Json file
            # Find the center of the tile
            Cxm = round((Lon + (Size/2)), 3)
            Cym = round((Lat - (Size/2)), 3)
            ### Convert the center coordinate from Geo to Cartesian 
            XTileCenter = (Cxm * (math.pi/180))
            YTileCenter = (Cym * (math.pi/180))
            # Get the elevation of the center with DEM service elevation API
            eleurl = "https://sag.4castdemo.com:25400/api/Terrain/GetLocationElevation"
            position = {'x': Cxm, 'y': Cym}
            TileElevation = requests.get(url = eleurl, params = position)
            Elevation = TileElevation.json()
            ElevationData = round(Elevation) - Elevation - 1.8
            # Write the Json configuration file
            TilePosition = {
                "longitude": XTileCenter,
                "latitude": YTileCenter,
                "transHeight": ElevationData
            }
            TilePosition = json.dumps(TilePosition, indent = 3)
            print(style.BLUE)
            print(TilePosition)
            print(style.RESET)
            with open(JsonTileName, 'w') as json_file:
                json_file.write(TilePosition)
        print(style.BCKBLUE)
        print("***************************************************************************************************************")
        print("***************************************************************************************************************")
        print("***************************************************************************************************************")
        print(style.RESET)
