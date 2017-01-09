# Compute Functional Rarity for mammals ----------------------------------------


compute_funrar = function(pres_matrix, trait_df) {

    # Format trait data.frame
    cleaned_trait_df = format_trait(trait_df)


    # Format presence-absence matrix
    cleaned_pres_mat = as(pres_matrix, "sparseMatrix")

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

    return(pres_mat)
}


# Compute Null models ----------------------------------------------------------

compute_null_funrar = function(pres_matrix, trait_df) {

    cleaned_trait_df = format_trait(trait_df)
    # Format presence-absence matrix
    cleaned_pres_mat = format_presence_matrix(pres_matrix)

    distance_matrix = compute_dist_matrix(cleaned_trait_df)


    null_model = vegan::nullmodel(cleaned_pres_mat, "curveball")

    sim_pres = simulate(null_model, nsim = 1000, thin = 1000)

    # Get functional rarity indices
    species_funrar = funrar(, distance_matrix)

}
