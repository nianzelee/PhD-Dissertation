#!/bin/bash

compute_number_solved_instances () {
    number=$(grep "$1" ./csv/status.table.csv | cut -f"$2" | sort | uniq -c | grep 'done' | awk '{print $1}')
    echo "${number}"
}

write_tex_data_command () {
    echo "\newcommand{\\$1}{$2}" >> "$3"
}

normalize_string_for_benchexec () {
    # Remove timestamp
    temp=$(echo "$1" | cut -d'.' -f1)
    # Tokenize
    IFS='-' read -ra ARR <<< "$temp"
    # Change cases and concatenate
    retval=''
    for word in "${ARR[@]}"; do
        word="${word//[0-9]/}"
        word="${word,,}"
        word="${word^}"
        retval+="${word}"
    done
    echo "$retval"
}

write_missing_commands () {
    PREFIX="${1}${2}"
    echo "\\ifdefined\\${PREFIX}TotalCount\\else\\edef\\${PREFIX}TotalCount{0}\\fi" >> "$3"
    echo "\\ifdefined\\${PREFIX}CorrectCount\\else\\edef\\${PREFIX}CorrectCount{0}\\fi" >> "$3"
    echo "\\ifdefined\\${PREFIX}CorrectTrueCount\\else\\edef\\${PREFIX}CorrectTrueCount{0}\\fi" >> "$3"
    echo "\\ifdefined\\${PREFIX}CorrectFalseCount\\else\\edef\\${PREFIX}CorrectFalseCount{0}\\fi" >> "$3"
    echo "\\ifdefined\\${PREFIX}WrongTrueCount\\else\\edef\\${PREFIX}WrongTrueCount{0}\\fi" >> "$3"
    echo "\\ifdefined\\${PREFIX}WrongFalseCount\\else\\edef\\${PREFIX}WrongFalseCount{0}\\fi" >> "$3"
    echo "\\ifdefined\\${PREFIX}ErrorTimeoutCount\\else\\edef\\${PREFIX}ErrorTimeoutCount{0}\\fi" >> "$3"
    echo "\\ifdefined\\${PREFIX}ErrorOutOfMemoryCount\\else\\edef\\${PREFIX}ErrorOutOfMemoryCount{0}\\fi" >> "$3"
    echo "\\ifdefined\\${PREFIX}CorrectCputime\\else\\edef\\${PREFIX}CorrectCputime{0}\\fi" >> "$3"
    echo "\\ifdefined\\${PREFIX}CorrectCputimeAvg\\else\\edef\\${PREFIX}CorrectCputimeAvg{None}\\fi" >> "$3"
    echo "\\ifdefined\\${PREFIX}CorrectWalltime\\else\\edef\\${PREFIX}CorrectWalltime{0}\\fi" >> "$3"
    echo "\\ifdefined\\${PREFIX}CorrectWalltimeAvg\\else\\edef\\${PREFIX}CorrectWalltimeAvg{None}\\fi" >> "$3"
}

write_inconclusive_commands () {
    PREFIX="${1}${2}"
    echo "\\edef\\${PREFIX}ErrorOtherInconclusiveCount{\\the\\numexpr \\${PREFIX}TotalCount - \\${PREFIX}MissingCount - \\${PREFIX}ErrorTimeoutCount - \\${PREFIX}ErrorOutOfMemoryCount \\relax}" >> "$3"
}

formula_families=('Random' 'Application')
column_identifiers=('cputime' 'memory')

timestamp_er='erssat.2021-04-24_21-58-07'
compared_approaches=('bare-BDD' 'default-BDD')
echo "Generating CSV files of erssat for quantile plots ..."
for approach in "${compared_approaches[@]}"; do
    for family in "${formula_families[@]}"; do
        for identifier in "${column_identifiers[@]}"; do
            echo "  > Configuration: ${approach}; Family: ${family}; Identifier: ${identifier}"
            ./quantile-generator.py --sort-by "${identifier}" \
                "./results/${timestamp_er}.results.${approach}.${family}.xml.bz2" \
                > "./csv/erssat.${approach}.${family}.quantile.${identifier}.csv"
        done
    done
done

timestamp_dc='dcssat-er.2021-04-25_20-57-51'
compared_approaches=('default')
echo "Generating CSV files of dcssat for quantile plots ..."
for approach in "${compared_approaches[@]}"; do
    for family in "${formula_families[@]}"; do
        for identifier in "${column_identifiers[@]}"; do
            echo "  > Configuration: ${approach}; Family: ${family}; Identifier: ${identifier}"
            ./quantile-generator.py --sort-by "${identifier}" \
                "./results/${timestamp_dc}.results.${approach}.${family}.xml.bz2" \
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

echo "Generating CSV files of application formulas for scatter plots ..."
table-generator --no-diff -f csv -o ./csv -x ./scatter.xml -n "erssat.scatter" \
    "./results/${timestamp_er}.results.default-BDD.Application.xml.bz2" \
    "./results/${timestamp_er}.results.bare-BDD.Application.xml.bz2"
table-generator --no-diff -f csv -o ./csv -x ./scatter.xml -n "dcssat.scatter" \
    "./results/${timestamp_er}.results.default-BDD.Application.xml.bz2" \
    "./results/${timestamp_dc}.results.default.Application.xml.bz2"

echo "Compiling scatter plots from the tex files ..."
pdflatex -output-directory=./plots ./tex/scatter-erssat.tex
pdflatex -output-directory=./plots ./tex/scatter-dcssat.tex

# Generate the LaTeX commands for application formulas
cmdfile='./tex/data-commands.tex'
echo "" > $cmdfile
echo "Generating data commands for application formulas ..."
./statistics-tex.py "./results/${timestamp_dc}.results.default.Application.xml.bz2" >> $cmdfile
./statistics-tex.py "./results/${timestamp_er}.results.default-BDD.Application.xml.bz2" >> $cmdfile
./statistics-tex.py "./results/${timestamp_er}.results.bare-BDD.Application.xml.bz2" >> $cmdfile

# Define missing commands for those values equal to zero
write_missing_commands \
    "$(normalize_string_for_benchexec "$timestamp_dc")" \
    "$(normalize_string_for_benchexec default-Application)" \
    "$cmdfile"
write_missing_commands \
    "$(normalize_string_for_benchexec "$timestamp_er")" \
    "$(normalize_string_for_benchexec default-BDD-Application)" \
    "$cmdfile"
write_missing_commands \
    "$(normalize_string_for_benchexec "$timestamp_er")" \
    "$(normalize_string_for_benchexec bare-BDD-Application)" \
    "$cmdfile"

# Define other inconclusive commands
write_inconclusive_commands \
    "$(normalize_string_for_benchexec "$timestamp_dc")" \
    "$(normalize_string_for_benchexec default-Application)" \
    "$cmdfile"
write_inconclusive_commands \
    "$(normalize_string_for_benchexec "$timestamp_er")" \
    "$(normalize_string_for_benchexec default-BDD-Application)" \
    "$cmdfile"
write_inconclusive_commands \
    "$(normalize_string_for_benchexec "$timestamp_er")" \
    "$(normalize_string_for_benchexec bare-BDD-Application)" \
    "$cmdfile"

tool_name=(dcssat erssatb erssat)
application_formula_families=('ToiletA' 'conformant' 'castle' 'MaxCount' 'MPEC')
#application_formula_families=('ere-ToiletA' 'ere-conformant' 'ere-sand-castle' 'ere-MaxCount' 'ere-MPEC')
echo "Generating a tex file for data commands of application formulas ..."
table-generator --no-diff -f csv -o ./csv -x ./status.xml -n "status" \
    "./results/${timestamp_dc}.results.default.Application.xml.bz2" \
    "./results/${timestamp_er}.results.bare-BDD.Application.xml.bz2" \
    "./results/${timestamp_er}.results.default-BDD.Application.xml.bz2"
echo "% Commands for application formulas of ER-SSAT" >> "${cmdfile}"
for i in {2..4}; do
    for family in "${application_formula_families[@]}"; do
        number_solved_instances=$(compute_number_solved_instances "${family}" "${i}")
        write_tex_data_command "${tool_name[i-2]}${family}" "${number_solved_instances}" "${cmdfile}"
    done
done
