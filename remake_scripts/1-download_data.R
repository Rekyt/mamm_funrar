# Function to download data from Lawing et al. 2015 doi:10.5061/dryad.9t0n8

download_lawing_2015 = function() {
    # Get the handle to download the data from Dryad
    dryad_handle = "10255/dryad.116171"

    dryad_dir = paste0("data/raw/", strsplit(dryad_handle, "/", fixed = T)[[1]][2],
                       "/")


    # Create corresponding directory
    dir.create(dryad_dir, recursive = TRUE, showWarnings = FALSE)

    # Archive File Name
    dryad_archive = paste0(dryad_dir,"DataArchive.zip")


    # Create a temporary file
    tempfile(dryad_archive)

    # Download file
    dryad_fetch(download_url(dryad_handle), destfile = dryad_archive, mode = "wb")

    # Extract archive
    unzip(dryad_archive, exdir = substr(dryad_dir, 1, nchar(dryad_dir) - 1))

    # Clean Up Temporary File
    unlink(dryad_archive)
}



# Function download shapefile data ---------------------------------------------

download_shapefile_grid = function() {
    url = "http://mypage.iu.edu/~pdpolly/Data/Continent%20Shapefiles.zip"

    shpfile = "data/raw/ContinentShapefiles.zip"

    tempfile(shpfile)

    curl::curl_download(url, shpfile)

    unzip(shpfile, exdir = "data/raw")

    unlink(shpfile)
}
