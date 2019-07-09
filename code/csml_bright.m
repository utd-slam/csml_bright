%% CSML_bright
% Experiment which I am coding with Lindsey Reymore at CSML, investigating
% multimodal sensory brightness. 

% MM/DD/YY -- CHANGELOG
% 06/24/19 -- Meeting with Lindsey, beginning code. 

%% Startup
sca; DisableKeysForKbCheck([]); KbQueueStop;  

try
    PsychPortAudio('Close'); 
catch
    disp('PPA already closed!')
end
InitializePsychSound

clearvars; clc; 

TESTING = 0;
codeStart = GetSecs(); 
AudioDevice = PsychPortAudio('GetDevices'); 

%% Parameters
prompt = {...
    'Subject number (####DS)', ...
    'First run', ... 
    'Last run', ... 
    'RTBox connected (0/1):', ...
    }; 
dlg_ans = inputdlg(prompt); 

subj.num  = dlg_ans{1};
subj.firstRun = str2double(dlg_ans{2}); 
subj.lastRun  = str2double(dlg_ans{3}); 
ConnectedToRTBox = str2double(dlg_ans{4}); 

% Scan type
scan.type   = 'Hybrid';
scan.TR     = 1.000; 
scan.epiNum = 10; 

% Timing
t.stimTypes = 4; % bright/dark * color/sound
t.stimPerBlock = 5; % Five presentations of stimuli per block, same stimuli each time

t.runs = length(subj.firstRun:subj.lastRun); 
t.maxRuns = 16; % Seems reasonable?

t.presTime   = 2.000;  % 2 seconds of hearing or seeing
t.fixTime    = 1.000;  % 2 seconds of fixation cross

t.blockDuration = t.stimPerBlock * (t.presTime + t.fixTime); 
t.timeBetweenBlocks = 10.000;
t.numBlocks = 5; 
t.oddballBlocks = 1; 

t.epiTime    = 10.000; % 10 seconds
t.eventTime  = t.presTime + t.epiTime;

% t.runDuration = t.epiTime + ...   % After first pulse
%     t.eventTime * t.events + ...  % Each event
%     t.eventTime;                  % After last acquisition

%% Preallocating timing variables

AbsEvStart    = cell(t.numBlocks, t.maxRuns); 
AbsStimStart  = cell(t.numBlocks, t.maxRuns); AbsStimStart = cellfun((@(x) nan(1, t.stimPerBlock)), AbsStimStart, 'UniformOutput', 0); 
AbsStimEnd    = cell(t.numBlocks, t.maxRuns); AbsStimEnd   = cellfun((@(x) nan(1, t.stimPerBlock)), AbsStimEnd, 'UniformOutput', 0); 
AbsRxnEnd     = cell(t.numBlocks, t.maxRuns); AbsRxnEnd    = cellfun((@(x) nan(1, t.stimPerBlock)), AbsRxnEnd, 'UniformOutput', 0); 
AbsEvEnd      = cell(t.numBlocks, t.maxRuns); 
ansKey        = cell(t.numBlocks, t.maxRuns); 
eventStart    = cell(t.numBlocks, t.maxRuns);
stimStart     = cell(t.numBlocks, t.maxRuns); stimStart = cellfun((@(x) nan(1, t.stimPerBlock)), stimStart, 'UniformOutput', 0); 
stimEnd       = cell(t.numBlocks, t.maxRuns); stimEnd   = cellfun((@(x) nan(1, t.stimPerBlock)), stimEnd, 'UniformOutput', 0); 
eventEnd      = cell(t.numBlocks, t.maxRuns); 
eventStartKey = cell(t.numBlocks, t.maxRuns); 
stimStartKey  = cell(t.numBlocks, t.maxRuns); stimStartKey  = cellfun((@(x) nan(1, t.stimPerBlock)), stimStartKey, 'UniformOutput', 0); 
stimEndKey    = cell(t.numBlocks, t.maxRuns); stimEndKey    = cellfun((@(x) nan(1, t.stimPerBlock)), stimEndKey, 'UniformOutput', 0); 
rxnEndKey     = cell(t.numBlocks, t.maxRuns); rxnEndKey     = cellfun((@(x) nan(1, t.stimPerBlock)), rxnEndKey, 'UniformOutput', 0); 
eventEndKey   = cell(t.numBlocks, t.maxRuns); 

recStart      = cell(t.numBlocks, t.maxRuns);
recStartKey   = cell(t.numBlocks, t.maxRuns);
stimDuration  = cell(t.numBlocks, t.maxRuns); 

respTime_present = cell(t.numBlocks, t.maxRuns); respTime_present = cellfun((@(x) cell(1, t.stimPerBlock)), respTime_present, 'UniformOutput', 0); 
respTime_fixate  = cell(t.numBlocks, t.maxRuns); respTime_fixate  = cellfun((@(x) cell(1, t.stimPerBlock)), respTime_fixate, 'UniformOutput', 0); 
respKey_present  = cell(t.numBlocks, t.maxRuns); respKey_present  = cellfun((@(x) cell(1, t.stimPerBlock)), respKey_present, 'UniformOutput', 0); 
respKey_fixate   = cell(t.numBlocks, t.maxRuns); respKey_fixate   = cellfun((@(x) cell(1, t.stimPerBlock)), respKey_fixate, 'UniformOutput', 0); 

blockStart    = NaN(t.numBlocks, t.maxRuns); 
jitterKey     = NaN(t.numBlocks, t.maxRuns); 
blockEnd      = NaN(t.numBlocks, t.maxRuns); 
restStart     = NaN(t.numBlocks, t.maxRuns); 
restDuration  = NaN(t.numBlocks + 1, t.maxRuns); % how long between blocks, includes pause after first 5%
restEnd       = NaN(t.numBlocks, t.maxRuns); 
blockStartKey = NaN(t.numBlocks, t.maxRuns); 
AbsBlockEnd   = NaN(t.numBlocks, t.maxRuns); 
blockEndKey   = NaN(t.numBlocks, t.maxRuns); 
stimtrainStartKey = NaN(t.numBlocks, t.maxRuns); 
stimtrainEndKey   = NaN(t.numBlocks, t.maxRuns); 
blockDuration = NaN(t.numBlocks, t.maxRuns); 

%% Path
dir_code = pwd;
cd ..
dir_exp = pwd;
dir_stim = fullfile(pwd, 'stim'); 
dir_results = fullfile(pwd, 'results'); 
dir_docs = fullfile(pwd, 'docs');

%% Load stimuli
folders_stim = dir(dir_stim); folders_stim = folders_stim(3:end);
stim = cell(t.stimTypes, t.stimPerBlock); 
fs = nan(t.stimTypes/2, t.stimPerBlock); 

for ii = 1:length(folders_stim)
    thisfolder = fullfile(dir_stim, folders_stim(ii).name); 
    
    if any(ii == [1 3]) % if color
        im_files = dir(fullfile(thisfolder, '*.png'));
        for jj = 1:length(im_files)
            thisfile = fullfile(thisfolder, im_files(jj).name);
            stim{ii, jj} = imread(thisfile);
        end
        
    elseif any(ii == [2 4]) % if sound
        ad_files = dir(fullfile(thisfolder, '*.aif'));
        for jj = 1:length(ad_files)
            thisfile = fullfile(thisfolder, ad_files(jj).name);
            [stim{ii, jj}, fs(ii/2, jj)] = audioread(thisfile);
            stim{ii, jj} = stim{ii, jj}';
        end
        
    end
    
end

if all(range(fs)) ~= 0
    error('Check sampling rate')
else
    fs = fs(1);
end

%% Randomization!
blocks = nan(subj.lastRun, t.stimPerBlock); 
for ii = 1:subj.lastRun
    thisblock = 1:t.stimTypes+1;
    blocks(ii, :) = Shuffle(thisblock); 
    % 1 -- Bright color
    % 2 -- Bright sound
    % 3 -- Dark color
    % 4 -- Dark sound
    % 5 -- Oddball
end
blocks = blocks'; 

oddball = randi(4, [1, subj.lastRun]); 
oddball = (blocks == 5) .* oddball; 
% What is the oddball block? See above

events = cell(subj.lastRun, t.stimPerBlock); 
for ii = 1:subj.lastRun % for each run
    for jj = 1:t.stimPerBlock % for each block
        thisblock = Shuffle(1:t.stimPerBlock);
        
        if jj == 5 % if oddball (block "5")
            thisblock = thisblock(1:t.stimTypes);
            nback = randi(t.stimPerBlock-1); 
            thisblock = [thisblock(1:nback), thisblock(nback), thisblock(nback+1:end)];             
        end
        
        events{ii, jj} = thisblock;
    end
    
end

% So we'll call events{thisrun, blocks(thisrun, thisevent)}
% And we'll throw an if-else exception in the code. 

%% Prepare PTB
% PTB
if TESTING
    error('TESTING!') %#ok<UNRCH>
end

[wPtr, rect] = Screen('OpenWindow', 1, 185);
DrawFormattedText(wPtr, 'Please wait, preparing experiment...');
Screen('Flip', wPtr);
centerX = rect(3)/2;
centerY = rect(4)/2;
crossCoords = [-30, 30, 0, 0; 0, 0, -30, 30]; 
HideCursor(); 
pahandle = PsychPortAudio('Open', 5, [], [], fs);
RTBox('fake', ~ConnectedToRTBox);
RTBox('UntilTimeout', 1); 

% Prepare textures of colors
for ii = 1:t.stimPerBlock
    stim{1, ii} = Screen('MakeTexture', wPtr, stim{1, ii}); 
    stim{3, ii} = Screen('MakeTexture', wPtr, stim{3, ii}); 
end

%% Prepare block
try
    for runs = subj.firstRun:subj.lastRun

        DrawFormattedText(wPtr, 'Please wait, preparing run...');
        Screen('Flip', wPtr); 

        % Prepare timing keys
        restDuration(:, runs) = Shuffle(14:19); % also includes first rest after exp. begins
        jitterKey(:, runs) = rand(1, 5);
        
        blockStartKey(1, runs) = restDuration(1, runs); 
        
        for ii = 1:5 % blocks
            if ii ~= 1
                blockStartKey(ii, runs) = blockEndKey(ii-1, runs); 
            end
            
            stimtrainStartKey(ii, runs) = blockStartKey(ii, runs) + jitterKey(ii, runs); 
            
            stimStartKey{ii, runs}(1) = stimtrainStartKey(ii, runs); 
            stimEndKey{ii, runs}(1)   = stimStartKey{ii, runs}(1) + t.presTime; 
            for jj = 1:5 % event
                if jj ~= 1
                    stimStartKey{ii, runs}(jj) = rxnEndKey{ii, runs}(jj-1); 
                    stimEndKey{ii, runs}(jj) = stimStartKey{ii, runs}(jj) + t.presTime; 
                end
                
                rxnEndKey{ii, runs}(jj) = stimStartKey{ii, runs}(jj) + t.presTime + t.fixTime;
            end
        
            stimtrainEndKey(ii, runs) = stimtrainStartKey(ii, runs) + t.blockDuration; 
            restStart(ii, runs) = stimtrainEndKey(ii, runs); 
            restEnd(ii, runs) = restStart(ii, runs) + restDuration(ii+1, runs); 
            blockEndKey(ii, runs) = restEnd(ii, runs); 
        end

        % Wait for first pulse
        DrawFormattedText(wPtr, ['Waiting for first pulse. Block ', num2str(runs)]); 
        Screen('Flip', wPtr); 
        
        RTBox('Clear'); 
        RTBox('UntilTimeout', 1);
        firstPulse(runs) = RTBox('WaitTR'); 

        % Draw onto screen after recieving first pulse
        Screen('DrawLines', wPtr, crossCoords, 2, 0, [centerX, centerY]);
        Screen('Flip', wPtr); 

        % Generate absolute time keys
        for ii = 1:5 % blocks
            AbsStimStart{ii, runs} = firstPulse(runs) + stimStartKey{ii, runs}; 
            AbsStimEnd{ii, runs}   = firstPulse(runs) + stimEndKey{ii, runs}; 
            AbsRxnEnd{ii, runs}    = firstPulse(runs) + rxnEndKey{ii, runs}; 
            AbsBlockEnd(ii, runs)  = firstPulse(runs) + blockEndKey(ii, runs); 
        end
        
        WaitTill(firstPulse(runs) + restDuration(1, runs)); 

        %% Present stimuli
        for blks = 1:t.numBlocks 
            blockStart(runs, blks) = GetSecs(); 
            
            if any(blocks(blks, runs) == [1 3]) || any(oddball(blks, runs) == [1 3]) % if color
                for evts = 1:t.stimPerBlock
                    if any(oddball(blks, runs) == [1 3])
                        thisstim = stim{oddball(blks, runs), events{runs, blocks(blks, runs)}(evts)}; 
                    elseif any(blocks(blks, runs) == [1 3])
                        thisstim = stim{blocks(blks, runs), events{runs, blocks(blks, runs)}(evts)}; 
                    end
                    
                    thisstimstart = AbsStimStart{blks, runs}(evts);
                    thisstimend   = AbsStimEnd{blks, runs}(evts) - 0.01;
                    thisfixstart  = AbsStimEnd{blks, runs}(evts); 
                    thisrxnend    = AbsRxnEnd{blks, runs}(evts);

                    Screen('DrawTexture', wPtr, thisstim);
                    stimStart{blks, runs}(evts) = Screen('Flip', wPtr, thisstimstart); 
                    Screen('DrawLines', wPtr, crossCoords, 2, 0, [centerX, centerY]); % draw cross early
                    RTBox('Clear'); 
                    [respTime_present{blks, runs}{evts}, respKey_present{blks, runs}{evts}] = RTBox(thisstimend); 

                    Screen('Flip', wPtr, thisfixstart); 
                    RTBox('Clear'); 
                    [respTime_fixate{blks, runs}{evts}, respKey_fixate{blks, runs}{evts}] = RTBox(thisrxnend); 

                end
            
            elseif any(blocks(blks, runs) == [2 4]) || any(oddball(blks, runs) == [2 4]) % if sound
                for evts = 1:t.stimPerBlock
                    if any(oddball(blks, runs) == [2 4])
                        thisstim = stim{oddball(blks, runs), events{runs, blocks(blks, runs)}(evts)}; 
                    elseif any(blocks(blks, runs) == [2 4])
                        thisstim = stim{blocks(blks, runs), events{runs, blocks(blks, runs)}(evts)}; 
                    end
                    
                    thisstimstart = AbsStimStart{blks, runs}(evts);
                    thisstimend   = AbsStimEnd{blks, runs}(evts) - 0.01;
                    thisrxnend    = AbsRxnEnd{blks, runs}(evts);
                    
                    PsychPortAudio('FillBuffer', pahandle, thisstim);
                    RTBox('Clear'); 
                    stimStart{blks, runs}(evts) = PsychPortAudio('Start', pahandle, 1, thisstimstart, 1);
                    [respTime_present{blks, runs}{evts}, respKey_present{blks, runs}{evts}] = RTBox(thisstimend); 
                    
                    [respTime_fixate{blks, runs}{evts}, respKey_fixate{blks, runs}{evts}] = RTBox(thisrxnend); 
                    
                end
                
            end
            
        end
        
        WaitSecs()
        
        %% End of run
        WaitSecs(t.eventTime); 
        runEnd(runs) = GetSecs();  %#ok<SAGROW>

        if runs ~= subj.lastRun
            DrawFormattedText(wPtr, 'End of run. Great job!', 'center', 'center'); 
            Screen('Flip', wPtr); 
            WaitTill(GetSecs() + 6);
        end 
                    
    end
    
catch err
    %% Error exception
    sca; 
    runEnd(runs) = GetSecs();  %#ok<NASGU>
%     cd(dir_funcs)
%     disp('Dumping data...')
%     OutputData_fst
%     cd(dir_scripts)
    PsychPortAudio('Close'); 
    disp('Done!')
    rethrow(err)
end

%% End of experiment

sca


