classdef DatasetManager < handle
    
    properties (Access = private)
        init logical = 0;
        PYENV = pyenv;
        dataframe;
        continents;
        countries;
    end
    
    methods (Access = private)
        function loadEnv(obj, pathMods)
            if ~obj.init
                % PYENV config
                if ~strcmp(char(obj.PYENV.Version),'3.9')
                    pathExe = horzcat(pwd,'\env\Scripts\python.exe');
                    pyenv('Version',pathExe);
                end

                % Adding PATH to modules
                sysPath = py.sys.path;
                if count(sysPath,pathMods) == 0
                    insert(sysPath,int32(0),pathMods);
                end              
                
                % Importing modules
                py.importlib.import_module('cargar_data');
                py.importlib.import_module('gestor_de_data');

                obj.init = 1;
            end
        end

        function loadData(obj)
            obj.dataframe = py.cargar_data.dataframe();
            ubicaciones = py.cargar_data.ubicaciones(obj.dataframe);

            obj.continents = string(cell(ubicaciones{1}));
            obj.countries = cell(1,7);
            for continent=1:length(ubicaciones{2})
                obj.countries{continent} = string(cell(ubicaciones{2}{:,continent}));
            end
        end
    end

    methods
        function obj = DatasetManager(pathMods)
            obj.loadEnv(pathMods);
            if obj.init
                obj.loadData();
            end
        end
        
        function init = isInit(obj)
            init = obj.init;
        end

        function version = getPYENVersion(obj)
            version = obj.PYENV.Version;
        end

        function dataframe = getDataframe(obj)
            dataframe = obj.dataframe;
        end

        function continents = getContinents(obj)
            continents = obj.continents;
        end

        function countries = getCountries(obj, continent)
            countries = obj.countries{:,continent};
        end

        function result = filtrar(obj,continent,country,store,status,frecuency,movmean,cumulative)
            if strcmp(continent,'WORLD')
                continent = string(missing);
            end
            if strcmp(country,'ALL')
                country = string(missing);
            end
            if strcmp(store,'Ambos')
                store = string(missing);
            end
            switch status
                case 'Ambos'
                    status = string(missing);
                case 'Activo'
                    status = 'active';
                case 'Inactivo'
                    status = 'notactive';
            end
            switch frecuency
                case 'Diaria'
                    frecuency = 0;
                    datetimeFormat = 'yyyy-MM-dd';
                case 'Mensual'
                    frecuency = 1;
                    datetimeFormat = 'yyyy-MM';
                case 'Anual'
                    frecuency = 2;
                    datetimeFormat = 'yyyy';
            end
            consulta = py.gestor_de_data.consultar_dataframe(obj.dataframe, ...
                continent, ...
                country, ...
                store, ...
                status, ...
                frecuency, ...
                movmean, ...
                cumulative);
            result = {datetime(string(cell(consulta{1})),'InputFormat',datetimeFormat,'Format','preserveinput'),double(py.array.array('d',consulta{2}))};
        end
    end
        
end
