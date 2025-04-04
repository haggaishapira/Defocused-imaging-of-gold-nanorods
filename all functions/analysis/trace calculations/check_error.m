function error = check_error(phi,frame_reaction)

%     threshold = 90;
    threshold = 120;
    phi = phi(frame_reaction-1:end);
    error = abs(max(phi) - min(phi)) > threshold;

