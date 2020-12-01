
<!-- README.md is generated from README.Rmd. Please edit that file -->

# COVID-19 and mental health

<!-- badges: start -->

[![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://www.tidyverse.org/lifecycle/#experimental)
<!-- badges: end -->

*This project was done as part of Barcelona GSE masters in data
science.*

## Overview

This app provides a striaght-forward interface for users to monitor
COVID-19 and its potential effect on mental health across the world. It
provides a general overview of current COVID case numbers and relates
them to tweets streamed in real-time that relate to mental health.

## Usage

The app is hosted on shinyapps.io. Due to usage limits the server may
not always be responsive. A more robust way to access the app is through
Docker. To use the Docker image run:

    docker run -d --name covid --net host patalt/covid_mental_health

### Install as R package

R users not familiar with docker may prefer to install the app as an R
package and run it through R Studio. To do so first install the package
through:

``` r
devtools::install_git(url = "https://github.com/pat-alt/covidMentalHealth.git", branch = "main")
library(covidMentalHealth)
```

Then simply run `run_app()` to run the Shiny app.

### R and Python integration

The app relies on both R and Python code. The latter is integrated
through [reticulate](https://rstudio.github.io/reticulate/). The app
looks for the Python version found on your `PATH` through
`reticulate::use_python(Sys.which("python"))`. Python dependencies are
imported on load. In case you are missing any of the dependencies on
your machine you can install them through
`covidMentalHealth::install_py_dependencies()`.

## Data

We source data from two different APIs: for COVID case numbers we use
<https://covid19-api.org/> which continuously collects case numbers at
country level from across the globe; for tweets we user Twitter
streaming API. COVID data is sourced from the API a few times every day.
Tweets are streamed continuously. We filter tweets that involve at least
on term from this list related to mental health
`["mental health","suicide","depression","anxiety"]` *and* at least one
term from this list related to COVID
`['covid','coronavirus','sars-cov-2','pandemic']`.
