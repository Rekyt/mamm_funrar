# Contains functions to compute Null models

# Compute Distinctiveness for random site-species matrix -----------------------
# Null models to break spatial link with functional distinctiveness
# Shuffle site-species matrix using 'curveball' algorithm
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

# Null models with random trait matrix -----------------------------------------
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
    null_traits_funrar = null_traits %>%
        lapply(
            function(x) {
                Ui = uniqueness(as(pres_matrix, "sparseMatrix"),
                                compute_dist_matrix(x))
                Ri = restrictedness(as(pres_matrix, "sparseMatrix"))
                return(list(Ui = Ui, Ri = Ri))
            }
        )

    return(null_traits_funrar)
}

# Get all the uniqueness values for all null models
flatten_null_uniqueness = function(null_traits) {
    null_traits %>%
        purrr::reduce(inner_join, by = "species") %>%
        tidyr::gather(name, Ui, -species) %>%
        dplyr::select(-name)
}
