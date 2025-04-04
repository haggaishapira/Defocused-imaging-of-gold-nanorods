

clear
clc

% a = [5 60 185 220 185 220 180 220];
% a = 2*pi*rand(100,1);
% 
f1 = figure;
% f2 = figure;
ax1 = polaraxes(f1);
% ax2 = axes(f2);

return
tic
h = polarhistogram(ax1,a,'BinWidth',pi/12);
% h = compass(ax1,a);
toc

for i=1:100
    h.Data = 2*pi*rand(100,1);
    pause(0.01);
end
