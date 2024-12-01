@name "high rise";

@meta {
	buildingUse: office;
	classifyFacades: 0;
}

footprint {
	height: attr("height");
	minHeight: attr("min_height");
	numLevels: attr("building:levels") | if (not item["height"]) random_weighted( (4, 10), (5, 40), (6, 10) );
	minLevel: attr("building:min_level") | 0;
	topHeight: 0.;
	levelHeight: random_normal(3.);
	roofShape: attr("roof:shape") | flat;
	roofHeight: attr("roof:height");
	roofOrientation: attr("roof:orientation");
	claddingMaterial:
		attr("building:material")
		|
		bldgAttr("building:material")
		|
		per_building( random_weighted( (brick, 1), (plaster, 1) ) )
	;
	claddingColor:
		attr("building:colour")
		|
		bldgAttr("building:colour")
		|
		if (item["claddingMaterial"] == "brick") per_building(random_weighted(
			(#ede9e4, 1),
			(#cfcfcf, 1),
			(#ede8e8, 1)
		))
		|
		if (item["claddingMaterial"] == "plaster") per_building(random_weighted(
			(#ede9e4, 1),
			(#cfcfcf, 1),
			(#ede8e8, 1)
		))
		|
		if (item["claddingMaterial"] == "glass") per_building(random_weighted(
            (#4e7292, 1),
            (#2b515c, 1),
            (#182e45, 1)
		))
		|
		// grayish for concrete
		per_building(random_weighted(
			(#ede9e4, 1),
			(#cfcfcf, 1),
			(#ede8e8, 1)
		))
	;
}

facade(
	not item.footprint.numLevels or
	item.footprint.height - item.footprint.minHeight < 1.5 or // minHeightForLevels
	item.width < 1. // minWidthForOpenings
	or item.footprint["roofShape"] in ("gabled", "round", "gambrel", "saltbox")
) {
	label: "cladding only for structures without levels or too low structures or too narrow facades";
}

facade(item.footprint["claddingMaterial"] == "glass") {
	markup: [
		curtain_wall{}
		bottom {
			claddingMaterial: brick;
			claddingColor: #f5f1e9;
		}
	]
}

facade {
	markup: [
		level{}
	]
}

roof {
	roofCladdingMaterial:
		attr("roof:material")
		|
		bldgAttr("roof:material")
		|
		if (item.footprint["roofShape"] == "flat") concrete
		|
		metal
	;
	roofCladdingColor:
		attr("roof:colour")
		|
		bldgAttr("roof:colour")
		|
		if (item["roofCladdingMaterial"] == "concrete") per_building(random_weighted(
            (#afafaf, 1),
            (#b2b2a6, 1),
            (#c8c2b6, 1)
		))
		|
		if (item["roofCladdingMaterial"] == "roof_tiles") per_building(random_weighted(
            (#8a5c4d, 1),
            (#c57a63, 1),
            (#a6653f, 1)
		))
		|
		// roofCladdingMaterial == "metal"
		per_building(random_weighted(
            (#494c57, 1),
            (#5e2a31, 1),
            (#818b8f, 1)
		))
	;
	faces: if (item.footprint["roofShape"] in ("dome", "onion")) smooth;
}