#!/bin/bash

#run tide
echo "run TIDE"
python3 /codes/run_tide.py /data/GRCh37ERCC_refseq105_genes_tpm.csv /output/test_tide.txt

#run szabo
echo "run Szabo"
Rscript /codes/szabo_inflammation_signature.R /data/GRCh37ERCC_refseq105_genes_count.csv /output/test_szabo.txt

#run IMPRES
echo "run IMPRES"
Rscript /codes/run_IMPRES.R /data/GRCh37ERCC_refseq105_genes_tpm.csv /output/test_impres.txt

#run final code
echo "Final Run"
Rscript /codes/EDA_model1_submission.R


