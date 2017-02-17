North and Central American Mammals Functional Rarity Read Me
================
Matthias Grenié
17 février, 2017

`mamm_funrar`
-------------

This repository contains a worked through example of the use of [`funrar`R package](https://cran.r-project.org/package=funrar) in the context of biogeography using a publicly available dataset on North and Central American mammals (Lawing et al. 2016b; Lawing et al. 2016a).

The dataset is available through Dryad there: [doi:10.5061/dryad.9t0n8](https://doi.org/10.5061/dryad.9t0n8)

### Dependencies

The analysis strongly depends on several packages:

-   [`remake`](https://github.com/richfitz/remake) to make the analysis portable and reproducible,
-   [`dplyr`](https://github.com/hadley/dplyr) for data wrangling,
-   [`rdryad`](https://github.com/ropensci/rdryad) to download the date from Dryad,
-   [`rmarkdown`](https://github.com/rstudio/rmarkdown/) to generate the analysis report,
-   [`vegan`](https://github.com/vegandevs/vegan) to compute null models for site-species matrix,
-   [`ggplot2`](https://github.com/tidyverse/ggplot2) to plot figures in reports,
-   [`devtools`](https://github.com/hadley/devtools) for session info diagnostics,
-   [`funrar`](https://cran.r-project.org/package=funrar) to compute functional rarity indices.

### Session Info

``` r
devtools::session_info()
```

    ## Session info --------------------------------------------------------------

    ##  setting  value                       
    ##  version  R version 3.3.2 (2016-10-31)
    ##  system   x86_64, mingw32             
    ##  ui       RStudio (1.0.136)           
    ##  language (EN)                        
    ##  collate  French_France.1252          
    ##  tz       Europe/Warsaw               
    ##  date     2017-02-17

    ## Packages ------------------------------------------------------------------

    ##  package      * version date       source                          
    ##  assertthat     0.1     2013-12-06 CRAN (R 3.3.0)                  
    ##  backports      1.0.5   2017-01-18 CRAN (R 3.3.2)                  
    ##  codetools      0.2-15  2016-10-05 CRAN (R 3.3.2)                  
    ##  colorspace     1.3-2   2016-12-14 CRAN (R 3.3.2)                  
    ##  cowplot        0.7.0   2016-10-28 CRAN (R 3.3.1)                  
    ##  crayon         1.3.2   2016-06-28 CRAN (R 3.3.0)                  
    ##  DBI            0.5-1   2016-09-10 CRAN (R 3.3.1)                  
    ##  devtools       1.12.0  2016-06-24 CRAN (R 3.3.1)                  
    ##  digest         0.6.12  2017-01-27 CRAN (R 3.3.2)                  
    ##  divr           0.1.0   2017-02-17 local (Rekyt/divr@423faef)      
    ##  dplyr        * 0.5.0   2016-06-24 CRAN (R 3.3.1)                  
    ##  evaluate       0.10    2016-10-11 CRAN (R 3.3.1)                  
    ##  funrar         1.0.2   2017-02-14 Github (Rekyt/funrar@f59cf67)   
    ##  ggExtra        0.6     2016-11-12 CRAN (R 3.3.2)                  
    ##  ggplot2      * 2.2.1   2016-12-30 CRAN (R 3.3.2)                  
    ##  ggthemes       3.3.0   2016-11-24 CRAN (R 3.3.2)                  
    ##  gtable         0.2.0   2016-02-26 CRAN (R 3.3.0)                  
    ##  htmltools      0.3.5   2016-03-21 CRAN (R 3.3.0)                  
    ##  httpuv         1.3.3   2015-08-04 CRAN (R 3.3.0)                  
    ##  knitr          1.15.1  2016-11-22 CRAN (R 3.3.2)                  
    ##  labeling       0.3     2014-08-23 CRAN (R 3.3.0)                  
    ##  lattice        0.20-34 2016-09-06 CRAN (R 3.3.2)                  
    ##  lazyeval       0.2.0   2016-06-12 CRAN (R 3.3.0)                  
    ##  magrittr       1.5     2014-11-22 CRAN (R 3.3.0)                  
    ##  mapproj        1.2-4   2015-08-03 CRAN (R 3.3.0)                  
    ##  maps         * 3.1.1   2016-07-27 CRAN (R 3.3.1)                  
    ##  MASS           7.3-45  2016-04-21 CRAN (R 3.3.2)                  
    ##  Matrix         1.2-8   2017-01-20 CRAN (R 3.3.2)                  
    ##  memoise        1.0.0   2016-01-29 CRAN (R 3.3.0)                  
    ##  mgcv           1.8-17  2017-02-08 CRAN (R 3.3.2)                  
    ##  mime           0.5     2016-07-07 CRAN (R 3.3.1)                  
    ##  miniUI         0.1.1   2016-01-15 CRAN (R 3.3.0)                  
    ##  multcomp       1.4-6   2016-07-14 CRAN (R 3.3.1)                  
    ##  munsell        0.4.3   2016-02-13 CRAN (R 3.3.0)                  
    ##  mvtnorm        1.0-5   2016-02-02 CRAN (R 3.3.0)                  
    ##  nlme           3.1-131 2017-02-06 CRAN (R 3.3.2)                  
    ##  plyr           1.8.4   2016-06-08 CRAN (R 3.3.0)                  
    ##  purrr          0.2.2   2016-06-18 CRAN (R 3.3.1)                  
    ##  R6             2.2.0   2016-10-05 CRAN (R 3.3.1)                  
    ##  RColorBrewer   1.1-2   2014-12-07 CRAN (R 3.3.0)                  
    ##  Rcpp           0.12.9  2017-01-14 CRAN (R 3.3.2)                  
    ##  remake         0.2.0   2016-05-27 Github (richfitz/remake@d7164c7)
    ##  rmarkdown    * 1.3     2016-12-21 CRAN (R 3.3.2)                  
    ##  rprojroot      1.2     2017-01-16 CRAN (R 3.3.2)                  
    ##  sandwich       2.3-4   2015-09-24 CRAN (R 3.3.0)                  
    ##  scales         0.4.1   2016-11-09 CRAN (R 3.3.2)                  
    ##  shiny          1.0.0   2017-01-12 CRAN (R 3.3.2)                  
    ##  storr          1.0.1   2017-01-23 Github (richfitz/storr@4756931) 
    ##  stringi        1.1.2   2016-10-01 CRAN (R 3.3.1)                  
    ##  stringr        1.1.0   2016-08-19 CRAN (R 3.3.1)                  
    ##  survival       2.40-1  2016-10-30 CRAN (R 3.3.2)                  
    ##  TH.data        1.0-8   2017-01-23 CRAN (R 3.3.2)                  
    ##  tibble         1.2     2016-08-26 CRAN (R 3.3.1)                  
    ##  withr          1.0.2   2016-06-20 CRAN (R 3.3.1)                  
    ##  xtable         1.8-2   2016-02-05 CRAN (R 3.3.0)                  
    ##  yaml           2.1.14  2016-11-12 CRAN (R 3.3.2)                  
    ##  zoo            1.7-14  2016-12-16 CRAN (R 3.3.2)

### How to run

To run the analysis on your computer, install `remake`, make the working directory the project directory and run:

    remake::make()

You will see the full analysis run on your computer. With remake all the intermediate objects are viewable on a dependency graph:

``` r
remake::diagram()
```

    ## PhantomJS not found. You can install it with webshot::install_phantomjs(). If it is installed, please make sure the phantomjs executable can be found via the PATH variable.

<!--html_preserve-->

<script type="application/json" data-for="htmlwidget-9f18db972d9b58cd1791">{"x":{"diagram":"digraph remake { node [ fontname = courier, fontsize = 10 ] \nnode [ shape = circle, color = \"#34495e\", fillcolor = \"#D6DBDF\", style = filled ] \"all\"\nnode [ shape = ellipse, color = \"#3498db\", fillcolor = \"#3498db\", style = filled ] \"dryad_dataset\"; \"raw_mammal_traits\"; \"raw_pres_mat\"; \"subset_traits\"; \"subset_pres\"; \"pres_matrix\"; \"trait_df\"; \"dist_matrix\"; \"mammal_funrar\"; \"null_shuffled_matrix\"; \"null_shuffled_traits\"; \"null_flat_ui\"\nnode [ shape = box, color = \"#d35400\", fillcolor = \"#d35400\", style = filled ] \"results/exploratory_analysis.pdf\"\nnode [ shape = box, color = \"#d35400\", fillcolor = \"#F6DDCC\", style = filled ] \"README.md\"\nnode [ shape = box, color = \"#1abc9c\", fillcolor = \"#1abc9c\", style = filled ] \"data/raw/dryad.116171/DryadArchive/Traits.csv\"; \"data/raw/dryad.116171/DryadArchive/PresAbsMatrix50.csv\"; \"results/exploratory_analysis.Rmd\"; \"README.Rmd\"; \"refs.bib\"\n\"dryad_dataset\" -> \"raw_mammal_traits\" [tooltip = \"read.csv\"];\n\"dryad_dataset\" -> \"raw_pres_mat\" [tooltip = \"read.csv\"];\n\"raw_mammal_traits\" -> \"subset_traits\" [tooltip = \"select_traits\"];\n\"raw_pres_mat\" -> \"subset_pres\" [tooltip = \"get_common_species\"];\n\"subset_traits\" -> \"subset_pres\" [tooltip = \"get_common_species\"];\n\"subset_traits\" -> \"trait_df\" [tooltip = \"format_trait\"];\n\"subset_traits\" -> \"mammal_funrar\" [tooltip = \"compute_funrar\"];\n\"subset_pres\" -> \"pres_matrix\" [tooltip = \"format_presence_matrix\"];\n\"subset_pres\" -> \"results/exploratory_analysis.pdf\" [tooltip = \"render\"];\n\"pres_matrix\" -> \"mammal_funrar\" [tooltip = \"compute_funrar\"];\n\"pres_matrix\" -> \"null_shuffled_matrix\" [tooltip = \"compute_null_funrar\"];\n\"pres_matrix\" -> \"null_shuffled_traits\" [tooltip = \"compute_null_traits\"];\n\"trait_df\" -> \"dist_matrix\" [tooltip = \"compute_dist_matrix\"];\n\"trait_df\" -> \"null_shuffled_traits\" [tooltip = \"compute_null_traits\"];\n\"dist_matrix\" -> \"null_shuffled_matrix\" [tooltip = \"compute_null_funrar\"];\n\"mammal_funrar\" -> \"null_flat_ui\" [tooltip = \"flatten_null_uniqueness\"];\n\"mammal_funrar\" -> \"results/exploratory_analysis.pdf\" [tooltip = \"render\"];\n\"null_shuffled_matrix\" -> \"results/exploratory_analysis.pdf\" [tooltip = \"render\"];\n\"null_shuffled_traits\" -> \"null_flat_ui\" [tooltip = \"flatten_null_uniqueness\"];\n\"null_flat_ui\" -> \"results/exploratory_analysis.pdf\" [tooltip = \"render\"];\n\"results/exploratory_analysis.pdf\" -> \"README.md\" [tooltip = \"render_readme\"];\n\"README.md\" -> \"all\" [tooltip = \"(dependency only)\"];\n\"data/raw/dryad.116171/DryadArchive/Traits.csv\" -> \"raw_mammal_traits\" [tooltip = \"read.csv\"];\n\"data/raw/dryad.116171/DryadArchive/PresAbsMatrix50.csv\" -> \"raw_pres_mat\" [tooltip = \"read.csv\"];\n\"results/exploratory_analysis.Rmd\" -> \"results/exploratory_analysis.pdf\" [tooltip = \"render\"];\n\"README.Rmd\" -> \"README.md\" [tooltip = \"render_readme\"];\n\"refs.bib\" -> \"README.md\" [tooltip = \"render_readme\"]; }","config":{"engine":"dot","options":null}},"evals":[],"jsHooks":[]}</script>
<!--/html_preserve-->
References
----------

Lawing, A. Michelle, Jussi T. Eronen, Jessica L. Blois, Catherine H. Graham, and P. David Polly. 2016a. “Data from: Community Functional Trait Composition at the Continental Scale: The Effects of Non-Ecological Processes,” April. doi:[10.5061/dryad.9t0n8](https://doi.org/10.5061/dryad.9t0n8).

———. 2016b. “Community Functional Trait Composition at the Continental Scale: The Effects of Non-Ecological Processes.” *Ecography*, June, n/a–n/a. doi:[10.1111/ecog.01986](https://doi.org/10.1111/ecog.01986).
