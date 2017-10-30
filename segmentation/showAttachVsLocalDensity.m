function showAttachVsLocalDensity(m)


[N, B] = histcounts(m.counts);

[N, B] = histcounts(m.rndCounts, B);
plot(B(1:end-1),N./1000,':');

[N, B] = histcounts(m.counts);
plot(B(1:end-1),N,'-');


set(gca,'yscale','log');

end