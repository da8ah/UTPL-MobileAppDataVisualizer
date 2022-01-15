classdef MobileAppDataset < handle
    
    properties (Access = private)
        data;
    end
    
    methods (Access = private)
        function loadData(obj,path)
            obj.data = readtable(path);
        end
    end

    methods
        function obj = MobileAppDataset(path)   
            obj.loadData(path);
        end
        
        function data = getData(obj)
            data = obj.data;
        end

        function [releaseDate, cant] = getCountPerMonth(obj)
            releaseDate = datetime(obj.data{:,'releaseDate'},'InputFormat','yyyy-MM');
            cant = obj.data{:,'cant'};
        end
    end
        
end
