#!/bin/bash

timestamp='ressat-full.2021-01-28_17-40-12'
compared_approaches=('bare-Cachet'
                     'minimize-Cachet')

echo "Generating CSV files of ressat for quantile plots ..."
for approach in "${compared_approaches[@]}"; do
    echo "  > Configuration: ${approach}"
    ./quantile-generator.py "./results/${timestamp}.results.${approach}.RandomExist.xml.bz2" \
        > "./csv/ressat.${approach}.quantile.csv"
done

timestamp='dcssat-full.2021-01-29_19-06-55'
compared_approaches=('default')

echo "Generating CSV files of dcssat for quantile plots ..."
for approach in "${compared_approaches[@]}"; do
    echo "  > Configuration: ${approach}"
    ./quantile-generator.py "./results/${timestamp}.results.${approach}.RandomExist.xml.bz2" \
        > "./csv/dcssat.${approach}.quantile.csv"
done
