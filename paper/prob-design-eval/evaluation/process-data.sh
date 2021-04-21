#!/bin/bash

table-generator -x PEC.xml -f csv -o ./csv --no-diff
./csv_parser.py
