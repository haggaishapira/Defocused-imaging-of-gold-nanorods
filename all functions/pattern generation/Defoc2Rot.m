function rot_diff = Defoc2Rot(t,theta,phi,lim)

if nargin<4||isempty(lim)
    lim = 10;
end
maxord = 4;
tphi = unwrap(phi*2,pi)/2;
theta = unwrap(2*theta)/2;

exposure = min(diff(t));
t = round(t./exposure);
tvec = t(1):t(end);
[~,ind] = ismember(t,tvec);
theta_full = NaN.*tvec;
phi_full = theta_full;

theta_full(ind) = theta;
phi_full(ind) = tphi;

clear mm cnt
kv = 1:lim; % max number of frame number difference to be analyzed
tmp = [sin(theta_full).*cos(phi_full); sin(theta_full).*sin(phi_full); cos(theta_full)].';
% ind = isnan(tmp); % the deletion
% tmpx = 0*tmp;
% tmpx(ind)=1;
for k=1:max(kv)
    if k<size(tmp,1)
        cnt(k) = numel(theta)-k;
        cntx(k) = length(phi_full)-k;
        for s=1:maxord
            mm(k,s) = nansum(nansum((tmp(1:end-k,:).*tmp(k+1:end,:)),2).^s);
            mmx(k,s) = sum(sum((isnan(tmp(1:end-k,:)).*isnan(tmp(k+1:end,:))),2).^s);
        end
    else
        for s=1:maxord
            mm(k,s) = 0;
            mmx(k,s) = 0;
        end
        cnt(k) = 0;
        cntx(k) = 0;
    end
end

mm = mm./(cnt'*ones(1,maxord));
mmx = mmx./(cntx'*ones(1,maxord)); % correlation of deleted points

para = [10 1 1e-2 1e-3];
maxk = lim;
for j=1:5
    para = Simplex('RotoDiffFit',para,0*para,[],[],[],[kv(1:maxk)],[mm(1:maxk,:)]);
end
h=get(gca,'children');
for j=1:4
    set(h(j),'color',get(h(j+4),'color'));
end
xlabel('frame number'); ylabel('\langlecos^{\itn\rm}\Theta\rangle');
legend({'\langlecos\Theta\rangle','\langlecos^2\Theta\rangle','\langlecos^3\Theta\rangle','\langlecos^4\Theta\rangle'})

rot_diff = para;
% plot sphere plot
figure
sphere(50)
alpha(0.1)
shading flat
hold on
plot3(tmp(:,1),tmp(:,2),tmp(:,3));
hold off
axis equal
lighting gouraud
axis off
h = line([0 0 0; 1.3 0 0],[0 0 0; 0 1.3 0],[0 0 0; 0 0 1.3]);
for j=1:length(h) set(h,'color','b','linewidth',1.5); end
view([135 30])


