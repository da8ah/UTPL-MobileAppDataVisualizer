classdef MobileAppDataset < handle
    
    properties (Access = private)
        datatable;
        countries;
    end
    
    methods (Access = private)
        function loadData(obj,path)
            obj.datatable = readtable(path);
            obj.countries = readtable('africa.csv');
        end
    end

    methods
        function obj = MobileAppDataset(path)   
            obj.loadData(path);
        end
        
        function datatable = getData(obj)
            datatable = obj.datatable;
        end

        function [releaseDate, cant] = getCountPerMonth(obj)
            releaseDate = datetime(obj.datatable{:,'releaseDate'},'InputFormat','yyyy-MM');
            cant = obj.datatable{:,'cant'};
        end

        function countries = getCountries(obj)
            countries = obj.countries;
        end
    end
        
end
