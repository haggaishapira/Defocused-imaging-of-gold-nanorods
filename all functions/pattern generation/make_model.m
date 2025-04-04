function model = make_model()

NA = 1.45;
%n0 = [1.52 nau nsi];
n0 = [1.52];
%d0 = [0.34 10]*1e-3;
d0 = [];
n = 1.35; % PVA
n1 = 1.35;
% d0 = [];
d = 1e-3; % 20 nm film
z = 0; % the molecule is in the middle of the film lets say. (Doesn't change much)
d1 = [];
% lamem = 0.690;
lamem = 0.640;
%mag = 100;
mag = 60;
focus = -0.8; %original -0.8
atf = [];
ring = [];
pixel = 16/1.6;
pic = 1;
be_res = 5;
al_res = 5;
nn = [12 12];

block = 3; % in mm

fac = 2*pi/lamem;

model = PatternGeneration(z, NA, n0, n, n1, d0, d, d1, lamem, mag, focus, atf, ring, pixel, nn, be_res, al_res, block, pic);