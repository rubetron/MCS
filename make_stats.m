function out = make_stats(data, boot_index)

data_mean = mean(data,1)';
[n B] = size(boot_index);
weights = zeros(n, B);
for i=1:B
    t = tabulate(boot_index(:,i));
    weights(t(:,1),i) = t(:,2)/n;
end

boot_data_mean = data'*weights;

out.data_mean = data_mean;
out.boot_data_mean = boot_data_mean;
