%{
****************************************************
FIRST VERSION OF THE PROGRAM STOSS (ZIQI PROJECT)
****************************************************
%}

addpath('C:\Users\Principal\Documents\STOSS-DC');
clear 
clc

%------------------
%   Timer:
%------------------
tic

%---------------------------------------------------
%   Reading experimental conditions from EXCEL file
%---------------------------------------------------
[simulate_all_experimental_temperatures, total_number_spins, Temperature, decays_or_hysteresis, save, sweep_rate, number_of_cristal_configurations, starting_mode, ...
    number_spins, maximun_value_magnetic_field, magnetic_field_batches, time_per_batch, total_time, step_length, total_time_steps,...
    index_starting_plotting_point, external_magnetic_field] = read_data ();

if (decays_or_hysteresis == 0)
    [peso, total_gap] = numerical_integration_data ();
else
    peso = 1;
    total_gap = [1, 2];
end

%--------------------------------
%   Arrays for saving results
%--------------------------------
simulation_steps_after_stabilization = round(total_time_steps -index_starting_plotting_point);
total_spin_states = single(zeros (simulation_steps_after_stabilization, number_of_cristal_configurations)); 
matrix_temporal_for_hysteris = single(zeros (simulation_steps_after_stabilization, number_of_cristal_configurations));
magnetic_hysteresis = single(zeros (1, simulation_steps_after_stabilization));
total_time_vector = 0:step_length:total_time;
Zeeman_effect_total = single(zeros (simulation_steps_after_stabilization, number_of_cristal_configurations)); 
relaxation_time_total = single(zeros (simulation_steps_after_stabilization, number_of_cristal_configurations)); 
up_probability_total = single(zeros (simulation_steps_after_stabilization, number_of_cristal_configurations)); 
down_probability_total = single(zeros (simulation_steps_after_stabilization, number_of_cristal_configurations)); 
y_relaxation_total = single(zeros (simulation_steps_after_stabilization, number_of_cristal_configurations)); 
HS_spins_total = single(zeros (simulation_steps_after_stabilization, number_of_cristal_configurations));
LS_spins_total = single(zeros (simulation_steps_after_stabilization, number_of_cristal_configurations));
Magnetic_Field_local_total = single(zeros (simulation_steps_after_stabilization, number_of_cristal_configurations));

for i = 1:number_of_cristal_configurations
    disp(['Part:', num2str(i)]);
    
    [Magnetic_Field_local, magnetic_response, Zeeman_effect, relaxation_time, up_probability, down_probability, y_relaxation, spin_states, HS_spins, LS_spins] = iteration_process (number_spins, total_time_steps, starting_mode, external_magnetic_field, decays_or_hysteresis, total_gap(i+1), step_length, Temperature, index_starting_plotting_point);       
    
    if (decays_or_hysteresis == 0)
        for j = 1:length(magnetic_response)
            
            total_spin_states (j, i) = magnetic_response(j);
            Zeeman_effect_total (j, i) = Zeeman_effect(j);
            relaxation_time_total (j, i) = relaxation_time(j);
            down_probability_total (j, i) = down_probability(j);
            up_probability_total (j, i) = up_probability(j);
            y_relaxation_total (j, i) = y_relaxation (j);
            Magnetic_Field_local_total (j, i) = Magnetic_Field_local (j);


            HS_spins_total (j, i) = HS_spins (j);
            LS_spins_total (j, i) = LS_spins (j);


            matrix_temporal_for_hysteris (j, i) = total_spin_states (j, i) * peso (i);
        end
    end
end

if (decays_or_hysteresis == 0)
    magnetic_hysteresis  = sum (matrix_temporal_for_hysteris');
    %for j =1:simulation_steps_after_stabilization
     %   magnetic_hysteresis (j) = sum (matrix_temporal_for_hysteris(j, :));
    %end
end

final = toc;
disp ('-------------------------------------------------')
disp ('Information about the simulation')
disp ('-------------------------------------------------')
disp ('Time, secs:')
disp (final)

%--------------------------------
%   Plotting results
%--------------------------------
delete('hysteresis_data.xlsx');
y = external_magnetic_field(index_starting_plotting_point:end-1)';
x = magnetic_hysteresis;
final_data = [x; y]';

filename = 'hysteresis_data.xlsx';
writematrix(final_data, filename,'Sheet',1)



