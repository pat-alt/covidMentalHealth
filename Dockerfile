FROM rocker/r-ver:4.0.2
RUN apt-get update && apt-get install -y  git-core libcairo2-dev libcurl4-openssl-dev libgit2-dev libpng-dev libssh2-1-dev libssl-dev libxml2-dev libpython3-dev python3-pip make pandoc pandoc-citeproc python-minimal zlib1g-dev && rm -rf /var/lib/apt/lists/*
RUN cp /usr/bin/python3 /usr/bin/python
RUN python -m pip install pymongo pandas
RUN echo "options(repos = c(CRAN = 'https://cran.rstudio.com/'), download.file.method = 'libcurl')" >> /usr/local/lib/R/etc/Rprofile.site
RUN R -e 'install.packages("remotes")'
RUN R -e 'remotes::install_github("r-lib/remotes", ref = "97bbf81")'
RUN Rscript -e 'remotes::install_version("glue",upgrade="never", version = "1.4.2")'
RUN Rscript -e 'remotes::install_version("processx",upgrade="never", version = "3.4.5")'
RUN Rscript -e 'remotes::install_version("pkgload",upgrade="never", version = "1.1.0")'
RUN Rscript -e 'remotes::install_version("testthat",upgrade="never", version = "3.0.0")'
RUN Rscript -e 'remotes::install_version("htmltools",upgrade="never", version = "0.5.0")'
RUN Rscript -e 'remotes::install_version("shiny",upgrade="never", version = "1.5.0")'
RUN Rscript -e 'remotes::install_version("attempt",upgrade="never", version = "0.3.1")'
RUN Rscript -e 'remotes::install_version("dplyr",upgrade="never", version = "1.0.2")'
RUN Rscript -e 'remotes::install_version("ggplot2",upgrade="never", version = "3.3.2")'
RUN Rscript -e 'remotes::install_version("shinydashboard",upgrade="never", version = "0.7.1")'
RUN Rscript -e 'remotes::install_version("config",upgrade="never", version = "0.3")'
RUN Rscript -e 'remotes::install_version("maps",upgrade="never", version = "3.3.0")'
RUN Rscript -e 'remotes::install_version("shinycssloaders",upgrade="never", version = "1.0.0")'
RUN Rscript -e 'remotes::install_version("tidyr",upgrade="never", version = "1.1.2")'
RUN Rscript -e 'remotes::install_version("zoo",upgrade="never", version = "1.8-8")'
RUN Rscript -e 'remotes::install_version("lubridate",upgrade="never", version = "1.7.9.2")'
RUN Rscript -e 'remotes::install_version("ggiraph",upgrade="never", version = "0.7.8")'
RUN Rscript -e 'remotes::install_version("tidytext",upgrade="never", version = "0.2.6")'
RUN Rscript -e 'remotes::install_version("ggwordcloud",upgrade="never", version = "0.5.0")'
RUN Rscript -e 'remotes::install_version("dashboardthemes",upgrade="never", version = "1.1.3")'
RUN Rscript -e 'remotes::install_version("shinythemes",upgrade="never", version = "1.1.2")'
RUN Rscript -e 'remotes::install_version("reticulate",upgrade="never", version = "1.18")'
RUN Rscript -e 'remotes::install_version("shinyWidgets",upgrade="never", version = "0.5.4")'
RUN Rscript -e 'remotes::install_version("data.table",upgrade="never", version = "1.13.2")'
RUN Rscript -e 'remotes::install_version("shinydashboardPlus",upgrade="never", version = "0.7.5")'
RUN Rscript -e 'remotes::install_version("DT",upgrade="never", version = "0.16")'
RUN Rscript -e 'remotes::install_version("golem",upgrade="never", version = "0.2.1")'
RUN mkdir /build_zone
ADD . /build_zone
WORKDIR /build_zone
RUN R -e 'remotes::install_local(upgrade="never")'
EXPOSE 80
CMD R -e "options('shiny.port'=80,shiny.host='0.0.0.0');covidMentalHealth::run_app()"
