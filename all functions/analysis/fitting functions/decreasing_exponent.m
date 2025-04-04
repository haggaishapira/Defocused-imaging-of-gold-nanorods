function y = decreasing_exponent(p,t)
    
    y = p(1) + (p(2) - p(1)) .* (exp(-(1/p(3)).*t));