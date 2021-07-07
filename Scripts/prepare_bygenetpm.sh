#!/bin/sh

#tpm 
infile=$1
outfile=$2

perl /data1/jyin/DREAM/Scripts/rename_expr.pl $infile ${outfile/.txt/_pre.txt}

perl /home/jyin/Projects/Pipeline/sbptools/mergefiles/mergefiles_caller.pl -m /data1/jyin/DREAM/Training/AllMerged/genes_sel_final.txt -i ${outfile/.txt/_pre.txt} -o $outfile --id "," --od "," -n T
