import pandas as pd


def load_africa():
    return pd.read_csv('./data/base/africa.csv', index_col='code')
