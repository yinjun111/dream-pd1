
FROM ubuntu:latest

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update 
#RUN deb https://cloud.r-project.org/bin/linux/ubuntu focal-cran40/

RUN apt-get update 
RUN apt-get -y install --no-install-recommends --no-install-suggests ca-certificates software-properties-common gnupg2 gnupg1
RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys E298A3A825C0D65DFD57CBB651716619E084DAB9
RUN add-apt-repository 'deb https://cloud.r-project.org/bin/linux/ubuntu focal-cran40/'
RUN apt-get install -f -y --no-install-recommends r-base

RUN apt-get install -y --no-install-recommends build-essential python3.6 python3-pip python3-setuptools python3-dev

#RUN apt-get install aptitude
#RUN apt-get install libcurl4-openssl-dev
#RUN apt-get install libxml2-dev
#RUN apt-get install libssl-dev
#RUN apt-get install gfortan
#RUN apt-get install libblas-dev liblapack-dev

#WORKDIR /app

#COPY requirements.txt /app/requirements.txt

RUN pip3 install tidepy numpy pandas==1.0.5

RUN R -e "install.packages('ModelMetrics', repos = 'http://cran.us.r-project.org')"
RUN R -e "install.packages('remotes', repos = 'http://cran.us.r-project.org')"

#IMPRES
RUN R -e "remotes::install_github('Benjamin-Vincent-Lab/binfotron')"
RUN R -e 'stopifnot("binfotron" %in% installed.packages()[,"Package"])'

RUN R -e "install.packages('caret', repos = 'http://cran.us.r-project.org')"
RUN R -e 'stopifnot("caret" %in% installed.packages()[,"Package"])'

RUN R -e "install.packages('e1071', repos = 'http://cran.us.r-project.org')"

#for GBM model
RUN R -e "install.packages('gbm', repos = 'http://cran.us.r-project.org')"
RUN R -e "install.packages('pROC', repos = 'http://cran.us.r-project.org')"

#
RUN R -e "install.packages('RCurl', repos = 'http://cran.us.r-project.org')"
RUN R -e "install.packages('openssl', repos = 'http://cran.us.r-project.org')"
RUN R -e "install.packages('httr', repos = 'http://cran.us.r-project.org')"

#ssGSEA
RUN R -e "install.packages('argparse', repos = 'http://cran.us.r-project.org')"
RUN R -e "if (!requireNamespace('BiocManager', quietly = TRUE)) install.packages('BiocManager');BiocManager::install('GSVA');BiocManager::install('org.Hs.eg.db');BiocManager::install('GSEABase');"

#FARDEEP
RUN R -e "install.packages('FARDEEP', repos = 'http://cran.us.r-project.org')"

#install for Szabo
RUN R -e "install.packages('BiocManager', repos = 'http://cran.us.r-project.org')"
RUN R -e "BiocManager::install('NOISeq')"


#-------
# Codes for feature generation
#-------

COPY codes/c5.go.bp.v7.2.symbols.gmt /codes/c5.go.bp.v7.2.symbols.gmt
COPY codes/genes_sel_final.txt /codes/genes_sel_final.txt
COPY codes/gen_features_bygenetpm_testdata.sh /codes/gen_features_bygenetpm_testdata.sh
COPY codes/gsea_selected.txt /codes/gsea_selected.txt
COPY codes/gsva_calculation_update.R /codes/gsva_calculation_update.R
COPY codes/h.all.v7.2.symbols.gmt /codes/h.all.v7.2.symbols.gmt
COPY codes/mergefiles_caller.pl /codes/mergefiles_caller.pl
COPY codes/Model_GBM_v1.rdata /codes/Model_GBM_v1.rdata
COPY codes/run_FARDEEP_GEP.R /codes/run_FARDEEP_GEP.R
COPY codes/run_GBMmodel.R /codes/run_GBMmodel.R
COPY codes/run_IMPRES.R /codes/run_IMPRES.R
COPY codes/run_tide.py /codes/run_tide.py
COPY codes/run_TMB.R /codes/run_TMB.R
COPY codes/szabo_inflammation_signature_rev.R /codes/szabo_inflammation_signature_rev.R


#-------
#Running code
#-------

RUN chmod +x /codes/gen_features_bygenetpm_testdata.sh

CMD ["sh","/codes/gen_features_bygenetpm_testdata.sh"]


