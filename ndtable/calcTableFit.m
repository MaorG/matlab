function [] = calcTableFit(rt)

XX = rt.valsA;
YY = rt.valsB;
ZZ = rt.T;

createFit(XX,YY,ZZ, 'a + b / (1 +  exp ( - ( (x*cos(e) + y*sin(e) ) - c) / d))');


        
end