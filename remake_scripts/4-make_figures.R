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
