#!/bin/bash

#input file, gene tpm csv, output, all needed features

infile=/data/GRCh37ERCC_refseq105_genes_tpm.csv
annofile=/data/clinical_data.csv
outfile=/output/testdata.txt
codefolder=/codes

#infile=GRCh37ERCC_refseq105_genes_tpm.csv
#annofile=clinical_data.csv
#outfile=testdata.txt
#codefolder=/data1/jyin/DREAM/Submission/Model_C3_v1/codes

#only use variables same as training
echo "filter genes"
perl $codefolder/mergefiles_caller.pl -m $codefolder/genes_sel_final.txt -i $infile -o ${outfile/.txt/_filtered.txt} --id "," --od "," --n T

#FARDEEP + GEP
echo "run FARDEEP + GEP"
Rscript $codefolder/run_FARDEEP_GEP.R ${outfile/.txt/_filtered.txt} ${outfile/.txt/_fardeep.txt} ${outfile/.txt/_gep.txt}

#ssGSEA
#ssGSEA GO-BP
echo "run ssGSEA"
Rscript $codefolder/gsva_calculation_update.R -i ${outfile/.txt/_filtered.txt} -m ssgsea -db GO_BP -gmt $codefolder/c5.go.bp.v7.2.symbols.gmt -o ${outfile/.txt/_ssgsea_go-bp.txt}

#ssGSEA HallMark
Rscript $codefolder/gsva_calculation_update.R -i ${outfile/.txt/_filtered.txt} -m ssgsea -db Hallmark -gmt $codefolder/h.all.v7.2.symbols.gmt -o ${outfile/.txt/_ssgsea_hallmark.txt}

head -1 ${outfile/.txt/_ssgsea_go-bp.txt} > ${outfile/.txt/_gsea_title.txt}

cat ${outfile/.txt/_ssgsea_go-bp.txt} ${outfile/.txt/_ssgsea_hallmark.txt} | grep -v -P "^," > ${outfile/.txt/_ssgsea_all_pre.txt}
cat ${outfile/.txt/_gsea_title.txt} ${outfile/.txt/_ssgsea_all_pre.txt} > ${outfile/.txt/_ssgsea_all.txt}

perl $codefolder/mergefiles_caller.pl -m $codefolder/gsea_selected.txt -i ${outfile/.txt/_ssgsea_all.txt} -o ${outfile/.txt/_ssgsea_all_selected.txt} --id "," --od "," -n T

#IMPRES	
echo "run IMPRES"
Rscript $codefolder/run_IMPRES.R ${outfile/.txt/_filtered.txt} ${outfile/.txt/_impres.txt}

#TIDE
echo "run TIDE"
python3 $codefolder/run_tide.py ${outfile/.txt/_filtered.txt} ${outfile/.txt/_tide.txt}

#SZABO
echo "run SZABO"
Rscript $codefolder/szabo_inflammation_signature_rev.R ${outfile/.txt/_filtered.txt} ${outfile/.txt/_szabo.txt}

#TMB, kNN to impute TMB
echo "run TMB"
Rscript $codefolder/run_TMB.R ${outfile/.txt/_filtered.txt} $annofile ${outfile/.txt/_tmb.txt}


#Apply model
echo "apply model"
#Rscript $codefolder/run_GBMmodel.R
Rscript $codefolder/run_GBMmodel_C3_v3.R