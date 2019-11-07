% mixing target and masker for different configurations
fs = 44100;
rampdur = 0.01;
t_onset = 0.8;
% CHANGE AS NEEDED
root_audios = '/Users/baoagudemu1/Desktop/Lab/Experiment/speechAudiofiles_stage2';

configuration = 'sum'; % 'pitch', 'space', 'anechoic', 'echo', 'sum'
flag_c = 1;
while flag_c
    switch configuration
        case 'anechoic'
            SNRs = 9:-3:-12; 
            N = [20, 30, 30, 30, 30, 30, 30, 20]; % Number of trials per SNR (variable)
            flag_c = 0;
        case 'pitch'
            SNRs = 12:-3:-9; 
            N = [20, 30, 30, 30, 30, 30, 30, 20]; 
            flag_c = 0;
        case 'space'
            SNRs = 12:-3:-9; 
            N = [20, 30, 30, 30, 30, 30, 30, 20]; 
            flag_c = 0;
        case 'echo'
            SNRs = 12:-3:-9; 
            N = [20, 30, 30, 30, 30, 30, 30, 20]; 
            flag_c = 0;
        case 'sum'
            SNRs = 9:-3:-12; 
            N = [20, 30, 30, 30, 30, 30, 30, 20]; 
            flag_c = 0;
        otherwise
            fprintf(2, 'Unrecognized configuration type! Try again!\n');
    end
end

num_trials = sum(N);
num_snr = numel(SNRs);
% For different randomization across conditions
target_masker(N);

gender = 'same_gender';
b_same = filter_param(num_trials, gender, strcat(root_audios, '/target_masker/', gender, '/'), fs);
gender = 'opposite_gender';
b_opposite = filter_param(num_trials, gender, strcat(root_audios, '/target_masker/', gender, '/'), fs);

if strcmp(configuration,'anechoic')
    num_trial = 0;
    rand_trialnums = randperm(sum(N));
    for i = 1:num_snr
        for j = 1:N(i)
            num_trial = num_trial + 1;
            load(strcat(root_audios, '/target_masker/same_gender/trial', int2str(num_trial), '.mat'));
            mixture(stim_tar, stim_same, b_same, configuration, SNRs(i),  int2str(rand_trialnums(num_trial)), target, wordlist, t_onset, fs, rampdur, root_audios);
        end
    end
elseif strcmp(configuration, 'pitch')
    num_trial = 0;
    rand_trialnums = randperm(sum(N));
    for i = 1:num_snr
        for j = 1:N(i)
            num_trial = num_trial + 1;
            load(strcat(root_audios, '/target_masker/opposite_gender/trial', int2str(num_trial), '.mat'));
            mixture(stim_tar, stim_opposite, b_opposite, configuration, SNRs(i), int2str(rand_trialnums(num_trial)), target, wordlist, t_onset, fs, rampdur, root_audios);
        end
    end
elseif strcmp(configuration, 'space')
    num_trial = 0;
    rand_trialnums = randperm(sum(N));
    for i = 1:num_snr
        for j = 1:N(i)
            num_trial = num_trial + 1;
            load(strcat(root_audios, '/target_masker/same_gender/trial', int2str(num_trial), '.mat'));
            mixture(stim_tar, stim_same, b_same, configuration, SNRs(i),  int2str(rand_trialnums(num_trial)), target, wordlist, t_onset, fs, rampdur, root_audios);
        end
    end
elseif strcmp(configuration, 'echo')
    num_trial = 0;
    rand_trialnums = randperm(sum(N));
    for i = 1:num_snr
        for j = 1:N(i)
            num_trial = num_trial + 1;
            load(strcat(root_audios, '/target_masker/same_gender/trial', int2str(num_trial), '.mat'));
            mixture(stim_tar, stim_same, b_same, configuration, SNRs(i),  int2str(rand_trialnums(num_trial)), target, wordlist, t_onset, fs, rampdur, root_audios);
        end
    end
elseif strcmp(configuration, 'sum')
    num_trial = 0;
    rand_trialnums = randperm(sum(N));
    for i = 1:num_snr
        for j = 1:N(i)
            num_trial = num_trial + 1;
            load(strcat(root_audios, '/target_masker/opposite_gender/trial', int2str(num_trial), '.mat'));
            mixture(stim_tar, stim_opposite, b_opposite, configuration, SNRs(i), int2str(rand_trialnums(num_trial)), target, wordlist, t_onset, fs, rampdur, root_audios);
        end
    end
end