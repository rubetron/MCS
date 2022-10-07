function out = estMCS(loss, B, l)

% This function carries estimated the Model Confidence Set procedure of Hansen, 
% Lunde and Nason (2011), i.e. a set that contains the best model with a given
% probability. This code is almost entirely adapted from the modelconf
% R package written by Rolf Tschernig and maintained by Niels Aka. 
% 
% INPUTS: 
% loss: (n x m) matrix or table of losses for m models. 
% B: number of bootstrap samples.
% l: length of bootstrap block in the moving-block bootstrap.
% 
% OUTPUT
% The function returns an (m x 3) table. The first column contains the model order
% (as defined in the loss matrix). The second column contains the p-value +3
% associated with the test that removed that particular model from the set. 
% The third column contains the MCS p-values, which can be used to
% determine which models belong to the MCS of a specific significance
% level. 
%
% NOTES
% The original paper proposed using one of two statistics in the MCS procedure. 
% One is based on a maximum t-statistic (T_max), and the other is based on a 
% range statistic (T_R). However, due to a mistake in the implementation,
% the authors reported results using a minimum t-statistic. In a corrigendum
% to the paper, the authors recommend the use of the range statistics, which 
% is the only one used in this implementation. Note that the modelconf R 
% package from which this code was adapted allows the user to select the other
% statistics. 
%
% REFERENCES
% [1] Hansen, P. R., Lunde, A., Nason, J. M. 2011. "The Model Confidence Set",
% Econometrica, 79(2), 453 - 497. (see also the corrigendum to the paper).
% [2] The modelconf R package, written by R. Tschernig and maintained by Niels Aka.
% Available at  https://github.com/nielsaka/modelconf/.

% check if user provided an array or a table with the losses. If the user
% provided a table, the names of the columns are used as the names of the
% models. Otherwise, model names are created sequentially following the
% order of the columns in loss. 
[n m] = size(loss);
if ( istable(loss) || istimetable(loss) )
    model_names = loss.Properties.VariableNames;
    loss_data = loss.Variables;
else
    model_names = cell(1,m);
    for i=1:m
        model_names{i} = ['Model_' num2str(i)];
    end
    loss_data = loss;
end

% create blocks for bootstrap
blocks = make_blocks(n,l);
% create indices corresponding to blocks
boot_index = make_index(B, blocks);
% initialize output
mcs = nan(m, 3);
models = 1:m;
stats = make_stats(loss_data, boot_index);

% run MCS procedure
for i=1:m-1
    rejection = t_range(stats);
    if ~isempty(rejection.candidate)
        mcs(i,:) = [models(rejection.candidate) ...
                    rejection.p_value ...
                    max( [mcs(:, 2);rejection.p_value])];
        models(rejection.candidate) = [];
        stats.data_mean(rejection.candidate) = [];
        stats.boot_data_mean(rejection.candidate,:) = [];
    end
end

% output
mcs(m, :) = [models 1 1];
mcs = sortrows(mcs,1);
mcs = [mcs(:,1) mean(loss_data)' mcs(:, 2:end)];

out = array2table(mcs, 'VariableNames', {'Model', 'Mean_loss', 'p_value', 'MCS_p_val'},...
                        'RowNames', model_names);
