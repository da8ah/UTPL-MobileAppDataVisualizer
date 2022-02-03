classdef MobileAppDataset < handle
    
    properties (Access = private, Constant)
        PathDataBase = './data/base/';
        PathGeographicCoverage = horzcat(MobileAppDataset.PathDataBase,'geographicCoverage_');
        PathCountPerMonth = horzcat(MobileAppDataset.PathDataBase,'count_per_month.csv');
    end

    properties (Access = private)
        countPerMonthTable;
        continents;
        countries;
    end
    
    methods (Access = private)
        function loadData(obj)
            obj.continents = readtable(horzcat(obj.PathGeographicCoverage,'continents','.csv'),'Delimiter',',');
            obj.countries = cell(1,7);
            for continent = 1:length(obj.continents{:,1})
                obj.countries{continent} = {readtable(horzcat(obj.PathGeographicCoverage,replace(lower(obj.continents{continent,1}{:}),' ','_'),'.csv'),'Delimiter',',')};
            end
            obj.countPerMonthTable = readtable(obj.PathCountPerMonth);
        end
    end

    methods
        function obj = MobileAppDataset()   
            obj.loadData();
        end
        
        function countPerMonthTable = getCountPerMonthTable(obj)
            countPerMonthTable = obj.countPerMonthTable;
        end

        function [releaseDate, cant] = getCountPerMonth(obj)
            releaseDate = datetime(obj.countPerMonthTable{:,'releaseDate'},'InputFormat','yyyy-MM');
            cant = obj.countPerMonthTable{:,'cant'};
        end

        function continents = getContinents(obj)
            continents = obj.continents;
        end

        function countries = getCountries(obj)
            countries = obj.countries;
        end

        function msg = pydisp(obj,input)
            py.importlib.import_module('procesamiento')
            msg = py.procesamiento.imprimir(input);
        end
    end
        
end
