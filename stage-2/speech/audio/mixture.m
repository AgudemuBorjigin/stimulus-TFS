function mixture(stim_tar, stim_masker, b, configuration, SNR, id_trial, target, wordlist, t_mskonset, fs, rampdur, root_audios) %#ok<INUSL>
% masker starts after the prompt for target 
stim_masker = filter(b, 1, stim_masker);
switch configuration
    case {'pitch', 'space', 'echo'}
        load('h_barMonsieurRichard.mat');
        stim_masker = conv(stim_masker,h);
    otherwise
end
stim_masker = [zeros(t_mskonset*fs, 1); stim_masker];
stim_masker = sigNorm(stim_masker)*0.1; % 0.1 is an arbitrary small number 

switch configuration
    case {'pitch', 'space', 'echo'}
        load('h_barMonsieurRichard.mat');
        echo_tar = conv(stim_tar(t_mskonset*fs:end),h);
        echo_tar = sigNorm(echo_tar)*0.1;
        stim_tar = sigNorm(stim_tar)*0.1; % 0.1 is an arbitrary small number 
        stim_tar = [stim_tar(1:t_mskonset*fs-1); echo_tar];
    otherwise
        stim_tar = sigNorm(stim_tar)*0.1; % 0.1 is an arbitrary small number 
end

if length(stim_tar) < length(stim_masker)
    stim_tar = [stim_tar; zeros(length(stim_masker) - length(stim_tar), 1)];
else
    stim_masker = [stim_masker; zeros(length(stim_tar) - length(stim_masker), 1)];
end

switch configuration
    case {'anechoic', 'pitch', 'echo'}
        mix = db2mag(-SNR)*stim_masker + stim_tar;
    otherwise
        stim_masker = -stim_masker;
        mix = db2mag(-SNR)*stim_masker + stim_tar;
end

% mix = scaleSound(mix); 
mix  = rampsound(mix, fs, rampdur);
y = [mix, mix]; %#ok<NASGU>

savename = [root_audios, '/mixture/', configuration, '/trial', id_trial, '.mat'];
save(savename, 'y', 'fs', 'SNR', 'target', 'wordlist');
end