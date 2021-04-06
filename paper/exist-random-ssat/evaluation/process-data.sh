#!/bin/bash

timestamp='erssat-full.2021-01-29_16-19-54'
compared_approaches=('bare-BDD'
                     'default-BDD')

echo "Generating CSV files of erssat for quantile plots ..."
for approach in "${compared_approaches[@]}"; do
    echo "  > Configuration: ${approach}"
    ./quantile-generator.py "./results/${timestamp}.results.${approach}.ExistRandomExist.xml.bz2" \
        > "./csv/erssat.${approach}.quantile.csv"
done

timestamp='dcssat-full.2021-01-29_19-06-55'
compared_approaches=('default')

echo "Generating CSV files of dcssat for quantile plots ..."
for approach in "${compared_approaches[@]}"; do
    echo "  > Configuration: ${approach}"
    ./quantile-generator.py "./results/${timestamp}.results.${approach}.ExistRandomExist.xml.bz2" \
        > "./csv/dcssat.${approach}.quantile.csv"
done
