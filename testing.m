% %% testing
% 
% crossCoords = [-30, 30, 0, 0; 0, 0, -30, 30]; 
% 
% [wPtr, rect] = Screen('OpenWindow', 1, 185);
% DrawFormattedText(wPtr, 'Please wait, preparing experiment...');
% Screen('Flip', wPtr);
% centerX = rect(3)/2;
% centerY = rect(4)/2;
% HideCursor(); 
% 
% % WaitSecs(2);
% % sca
% 
% % Make the image into a texture
% text = cell(1, 5);
% for ii = 1:5
%     text{ii} = Screen('MakeTexture', wPtr, stim{1, ii});
% end
% 
% % Draw the image to the screen, unless otherwise specified PTB will draw
% % the texture full size in the center of the screen. We first draw the
% % image in its correct orientation.
% Screen('DrawLines', wPtr, crossCoords, 2, 0, [centerX, centerY]);
% Screen('Flip', wPtr); 
% WaitSecs(2);
%     
% for ii = 1:5
%     
%     Screen('DrawTexture', wPtr, text{ii}, [], [], 0);
%     Screen('Flip', wPtr);
%     WaitSecs(1);
% 
%     Screen('DrawLines', wPtr, crossCoords, 2, 0, [centerX, centerY]);
%     Screen('Flip', wPtr); 
%     WaitSecs(1);
%     
% end
% 
% sca
% 
% 
% %%
% AbsEvStart    = cell(t.numBlocks, t.maxRuns); 
% AbsStimStart  = cell(t.numBlocks, t.maxRuns); 
% AbsStimEnd    = cell(t.numBlocks, t.maxRuns); 
% AbsRxnEnd     = cell(t.numBlocks, t.maxRuns); 
% AbsEvEnd      = cell(t.numBlocks, t.maxRuns); 
% ansKey        = cell(t.numBlocks, t.maxRuns); 
% eventStart    = cell(t.numBlocks, t.maxRuns);
% stimStart     = cell(t.numBlocks, t.maxRuns); 
% stimEnd       = cell(t.numBlocks, t.maxRuns); 
% eventEnd      = cell(t.numBlocks, t.maxRuns); 
% eventStartKey = cell(t.numBlocks, t.maxRuns); 
% stimStartKey  = cell(t.numBlocks, t.maxRuns); 
% stimEndKey    = cell(t.numBlocks, t.maxRuns);
% eventEndKey   = cell(t.numBlocks, t.maxRuns); 
% 
% recStart      = cell(t.numBlocks, t.maxRuns);
% recStartKey   = cell(t.numBlocks, t.maxRuns);
% stimDuration  = cell(t.numBlocks, t.maxRuns); 
% 
% 
% blockStart    = NaN(t.numBlocks, t.maxRuns); 
% jitterKey     = NaN(t.numBlocks, t.maxRuns); 
% blockEnd      = NaN(t.numBlocks, t.maxRuns); 
% restStart     = NaN(t.numBlocks, t.maxRuns); 
% restDuration  = NaN(t.numBlocks, t.maxRuns); % how long between blocks
% restEnd       = NaN(t.numBlocks, t.maxRuns); 
% blockStartKey = NaN(t.numBlocks, t.maxRuns); 
% blockEndKey   = NaN(t.numBlocks, t.maxRuns); 
% stimtrainStartKey = NaN(t.numBlocks, t.maxRuns); 
% stimtrainEndKey   = NaN(t.numBlocks, t.maxRuns); 
% blockDuration = NaN(t.numBlocks, t.maxRuns); 

%% Audio testing
% 
% firstPulse = GetSecs + 5; 
% for ii = 1:5 % blocks
% %             AbsEvStart(:, runs)   = firstPulse(runs) + eventStartKey(:,runs); 
%     AbsStimStart{ii, runs} = firstPulse(runs) + stimStartKey{ii, runs}; 
%     AbsRxnEnd{ii, runs}   = firstPulse(runs) + rxnEndKey{ii, runs}; 
% %             AbsRxnEnd(:, runs)    = firstPulse(runs) + rxnEndKey(:,runs); 
% %             AbsEvEnd(:, runs)     = firstPulse(runs) + eventEndKey(:,runs); 
% end
% 
% respKey = cell(1, 5);
% respTime = cell(1, 5);
% WaitTill(firstPulse); 
% 
% for evts = 1:t.stimPerBlock
%     if any(oddball(blks, runs) == [2 4])
%         thisstim = stim{oddball(blks, runs), events{runs, blocks(blks, runs)}(evts)}; 
%     elseif any(blocks(blks, runs) == [2 4])
%         thisstim = stim{blocks(blks, runs), events{runs, blocks(blks, runs)}(evts)}; 
%     end
%     thisstart = AbsStimStart{blks, runs}(evts);
%     thisend = AbsRxnEnd{blks, runs}(evts);
% 
%     PsychPortAudio('FillBuffer', pahandle, thisstim);
% 
%     RTBox('Clear'); 
%     stimStart{blks, runs}(evts) = PsychPortAudio('Start', pahandle, 1, thisstart, 1);
%     [respTime{blks, runs}{evts}, respKey{blks, runs}{evts}] = RTBox(thisend); 
% 
% end

%% Image testing

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
restDuration  = NaN(t.numBlocks, t.maxRuns); % how long between blocks
restEnd       = NaN(t.numBlocks, t.maxRuns); 
blockStartKey = NaN(t.numBlocks, t.maxRuns); 
blockEndKey   = NaN(t.numBlocks, t.maxRuns); 
stimtrainStartKey = NaN(t.numBlocks, t.maxRuns); 
stimtrainEndKey   = NaN(t.numBlocks, t.maxRuns); 
blockDuration = NaN(t.numBlocks, t.maxRuns); 

% Load stimuli
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

%%%%%
blks = 1;
runs = 1;
%%%%%

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

% Prepare timing keys
restDuration(:, runs) = Shuffle(14:18); 
jitterKey(:, runs) = rand(1, 5);

blockStartKey(1, runs) = scan.TR; 

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
    restEnd(ii, runs) = restStart(ii, runs) + restDuration(ii, runs); 
    blockEndKey(ii, runs) = restEnd(ii, runs); 
end

% Prepare textures of colors
for ii = 1:t.stimPerBlock
    stim{1, ii} = Screen('MakeTexture', wPtr, stim{1, ii}); 
    stim{3, ii} = Screen('MakeTexture', wPtr, stim{3, ii}); 
end

% Wait for first pulse

firstPulse = GetSecs + 5; 
% Draw onto screen after recieving first pulse
Screen('DrawLines', wPtr, crossCoords, 2, 0, [centerX, centerY]);
Screen('Flip', wPtr); 

% Generate absolute time keys
for ii = 1:5 % blocks
%             AbsEvStart(:, runs)   = firstPulse(runs) + eventStartKey(:,runs); 
    AbsStimStart{ii, runs} = firstPulse(runs) + stimStartKey{ii, runs}; 
    AbsStimEnd{ii, runs} = firstPulse(runs) + stimEndKey{ii, runs}; 
    AbsRxnEnd{ii, runs}   = firstPulse(runs) + rxnEndKey{ii, runs}; 
%             AbsRxnEnd(:, runs)    = firstPulse(runs) + rxnEndKey(:,runs); 
%             AbsEvEnd(:, runs)     = firstPulse(runs) + eventEndKey(:,runs); 
end

WaitTill(firstPulse(runs) + scan.TR); 


for evts = 1:t.stimPerBlock
%     eventStart(evts, runs) = GetSecs(); 
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

pause(3)
sca; 














