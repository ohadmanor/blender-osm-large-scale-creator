import os
import sys
import bpy

def Installosm():
    bpy.ops.preferences.addon_enable(module="blender-osm")
    print("****************** OSM Addon Install")

Installosm()
bpy.ops.wm.quit_blender()