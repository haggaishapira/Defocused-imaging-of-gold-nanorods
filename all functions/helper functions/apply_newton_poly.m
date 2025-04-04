

function y = apply_newton_poly(b,x,x_interp)

% N(x) = b0+b1(x-x0)+b2(x-x0)(x-x1)+...

deg = length(x)-1;
y = zeros(length(x_interp),1);

for i=1:length(x_interp)
    sm = 0;
    for j=0:deg
        prod = b(j+1);
        for k=j-1:-1:0
            prod = prod * (x_interp(i) - x(k+1));
        end
        sm = sm + prod;
    end
    y(i) = sm;
end
        