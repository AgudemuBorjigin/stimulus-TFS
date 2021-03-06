clear all; close all hidden; clc; %#ok<CLALL>

fig_num=99;
USB_ch=1;

pth = genpath('./functions/');
addpath(pth);

FS_tag = 3;

Fs = 48828.125;


[f1RZ,RZ,FS]=load_play_circuit(FS_tag,fig_num,USB_ch);


load('randITDsTrigNums_passive.mat'); % CHANGE AS NEEDED
TFSorENV = 'TFS'; % Determines if the phase jump is in TFS or ENV
fc = 500;
fm = 40.8;
dur = 1.5;
ramp = 0.005;
L = 70; % set everything to 70


nTrials = numel(randITDs);

% Pause Off, AB: not sure if changes are required, 3/8/18
invoke(RZ, 'SetTagVal', 'trgname',253);
invoke(RZ, 'SetTagVal', 'onsetdel',100);
invoke(RZ, 'SoftTrg', 6);

pause(2.0);

tstart = tic;
jit = rand(nTrials, 1)*0.1;

for p = 1:nTrials
    
    y = makeITDstim(leftOrRight{p},randITDs(p), fc, Fs, fm, dur, ramp, TFSorENV);
    scale = rms(y(1,:)); % AB
    
    if strcmp(leftOrRight{p}, 'left')
        sideFlag = 0;
    else 
        sideFlag = 1;
    end
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Clear Up buffers for 1st stim
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    % If using headphones (HDA 300), we have to use the phoneSens.m
    % function, but ER-1s are plat spectrum with fixed sensitivity.
    
    sens = 100; % in dB SPL / 0 dBV (frequency specific)
    % Without attenuation, RZ6 gives 10.5236 dBV (matlab is restricted
    % to +/- 0.95 by scaleSound). So you would get sens + 10.5236 dB
    % SPL for pure tones occupying full range in MATLAB. To get a level
    % of 'L' dB SPL, you need to attenuate by sens + 10.5236 - L. This
    % is for a tone which would have an rms of 0.95/sqrt(2).
    % For a different waveform of rms 'scale', we should adjust further
    % by db(scale*sqrt(2)/0.95).
    
    digDrop = 0; % How much to drop digitally
    drop = sens + 10.5236 - L - digDrop + db(scale*sqrt(2)/0.95); % db(scale*sqrt(2)/0.95) is the compensation considering the real signal
    %Start dropping from maximum RMS (actual RMS not peak-equivalent)
    wavedata = y * db2mag(-1 * digDrop);
    %-----------------------------------------
    % Attenuate both sides, just in case
    invoke(RZ, 'SetTagVal', 'attA', drop); %setting analog attenuation L
    invoke(RZ, 'SetTagVal', 'attB', drop); %setting analog attenuation R
    invoke(RZ, 'SetTagVal', 'nsamps', size(wavedata,2));
    trigger = randTrigNums(p) + sideFlag*numel(unique(randITDs));
    invoke(RZ, 'SetTagVal', 'trgname', trigger);
    invoke(RZ, 'WriteTagVEX', 'datainL', 0, 'F32', wavedata(1, :));
    invoke(RZ, 'WriteTagVEX', 'datainR', 0, 'F32', wavedata(2, :));
    WaitSecs(0.2);
    %Start playing from the buffer:
    invoke(RZ, 'SoftTrg', 1); %Playback trigger
    fprintf(1,' Trial Number %d/%d\n', p, nTrials);
    WaitSecs(dur + 0.5 + jit(p)); % AB: is jit variable needed?
end

toc(tstart);

%Clearing I/O memory buffers, AB: not sure if changes are required, 3/8/18
invoke(RZ,'ZeroTag','datainL');
invoke(RZ,'ZeroTag','datainR');
pause(3.0);

% Pause On, AB: not sure if changes are required, 3/8/18
invoke(RZ, 'SetTagVal', 'trgname', 254);
invoke(RZ, 'SetTagVal', 'onsetdel',100);
invoke(RZ, 'SoftTrg', 6);

close_play_circuit(f1RZ,RZ);
fprintf(1,'\n Done with data collection!\n');

rmpath(pth);

