
mdataDry = getDataByParams(allData, 'ticks', 20000)
mdataWet = getDataByParams(allData, 'ticks', 19000)

mdata = [mdataDry; mdataWet]

mdata = scoreAllData(mdata, 'image', @getAgentsImageCustom, 4.0);

rt1 = createNDResultTable(mdata, 'image',  'attach', 'ticks');
tableUI(rt1, [@imshow], []);