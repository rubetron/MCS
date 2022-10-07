function out = t_range(stats)

data_mean = stats.data_mean;
boot_data_mean = stats.boot_data_mean;
B = size(boot_data_mean,2);
boot_data_mean_shift = boot_data_mean - repmat(data_mean, 1, size(boot_data_mean,2));
m = numel(data_mean);

% all combinations of pairs of models
ij_index = nchoosek(1:m, 2);

% calculate the average difference in loss between each pair of models
n_combs = size(ij_index,1);
d_ij = zeros(n_combs,1);
for i=1:n_combs
    d_ij(i,1) = data_mean(ij_index(i,1)) - data_mean(ij_index(i,2));
end

boot_d_ij = zeros(n_combs, B);
for b = 1:B
    for i = 1:n_combs
        boot_d_ij(i, b) = abs(boot_data_mean_shift(ij_index(i,1), b) - boot_data_mean_shift(ij_index(i,2), b));
%         boot_d_ij(i, b) = boot_data_mean(ij_index(i,1), b) - boot_data_mean(ij_index(i,2), b);
    end
end

sd_d_ij = sqrt(mean(boot_d_ij.*boot_d_ij, 2));
% sd_d_ij = std(boot_d_ij')';
t_stat = d_ij./sd_d_ij;
boot_t_stat = boot_d_ij./repmat(sd_d_ij, 1, size(boot_d_ij,2));

candidate = find(abs(t_stat) == max(abs(t_stat)));

T_range = abs(t_stat(candidate));
boot_T_range = max(abs(boot_t_stat),[], 1);
p_value = mean((boot_T_range - T_range) > 0);
if (t_stat(candidate) > 0 )  
    candidate  = ij_index(candidate, 1);
else
    candidate  = ij_index(candidate, 2);
end

out.candidate = candidate;
out.p_value = p_value;

% [xx yy] = meshgrid(data_mean);
% d_ij2 = xx-yy;
% d_ij2 = d_ij2(tril(d_ij2)~=0);
% ind_lower = tril(d_ij2);
% 
% d_ij2 = d_ij2(:);
% d_ij2(d_ij2 ==0) = [];
% 
% d_ij = (as.matrix(data.mean), ij.index - 1);

