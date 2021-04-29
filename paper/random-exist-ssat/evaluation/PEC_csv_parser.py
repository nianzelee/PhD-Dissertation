#!/usr/bin/python3

import numpy as np
import pandas as pd

# Read CSV file generated by table-generator
df = pd.read_csv("./csv/PEC.table.csv", sep="\t")
df = df.fillna(value=np.nan)
# Drop useless rows
df = df.drop([0, 1])
# Adjust formula names
df = df.replace(regex=r"^re-", value="")
df = df.replace(regex=r"-0.125", value="")
df = df.replace(regex=r"\.sdimacs", value="")
df = df.replace(regex=r"mem_ctrl", value="mem\_ctrl")
# Erase CPU time if the task is not done
df["DC-SSAT .1"][df["DC-SSAT "] != "done"] = np.nan
df["ABC .1"][df["ABC "] != "done"] = np.nan
df["ABC .5"][df["ABC .4"] != "done"] = np.nan
# Erase upper bound if it equals 1.0
df["ABC .3"][df["ABC .3"] == "1.000000"] = np.nan
df["ABC .7"][df["ABC .7"] == "1.000000"] = np.nan
# Drop useless columns and rename left columns
df = df.drop(["DC-SSAT "], axis=1)
df = df.drop(["ABC "], axis=1)
df = df.drop(["ABC .4"], axis=1)
df.columns = [
    "Formula",
    "DC-T",
    "DC-P",
    "erSSAT-T",
    "erSSAT-P",
    "erSSAT-U",
    "erSSATb-T",
    "erSSATb-P",
    "erSSATb-U",
]
# Drop all-empty rows
df = df.dropna(how="all", subset=df.columns[1:])
# Write out two parsed csv file (defect rate equals 0.01 and 0.10)
df[df["Formula"].str.contains("0.01")].replace(regex="-0.01", value="").to_csv(
    "./csv/parsed-PEC-0.01.csv", sep="\t", na_rep="nan", index=False
)
df[df["Formula"].str.contains("0.10")].replace(regex="-0.10", value="").to_csv(
    "./csv/parsed-PEC-0.10.csv", sep="\t", na_rep="nan", index=False
)
