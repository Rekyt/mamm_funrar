# Functions to be used to rasterize ranges and compute functional rarity over
# all mammals given by IUCN spatial data using PanTHERIA traits

# Common Species List between IUCN & PanTHERIA ---------------------------------
get_common_species = function(iucn_ranges, pantheria_traits) {

    # List of species in common between IUCN range maps and PanTHERIA traits
    common_species = intersect(iucn_ranges[["binomial"]],
                               pantheria_traits[["MSW05_Binomial"]])

    return(common_species)
}


# Return IUCN ranges only for species in common --------------------------------

common_iucn_ranges = function(iucn_ranges, pantheria_traits) {

    common_species = get_common_species(iucn_ranges, pantheria_traits)

    proj4string(iucn_ranges) = "+proj=longlat +ellps=WGS84 +datum=WGS84 +no_defs "

    return(iucn_ranges[iucn_ranges$binomial %in% common_species,])
}


# Return PanTHERIA traits only for species in common ---------------------------

common_pan_traits = function(iucn_ranges, pantheria_traits) {

    common_species = get_common_species(iucn_ranges, pantheria_traits)

    return(pantheria_traits[
        pantheria_traits[["MSW05_Binomial"]] %in% common_species,])
}



# Rasterize IUCN ranges --------------------------------------------------------

rasterize_iucn_ranges = function(iucn_ranges, resolution = 3) {

    iucn_raster = raster()
    res(iucn_raster) = 3

    iucn_raster = rasterize(iucn_ranges, iucn_raster, field = "binomial",
                            fun = function(x,...)length(na.omit(x)))

    return(iucn_raster)
}
