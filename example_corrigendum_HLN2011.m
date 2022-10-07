% This example applies the MCS procedure to the inflation forecast data
% from Hansen, Lunde, and Nason (2011). The results should match those in
% the first column of Table IV of the corrigendum to the paper. 

data = readtable('\estMCS\SW_infl4cast.csv');
Y = data.Obs;
forecasts = data(:, 2:end);
loss = (forecasts.Variables - repmat(Y, 1, size(forecasts,2))).^2;
loss = array2table(loss, 'VariableNames', forecasts.Properties.VariableNames);
mcs_inflation = estMCS(loss, 25000, 12);

% MCS p-values from Table IV from the corrigendum
p_MCS_paper = [0.045
               0.177
               0.129
               0.065
               0.266
               0.886
               0.266
               0.173
               1.00
               0.266
               0.477s
               0.815
               0.886
               0.753
               0.416
               0.116
               0.477
               0.753
               0.199];
           
bar([mcs_inflation.MCS_p_val p_MCS_paper])
legend('This implementation', 'Hansen, Lunde and Nason (2011)')