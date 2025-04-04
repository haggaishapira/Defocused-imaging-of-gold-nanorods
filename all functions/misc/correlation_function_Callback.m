function correlation_function_Callback(hObject, eventdata, handles)

    f1=figure;
    ax1 = axes(f1);
    
    all = 0;
    
    num_mol = handles.num_mol;
    
    
    
    if all
        vec = 1:num_mol;
%         vec = [1 4 5 3 2];

%         vec = 1:7;
    else
        mol = handles.molecule_list.Value;
        vec = mol;
    end
    
    for i=1:length(vec)
%         mol = handles.molecule_list.Value;
        mol = vec(i);
        molecule = handles.molecules(mol);
    %     phi = molecule.trace_phi_whole;
        ROI = molecule.ROI;
        ROI = ROI(:,1);
        len = handles.vid_len;
    %     dim = ROI(3);
        left = ROI(1);
        top = ROI(2);
        right = ROI(1) + ROI(3) - 1;
        bottom = ROI(2) + ROI(4) - 1;

        ROI_vid = handles.video(top:bottom,left:right,:);

        for i=1:len
            im = ROI_vid(:,:,i);
            ROI_vid(:,:,i) = im/sum(im(:));
        end
        max_separation = 100;
        corr = zeros(max_separation+1,1);
        for separation=0:max_separation
            num_counted = 0;
            sm = 0;
            for i=1:len
                if i+separation>len
                    break;
                end
                im1 = ROI_vid(:,:,i);
                im2 = ROI_vid(:,:,i+separation);
                mul = im1.*im2;
                val = sum(mul(:));
                sm = sm + val;
                num_counted = num_counted + 1;
            end
            sm = sm / num_counted;
            corr(separation+1) = sm;
        end

        %fit exponent
        p0 = [1 1];
        x = (0:max_separation)';
%         norm_x = x/max(x);
        norm_x = x/max(x);
        y = corr;
        y = y - min(y);
        y = y / max(y);

        plot(ax1,x,y,'LineWidth',3);

        %%old fitting
%         curve = fit(norm_x, y, 'exp1', 'StartPoint', p0);

        %% new fitting
        optFunc = @exponent_func;
        a_init = 1;
        b_init = -30;
        y0_init = 0;
        initialguess = [a_init b_init y0_init];
        lb = [0.99 -200 0];
        ub = [1.01 10 1];
        options = optimset('lsqcurvefit');
        options = optimset(options, 'Jacobian','off', 'Display','off',  'TolX',10^-2, 'TolFun',10^-2, 'MaxPCGIter',1, 'MaxIter',500);
%         options = optimset(options,'Algorithm', 'levenberg-marquardt');
                
%         [xgrid,ygrid] = meshgrid(1:10,1:10); % Make grids
%         grid = [xgrid ygrid]; % x-y grid used for Gaussian image

        %%%start fit average frame
%         x_grid = x;
        [paramsFit, ~] = lsqcurvefit(... % lsqcurvefit performs the optimization. This requires the Optimization Toolbox
                  optFunc, ... % Function to optimize
                  initialguess,norm_x, y,... % p0, xdata, ydata
                  lb, ub, options); % params: [x0, y0, sx, sy, background, amplitude]

        clc;
%         a = curve.a;
%         b = curve.b;
        a = paramsFit(1);
        b = paramsFit(2);
        y0 = paramsFit(3);
        
        disp(a);
        disp(b);
        disp(y0);

        handles.correlation.String = num2str(-b);
        %f = a*e^bx

        y_fit = a*exp(b*norm_x);
        hold(ax1,'on');
        plot(ax1,x,y_fit,'LineWidth',3);
%         legend({'10','20','30','40','50'});
%         legend(ax1,i);
    end    
    
    ax1.FontSize = 14;
    ax1.FontWeight = 'bold';
