# This script installs all packages necessary for the tutorial to use `funrar`
# package
# Author: Matthias Grenié <matthias.grenie[at]cefe.cnrs.fr>
# /!\ WARNING it creates a directory 'funrar_tutorial' in the current working
# directory, make sure to change the working directory if you want to install
# the tutorial folder elsewhere /!\

# Installing Packages ----------------------------------------------------------
# Install package `devtools` to install development version of `funrar`
if (!require("devtools")) {
    install.packages("devtools")
}

# Install development version of funrar
devtools::install_github("Rekyt/funrar", build_vignettes = TRUE)

# Install development version of `rdryad` if missing to download the example
# dataset
devtools::install_github("ropensci/rdryad")

# Install `ggplot2` if missing
if (!require("ggplot2")) {
    install.packages("ggplot2")
}


# Create Folders ---------------------------------------------------------------
# Create a tutorial directory in the current directory
if (!dir.exists("funrar_tutorial")) {
    dir.create("funrar_tutorial")
}

# Move to tutorial directory
setwd("funrar_tutorial")

if (!dir.exists("data")) {
    dir.create("data")
}

# Dowload Data -----------------------------------------------------------------
# Download the example dataset from Lawning et al. 2016
# <doi:10.5061/dryad.9t0n8>
tempfile("data/lawning_data.zip")
rdryad::dryad_fetch(
    rdryad::dryad_files(rdryad::handle2doi("10255/dryad.116171"))[1],
    destfile = "data/lawning_data.zip", mode = "wb")
unzip("data/lawning_data.zip", exdir = "data")
unlink("data/lawning_data.zip")
