function chi_sq = chi_squared(y1,y2)
    chi_sq = sum((y1 - y2) .^ 2);
