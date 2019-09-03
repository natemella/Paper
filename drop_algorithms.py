import pandas as pd
import sys
import os

cwd = os.getcwd()
algorithms = sys.argv[1:]

for file in os.listdir(cwd):
    if file.endswith(("tsv", "txt")):
        df = pd.read_csv(file, sep='\t')
        for algo in algorithms:
            df = df.loc[~(df.Algorithm == algo)]
        df.to_csv(file, sep='\t', index=False)