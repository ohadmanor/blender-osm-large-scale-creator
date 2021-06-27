# objTo3d-tiles
Node command line tool and module convert obj model file to 3D Tiles, based on [obj2gltf](https://github.com/AnalyticalGraphicsInc/obj2gltf).

>NOTE: Only support `.b3dm` and `.i3dm` for now!
>
>Please use Cesium after v1.37, cause this 3d tile use glTF2.0.

## Getting Start

```
npm install -g
```

### Basic Usage

* Convert `.obj` to `.gltf`

```
obj23dtiles -i ./bin/barrel/barrel.obj

```

* Convert `.obj` to `.glb`

```
obj23dtiles -i ./bin/barrel/barrel.obj -b  

```

>NOTE: If your model have tarnsparency texture please add `--checkTransparency` parameter.

>NOTE: If your model using blinn-phong material, and use occlusion when convert to PBR material, the model will looks darker.
>The `useOcclusion` default is false, remember adding `--useOcclusion` if your model using PBR material.


```

FeatureTable support following parameters : `position`, `orientation`, `scale`.


The `customTilesetOptions.json` can have options bellow, and these are fake values, please only add properties you need, other value will be auto calculate through `.obj` file.

```
{
    "longitude":      -1.31968,     // Tile origin's(models' point (0,0,0)) longitude in radian.
    "latitude":       0.698874,     // Tile origin's latitude in radian.
    "transHeight":    0.0,          // Tile origin's height in meters.
    "region":         true,         // Using region bounding volume.
    "box":            false,        // Using box bounding volume.
    "sphere":         false         // Using sphere bounding volume.
}
```
>NOTE: If you are not specify the `transHeight` option, your model will be place at earth ground surface, which means no matter what the height your models are,
>the lowerest point of your models will be place at `height = 0.0` on the earth. But if you want keep origin heigth you just need specify `transHeight = 0.0`.

Here are different bounding volumes.
<p align="center"><img src ="./pics/boundingvolume.png" /></p>

### Combine tilesets
You can combine tilesets into one `tileset.json` as external tileset.

```
obj23dtiles combine -i ./bin/barrel/output
```

## Using as node module
If you want to use this tool in node or debug, check out [how to use as node module](NODEUSAGE.md).


## Troubleshooting
First, make sure your `.obj` file is complete, normally include `.obj`, `.mtl` and textures like `.jpg` or `.png`.
You can preview your `.obj` model via "Mixed Reality Viewer" if you are in windows 10.
Otherwise you can use this [online viewer](https://3dviewer.net/).
<br />
<br />
Second, export `.glb` and check if it display correctly. You can use
[Cesium](https://www.virtualgis.io/gltfviewer/) or [Three.js](https://gltf-viewer.donmccurdy.com/) gltf viewer.
<br />
<br />
In the end, just export `.b3dm` or tileset and load in Cesium.

## Sample Data
Sample data under the `.bin\barrel\` folder. 

```
barrel\
    |
    - barrel.blend              --
    |                             |- Blender project file with texture.
    - barrel.png                --
    |
    - barrel.obj                --
    |                             |- Obj model files.
    - barrel.mtl                --
    |
    - customBatchTable.json     ---- Custom batchtable for b3dm.
    |
    - customTilesetOptions.json ---- Custom tileset optional parameters.
    |
    - customFeatureTable.json   ---- Custom FeatureTable for i3dm.
    |
    - customI3dmBatchTable.json ---- Custom BatchTable for i3dm.
    |
    - output\                   ---- Export data by using upper files.
        |
        - barrel.glb
        |
        - barrel.gltf
        |
        - barrel_batchTable.json    ---- Default batch table.
        |
        - Batchedbarrel\            ---- Tileset use b3dm
        |   |
        |   - tileset.json
        |   |
        |   - barrel.b3dm
        |
        - Instancedbarrel\          ---- Tileset use i3dm
        |   |
        |   - tileset.json
        |   |
        |   - barrel.i3dm
        |
        - BatchedTilesets\          ---- Tileset with custom tileset.json
            |
            - tileset.json
            |
            - barrel_withDefaultBatchTable.b3dm
            |
            - barrel_withCustonBatchTable.b3dm
```

## Resources
* Online glTF viewer, make sure your glTF is correct. [Cesium](https://www.virtualgis.io/gltfviewer/), [Three.js](https://gltf-viewer.donmccurdy.com/).
* [Cesium](https://github.com/AnalyticalGraphicsInc/cesium)
* [3D Tiles](https://github.com/AnalyticalGraphicsInc/3d-tiles)
* [glTF](https://github.com/KhronosGroup/glTF)

## Credits
Great thanks to Sean Lilley([@lilleyse](https://github.com/lilleyse)) for helping and advising.

Thanks [AnalyticalGraphicsInc](https://github.com/AnalyticalGraphicsInc) provide a lot of open source project (like [Cesium](https://github.com/AnalyticalGraphicsInc/cesium) and [3D Tiles](https://github.com/AnalyticalGraphicsInc/3d-tiles)) and creat a great GIS environment.

## License
[Apache License 2.0](https://github.com/PrincessGod/objTo3d-tiles/blob/master/LICENSE)
