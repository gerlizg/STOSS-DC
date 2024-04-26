function [Magnetic_Field_local, magnetic_response, Zeeman_effect, relaxation_time, up_probability, down_probability, y_relaxation, spin_states, HS_spins, LS_spins] = iteration_process (number_spins, total_time_steps, starting_mode, external_magnetic_field, decays_or_hysteresis, total_gap, step_length, Temperature, index_starting_plotting_point)    
   

%-------------------------------------------------
%   Defining physical parameters
%-------------------------------------------------
                          
n= 3.3;                              % Exponential factor (Raman) 
C = 2.9E-08;                         % Pre-factor factor (Raman)    
A = 0.02/100;                        % Constant factor (direct mechasnim)     
tau_QTM = 100;                       % QTM
B_2 = 500;                            % Constant Factor (QTM) 
miu_B = 0.671713816;                 % Bohr's magneton                   
Mj = 0.5;                            % Spin Projection
tunning_factor = 0.25;                        % 0.25T multiplied for the ratio spins up and down
    
if (decays_or_hysteresis == 1)
    g_Dy = 6.63;                                    % Mean value for gDy
end


%-------------------------------------------------
%   Creating arrays:
%-------------------------------------------------

spin_states = single(zeros (number_spins, total_time_steps));      
up_probability = single(zeros (1, total_time_steps));                
down_probability = single(zeros (1, total_time_steps));
total_probability = single(zeros (1, total_time_steps)); 
P_ij = single(zeros (1, total_time_steps));   
HS_spins = single(zeros (1, total_time_steps)); 
LS_spins = single(zeros (1, total_time_steps));
Magnetic_Field_local = single(zeros (1, total_time_steps));
Zeeman_effect = single(zeros (1, total_time_steps));
relaxation_time = single(zeros (1, total_time_steps));

%-------------------------------------------------                
%   Iteration over the Matrix
%-------------------------------------------------

% Initializating spins in a specific state:
spin_states(1:round(starting_mode*number_spins), 1) = 1;

% Reading the previous state of each time step:

for z = 2: total_time_steps
    
    rng(z)
    

    random_number_for_comparison = rand ([1, number_spins]);
    
    HS_spins (z-1) = sum (spin_states(:, z-1));
    LS_spins (z-1) = number_spins - HS_spins (z-1);

    Magnetic_Field_local (z) = external_magnetic_field (z) - (tunning_factor * (HS_spins (z-1) - LS_spins (z-1))/(number_spins));
    
    if (decays_or_hysteresis == 1)
        Zeeman_effect (z) = abs (2 * Mj * g_Dy * miu_B * Magnetic_Field_local (z));
    else
        Zeeman_effect (z) = abs (total_gap * Mj * miu_B * Magnetic_Field_local (z));
    end

    if (Zeeman_effect (z) == 0)
        relaxation_time (z) = (  (C*(Temperature^n)) + ((tau_QTM^-1)/(1+(B_2*(Magnetic_Field_local(z)^2))))  )^-1;
    else
        relaxation_time (z) = (  (C*(Temperature^n)) + ((tau_QTM^-1)/(1+(B_2*(Magnetic_Field_local(z)^2)))) + ((Zeeman_effect(z)^2)*(A*coth(Zeeman_effect(z)/Temperature)))  )^-1;
    end

    tau_exp = (relaxation_time (z) / step_length);
    total_probability (z) = total_probability_function (tau_exp);                             
    P_ij (z) = 1 / (exp(Zeeman_effect(z)/Temperature));
    [x, y] = solve_single_p (total_probability (z), P_ij (z));
    up_probability (z) = x;
    down_probability (z) = y;
    
    for j = 1:number_spins
         
        if (Magnetic_Field_local(z)>=0)  % Positive Magnetic Field
        
            % Changing the state from 1 to 0:
            
            if (random_number_for_comparison (j) <= up_probability (z) && spin_states (j, z-1) == 1)
                spin_states (j,z) = 0;
                                    
            % Changing the state from 0 to 1:
            
            elseif (random_number_for_comparison (j) <= down_probability(z) && spin_states(j, z-1) == 0)  
                spin_states (j,z) = 1; 
                                    
            else 
                spin_states (j,z) = spin_states (j, z-1);
            end
                
        else       % Negative Magnetic Field
        
            % Changing the state from 1 to 0:
            
            if (random_number_for_comparison (j) <= down_probability(z) && spin_states (j, z-1) == 1)    
                spin_states (j,z) = 0;
                                  
            % Changing the state from 0 to 1:
            
            elseif (random_number_for_comparison (j) <= up_probability(z) && spin_states (j, z-1) == 0)  
                spin_states (j,z) = 1;
                                    
            else
                spin_states (j,z) = spin_states (j, z-1);
            end
        end
        
    end

end 

%-------------------------------------------------    
%   Relaxation curve:
%-------------------------------------------------

column = sum(spin_states);
y_relaxation = single(number_spins - column);

if (decays_or_hysteresis == 0)
    y_relaxation1 = y_relaxation(index_starting_plotting_point:length(y_relaxation)-1);
    magnetic_response = (number_spins-(2*y_relaxation1))/number_spins; 
else
    magnetic_response = (2*y_relaxation)-number_spins;
end

end


