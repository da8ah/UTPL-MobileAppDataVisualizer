import pandas as pd
import numpy as np

__ruta_data = './data/'
__ruta_dataSource = __ruta_data + 'COVID-19_mobile_apps.csv'
__ruta_countryCodes = __ruta_data + 'CountryCodes.csv'
'''
PRE-PROCESAMIENTO
'''


def __procesar_fuente_de_datos():

    # Load DataSource
    df = pd.read_csv(__ruta_dataSource,
                     index_col='releaseDate',
                     parse_dates=['releaseDate', 'latestUpdate'])

    # Drop NaT indexes
    df_not_indexNa = df[df.index.isin(df.index.dropna())]

    # Format index with uniform datetime format
    df_index_formatted = pd.DataFrame({
        'releaseDate': [
            pd.to_datetime(fecha.strftime('%Y-%m-%d'))
            for fecha in df_not_indexNa.index
        ],
        'name':
        df_not_indexNa['name'].values,
        'continents':
        df_not_indexNa['continents'].values,
        'geographicCoverage': # UAE and ARE refers to same country (ARE is widely used):
        df_not_indexNa['geographicCoverage'].replace(to_replace='UAE',
                                                     value='ARE').values,
        'storeName':
        df_not_indexNa['storeName'].values,
        'status':
        df_not_indexNa['status'].values
    }).dropna().set_index('releaseDate').sort_index()

    return df_index_formatted


def __unir_df_index_formatted_con_ubicaciones(df_index_formatted):

    # Load Country Codes
    df_countryCodes = pd.read_csv(__ruta_countryCodes)

    # Splitting Codes and Names
    matrixCodesAndNames = np.transpose([
        [
            code,
            df_countryCodes['name'][df_countryCodes['alpha-3'] == code].item()
        ] for code in
        df_index_formatted['geographicCoverage'].drop_duplicates().values
        if len(df_countryCodes['name'][df_countryCodes['alpha-3'] == code]) > 0
    ]).tolist()

    # Adding WORLD Code and Name
    matrixCodesAndNames[0].append('WORLD')
    matrixCodesAndNames[1].append('WORLD')

    # Dataframe with Codes (as index) and Names
    df_countryCodesAndNames = pd.DataFrame({
        'geographicCoverage':
        matrixCodesAndNames[0],
        'country':
        [name.split(',')[0].split(' (')[0] for name in matrixCodesAndNames[1]]
    }).set_index('geographicCoverage').sort_index()

    # Join dataframes to integrate them into one (on Codes)
    df_joined = df_index_formatted.join(df_countryCodesAndNames,
                                        on='geographicCoverage')[[
                                            'name', 'continents',
                                            'geographicCoverage', 'country',
                                            'storeName', 'status'
                                        ]]

    return df_joined


def dataframe():
    df_index_formatted = __procesar_fuente_de_datos()
    df_joined = __unir_df_index_formatted_con_ubicaciones(df_index_formatted)
    return df_joined


def __obtener_continents(df_joined):

    # Obtaining Continents
    continents = [
        continent for continent in
        df_joined['continents'].sort_values().unique().tolist()
    ]

    # Insert WORLD at 0 index
    continents.insert(0, continents.pop(len(continents) - 1))

    return continents


def ubicaciones(df_joined):

    # Filtering Continents
    continents = __obtener_continents(df_joined)

    # Filtering World Countries
    world = df_joined['country'][df_joined['country'] != 'WORLD'].dropna(
    ).drop_duplicates().sort_values().values.tolist()
    world.insert(0, 'ALL')

    # Filtering Countries Per Continent
    countriesPerContinent = [
        df_joined['country'][df_joined['continents'] == continent].
        drop_duplicates().sort_values().values.tolist()
        for continent in continents if continent != 'WORLD'
    ]

    # Adding to the list World's data at 0 index
    countriesPerContinent.insert(0, world)

    # Returning an Array with Continents and Contries
    return [continents, countriesPerContinent]