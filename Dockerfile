FROM ubuntu:focal

RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y r-base

RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y r-cran-randomforest

RUN echo "r <- getOption('repos'); r['CRAN'] <- 'http://cran.us.r-project.org'; options(repos = r);" > ~/.Rprofile

RUN Rscript -e "install.packages('readr')"
RUN Rscript -e "install.packages('optparse')"
RUN Rscript -e "install.packages('randomForest')"
RUN Rscript -e "install.packages('glmnet')"



COPY run_model.R /usr/local/bin/
COPY model.rds /usr/local/bin/
RUN chmod a+x /usr/local/bin/run_model.R

ENTRYPOINT ["Rscript", "/usr/local/bin/run_model.R"]