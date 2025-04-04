function [x_hat,z_hat,returnedErr,errmsg] = vbAnalysis(trace,num_states)
% This does the actual analysis of vbFRET
% Originally edited fall 2009 by Jonathan E Bronson (jeb2126@columbia.edu)
% for http://vbfret.sourceforge.net. Adapted for iSMS 2014 by S?ren Preus.
%
%    Input:
%     mainhandle     - handle to the main window
%     selectedPairs  - [file1 pair1;...] to calculate
%     traceChoice    - 'E', 'S', 'AA' trace to analyse
%
%    Output:
%     mainhandles    - ...
%

%% Initialize

% Initialize possible error message
returnedErr = 0;
errmsg = sprintf('OBS: vbFRET was unable to solve the idealized path of the following pairs:\n');



% turn off divide by 0 warning
warning off MATLAB:divideByZero

%--- Parameters ----%
% dims = length(traceChoice); % Number of dimensions (1 for E and S trace, 2 for A+D trace analysis)
dims = 1;
% npairs = size(selectedPairs,1); % No. of pairs
npairs = 1;
% attempts = mainhandles.settings.vbFRET.attempts; % Fitting attempts per trace (def: 10)
attempts = 5;
% minK = mainhandles.settings.vbFRET.minStates; % Minimum no. of states (def: 1)
minK = num_states;
% maxK = mainhandles.settings.vbFRET.maxStates; % Maximum no. of states (def: 5)
% maxK = 4;
maxK = num_states;

% minK = 2;
% maxK = 3;

% Hyperparameter priors, see vbFRET manual pp13. Usually not changed from
% defaults.



PriorPar = struct(...
    'upi', 1,... % Probability of first state being state k (def: 1)
    'mu', 0.5,... % Mean of FRET Gaussian distribution of state k (def: 0.5)
    'beta', 0.25,... % Spread of Gaussian of state k (def: 0.25)
    'W', 50,... % Gamma-distribution parameter of state k (def: 50)
    'v', 5,... % Gamma-distribution parameter of state k (def: 5)
    'ua', 1,... % Related to transition probability between states (def: 1)
    'uad', 0); % Related to transition probability between state (def: 0)
PriorPar.mu = PriorPar.mu*ones(dims,1); % Make sure priors are set for each dimension if analyzing A and D traces
PriorPar.W = PriorPar.W*eye(dims);

% Optimization options
vb_opts.maxIter = 100; % Stop after vb_opts iterations if program has not yet converged (def: 100)
vb_opts.threshold = 0.00001; % Stop when two iterations have the same evidence to within this (def: 1e-5)
% run_time = []; run_iters = [];

% raw = cell(1);
% FRET = cell(1);
% for i = 1:npairs
%     filechoice = selectedPairs(i,1);
%     pairchoice = selectedPairs(i,2);
%     raw{i} = [mainhandles.data(filechoice).FRETpairs(pairchoice).DDtrace(:)  mainhandles.data(filechoice).FRETpairs(pairchoice).ADtrace(:)];
%     FRET{i} = mainhandles.data(filechoice).FRETpairs(pairchoice).Etrace(:);
% end

% Output structures
fit_par.out = cell(1,npairs); % hyperparameters of best fit
fit_par.mix = cell(1,npairs); % initial starting guesses of best fit
fit_par.bestLP = -Inf*ones(1,npairs); % log evidence of best fit
fit_par.settings = []; % analysis settings



% traces = getTraces(mainhandle,selectedPairs,'vbFRET'); 

%% Run analysis

% progressbar('Total','States','Attempts')
% runbar1 = 1;
%     filechoice = selectedPairs(i,1);
%     pairchoice = selectedPairs(i,2);
%     pair = mainhandles.data(filechoice).FRETpairs(pairchoice);
    
%     % Get time trace to analyse
%     if strcmp(traceChoice,'S')
%         trace = traces(i).S(:);
%     elseif strcmp(traceChoice,'E')
%         trace = traces(i).E(:);
% %         trace = pair.DDtrace(:);
% %         trace = map_to_unit(trace);
%     elseif strcmp(traceChoice,'D')
%         trace = pair.DDtrace(:);
%         trace = map_to_unit(trace);
%     elseif strcmp(traceChoice,'A')
%         trace = pair.ADtrace(:);
% %         trace = [pair.DDtrace(:) pair.ADtrace(:)];
%     end
    
    % fit trace with minK:maxK states, numrestarts times
%     runbar2 = linspace(0,1,length(minK:maxK));
%     run2 = 1;
    for j = minK:maxK
        for k = 1:attempts
            % when number of states = 1, all restarts converge to same
            % value so don't waste time with extra restarts. If analysis
            % was paused and resumed also skip over any analysis that has
            % already been done
            if j==1 && k > 1 
%                 runbar1 = runbar1+1;
                break
            end
            
            %--- Start guess ---%
%             start_guess = mainhandles.settings.vbFRET.startGuess(:);
%             start_guess = [];
%             if mainhandles.settings.vbFRET.useStartGuess && ~isempty(start_guess)
%                 % if more user guessed states than states being fit
%                 if j < length(start_guess)
%                     perm = randperm(length(start_guess));
%                     start_guess = start_guess(perm(1:j),:);
                    
                    % if less user guessed states than states being fit
%                 elseif j > length(start_guess)
% %                     start_guess = [start_guess; rand(j-length(start_guess),1)];
%                     start_guess = [0.1;0.3;0.8];
% 
%                 end
                
%             else % Set guess as evenly spread between 0 and 1
                if k == 1
                    start_guess = (1:j)'/(j+1);
                else
                    start_guess = rand(j,1);
                end
%             end
            
            %             try
                % mix structure has initilization information
                [mix] = get_mix(trace,start_guess); % initializes the gaussian centers that will be used in the continuous hidden markov model analysis.
                [out] = vbFRET_VBEM(trace', mix, PriorPar, vb_opts); % Variational Bayes EM algorithm for a hidden Markov Gaussian Mixture Model
                
                % Only save the iterations with the best out.F
                if out.F(end) > fit_par.bestLP
                    fit_par.bestLP = out.F(end);
                    fit_par.out = out;
                    fit_par.mix = mix;                 

%                     % plot results, if user desires
%                     [dat.z_hat{i} dat.x_hat{1,i}] = chmmViterbi(out,trace'); % Get Viterbi path (?)
%                     fit = dat.x_hat{1,n};
%                     plot(plot_axis,1:T,fit,'Color',opts.FRETfit.color,'LineStyle',opts.FRETfit.lineStyle...
%                         ,'LineWidth',opts.FRETfit.lineThickness);
                end
                

%                 run_iters = length(out.F);
%                 progressbar(runbar1/(npairs*(length(minK:maxK))*attempts-attempts+1),runbar2(run2),k/attempts)
%                 runbar1=runbar1+1;
%              catch
%              end
        end
%         run2 = run2+1;
    end
    
    % Returned err
    if isempty(fit_par.out)
        errmsg = sprintf('%s\n (%i,%i)',errmsg,filechoice,pairchoice);
        returnedErr = 1;
%         continue
        return
    end
    
    % Get Viterbi path, i.e. "ideal traces"
%     [dat.z_hat{i} dat.x_hat{1,i}] = chmmViterbi(fit_par.out{i},trace');
    [z_hat, x_hat] = chmmViterbi(fit_par.out,trace(:)');
    
%     if strcmp(traceChoice,'S')
%         mainhandles.data(filechoice).FRETpairs(pairchoice).vbfitS_fit = [x_hat(:) z_hat(:)];
%         mainhandles.data(filechoice).FRETpairs(pairchoice).vbfitS_bestLP = fit_par.bestLP(i);
%         mainhandles.data(filechoice).FRETpairs(pairchoice).vbfitS_out = fit_par.out{i};
%         mainhandles.data(filechoice).FRETpairs(pairchoice).vbfitS_mix = fit_par.mix{i}; % Initial Gaussian centers
%     elseif strcmp(traceChoice,'E')
%         mainhandles.data(filechoice).FRETpairs(pairchoice).vbfitE_fit = [x_hat(:) z_hat(:)];
%         mainhandles.data(filechoice).FRETpairs(pairchoice).vbfitE_bestLP = fit_par.bestLP(i);
%         mainhandles.data(filechoice).FRETpairs(pairchoice).vbfitE_out = fit_par.out{i};
%         mainhandles.data(filechoice).FRETpairs(pairchoice).vbfitE_mix = fit_par.mix{i};
%         mainhandles.data(filechoice).FRETpairs(pairchoice).vbfitE_idx = traces(i).idx;
%         
%     elseif strcmp(traceChoice,'AA')
%         mainhandles.data(filechoice).FRETpairs(pairchoice).vbfitAA_fit = [x_hat(:) z_hat(:)];
%         mainhandles.data(filechoice).FRETpairs(pairchoice).vbfitAA_bestLP = fit_par.bestLP(i);
%         mainhandles.data(filechoice).FRETpairs(pairchoice).vbfitAA_out = fit_par.out{i};
%         mainhandles.data(filechoice).FRETpairs(pairchoice).vbfitAA_mix = fit_par.mix{i};
%     end
    
%     updatemainhandles(mainhandles)
%     updateDynamicsList(mainhandle,mainhandles.dynamicswindowHandle,'all')


% progressbar(1)

% make a second set of pseudo x_hats in the dimension not analyzed
% dat.x_hat(2,:) = pseudo_x_hat(dat.z_hat,dat.FRET,dat.raw,dims);
% updatemainhandles(mainhandles)

%% Update dynamics window if its open

% if strcmpi(get(mainhandles.Toolbar_dynamicswindow,'State'),'on')
%     updateDynamicsList(mainhandle,mainhandles.dynamicswindowHandle,'all')
%     updateDynamicsPlot(mainhandle,mainhandles.dynamicswindowHandle,'all')
%     updateDynamicsFit(mainhandle,mainhandles.dynamicswindowHandle)
% end

% turn warnings back on
warning on MATLAB:divideByZero

function x_hat = pseudo_x_hat(z_hat,FRET,raw,D)

N = length(FRET);
x_hat = cell(1,N);
% use traces in dimension opposite the one analyzed
if D == 1
    traces = raw;
    pseudoD = 2;
else
    traces = FRET;
    pseudoD = 1;
end


for n=1:N
    if isempty(z_hat{n})
        break
    end
    
    states = unique(z_hat{n});
    T = length(FRET{n});
    x_hat{n} = zeros(T,pseudoD);
    for s=1:length(states)
        % set the mean (i.e. Viterbi path value) of each state based on the
        % mean value of the data points at that state.
        meanS = mean(traces{n}(z_hat{n} == states(s),:),1);
        x_hat{n}(z_hat{n} == states(s),:) = meanS(ones(1,sum(z_hat{n} == states(s))),:);
    end
end

