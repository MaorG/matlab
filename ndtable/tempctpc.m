%run = cruns{3,3}{5};
%run = scoreAllData(run, 'ctpc', @getCrossTypePairCorrelation, 4);


xVec = zeros(size(run));
yVec = run(1).ctpc(2,:)';
zMat = zeros(size(xVec,1), size(yVec,1));
for ii = 1:size(xVec,1)
    xVec(ii) = run(ii).time;
    for jj = 1:size(yVec,1)
        zMat(ii,jj) = run(ii).ctpc(1,jj);
    end
end
figure(1033);
title('3, 3');
surf(xVec, yVec, zMat');