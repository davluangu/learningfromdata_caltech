clc
clear all;
NOUTSAMPLE      = 1000;
DIMENSIONALITY  = 2;
NINSAMPLE       = 1000;
NRUNS           = 1000;
errorIn         = nan(1, NRUNS);
errorOut        = nan(1, NRUNS);

for r = 1:NRUNS  
  % generate random data inside [-1 1]^N space
  X                 = 2*rand(DIMENSIONALITY,NINSAMPLE)-1; % uniform distribution between [-1 and 1]
  Y                 = sign(sum(X.^2,1)-0.6); % classify data using the random hyperplane generated
   
  % add some noise to Y
  randomIndicies    = randperm(NINSAMPLE, 0.10*NINSAMPLE);
  Y(randomIndicies) = -1*Y(randomIndicies);

  % nl regression
  X_nl          = [ones(1,NINSAMPLE); X(1,:); X(2,:); X(1,:).*X(1,:); X(1,:).^2; X(2,:).^2];
  w_nl(:,r)     = pinv(X_nl)'*Y';
  Y_nl          = sign(w_nl(:,r)'*X_nl);
  
  % check which of the given equations it is in agreement with most of the
  % time
  coef = [ -1 -0.05 0.08 0.13 1.5 1.5;
    -1 -0.05 0.08 0.13 1.5 15;
    -1 -0.05 0.08 0.13 15 1.5;
    -1 -1.5 0.08 0.13 15 1.5
    -1 -1.5 0.08 0.13 0.05 0.05;
    -1 -0.05 0.08 1.5 0.15 0.15];
  Y_coef = sign(coef*X_nl);
  
  AGREE_coef = Y_coef == repmat(Y_nl, size(coef,2), 1);
  agreePercent_coef(:,r) = sum(AGREE_coef,2)/NINSAMPLE;

  % out of sample
  X_out                   = rand(DIMENSIONALITY, NOUTSAMPLE);
  Y_out                   = sign(sum(X_out.^2,1)-0.6);
  Y_out_noisy             = Y_out;
  randomIndicies          = randperm(NOUTSAMPLE, 0.10*NOUTSAMPLE);
  Y_out_noisy(randomIndicies)   = -1*Y_out_noisy(randomIndicies);
  
  X_out_nl                = [ones(1,NOUTSAMPLE); X_out(1,:); X_out(2,:); X_out(1,:).*X_out(1,:); X_out(1,:).^2; X_out(2,:).^2];
  Y_out_nl                = sign(w_nl(:,r)'*X_out_nl);

  errorOut_nl(r)          = sum(Y_out_noisy ~= Y_out_nl)/NOUTSAMPLE;
end
mean(errorOut_nl)
mean(agreePercent_coef,2)
% mean(errorOut)
% mean(iterations_pla)

%%
figure;
subplot(1,2,1)
hold on
plot(X_out(1,Y_out_noisy>0), X_out(2,Y_out_noisy>0), 'ro');
plot(X_out(1,Y_out_noisy<0), X_out(2,Y_out_noisy<0), 'bo');
axis equal
axis([-1 1 -1 1])

subplot(1,2,2)
hold on
plot(X_out(1,Y_out_nl>0), X_out(2,Y_out_nl>0), 'ro');
plot(X_out(1,Y_out_nl<0), X_out(2,Y_out_nl<0), 'bo');
plot(X_out(1,Y_out_nl~=Y_out_noisy), X_out(2,Y_out_nl~=Y_out_noisy), '+k');
hold off
axis equal
axis([-1 1 -1 1])

%%
figure;
subplot(1,2,1)
hold on
plot(X(1,Y>0), X(2,Y>0), 'ro');
plot(X(1,Y<0), X(2,Y<0), 'bo');
plot(X(1,Y_nl~=Y), X(2,Y_nl~=Y), '+k');
axis equal
axis([-1 1 -1 1])


subplot(1,2,2)
hold on
plot(X(1,Y_nl>0), X(2,Y_nl>0), 'ro');
plot(X(1,Y_nl<0), X(2,Y_nl<0), 'bo');
plot(X(1,Y_nl~=Y), X(2,Y_nl~=Y), '+k');
hold off
axis equal
axis([-1 1 -1 1])