import pandas as pd
import sys
import os

cwd = os.getcwd()
algorithms = sys.argv[1:]

for file in os.listdir(cwd):
    if file.endswith("tsv"):
        new_name = file.replace("+", " +")
        os.rename(file, new_name)