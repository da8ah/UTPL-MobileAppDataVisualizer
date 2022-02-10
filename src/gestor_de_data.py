'''
PROCESAMIENTO
'''


def consultar_dataframe(df,
                        continent=None,
                        country=None,
                        store=None,
                        status=None,
                        frecuency=1,
                        movmean=1,
                        cumulative=False):

    # Basic queries to filter variables (qualitative data)
    query = df
    if continent != None:
        query = __consultar_continent(query, continent)
    if country != None:
        query = __consultar_country(query, country)
    if store != None:
        query = __consultar_store(query, store)
    if status != None:
        query = __consultar_status(query, status)

    # Statistical queries to get numbers (quantitative data)
    if frecuency >= 0 and frecuency <= 2:
        switcher = {
            0: 'D',
            1: 'M',
            2: 'Y',
        }
        if switcher.get(frecuency) == 'D':
            strftime = '%Y-%m-%d'
        elif switcher.get(frecuency) == 'M':
            strftime = '%Y-%m'
        elif switcher.get(frecuency) == 'Y':
            strftime = '%Y'
        query = __aplicar_frecuency(query, switcher.get(frecuency))
    if movmean > 1 and movmean <= 15:
        query = __aplicar_movmean(query, movmean)
    if cumulative:
        query = __aplicar_cumulative(query)

    # Returning an Array with Indexes and Data Count
    return [
        query.index.strftime(strftime).tolist(), query['name'].values.tolist()
    ]


# Individual functions to each query
def __consultar_continent(df, continent):
    return df[df['continents'] == continent]


def __consultar_country(df, country):
    return df[df['country'] == country]


def __consultar_store(df, store):
    return df[df['storeName'] == store]


def __consultar_status(df, status):
    return df[df['status'] == status]


def __aplicar_frecuency(df, frecuency):
    return df.resample(frecuency).count()


def __aplicar_movmean(df, movmean):
    return df.rolling(int(movmean)).mean().dropna()


def __aplicar_cumulative(df):
    return df.cumsum()