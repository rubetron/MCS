function out = make_index(B, blocks)

[l n] = size(blocks);
z = ceil(n/l);
start_points = randi(n, z*B,1);
index = blocks(:, start_points);
keep = [ones(n, 1); zeros(z*l-n,1)];
keep = repmat(keep, B, 1);
index = index(:);
boot_index = reshape(index(keep==1), n, B);

out = boot_index;