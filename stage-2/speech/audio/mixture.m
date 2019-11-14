function mixture(stim_tar, stim_masker, b, configuration, SNR, id_trial, target, wordlist, t_mskonset, fs, rampdur, root_audios) %#ok<INUSL>
normval = 0.01;
% masker starts after the prompt for target 
stim_masker = filter(b, 1, stim_masker);
switch configuration
    case {'pitch', 'echo', 'space'}
        load('h_barMonsieurRichard.mat');
        % h = h/max(h); %#ok<NODEF>
        stim_masker = conv(stim_masker,h);
    otherwise
end
stim_masker = sigNorm(stim_masker)*normval;
stim_masker = db2mag(-SNR)*stim_masker;
stim_masker = [zeros(t_mskonset*fs, 1); stim_masker];

switch configuration
    case {'pitch', 'echo', 'space'}
        load('h_barMonsieurRichard.mat');
        % h = h/max(h);
        stim_tar = conv(stim_tar,h);
    otherwise
end
stim_tar = sigNorm(stim_tar)*normval;
stim_tar = [stim_tar; zeros(length(stim_masker) - length(stim_tar), 1)];

switch configuration
    case {'anechoic', 'pitch', 'echo'}
        mix_left = stim_tar + stim_masker;
        mix_right = stim_tar + stim_masker;
    otherwise
        mix_left = -stim_tar + stim_masker; % N0S_pi
        length(stim_tar) 
        length(stim_masker)
        mix_right = stim_tar + stim_masker;
end

% mix = scaleSound(mix); 
mix_left  = rampsound(mix_left, fs, rampdur);
mix_right  = rampsound(mix_right, fs, rampdur);
y = [mix_left, mix_right];  %#ok<NASGU>

savename = [root_audios, '/mixture/', configuration, '/trial', id_trial, '.mat'];
save(savename, 'y', 'fs', 'SNR', 'target', 'wordlist');
end