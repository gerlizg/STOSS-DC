function [peso, total_gap] = numerical_integration_data ()

filename_1 = 'peso.txt';
data_vector = readtable(filename_1);
data = table2array (data_vector(:,2));
peso = data(~isnan(data));

filename_2 = 'total_gap.txt';
data_vector = readtable(filename_2);
data = table2array (data_vector);
total_gap = data(~isnan(data));

end