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

%%

firstPulse = GetSecs + 5; 
for ii = 1:5 % blocks
%             AbsEvStart(:, runs)   = firstPulse(runs) + eventStartKey(:,runs); 
    AbsStimStart{ii, runs} = firstPulse(runs) + stimStartKey{ii, runs}; 
    AbsRxnEnd{ii, runs}   = firstPulse(runs) + rxnEndKey{ii, runs}; 
%             AbsRxnEnd(:, runs)    = firstPulse(runs) + rxnEndKey(:,runs); 
%             AbsEvEnd(:, runs)     = firstPulse(runs) + eventEndKey(:,runs); 
end

respKey = cell(1, 5);
respTime = cell(1, 5);
WaitTill(firstPulse); 

for evts = 1:t.stimPerBlock
    if any(oddball(blks, runs) == [2 4])
        thisstim = stim{oddball(blks, runs), events{runs, blocks(blks, runs)}(evts)}; 
    elseif any(blocks(blks, runs) == [2 4])
        thisstim = stim{blocks(blks, runs), events{runs, blocks(blks, runs)}(evts)}; 
    end
    thisstart = AbsStimStart{blks, runs}(evts);
    thisend = AbsRxnEnd{blks, runs}(evts);

    PsychPortAudio('FillBuffer', pahandle, thisstim);

    RTBox('Clear'); 
    stimStart{blks, runs}(evts) = PsychPortAudio('Start', pahandle, 1, thisstart, 1);
    [respTime{blks, runs}{evts}, respKey{blks, runs}{evts}] = RTBox(thisend); 

end