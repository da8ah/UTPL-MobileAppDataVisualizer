import pandas as pd
import numpy as np

rutaData = './data/'
rutaDataSource = rutaData + 'COVID-19_mobile_apps.csv'
rutaDataBase = rutaData + 'base/'
rutaDataWithFormat = rutaDataBase + 'data.csv'
rutaGeographicCoverage = rutaDataBase + 'geographicCoverage_'


def __procesar_fuente_de_datos(rutaDataSource):

    # Load DataSource
    df = pd.read_csv(rutaDataSource, index_col='releaseDate',
                     parse_dates=['releaseDate', 'latestUpdate'])

    # Drop NaN indexes
    df_not_indexNaN = pd.DataFrame({
        'releaseDate': df[df.index.isin(df.index.dropna())].index,
        'name': df['name'][df.index.isin(df.index.dropna())].values,
        'continents': df['continents'][df.index.isin(df.index.dropna())].values,
        'geographicCoverage': df['geographicCoverage'][df.index.isin(df.index.dropna())].values
    }).set_index('releaseDate')

    # Format index with uniform datetime format
    pd.DataFrame({
        'releaseDate': [pd.to_datetime(fecha.strftime('%Y-%m-%d %H:%M:%S')) for fecha in df_not_indexNaN['name'].index],
        'name': df_not_indexNaN['name'].values,
        'continents': df['continents'][df.index.isin(df.index.dropna())].values,
        'geographicCoverage': df['geographicCoverage'][df.index.isin(df.index.dropna())].values
    }).set_index('releaseDate').sort_index().to_csv(rutaDataWithFormat)

    return True


def __extraer_cobertura_geografica(df_formated):
    continents = [continent.title(
    ) for continent in df_formated['continents'].sort_values().unique().tolist()]
    continents.insert(0, continents.pop(len(continents) - 1))
    continents = pd.DataFrame({
        'continents': continents
    }).set_index('continents').to_csv(rutaGeographicCoverage + 'continents.csv')

    return True
