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
