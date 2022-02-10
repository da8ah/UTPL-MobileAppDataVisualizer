classdef DatasetManager < handle
    
    properties (Access = private)
        init logical = 0; % To know if the python ENV is inicialized
        PYENV = pyenv; % Variable to save all pyenv info
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
            % Loading data to dataframe, continents and countries variables
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
            obj.loadEnv(pathMods); % Load Enviroment and set Init to true
            if obj.init % if init
                obj.loadData(); % Load data
            end
        end
        
        % Getters
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

        % Use user inputs from GUI to filter data using the dataframe
        function result = filtrar(obj,continent,country,store,status,frecuency,movmean,cumulative)
            % string(missing) = python None value
            % if None python function returns all
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
            % Format to convert datetime index from dataframe
            % Python function receive:
            % frecuency = 0 as 'D'
            % frecuency = 1 as 'M'
            % frecuency = 2 as 'Y'
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

            % Applying filters and querying the dataframe
            consulta = py.gestor_de_data.consultar_dataframe(obj.dataframe, ...
                continent, ...
                country, ...
                store, ...
                status, ...
                frecuency, ...
                movmean, ...
                cumulative);

            % Returning a cell with formatted dates and quantities
            result = {datetime(string(cell(consulta{1})),'InputFormat',datetimeFormat,'Format','preserveinput'),double(py.array.array('d',consulta{2}))};
        end
    end
        
end
