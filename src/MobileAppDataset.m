classdef MobileAppDataset < handle
    
    properties (Access = private)
        path = '..\data\bundles_prop.csv';
        data;
    end
    
    methods
        %function obj = MobileAppDataset()   
        %end
        function data = getData(obj)
            data = obj.data;
        end
    end
    
    methods        
        function loadData(obj,path)
            obj.data = readtable(path);
        end
    end
    
end

