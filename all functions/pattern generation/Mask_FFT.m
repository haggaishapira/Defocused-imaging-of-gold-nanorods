function data = Mask_FFT(tmpim,mask,bck)

n1 = size(mask,1);
n2 = size(mask,2);
n3 = size(mask,3);

sup = bck;
bck  = bck/sqrt(sum(sum(sup.*bck.^2)));
mask = mask.*repmat(sup,[1,1,n3]);
mask = mask./repmat(sqrt(sum(sum(repmat(sup,[1,1,n3]).*mask.^2))),[n1,n2,1]);

if rem(n1,2)==0
   mb = n1/2;
   mbb = 0;
else
   mb = (n1-1)/2;
   mbb = 1;
end
if rem(n2,2)==0
   nb = n2/2;
   nbb = 0;
else
   nb = (n2-1)/2;
   nbb = 1;
end

maskim = zeros(size(tmpim,1)+2*mb,size(tmpim,2)+2*nb,n3);
crs = zeros(2,2,n3);
 for s = 1:n3
    tmpmask = zeros(size(tmpim,1)+2*mb,size(tmpim,2)+2*nb);
    tmpb = sup.*mask(:,:,s);
    tmpmask(1:mb+mbb,1:nb+nbb,:) = tmpb(mb+1:end,nb+1:end,:);
    tmpmask(end-mb+1:end,1:nb+nbb,:) = tmpb(1:mb,nb+1:end,:);
    tmpmask(1:mb+mbb,end-nb+1:end,:) = tmpb(mb+1:end,1:nb,:);
    tmpmask(end-mb+1:end,end-nb+1:end,:) = tmpb(1:mb,1:nb,:);
    maskim(:,:,s) = fft2(tmpmask);
    tmpcrs = sum(sum(sup.*bck.*mask(:,:,s)));
    crs(:,:,s) = inv([1 tmpcrs; tmpcrs 1]);
 end
 
 data.maskim = maskim;
 data.crs = crs;