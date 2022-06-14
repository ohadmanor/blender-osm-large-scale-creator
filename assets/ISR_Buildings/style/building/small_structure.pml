@name "small structure";

@meta {
	classifyFacades: 0;
}

footprint {
	height: attr("height") | 3.;
	minHeight: attr("min_height");
	numLevels: 0;
	topHeight: 0.;
	roofShape: attr("roof:shape") | flat;
	roofHeight: attr("roof:height") | 1.;
	roofOrientation: attr("roof:orientation");
	claddingMaterial:
		attr("building:material") | bldgAttr("building:material") | brick
	;
	claddingColor:
		attr("building:colour")
		|
		bldgAttr("building:colour")
		|
		// brick
		per_building(random_weighted(
			(#ede9e4, 1),
			(#cfcfcf, 1),
			(#ede8e8, 1)
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