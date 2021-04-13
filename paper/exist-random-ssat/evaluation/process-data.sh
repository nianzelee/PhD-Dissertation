#!/bin/bash

timestamp='erssat.2021-04-09_12-40-52'
compared_approaches=('bare-BDD' 'default-BDD')
formula_families=('Random' 'Application')
column_identifiers=('cputime' 'memory')

echo "Generating CSV files of erssat for quantile plots ..."
for approach in "${compared_approaches[@]}"; do
    for family in "${formula_families[@]}"; do
        for identifier in "${column_identifiers[@]}"; do
            echo "  > Configuration: ${approach}; Family: ${family}; Identifier: ${identifier}"
            ./quantile-generator.py --sort-by "${identifier}" \
                "./results/${timestamp}.results.${approach}.${family}.xml.bz2" \
                > "./csv/erssat.${approach}.${family}.quantile.${identifier}.csv"
        done
    done
done

timestamp='dcssat-er.2021-04-09_23-47-31'
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

timestamp_er='erssat.2021-04-09_12-40-52'
timestamp_dc='dcssat-er.2021-04-09_23-47-31'
echo "Generating CSV files of application formulas for scatter plots ..."
table-generator --no-diff -f csv -o ./csv -x ./scatter.xml -n "erssat.scatter" \
    "./results/${timestamp_er}.results.default-BDD.Application.xml.bz2" \
    "./results/${timestamp_er}.results.bare-BDD.Application.xml.bz2"
table-generator --no-diff -f csv -o ./csv -x ./scatter.xml -n "dcssat.scatter" \
    "./results/${timestamp_er}.results.default-BDD.Application.xml.bz2" \
    "./results/${timestamp_dc}.results.default.Application.xml.bz2"
