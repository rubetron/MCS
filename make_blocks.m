function out = make_blocks(n,l)

blocks = zeros(l,n);
blocks(1,:) = 1:n;
if (l>1)
    for i=2:l
        blocks(i,:) = [i:n 1:(i-1)];
    end
end

out = blocks;