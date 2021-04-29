#!/bin/bash

timestamp='ressat.2021-04-23_21-45-25'
compared_approaches=('bare-Cachet' 'minimize-Cachet')
formula_families=('Random' 'Strategic')
column_identifiers=('cputime' 'memory')

echo "Generating CSV files of ressat for quantile plots ..."
for approach in "${compared_approaches[@]}"; do
    for family in "${formula_families[@]}"; do
        for identifier in "${column_identifiers[@]}"; do
            echo "  > Configuration: ${approach}; Family: ${family}; Identifier: ${identifier}"
            ./quantile-generator.py --sort-by "${identifier}" \
                "./results/${timestamp}.results.${approach}.${family}.xml.bz2" \
                > "./csv/ressat.${approach}.${family}.quantile.${identifier}.csv"
        done
    done
done

timestamp='dcssat-re.2021-04-24_12-18-42'
compared_approaches=('default')

echo "Generating CSV files of dcssat for quantile plots ..."
for approach in "${compared_approaches[@]}"; do
    for family in "${formula_families[@]}"; do
        for identifier in "${column_identifiers[@]}"; do
            echo "  > Configuration: ${approach}; Family: ${family}; Identifier: ${identifier}"
            ./quantile-generator.py --sort-by "${identifier}" \
                "./results/${timestamp}.results.${approach}.${family}.xml.bz2" \
                > "./csv/dcssat.${approach}.${family}.quantile.${identifier}.csv"
        done
    done
done

echo "Compiling quantile plots from the tex files ..."
for family in "${formula_families[@]}"; do
    for identifier in "${column_identifiers[@]}"; do
        echo "  > Family: ${family}; Identifier: ${identifier}"
        pdflatex -output-directory=./plots "./tex/quantile-${identifier}-${family}.tex"
    done
done

table-generator -f csv --no-diff -o ./csv -x ./PEC.xml
./PEC_csv_parser.py
