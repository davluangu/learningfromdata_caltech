clc
clear all;
NOUTSAMPLE      = 10000;
DIMENSIONALITY  = 2;
NINSAMPLE       = 100;
NRUNS           = 10000;
errorIn_regression         = nan(1, NRUNS);
errorOut_regression        = nan(1, NRUNS);

for r = 1:NRUNS
  % generate a random hyperplane inside the [-1 1]^N space
  linePoints    = [2*rand(DIMENSIONALITY,DIMENSIONALITY)-1];
  w_target      = [1; linePoints\ones(DIMENSIONALITY,1)];
  
  % generate random data inside [-1 1]^N space
  X             = 2*rand(DIMENSIONALITY,NINSAMPLE)-1; % uniform distribution between [-1 and 1]
  X_augmented   = [ones(1,NINSAMPLE); X];
  
  % classify data using the random hyperplane generated
  Y             = sign(w_target'*X_augmented);
  
  % regression
  w_regression  = X_augmented'\Y';
  Y_regression  = sign(w_regression'*X_augmented);
  
  % execute PLA initialized to the regression weights
  w_pla         = w_regression;
%   w_pla         = zeros(3,1);
  Y_pla         = sign(w_pla'*X_augmented);
  iter_pla          = 0;
  while(~all(Y_pla == Y))
    misclassified       = find(Y_pla ~= Y);
    randomMisclassified = misclassified(randi(numel(misclassified)));
    w_pla               = w_pla + Y(randomMisclassified)*X_augmented(:,randomMisclassified);
    Y_pla               = sign(w_pla'*X_augmented);
    iter_pla            = iter_pla + 1;
  end
  iterations_pla(r) = iter_pla;
  
  %%
  errorIn_regression(r)   = sum(Y ~= Y_regression)/NINSAMPLE;
  errorIn_pla(r)          = sum(Y ~= Y_pla)/NINSAMPLE;

  % out of sample
  X_out                   = rand(DIMENSIONALITY, NOUTSAMPLE);
  X_out_augmented         = [ones(1,NOUTSAMPLE); X_out];
  Y_out                   = sign(w_target'*X_out_augmented);
  Y_out_regression        = sign(w_regression'*X_out_augmented);
  Y_out_pla               = sign(w_pla'*X_out_augmented);
  errorOut_regression(r)  = sum(Y_out ~= Y_out_regression)/NOUTSAMPLE;
  errorOut_pla(r)         = sum(Y_out ~= Y_out_pla)/NOUTSAMPLE;
  
end
fprintf('Ein regression: %f\n', mean(errorIn_regression))
fprintf('Eout regression: %f\n', mean(errorOut_regression))

fprintf('Ein pla: %f\n', mean(errorIn_pla))
fprintf('Eout pla: %f\n', mean(errorOut_pla))
fprintf('mean iterations pla: %f\n', mean(iterations_pla))


%%
clf
hold on
plot(X(1,Y>0), X(2,Y>0), 'ro');
plot(X(1,Y<0), X(2,Y<0), 'bo');
% plot(X(1,Y_regression>0), X(2,Y_regression>0), 'r*');
% plot(X(1,Y_regression<0), X(2,Y_regression<0), 'b*');
plot(X(1,Y_regression~=Y), X(2,Y_regression~=Y), '+k');

plot([-1 1], -[w_target(1:2)/w_target(3)]'          *[1 1; -1 1], 'k')
plot([-1 1], -[w_regression(1:2)/w_regression(3)]'  *[1 1; -1 1], 'g')
plot([-1 1], -[w_pla(1:2)/w_pla(3)]'                *[1 1; -1 1], 'm')
axis equal
axis([-1 1 -1 1])