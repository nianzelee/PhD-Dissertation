#!/bin/bash

compute_number_solved_instances () {
    number=$(grep "$1" ./csv/status.table.csv | cut -f"$2" | sort | uniq -c | grep 'done' | awk '{print $1}')
    echo "${number}"
}

write_tex_data_command () {
    echo "\newcommand{\\$1}{\num{$2}}" >> "$3"
}

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

tool_name=(dcssat erssatb erssat)
application_formula_families=('ToiletA' 'conformant' 'castle' 'MaxCount' 'MPEC')
#application_formula_families=('ere-ToiletA' 'ere-conformant' 'ere-sand-castle' 'ere-MaxCount' 'ere-MPEC')
data_commands_file="tex/data-commands.tex"
echo "Generating a tex file for data commands of application formulas ..."
table-generator --no-diff -f csv -o ./csv -x ./status.xml -n "status" \
    "./results/${timestamp_dc}.results.default.Application.xml.bz2" \
    "./results/${timestamp_er}.results.bare-BDD.Application.xml.bz2" \
    "./results/${timestamp_er}.results.default-BDD.Application.xml.bz2"
echo "% Commands for application formulas of ER-SSAT" > "${data_commands_file}"
for i in {2..4}; do
    for family in "${application_formula_families[@]}"; do
        number_solved_instances=$(compute_number_solved_instances "${family}" "${i}")
        write_tex_data_command "${tool_name[i-2]}${family}" "${number_solved_instances}" "${data_commands_file}"
    done
done
