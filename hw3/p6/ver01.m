clear all;
for N = 4:10
  binMat = dec2bin(0:2^N-1);
  isDichotomy = nan(size(binMat,1),1);
  signflip  = nan(size(binMat,1),1);
  for m = 1:size(binMat,1)
    aRow = binMat(m,:)=='1';
    temp = find(aRow, 1, 'first');
    signflip(m) = 0;
    if ~isempty(temp) && temp~=size(binMat,2)
      for t = temp+1:numel(aRow)
        if aRow(t-1) ~= aRow(t)
          signflip(m)= signflip(m)+ 1;
        end
        temp = aRow(t);
      end
    end
    isDichotomy(m) = signflip(m) < 4;
  end
  
  
  a = nchoosek(N+1,4);
  b = nchoosek(N+1,2) + 1;
  c = nchoosek(N+1,4) + nchoosek(N+1,2) + 1;
  d = nchoosek(N+1,4) + nchoosek(N+1,3) + nchoosek(N+1,2) + nchoosek(N+1,1) + 1;
  
  fprintf('%2d\t%8d\t%8d\t%8d\t%8d\t%8d\n', N, sum(isDichotomy), a, b, c, d);
  
  %a
  
end

