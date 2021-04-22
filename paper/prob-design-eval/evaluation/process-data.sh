#!/bin/bash

defect_rates=('D-0.01' 'D-0.10')

echo "Generating CSV files for PEC tables ..."
for defect in "${defect_rates[@]}"; do
    table-generator -x PEC-"${defect}".xml -f csv -o ./csv --no-diff
    ./PEC_csv_parser.py "${defect}"
done

echo "Generating CSV files for MPEC tables ..."
for defect in "${defect_rates[@]}"; do
    table-generator -x MPEC-"${defect}".xml -f csv -o ./csv --no-diff
    ./MPEC_csv_parser.py "${defect}"
done
