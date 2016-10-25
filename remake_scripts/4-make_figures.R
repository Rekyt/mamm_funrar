# Functions to draw figures

# Function to draw richness map ------------------------------------------------

draw_richness_map = function(pres_mat) {

    site_coords = pres_mat[, 1:3]

    site_richness = rowSums(pres_mat[, -c(1:3)])

    site_df = data.frame(site_coords, SpeciesRichness = site_richness)

    richness_map = ggplot(site_df) +
        geom_tile(aes(x = Longitude, y = Latitude, fill = SpeciesRichness), width = 2) +
        borders(xlim = range(site_df$Longitude) + c(-2, 2),
                ylim = range(site_df$Latitude) + c(-2, -2)) +
        coord_proj(proj = "+proj=aea +lat_1=20 +lat_2=60 +lat_0=40 +lon_0=-96
                   +x_0=0 +y_0=0 +ellps=GRS80 +datum=NAD83 +units=m +no_defs ")
}


# From shapefile points make a grid --------------------------------------------

get_spatial_grid = function(shpfilename) {

    shp_layer = tools::file_path_sans_ext(basename(shpfilename))

    shpfile = readOGR(dirname(shpfilename), shp_layer)

    #shpfile = spTransform(shpfile, CRS(albers_proj4()))

    return(shpfile)
}

rasterize_vector_grid = function(vector_data) {

    raster_data = raster(crs = CRS(proj4string(vector_data)))

    # Extend for limits of grid
    extent(raster_data) = extend(extent(vector_data), 50000)

    # Resolution of 50km by 50km
    res(raster_data) = 50000

    raster_data = rasterize(vector_data, raster_data, fun = "count")

    return(raster_data)
}

# A function that returns North America Albers Equal Area Conic proj4 string
# ESRI: 102008
# http://spatialreference.org/ref/esri/north-america-albers-equal-area-conic/
albers_proj4 = function() {
    "+proj=aea +lat_1=20 +lat_2=60 +lat_0=40 +lon_0=-96 +x_0=0 +y_0=0
    +ellps=GRS80 +datum=NAD83 +units=m +no_defs "
}
