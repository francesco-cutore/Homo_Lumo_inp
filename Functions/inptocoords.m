function coords = inptocoords(p,q)

pidx=[1,0,-1];
qidx=[-1,1,0];
Hexcoords=zeros(q,p,3);
for i=1:q 
    for j=1:p
        for k=1:3
        Hexcoords(i,j,k) = (j-1)*qidx(k) + (i-1)*pidx(k);
        end
    end
end
coords=reshape(Hexcoords,q*p,3);
coords=coords(2:size(coords,1),1:size(coords,2));

end