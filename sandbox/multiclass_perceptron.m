
addpath(genpath('C:\Users\optimus\Documents\MATLAB\mathworks_central'))
clear all;
xintersect = 0;
yintersect = 0;
while (-1 < xintersect && xintersect < 1) || (-1 < yintersect && yintersect < 1)
  
% random target functions
randomPointsForLine1 = [2*rand(2,2)-1];
randomPointsForLine2 = [2*rand(2,2)-1];

% do the lines intersect inside the [-1 1] x [-1 1] box?
xintersect = det([det(randomPointsForLine1) det([randomPointsForLine1(:,1), [1;1]]); ...
  det(randomPointsForLine2) det([randomPointsForLine2(:,1), [1;1]])]) / ...
  det([det([randomPointsForLine1(:,1) [1;1]]) det([randomPointsForLine1(:,2), [1;1]]); ...
  det([randomPointsForLine2(:,1) [1;1]]) det([randomPointsForLine2(:,2), [1;1]])]);

yintersect = det([det(randomPointsForLine1) det([randomPointsForLine1(:,2), [1;1]]); ...
  det(randomPointsForLine2) det([randomPointsForLine2(:,2), [1;1]])]) / ...
  det([det([randomPointsForLine1(:,1) [1;1]]) det([randomPointsForLine1(:,2), [1;1]]); ...
  det([randomPointsForLine2(:,1) [1;1]]) det([randomPointsForLine2(:,2), [1;1]])]);
end

slope1 = diff(randomPointsForLine1(:,2))/diff(randomPointsForLine1(:,1));
intercept1 = randomPointsForLine1(1,2) - slope1*randomPointsForLine1(1,1);

slope2 = diff(randomPointsForLine2(:,2))/diff(randomPointsForLine2(:,1));
intercept2 = randomPointsForLine2(1,2) - slope2*randomPointsForLine2(1,1);


N = 50;
X = 2*rand(N,2) - 1;
ybar1 = slope1*X(:,1) + intercept1;
ybar2 = slope2*X(:,1) + intercept2;

if all(ybar1>ybar2)
  IND_CLUSTERS(:,1) = (X(:,2)>ybar1);
  IND_CLUSTERS(:,2) = (ybar2>X(:,2));
  IND_CLUSTERS(:,3) = ~IND_CLUSTERS(:,1) & ~IND_CLUSTERS(:,2);
else
  IND_CLUSTERS(:,1) = (X(:,2)<ybar1);
  IND_CLUSTERS(:,2) = (ybar2<X(:,2));
  IND_CLUSTERS(:,3) = ~IND_CLUSTERS(:,1) & ~IND_CLUSTERS(:,2);
end

% the output vector of the 4 classes
Yclass = nan(N,1); % preallocate
Ybinary = nan(N,3);
for n = 1:3
  Yclass(IND_CLUSTERS(:,n))        = n;  
  Ybinary(IND_CLUSTERS(:,n),n)        = 1;
  Ybinary(~IND_CLUSTERS(:,n),n)       = -1;
end


cm = [0 0 1; 1 0 0; 0 0 0];
clf
hold on
for n = 1:3
  plot(X(IND_CLUSTERS(:,n),1), X(IND_CLUSTERS(:,n),2), '*', 'color', cm(n,:), 'linewidth', 2)
end
h_line = line([-1 1], [slope1*(-1) + intercept1, slope1*(1) + intercept1]);
set(h_line, 'color', [0 0 1], 'linewidth', 3)
h_line = line([-1 1], [slope2*(-1) + intercept2, slope2*(1) + intercept2]);
set(h_line, 'color', [1 0 0], 'linewidth', 3)


for n = 1:2
  n
  Y = Ybinary(:,n);
  XPLA = [ones(N,1) X];
  w = zeros(1, 2+1);
  plaOutput = sign(XPLA*w');
  iter = 0;
  while(~all(plaOutput == Y))
    temp = find(plaOutput ~= Y);
    ind_misclassified  = temp(round(rand*(numel(temp)-1)+1));
    w = w + Y(ind_misclassified)*XPLA(ind_misclassified,:);
    plaOutput = sign(XPLA*w');
    iter = iter + 1;
  end
  whypothesis(n,:) = w;
   
end
for n = 1:2
  w = whypothesis(n,:);
  h_line(n) = line([-1 1], [-(w(2)/w(3))*(-1) - (w(1)/w(3)), -(w(2)/w(3))*(1) - (w(1)/w(3))]);
  
end
set(h_line(1), 'color', [0 0 1], 'linewidth', 3, 'linestyle', ':')
set(h_line(2), 'color', [1 0 0], 'linewidth', 3, 'linestyle', ':')

legend({'1', '2', '3', 'TargetLine1', 'TargetLine2', 'HypothesisLine1', 'HypthesisLine2'}, 'location', 'EastOutside')
axis([-1 1 -1 1])
axis square


set(gcf, 'PaperPositionMode', 'auto');
print -depsc2 finalPlot1.jpg


print('example', '-dpng', '-r300')
% above red and above blue

% above red and below blue

% above blue and above red

% above blue and below red
