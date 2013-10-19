clc
close all
clear all;
NARRAY = [10 100 300];
for n = 1:numel(NARRAY)
  N = NARRAY(n);
  disp(N);
  for r = 1:1000
    % generate X training data
    X   = 2*rand(N,2)-1;
    x1  = X(:,1);
    x2  = X(:,2);
    
    % generate a random line
    XLine       = [2*rand(2,2)-1];
    target      = inv(XLine)*[1;1];
    slope       = -target(1)/target(2);
    intercept   = 1/target(2);
    
    % generate Y training data
    ABOVETARGET = slope*x1 + intercept > x2;
    BELOWTARGET = slope*x1 + intercept < x2;
    Y           = 1.0*ABOVETARGET;
    Y(Y==0)     = -1;
    
    %% PLA
    w             = zeros(1, 2+1); % initialzie w to the zero vector
    X_pla         = [ones(N,1) X];
    Y_pla         = sign(X_pla*w');
    iter          = 0;
    while(~all(Y_pla == Y))
      mismatches    = find(Y_pla ~= Y); % find mismatches
      randMismatch  = mismatches(round(rand*(numel(mismatches)-1)+1)); % get a random misclassified point
      w             = w + Y(randMismatch)*X_pla(randMismatch,:);
      Y_pla         = sign(X_pla*w');
      iter          = iter + 1;
    end
    iterations(r)   = iter;
    
    %% monte carlo simulations, find probability of disagreement between target and hypothesis
    MC                    = 10000;
    X_mc                  = 2*rand(MC,2)-1;
    Y_mc                  = nan(MC,1);
    ABOVETARGET_mc        = slope*X_mc(:,1) + intercept > X_mc(:,2);
    BELOWTARGET_mc        = slope*X_mc(:,1) + intercept < X_mc(:,2);
    Y_mc(ABOVETARGET_mc)  = 1;
    Y_mc(BELOWTARGET_mc)  = -1;
    
    X_pla_mc              = [ones(MC,1) X_mc];
    Y_pla_mc              = sign(X_pla_mc*w');
    
    DISAGREE              = Y_mc ~= Y_pla_mc;
    disagreePrct(r)       = sum(DISAGREE)/MC;
  end
  meanIter(n)         = mean(iterations);
  meanDisagreement(n) = mean(disagreePrct);
  
  %% plotting
  figure
  hold on
  % plot target classified points with an 'o'
  plot(X_mc(ABOVETARGET_mc,1),  X_mc(ABOVETARGET_mc,2),  'ob')
  plot(X_mc(BELOWTARGET_mc,1),  X_mc(BELOWTARGET_mc,2),  'or')
  % plot hypothesis classified points with an '*'
  plot(X_mc(Y_pla_mc==1,1),     X_mc(Y_pla_mc==1,2),  '*b')
  plot(X_mc(Y_pla_mc==-1,1),    X_mc(Y_pla_mc==-1,2), '*r')
  % highlight disagreement points with a 's'
  plot(X_mc(DISAGREE,1),        X_mc(DISAGREE,2), 'ms');
  
  % plot training data set with yellow up and down triangles
  plot(x1(ABOVETARGET),         x2(ABOVETARGET), '^y', 'linewidth', 3)
  plot(x1(BELOWTARGET),         x2(BELOWTARGET), 'vy', 'linewidth', 3)
  
  % target line (black line)
  h_line = line([-1 1], [slope*(-1) + intercept, slope*(1) + intercept]);
  set(h_line, 'color', [0 0 0], 'linewidth', 3)
  
  % hypothesis line (green line)
  h_line = line([-1 1], [-(w(2)/w(3))*(-1) - (w(1)/w(3)), -(w(2)/w(3))*(1) - (w(1)/w(3))]);
  set(h_line, 'color', [0 1 0], 'linewidth', 3)
  
  hold off
  axis([-1 1 -1 1])
  title(sprintf('N = %d, mean(iterations) = %.2f, mean(disagreemnt) = %.2f%%', N, meanIter(n), 100*meanDisagreement(n)))
end




