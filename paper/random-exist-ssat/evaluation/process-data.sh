#!/bin/bash

timestamp='ressat-thesis.2021-04-06_18-22-30'
compared_approaches=('bare-Cachet'
                     'minimize-Cachet')
formula_families=('Random'
                  'Strategic')

echo "Generating CSV files of ressat for quantile plots ..."
for approach in "${compared_approaches[@]}"; do
    for family in "${formula_families[@]}"; do
        echo "  > Configuration: ${approach}; Family: ${family}"
        ./quantile-generator.py "./results/${timestamp}.results.${approach}.${family}.xml.bz2" \
            > "./csv/ressat.${approach}.${family}.quantile.csv"
    done
done

timestamp='dcssat-thesis-re.2021-04-07_00-22-18'
compared_approaches=('default')

echo "Generating CSV files of dcssat for quantile plots ..."
for approach in "${compared_approaches[@]}"; do
    for family in "${formula_families[@]}"; do
        echo "  > Configuration: ${approach}; Family: ${family}"
        ./quantile-generator.py "./results/${timestamp}.results.${approach}.${family}.xml.bz2" \
            > "./csv/dcssat.${approach}.${family}.quantile.csv"
    done
done
