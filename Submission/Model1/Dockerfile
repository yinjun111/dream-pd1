
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




#WORKDIR /app

#COPY requirements.txt /app/requirements.txt

RUN pip3 install tidepy numpy pandas==1.0.5

RUN R -e "install.packages('ModelMetrics', repos = 'http://cran.us.r-project.org')"

RUN R -e "install.packages('remotes', repos = 'http://cran.us.r-project.org')"
RUN R -e "remotes::install_github('Benjamin-Vincent-Lab/binfotron')"
RUN R -e 'stopifnot("binfotron" %in% installed.packages()[,"Package"])'

RUN R -e "install.packages('caret', repos = 'http://cran.us.r-project.org')"
RUN R -e 'stopifnot("caret" %in% installed.packages()[,"Package"])'

RUN R -e "install.packages('e1071', repos = 'http://cran.us.r-project.org')"

#install for Szabo
RUN R -e "install.packages('BiocManager', repos = 'http://cran.us.r-project.org')"
RUN R -e "BiocManager::install('NOISeq')"

#gbm
RUN R -e "install.packages('gbm', repos = 'http://cran.us.r-project.org')"


#-------
# Codes for feature gen
#-------

COPY codes/run_tide.py /codes/run_tide.py

COPY codes/szabo_inflammation_signature.R /codes/szabo_inflammation_signature.R
COPY codes/run_IMPRES.R /codes/run_IMPRES.R
COPY codes/EDA_model1_submission.R /codes/EDA_model1_submission.R

COPY training/data_tide.txt /training/data_tide.txt
COPY training/data_impres.txt /training/data_impres.txt
COPY training/data_szabo.txt /training/data_szabo.txt
COPY training/data_clinical.txt /training/data_clinical.txt

#-------
#Running code
#-------

ADD codes/submission_exec.sh /codes/
RUN chmod +x /codes/submission_exec.sh

CMD ["sh","/codes/submission_exec.sh"]


