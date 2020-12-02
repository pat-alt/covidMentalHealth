
<!-- README.md is generated from README.Rmd. Please edit that file -->

# COVID-19 and mental health

<!-- badges: start -->

[![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://www.tidyverse.org/lifecycle/#experimental)
<!-- badges: end -->

*This project was done jointly by [@polinabee](https://github.com/polinabee), [@marcagusti](https://github.com/marcagusti) and myself as part of [Barcelona GSE Masters Program in Data
Science](https://www.barcelonagse.eu/study/masters-programs/data-science-methodology). Any comments and feedback are appreciated.*

## Overview

This app provides a striaght-forward interface for users to monitor
COVID-19 and its potential effect on mental health across the world. It
provides a general overview of current COVID case numbers and relates
them to tweets streamed in real-time that relate to mental health.

## Data

We source data from two different APIs: for COVID case numbers we use
<https://covid19-api.org/> which continuously collects case numbers at
country level from across the globe; for tweets we use the Twitter
streaming API. COVID data is sourced from the API a few times every day.
Tweets are streamed continuously. We filter tweets that involve at least
on term from this list related to mental health
`["mental health","suicide","depression","anxiety"]` *and* at least one
term from this list related to COVID
`['covid','coronavirus','sars-cov-2','pandemic']`.

## Usage

The app is hosted on shinyapps.io. Due to usage limits the server may
not always be responsive. A more robust way to access the app is through
Docker. To use the Docker image run:

    docker run -d --name covid --net host patalt/covid_mental_health

### Install as R package

Depending on how you plan to run the app from local the package require `virtualenv`
to be installed on your machine (more on this below). 

In case unfamiliar with Docker some users may prefer to install the app
as an R package and run it through R Studio. To do so first install the
package through:

``` r
devtools::install_git(url = "https://github.com/pat-alt/covidMentalHealth.git", branch = "main")
```

Once this is done you can simply run `covidMentalHealth::run_app()` to
launch the Shiny app.

### R and Python integration

The app relies on both R and Python code. The latter is integrated
through [reticulate](https://rstudio.github.io/reticulate/). By default
the `use_venv` argument of `run_app()` is set to `TRUE`, which will tell
the app to set up a Python 3 virtual environment to be used by
`reticulate`. This should generally work provided you have `virtualenv` installed 
on your machine. If missing you can install for example through `pip` by running

```
pip install virtualenv
```
in the terminal. For more colour on this see [here](https://github.com/ranikay/shiny-reticulate-app).

Setting up the virtual environment takes time, so in case you are
already familiar with `reticulate` and perhaps even have a default
`RETICULATE_PYTHON` path set up, you can set `use_venv=FALSE` to run
`reticulate` in the usual way. In case you are missing Python
dependencies you can use `covidMentalHealth::install_py_dependencies()`
to install them.

## Troubleshooting

We have not had time to test the R package installation on more than a few machines. If package dependencies cause trouble at the installation stage please document the issue [here](https://github.com/pat-alt/covidMentalHealth/issues) (preferably with an error message). 

## Ackowledgements

This [tutorial](https://github.com/ranikay/shiny-reticulate-app) by [@ranikay](https://github.com/ranikay) was immensely helpful with the deployment process of a reticulated Shiny app. 
