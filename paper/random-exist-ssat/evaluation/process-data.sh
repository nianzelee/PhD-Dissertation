#!/bin/bash

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

formula_families=('Random' 'Strategic')
column_identifiers=('cputime' 'memory')

timestamp_re='ressat.2021-04-23_21-45-25'
compared_approaches=('bare-Cachet' 'minimize-Cachet')
echo "Generating CSV files of ressat for quantile plots ..."
for approach in "${compared_approaches[@]}"; do
    for family in "${formula_families[@]}"; do
        for identifier in "${column_identifiers[@]}"; do
            echo "  > Configuration: ${approach}; Family: ${family}; Identifier: ${identifier}"
            ./quantile-generator.py --sort-by "${identifier}" \
                "./results/${timestamp_re}.results.${approach}.${family}.xml.bz2" \
                > "./csv/ressat.${approach}.${family}.quantile.${identifier}.csv"
        done
    done
done

timestamp_dc='dcssat-re.2021-04-24_12-18-42'
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

echo "Generating CSV files of strategic-company formulas for scatter plots ..."
table-generator --no-diff -f csv -o ./csv -x ./scatter.xml -n "ressat.scatter" \
    "./results/${timestamp_re}.results.minimize-Cachet.Strategic.xml.bz2" \
    "./results/${timestamp_re}.results.bare-Cachet.Strategic.xml.bz2"
table-generator --no-diff -f csv -o ./csv -x ./scatter.xml -n "dcssat.scatter" \
    "./results/${timestamp_re}.results.minimize-Cachet.Strategic.xml.bz2" \
    "./results/${timestamp_dc}.results.default.Strategic.xml.bz2"

echo "Compiling scatter plots from the tex files ..."
pdflatex -output-directory=./plots ./tex/scatter-ressat.tex
pdflatex -output-directory=./plots ./tex/scatter-dcssat.tex

# Generate the LaTeX commands for application formulas
cmdfile='./tex/data-commands.tex'
echo "" > $cmdfile
echo "Generating data commands for application formulas ..."
compared_approaches=('bare-Cachet' 'minimize-Cachet')
formula_families=('Strategic' 'PEC')
for approach in "${compared_approaches[@]}"; do
    for family in "${formula_families[@]}"; do
        ./statistics-tex.py "./results/${timestamp_re}.results.${approach}.${family}.xml.bz2" >> $cmdfile
        write_missing_commands \
            "$(normalize_string_for_benchexec "$timestamp_re")" \
            "$(normalize_string_for_benchexec "${approach}-${family}")" \
            "$cmdfile"
        write_inconclusive_commands \
            "$(normalize_string_for_benchexec "$timestamp_re")" \
            "$(normalize_string_for_benchexec "${approach}-${family}")" \
            "$cmdfile"
    done
done
compared_approaches=('default')
for approach in "${compared_approaches[@]}"; do
    for family in "${formula_families[@]}"; do
        ./statistics-tex.py "./results/${timestamp_dc}.results.${approach}.${family}.xml.bz2" >> $cmdfile
        write_missing_commands \
            "$(normalize_string_for_benchexec "$timestamp_dc")" \
            "$(normalize_string_for_benchexec "${approach}-${family}")" \
            "$cmdfile"
        write_inconclusive_commands \
            "$(normalize_string_for_benchexec "$timestamp_dc")" \
            "$(normalize_string_for_benchexec "${approach}-${family}")" \
            "$cmdfile"
    done
done

# Generate tables with upper bounds for PEC formulas
table-generator -f csv --no-diff -o ./csv -x ./PEC.xml
./PEC_csv_parser.py
