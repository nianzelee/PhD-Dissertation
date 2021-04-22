#!/bin/bash

benchmark_sets=('ISCAS' 'EPFL')
echo "Generating CSV files for circuit statistics ..."
for bench_set in "${benchmark_sets[@]}"; do
    table-generator -x ./xml/"${bench_set}".xml -f csv -o ./csv --no-diff
    ./circuit_parser.py "${bench_set}"
done

defect_rates=('D-0.01' 'D-0.10')

echo "Generating CSV files for miter statistics ..."
for defect in "${defect_rates[@]}"; do
    table-generator -x ./xml/Miter-"${defect}".xml -f csv -o ./csv --no-diff
    ./miter_parser.py "${defect}"
done

echo "Generating CSV files for PEC tables ..."
for defect in "${defect_rates[@]}"; do
    table-generator -x ./xml/PEC-"${defect}".xml -f csv -o ./csv --no-diff
    ./PEC_csv_parser.py "${defect}"
done

echo "Generating CSV files for MPEC tables ..."
for defect in "${defect_rates[@]}"; do
    table-generator -x ./xml/MPEC-"${defect}".xml -f csv -o ./csv --no-diff
    ./MPEC_csv_parser.py "${defect}"
done
