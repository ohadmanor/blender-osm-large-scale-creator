@name "place of worship";

@meta {
	classifyFacades: 0;
}

footprint {
	height: attr("height") | 8.;
	minHeight: attr("min_height");
	numLevels: 0;
	topHeight: 0.;
	roofShape: attr("roof:shape") | flat;
	roofHeight: attr("roof:height");
	roofOrientation: attr("roof:orientation");
	claddingMaterial:
		attr("building:material") | bldgAttr("building:material") | plaster
	;
	claddingColor:
		attr("building:colour")
		|
		bldgAttr("building:colour")
		|
		// plaster
		per_building(random_weighted(
			(#cfbc8e, 1),
			(#b8a594, 1),
			(#a3865f, 1)
		))
	;
}

facade {
// cladding material only
}

roof {
	roofCladdingMaterial: attr("roof:material") | bldgAttr("roof:material") | metal;
	roofCladdingColor:
		attr("roof:colour")
		|
		bldgAttr("roof:colour")
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