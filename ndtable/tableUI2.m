function tableUI(rt, showfunc, appliedfuncs)

figHandle = figure('units','normalized','outerposition',[0 0 1 1]);

myhandles = guihandles(figHandle);
myhandles.rt = rt;

createNameTexts(rt);
myhandles.bgx = createXButtons(rt);
myhandles.bgy = createYButtons(rt);
myhandles.bgo = createOverlayButtons(rt);
myhandles.sg = createSliders(rt);
myhandles.vg = createVals(rt);

% nasty init
myhandles.bx = 'none';
myhandles.by = 'none';
myhandles.bo = 'none';

myhandles.sliderVals = ones(size(rt.names));
myhandles.showfunc = showfunc;

if nargin > 2
    myhandles.appliedfuncs = appliedfuncs;
else
    myhandles.appliedfuncs = cell(0);
end

guidata(figHandle,myhandles)
%updateDisplay;

end

function vg = createVals(rt)

vg = uibuttongroup('Visible','off',...
    'Position',[0.28 0 0.02 0.5]);

N = numel(rt.names);
for i = 1:N
    txt(i) = uicontrol(vg, 'Style', 'text',...
        'Units','normalized',...
        'String',num2str(rt.vals{i}(1)),...
        'Position', [0.1,0.1*i, 0.8, 0.1]);
end
vg.Visible = 'on';

vg.Children = flip(vg.Children);

end

function createNameTexts(rt)

txtg = uibuttongroup('Visible','off',...
    'Position',[0 0 .08 0.5]);

options = [rt.names; 'none'];
N = numel(options);
for i = 1:N
    t(i) = uicontrol(txtg, 'Style', 'text',...
        'Units','normalized',...
        'String',options{i},...
        'Position', [0.1,0.1*i, 0.8, 0.1]);
end
txtg.Visible = 'on';

end

function sg = createSliders(rt)

sg = uibuttongroup('Visible','off',...
    'Position',[0.14 0 .14 0.5],...
    'SelectionChangedFcn',@bselectionX);
N = numel(rt.dims);

for i = 1:N
    step = 1/(numel(rt.vals{i})-1);
    if isinf(step)
        step = 0;
    end
    sld(i) = uicontrol(sg, 'Style', 'slider',...
        'Min',1,'Max',numel(rt.vals{i}),'Value',1,...
        'Tag',rt.names{i},...
        'SliderStep',[step step],...
        'Units','normalized',...
        'Position', [0,0.1*i, 1,0.1],...
        'Callback', @slider_callback);
end
sg.Visible = 'on';
end

function bgO = createOverlayButtons(rt)
bgO = uibuttongroup('Visible','off',...
    'Position',[0.08 0 0.02 0.5],...
    'SelectionChangedFcn',@bselectionO);

optionsO = [rt.names; 'none'];
N = numel(optionsO);
for i = 1:N
    bO(i) = uicontrol(bgO,'Style',...
        'checkbox',...
        'Units','normalized',...
        'Tag',optionsO{i},...
        'Position',[0.025,0.1*i, 1, 0.1],...
        'HandleVisibility','off');
end
set(bgO,'SelectedObject',bO(N));  % Set default.

% Make the uibuttongroup visible after creating child objects.
bgO.Visible = 'on';

end


function bgX = createXButtons(rt)
bgX = uibuttongroup('Visible','off',...
    'Position',[0.1 0 0.02 0.5],...
    'SelectionChangedFcn',@bselectionX);

optionsX = [rt.names; 'none'];
N = numel(optionsX);
for i = 1:N
    bX(i) = uicontrol(bgX,'Style',...
        'radiobutton',...
        'Units','normalized',...
        'Tag',optionsX{i},...
        'Position',[0.025,0.1*i, 1, 0.1],...
        'HandleVisibility','off');
end
set(bgX,'SelectedObject',bX(N));  % Set default.

% Make the uibuttongroup visible after creating child objects.
bgX.Visible = 'on';

end

function bgY = createYButtons(rt)
bgY = uibuttongroup('Visible','off',...
    'Position',[.12 0 .02 0.5],...
    'SelectionChangedFcn',@bselectionY);
optionsY = [rt.names; 'none'];
N = numel(optionsY);
for i = 1:N
    bY(i) = uicontrol(bgY,'Style',...
        'radiobutton',...
        'Units','normalized',...
        'Tag',optionsY{i},...
        'Position',[0.125, 0.1*i, 1, 0.1],...
        'HandleVisibility','off');
end
set(bgY,'SelectedObject',bY(N));  % Set default.
% Make the uibuttongroup visible after creating child objects.
bgY.Visible = 'on';

end

function bselectionX(source,callbackdata)
display(['Previous: ' callbackdata.OldValue.String]);
display(['Current: ' callbackdata.NewValue.String]);
display('------------------');

myhandles = guidata(gcbo);
myhandles.bx = callbackdata.NewValue.Tag;
guidata(gcbo,myhandles)

updateDisplay;
end

function bselectionY(source,callbackdata)
display(['Previous: ' callbackdata.OldValue.String]);
display(['Current: ' callbackdata.NewValue.String]);
display('------------------');

myhandles = guidata(gcbo);
myhandles.by = callbackdata.NewValue.Tag;
guidata(gcbo,myhandles);

updateDisplay;
end

function bselectionO(source,callbackdata)
display(['Previous: ' callbackdata.OldValue.String]);
display(['Current: ' callbackdata.NewValue.String]);
display('------------------');

myhandles = guidata(gcbo);
myhandles.bo = callbackdata.NewValue.Tag;
guidata(gcbo,myhandles);

updateDisplay;
end

function slider_callback(hObject,eventdata)

myhandles = guidata(gcbo);

sliderVals = arrayfun(@(t) t.Value, hObject.Parent.Children);
myhandles.sliderVals = sliderVals;
guidata(gcbo,myhandles);

updateDisplay;
end

function updateDisplay

myhandles = guidata(gcbo);
sliderVals = flip(floor(myhandles.sliderVals))';
bx = myhandles.bx;
by = myhandles.by;
bo = myhandles.bo;
rt = myhandles.rt;
vg = myhandles.vg;

for ii = 1:numel(vg.Children)
    vg.Children(ii).String = num2str(rt.vals{ii}(sliderVals(ii)));
end

showfunc = myhandles.showfunc;
appliedfuncs = myhandles.appliedfuncs;
delete(findall(gcf,'type','axes'));

hndbg = axes('Units','normalized',...
    'Position',[0.3,0,0.7,1]);
set(hndbg, 'XTick', []);
set(hndbg, 'YTick', []);

indices = num2cell(sliderVals,1);
T = rt.T;
a = T{indices{:}};


% if ~strcmp(bx,'none') && ~strcmp(by,'none')
%     indx = find(cellfun(@(t) strcmp(t, bx), rt.names));
%     indy = find(cellfun(@(t) strcmp(t, by), rt.names));
%
%     perm = 1:numel(rt.names);
%     perm = perm(perm ~= indx);
%     perm = perm(perm ~= indy);
%     perm = [indx, indy, perm];
%
%     newindices = num2cell(sliderVals(perm),1);
%     newindices = newindices(3:end);
%     T = permute(rt.T, perm);
%     a = T(:,:,newindices{:});
% end

if ~strcmp(bx,'none') && ~strcmp(by,'none') && strcmp(bo,'none')
    indx = find(cellfun(@(t) strcmp(t, bx), rt.names));
    indy = find(cellfun(@(t) strcmp(t, by), rt.names));
    
    perm = 1:numel(rt.names);
    perm = perm(perm ~= indx);
    perm = perm(perm ~= indy);
    perm = [indx, indy, perm];
    
    newindices = num2cell(sliderVals(perm),1);
    newindices = newindices(3:end);
    T = permute(rt.T, perm);
    a = T(:,:,newindices{:});
end

if ~strcmp(bx,'none') && ~strcmp(by,'none') && ~strcmp(bo,'none')
    indx = find(cellfun(@(t) strcmp(t, bx), rt.names));
    indy = find(cellfun(@(t) strcmp(t, by), rt.names));
    indo = find(cellfun(@(t) strcmp(t, bo), rt.names));
    
    perm = 1:numel(rt.names);
    perm = perm(perm ~= indx);
    perm = perm(perm ~= indy);
    perm = perm(perm ~= indo);
    perm = [indx, indy, indo, perm];
    
    newindices = num2cell(sliderVals(perm),1);
    newindices = newindices(4:end);
    T = permute(rt.T, perm);
    a = T(:,:,:,newindices{:});
end

%%%%

w = size(a,1);
h = size(a,2);
z = size(a,3);
%[W, H] = meshgrid(1:w,1:h)

addTicks();

if iscell(a{1}) && numel(a{1}{1}) == 1
    updateslice();
else
    
    if numel(a{1}{1}) > 1 && numel(a) > 1
        updatetable();
    else
        
        hndbg = axes('Units','normalized',...
            'Position',[0.3,0,0.7,1]);
        if ~isempty(a)
            showfunc(a{1}{1});
        else
            showfunc(0)
        end
    end
end

    function addTicks()
        
        for i = 1:w
            
            val = num2str(rt.vals{indx}(i));
            x1 = 0.05 + 0.95*((1/w)*(i-1) + 0.5/w);
            y1 = 0.01;
            text(x1, y1, val);
        end
        
        for i = 1:h
            val = num2str(rt.vals{indy}(i));
            x1 = 0.01;
            y1 = 0.05 + 0.95*((1/h)*(i-1) + 0.5/h);
            text(x1, y1, val,'rotation', 90);
        end
        
    end

    function updateslice()
        b = cellfun(@(t) t{1}, a);
        if size(b,3) > 1;
            b = nanmean(b,3);
        end
        hnd = axes('Units','normalized',...
            'Position',[0.35,0.05,0.65,0.95]);
        imagesc(b');
        set(hnd, 'XTick', []);
        set(hnd, 'YTick', []);
        colorbar;
        for k = 1:numel(appliedfuncs)
            appliedfuncs{k}(hnd);
        end
    end

    function updatetable()
        
        
        hnd = gobjects(w,h);
        
        for i = 1:w
            for j = 1:h
                x1 = 0.35 + (0.65/w)*(i-1);
                y1 = 0.05 + (0.95/h)*(j-1);
                
                hnd(i,j)= axes('Units','normalized',...
                    'Position',[x1,y1,0.63/w,0.93/h]);
                if ~isempty(a{i,j,1})
                    
                    try
                        for k = 1:z
                            showfunc(a{i,j,k}{1});
                            hold on;
                        end
                    catch
                        ':('
                    end
                else
                    showfunc(0)
                end
            end
        end
        
        for i = 1:w
            for j = 1:h
                if j ~= 1
                    set(hnd(i,j), 'XTick', []);
                end
                if i ~= 1
                    set(hnd(i,j), 'YTick', []);
                end
            end
        end
        
        for i = 1:w
            for j = 1:h
                for k = 1:numel(appliedfuncs)
                    appliedfuncs{k}(hnd(i,j));
                end
            end
        end
    end


end