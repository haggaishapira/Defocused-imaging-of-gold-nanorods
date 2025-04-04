function [step_reaction,num_changes] = analyze_step_hmm(settings,phi_for_analysis,t,frame_start,frame_end,stepping_error,command_name,i,sequence_info)

    step_reaction = [];
    num_changes = 1;

    num_states = settings.hmm_num_states;
    if settings.hmm_smooth_trace
        % smooth
        smooth_window = settings.hmm_smooth_window;
        phi_for_analysis = smooth(phi_for_analysis,smooth_window);
    end
    if settings.hmm_crop_trace
        crop_interval = settings.hmm_crop_interval;
        phi_for_analysis = phi_for_analysis(1:crop_interval:end);
        t_trace = t(frame_start:crop_interval:frame_end);
    else
        t_trace = t(frame_start:frame_end);
    end
    if isempty(phi_for_analysis)
        step_reaction = make_step_reaction(0,0,1,0,0,...
                [],[],1,stepping_error,0);
        return;
    end
    min_phi_hmm = phi_for_analysis(1);
    phi_for_analysis = phi_for_analysis - min_phi_hmm;
    try
        [hmm_fitted_trace,state_trace,returnedErr,errmsg] = vbAnalysis(phi_for_analysis,num_states); 

        % check for many jumps in state trace
        d_state_trace = abs(state_trace(2:end) - state_trace(1:end-1));
        num_changes = length(d_state_trace(d_state_trace>0));
        
        hmm_fitted_trace = hmm_fitted_trace + min_phi_hmm;
        initial_phi = hmm_fitted_trace(1);
        final_phi = hmm_fitted_trace(end);
        curr_phi = hmm_fitted_trace(end);
        for k=length(hmm_fitted_trace)-1:-1:1
            next_phi = hmm_fitted_trace(k);
            if next_phi ~= curr_phi
                curr_t = t_trace(k);
                AF_start_t = sequence_info.time_intervals(i,1);
                step_time = curr_t;                                      
                switch command_name
                    case 'AF1'
                        anti_fuel_num = 1;
                    case 'AF2'
                        anti_fuel_num = 2;
                    case 'AF3'
                        anti_fuel_num = 3;
                    case 'AF4'
                        anti_fuel_num = 4;
                    case 'AF5'
                        anti_fuel_num = 5;
                    case 'AF6'
                        anti_fuel_num = 6;
                end
                previous_fuel_command_name = sequence_info.command_names_full_sequence{i-5};
                switch previous_fuel_command_name
                    case 'F1'
                        previous_fuel_num = 1;
                    case 'F2'
                        previous_fuel_num = 2;
                    case 'F3'
                        previous_fuel_num = 3;
                    case 'F4'
                        previous_fuel_num = 4;
                    case 'F5'
                        previous_fuel_num = 5;
                    case 'F6'
                        previous_fuel_num = 6;
                end
                clockwise = 1+mod(anti_fuel_num + 2 - 1,6) == previous_fuel_num;
%                 step_reaction = make_step_reaction(AF_start_t,step_time,anti_fuel_num,initial_phi,final_phi,...
%                     t_trace,hmm_fitted_trace,clockwise,stepping_error,num_changes);
                step_reaction = make_step_reaction(AF_start_t,initial_phi,final_phi,0,initial_phi,step_time,step_time,...
                    anti_fuel_num,t_trace,hmm_fitted_trace,clockwise,stepping_error);

                break;
            end
            if k == 1 %% didnt find
                make_step_reaction(0,0,0,0,0,0,0,0,[],[],0,0);
            end
        end
    catch e
%                                     success = 0;
%         step_reaction = make_step_reaction(0,0,1,0,0,...
%                 [],[],1,stepping_error,num_changes);
        make_step_reaction(0,0,0,0,0,0,0,0,[],[],0,0);


    end

