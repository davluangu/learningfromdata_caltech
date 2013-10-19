pf = [
    0 0 0;
    0 0 1;
    0 1 0;
    0 1 1;
    1 0 0;
    1 0 1;
    1 1 0;
    1 1 1;
    ];

% x = [
%     0 0 0;
%     0 0 1;
%     0 1 0;
%     0 1 1;
%     1 0 0;
%     1 0 1;
%     1 1 0;
%     1 1 1;
%     ];


cnt = zeros(4, size(pf,1));

for n = 1:size(pf,1)
    possiblefunc = pf(n,:);
    hyp(1) = 1;
    hyp(2) = 0;
    hyp(3) = mod(sum(possiblefunc),2);
    hyp(4) = ~hyp(3);
    for m = 1:numel(possiblefunc)
        for h = 1:numel(hyp)
            if possiblefunc(m) == hyp(h)
                cnt(h,n) = cnt(h,n) + 1;
            end
        end
    end
end
sum(cnt.^2,2)

