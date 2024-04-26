function [simulate_all_experimental_temperatures, total_number_spins, Temperature, decays_or_hysteresis, save, sweep_rate, ...
    number_of_cristal_configurations, starting_mode, number_spins, maximun_value_magnetic_field, magnetic_field_batches, time_per_batch, total_time, ...
    step_length, total_time_steps, index_starting_plotting_point, external_magnetic_field] = read_data ()

    filename = 'user_configurations.xlsx';
    data_vector = readtable(filename);
    data = table2array (data_vector(:,2));
    data = data(~isnan(data));
    
    %-------------------------------------
    % GENERAL CONFIGURATIONS:
    %-------------------------------------
    simulate_all_experimental_temperatures = data(1);
    total_number_spins = data (2);   
    Temperature = data (3);
    decays_or_hysteresis = data(4);
    save = data (5);       
    sweep_rate = data (6);   

    if (simulate_all_experimental_temperatures == 0)
        Temperature = [1.9, 2, 3, 3.5, 4, 4.5,  5, 7, 9, 11, 13, 15, 17, 19, 21, 23, 25, 27, 29, 31, 33, 35, 37, 39, 41, 44];
    end
    
    if (decays_or_hysteresis == 0)
        number_of_cristal_configurations = 248;     % Numerical Integration for 248 crystal orientations
        starting_mode = 0.5;                        % Starting mode for all the spins (0.5 = 50% spins in the lower state of energy)
    else
        number_of_cristal_configurations = 1;
        starting_mode = 0;
    end

    number_spins = round(total_number_spins/number_of_cristal_configurations)+1;                                    %Spins for each configuration
    maximun_value_magnetic_field = 5;                                                           %Maximum value for Magnetic Field 
    magnetic_field_batches = 5;                                                                 %Number of cycles
    time_per_batch = maximun_value_magnetic_field/sweep_rate;                                                          %secs
    total_time = time_per_batch * magnetic_field_batches;                                       %Timeline, secs
    step_length = (total_time/magnetic_field_batches)/(maximun_value_magnetic_field/0.01);            
    total_time_steps = (round(total_time/step_length));                                           %Total time steps
    index_starting_plotting_point = round(total_time_steps/magnetic_field_batches);

    external_magnetic_field = readtable('B.csv');
    external_magnetic_field = table2array (external_magnetic_field(3:end,1));
    
    if (decays_or_hysteresis == 1)
        external_magnetic_field = single(zeros (1, total_time_steps));
    end
end