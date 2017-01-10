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
format_trait = function(trait_df, with_rownames = FALSE) {

    # If supplied data.frame or matrix doesn't have row names
    if (!with_rownames) {
        # Get species name similar to presence-absence matrix
        rownames(trait_df) = gsub(" ", "_", trait_df[["TaxonName"]])

        trait_df = trait_df[, -1]  # Take out species name
    }

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

    # Ensute all traits are numeric even if they are factors
    trait_df[["X6_1_DietBreadth"]] = trait_df[["X6_1_DietBreadth"]] %>%
        as.character() %>%
        as.numeric()

    trait_df[["X5_1_AdultBodyMass_g"]] = trait_df[["X5_1_AdultBodyMass_g"]] %>%
        as.character() %>%
        as.numeric()

    trait_df[["X15_1_LitterSize"]] = trait_df[["X15_1_LitterSize"]] %>%
        as.character() %>%
        as.numeric()

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

# Null models to break spatial link with functional distinctiveness
compute_null_funrar = function(pres_matrix, distance_matrix) {

    null_model = vegan::nullmodel(pres_matrix, "curveball")

    # Set seed to always get the same simulations
    set.seed(101010)
    sim_pres = simulate(null_model, nsim = 100, burnin = 10^4, thin = 1000)

    # Get functional rarity indices
    null_sm = apply(sim_pres, 3, function(x) {
        sparse_x = as(x, "sparseMatrix")

        distinctiveness(sparse_x, distance_matrix)
    })

    return(null_sm)
}

# Null models to break the link between Functional Uniqueness and Geographical
# Restrictedness
compute_null_traits = function(pres_matrix, trait_df, nrepet = 150) {

    # Set seed to always get the same sets of traits
    set.seed(101010)
    null_traits = lapply(1:nrepet, function(x) {
        trait_df %>%
            apply(2, sample) %>%  # Shuffle columns values independently
            as.data.frame() %>%   # Reconvert to data frame to get columns names
            format_trait(with_rownames = TRUE) %>%  # Reformat trait matrix
            `rownames<-`(rownames(trait_df))  # Relabel species
    })

    # For each null trait data frame recompute functional rarity indices
    # Doesn't change Geographical Restrictedness while changing Functional
    # Uniqueness
    null_traits_funrar = lapply(null_traits,
                                function(x) {
                                    uniqueness(as(pres_matrix, "sparseMatrix"),
                                           compute_dist_matrix(x))
                                })

    return(null_traits_funrar)
}


flatten_null_uniqueness = function(null_traits) {
    null_traits %>%
        purrr::reduce(inner_join, by = "species") %>%
        tidyr::gather(name, Ui, -species) %>%
        dplyr::select(-name)
}
