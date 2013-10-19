clear all;
clc

tic
N             = 100000;
NCOINS        = 1000;
NFLIPS        = 10;
headFraction  = nan(3,N);
for n = 1:N
  coinFlips   = rand(NCOINS,NFLIPS)>0.5;
  ind(1)      = 1;
  ind(2)      = randi(NCOINS);
  [~,temp]    = min(sum(coinFlips,2));
  ind(3)      = temp(1);
  
  headFraction(:,n) = sum(coinFlips(ind,:),2)/NFLIPS;
end
mean(headFraction, 2)
toc

% %%
% clear RHS
% clear LHS
% 
% epsilon = linspace(0,0.5,100);
% for n = 1:numel(epsilon)
%   eps = epsilon(n);
%   RHS(n) = 2*exp(-2*eps^2*NFLIPS);  
%   LHS(:,n) = sum(abs(headFraction-0.5)>eps,2)/N;
% end
% 
% all(LHS <= repmat(RHS,3,1),2)
% f = find(LHS(3,:) <= RHS);
% plot(f)
% epsThatFail = epsilon(find(LHS(3,:) <= RHS));