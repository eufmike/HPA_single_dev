import os
from pathlib import Path
import argparse
import pandas as pd

def merge_csv(args):
    iplist = [Path(x) for x in args.i]
    oppath = Path(args.o)

    df = []
    for csv_path in iplist:
        df.append(pd.read_csv(csv_path))
    df = pd.concat(df, ignore_index=True)
    oppath.parent.mkdir(exist_ok=True, parents=True)
    df.to_csv(oppath, index=False)

    return

def main():
    description = "merge csv file into one single csv file"
    parser = argparse.ArgumentParser(description=description)
    parser.add_argument('-i', type=str, required=True, nargs = '+', help='input csv files')
    parser.add_argument('-o', type=str, required=True, help='output file')
    
    args = parser.parse_args()
    merge_csv(args)
    return

if __name__ == "__main__":
    main()