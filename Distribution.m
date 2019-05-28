% % % % % % % % % % % % % % % % % % % % %
%
% % Allocate city compost to farms within a given radius.
%
%       Input:
%             CityTable: table of cities and their compost production (1 row for each city)
%             FarmTable: table of famrs and their compost needs (1 row for each farm)
%             CloseCity: table of XX closest cities to each farm  (XX rows for each farm)
%
%      Output:
%             CityTable: add a new column that indicates what quantity of the city's compost could be allocated to farms
%             FarmTable: add a new column that indicates what quantitty of farm's compost needs could be met by city compost
%
% % % % % % % % % % % % % % % % % % % % %

clf; clear data

% % % % Input files:
citytable=readtable('CityTableOriginalNEW.xlsx');
citytable.Properties.VariableNames{3} = 'CityMaxCompost';
citytable.Properties.VariableNames{4} = 'CompostAllocated';
CloseFarmTable=readtable('Original4.xlsx');
FarmTable=readtable('FarmTable.xlsx');
FarmTable.Properties.VariableNames('Farm_ID');
FarmTable.Properties.VariableNames('FarmMaxCompost');
FarmTable.Properties.VariableNames('CompostObtained');
FarmTable.Properties.VariableNames('Used');

citytable=unique(citytable); % 1 row for each city  (Creates a resulting file that has total space and remaining space)
scalable_waste = 1; %Allows us to test what it would be like if there were different percentages of waste present in cities. (Currently not applied)
number_of_cities = size(citytable,1);
number_of_farms = size(FarmTable,1);
amount_of_farm_compost =0;
amount_of_farm_compostU =0;
amount_of_city_compostU =0;
amount_of_city_compost =0;
i =1;
for i_cities = 1:number_of_cities  % loop through each farm
    
    cities_id = citytable.City_FID(i_cities);
    %disp(cities_id);
    % find the row index in CloseCityTable that match the farm_id
    % find the row index in CloseFarmTable that match the city id
    rows_CloseFarms = find(CloseFarmTable.City_FID == cities_id);
    
    number_of_closestfarms = size(rows_CloseFarms, 1);
    %disp("# of farms" + number_of_closestfarms);
    %NearCity = tenCloseCity.NearestCity(farm);
    %farmAreaLeft = tenCloseCity.farmarearemaining(farm); %Farm area remaining (Needs to subtract previous amount calculated based on call before this)
    
    for i_farm = 1:number_of_closestfarms %account for all of the cities
        
        farm_id = CloseFarmTable.Farm_FID(rows_CloseFarms(i_farm));
        
        % Find the row index in farmtable that match the farm_id
        row_FarmTable = find(FarmTable.Farm_ID == farm_id);
        
        % Allocate city compost to farm
        
        Farm_Demand = FarmTable.FarmMaxCompost(row_FarmTable)  -  FarmTable.CompostObtained(row_FarmTable); % how much more compost does the farm still need
        City_Supply = citytable.CityMaxCompost(i_cities)  -  citytable.CompostAllocated(i_cities); % how much more compost does the city still have to give
        % disp("Farm" + i);
        i = i+1;
        if( Farm_Demand > 0 && City_Supply > 0 ) % if farm still has need and city still has compost to allocate
            
            if (Farm_Demand >= City_Supply )
                %Various Data collection
                % % % % % % % % % % % % % % % % % % % % %
                %amount_of_farm_compostU = amount_of_farm_compostU + City_Supply;
                %amount_of_farm_compost = amount_of_farm_compost + FarmTable.FarmMaxCompost(i_farm);
                %amount_of_city_compostU = amount_of_city_compostU  + City_Supply;
                %amount_of_city_compost = amount_of_city_compost + citytable.CityMaxCompost(i_cities);
                % % % % % % % % % % % % % % % % % % % % %
                
                FarmTable.CompostObtained(row_FarmTable) = FarmTable.CompostObtained(row_FarmTable) + City_Supply; %Calculate how much compost each farm obtained
                FarmTable.Used(row_FarmTable) = 1; %Mark if farm was used
                citytable.CompostAllocated(i_cities) = citytable.CompostAllocated(i_cities) + City_Supply;
                disp("Farm" + i + " " + FarmTable.CompostObtained(row_FarmTable));
                disp("City" + i_cities + " " +  citytable.CompostAllocated(i_cities));
                
            else
                %Various Data collection
                % % % % % % % % % % % % % % % % % % % % %
                % City_Supply must be greater than Farm_Demand
                %amount_of_farm_compostU = amount_of_farm_compostU + Farm_Demand;
                %amount_of_farm_compost = amount_of_farm_compost + FarmTable.FarmMaxCompost(row_FarmTable);
                %amount_of_city_compostU = amount_of_city_compostU  + Farm_Demand;
                %amount_of_city_compost = amount_of_city_compost + citytable.CityMaxCompost(i_cities);
                FarmTable.CompostObtained(row_FarmTable) = FarmTable.CompostObtained(row_FarmTable) + Farm_Demand; %Calculate how much compost each farm obtained
                FarmTable.Used(row_FarmTable) = 1; %Mark if farm was used
                citytable.CompostAllocated(i_cities) = citytable.CompostAllocated(i_cities) + Farm_Demand;
                disp("Farm" + i + " " + FarmTable.CompostObtained(row_FarmTable));
                disp("City" + i_cities + " " +  citytable.CompostAllocated(i_cities));
            end
            
        end
        
    end % end city loop
end% end farm loop
