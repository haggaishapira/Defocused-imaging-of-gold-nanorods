function delta_phi = get_delta_phi(old_phi,new_phi)
    delta_phi = new_phi-old_phi;
    if new_phi>old_phi
        if abs(delta_phi)>180
            delta_phi = -(old_phi+360-new_phi);
        end
    else
        if abs(delta_phi)>180
            delta_phi = delta_phi + 360;
        end
    end
    if delta_phi <= -160
%         if rand()>0.5
            delta_phi = -delta_phi;
%         end
    end
        