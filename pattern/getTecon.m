function tecon = getTecon(data)

tecon = struct;

tecon.R = getTeconAux(data.Rclusters.areas);
tecon.G = getTeconAux(data.Gclusters.areas);
tecon.RandG = getTeconAux([data.Rclusters.areas; data.Gclusters.areas]);
tecon.all = getTeconAux(data.clusters.areas);

    

end

function loglogXY = getTeconAux(areas)
    
    sortedareas = sort(areas);
    
    
    pd = makedist('Lognormal');
    
    dist = random(pd,numel(areas),1);
    dist = sort(dist);

    
    
    
    loglogXY = [dist, sortedareas];
    

end