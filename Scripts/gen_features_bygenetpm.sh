#!/bin/sh

#input file, gene tpm csv, output, all needed features

infile=$1
outfile=$2

#FARDEEP + GEP
/apps/R-4.0.2/bin/Rscript /data1/jyin/DREAM/Scripts/run_FARDEEP_GEP.R $infile ${outfile/.txt/_fardeep.txt} ${outfile/.txt/_gep.txt}

#ssGSEA
#ssGSEA GO-BP
/apps/R-4.0.2/bin/Rscript /data/pzhang/GSVA/gsva_calculation_update.R -i $infile -m ssgsea -db GO_BP -gmt /data/pzhang/GSVA/c5.go.bp.v7.2.symbols.gmt -o ${outfile/.txt/_ssgsea_go-bp.txt}

#ssGSEA HallMark
/apps/R-4.0.2/bin/Rscript /data/pzhang/GSVA/gsva_calculation_update.R -i $infile -m ssgsea -db Hallmark -gmt /data/pzhang/GSVA/h.all.v7.2.symbols.gmt -o ${outfile/.txt/_ssgsea_hallmark.txt}

#IMPRES	
/apps/R-4.0.2/bin/Rscript /data1/jyin/DREAM/Scripts/run_IMPRES.R $infile ${outfile/.txt/_impres.txt}

#TIDE
python3 /data1/jyin/DREAM/Scripts/run_tide.py $infile ${outfile/.txt/_tide.txt}


#SZABO
/apps/R-4.0.2/bin/Rscript /data1/jyin/DREAM/Scripts/szabo_inflammation_signature_rev.R $infile ${outfile/.txt/_szabo.txt}
