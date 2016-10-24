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


# Function to select which trait to include in the analysis based on completeness
select_traits = function(trait_df) {
    trait_subset = trait_df %>%
        filter(!is.na(X5_1_AdultBodyMass_g) & !is.na(X15_1_LitterSize)
               & !is.na(X6_1_DietBreadth) & !is.na(X6_2_TrophicLevel)
               & !is.na(X12_1_HabitatBreadth) & !is.na(X12_2_Terrestriality))

    # Remove all columns containing 'NA'
    trait_subset[, colSums(is.na(trait_subset)) == 0]
}


# Function to get same species in presence-absence matrix as trait matrix ------
get_common_species = function(pres_mat, trait_df) {

    mat_columns = colnames(pres_mat)

    trait_species = gsub(" ", "_", trait_df[["TaxonName"]])

    # Extract matching species
    common_species = match(trait_species, mat_columns)

    return(pres_mat[, c(1:3, common_species)])
}

# Get IUCN statuses ------------------------------------------------------------

get_iucn_status = function(trait_df) {

    species_list = trait_df[["TaxonName"]]

    registerDoParallel(cores = parallel::detectCores())

    # For this function need to have defined a global option 'IUCN_REDLIST_KEY'
    status = iucn_summary(as.character(species_list), parallel = T) %>%
        iucn_status()

    stopImplicitCluster()

    # Add IUCN status column in trait df
    trait_df_status = trait_df %>%
        inner_join(data.frame(TaxonName = names(status), IUCN_status = status),
                   by = "TaxonName")

    return(trait_df_status)
}



# Compute Functional Rarity for mammals ----------------------------------------


compute_funrar = function(pres_matrix, trait_df) {

    # Format trait data.frame
    cleaned_trait_df = format_trait(trait_df)


    # Format presence-absence matrix
    cleaned_pres_mat = format_presence_matrix(pres_matrix)


    distance_matrix = compute_dist_matrix(cleaned_trait_df)

    # Get functional rarity indices
    species_funrar = funrar(cleaned_pres_mat, distance_matrix)

    return(species_funrar)
}


# Clean Up Trait data.frame by sorting traits and ordering them
format_trait = function(trait_df) {

    # Get species name similar to presence-absence matrix
    rownames(trait_df) = gsub(" ", "_", trait_df[["TaxonName"]])

    trait_df = trait_df[, -1]  # Take out species name

    # Format traits according to their categories
    trait_df[["X12_1_HabitatBreadth"]] = factor(
        trait_df[["X12_1_HabitatBreadth"]], levels = 1:3,
        labels = c("above_ground_dwelling", "aquatic",
                   "fossorial_and_ground_dwelling"), ordered = TRUE)


    trait_df[["X12_2_Terrestriality"]] = factor(
        trait_df[["X12_2_Terrestriality"]], levels = c(1, 2),
        labels = c("fossorial_plus_ground_dwelling", "above_ground_dwelling"),
        ordered = TRUE)


    trait_df[["X6_2_TrophicLevel"]] = factor(trait_df[["X6_2_TrophicLevel"]],
                                             levels = 1:3, ordered = TRUE,
                                             labels = c("herbivore",
                                                        "omnivore",
                                                        "carnivore"))

    return(trait_df)
}

# Tidy Up presence-absence matrix by renaming it and converting it to a sparse
format_presence_matrix = function(pres_mat) {

    rownames(pres_mat) = pres_mat[["GlobalID"]]

    # Take out plot names and coordinates
    pres_mat = pres_mat[, -c(1:3)]

    pres_mat = as.matrix(pres_mat)

    # Take out species occurring nowhere and sites with no species
    pres_mat = pres_mat[, which(colSums(pres_mat) != 0)]
    pres_mat = pres_mat[which(rowSums(pres_mat) != 0),]

    names(dimnames(pres_mat)) = c("Sites", "TaxonName")

    pres_mat = as(pres_mat, "sparseMatrix")

    return(pres_mat)
}
