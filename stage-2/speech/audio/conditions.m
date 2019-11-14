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
            SNRs = 8:-5:-22;
            N = [25, 35, 35, 35, 35, 35, 25]; % Number of trials per SNR (variable)
            num_trials = sum(N);
            flag_c = 0;
            target_masker(N);
            gender = 'same_gender';
            b_same = filter_param(num_trials, gender, strcat(root_audios, '/target_masker/', gender, '/'), fs);
        case 'pitch'
            SNRs = 12:-4:-16;
            N = [25, 35, 35, 35, 35, 35, 35, 25];
            num_trials = sum(N);
            flag_c = 0;
            % For different randomization across conditions
            target_masker(N);
            gender = 'opposite_gender';
            b_opposite = filter_param(num_trials, gender, strcat(root_audios, '/target_masker/', gender, '/'), fs);
        case 'space'
            SNRs = 12:-4:-16;
            N = [25, 35, 35, 35, 35, 35, 35, 25];
            num_trials = sum(N);
            flag_c = 0;
            target_masker(N);
            gender = 'same_gender';
            b_same = filter_param(num_trials, gender, strcat(root_audios, '/target_masker/', gender, '/'), fs);
        case 'echo'
            SNRs = 12:-4:-16;
            N = [25, 35, 35, 35, 35, 35, 35, 25];
            num_trials = sum(N);
            flag_c = 0;
            target_masker(N);
            gender = 'same_gender';
            b_same = filter_param(num_trials, gender, strcat(root_audios, '/target_masker/', gender, '/'), fs);
        case 'sum'
            SNRs = 4:-3:-17;
            N = [25, 35, 35, 35, 35, 35, 35, 25];
            num_trials = sum(N);
            flag_c = 0;
            target_masker(N);
            gender = 'opposite_gender';
            b_opposite = filter_param(num_trials, gender, strcat(root_audios, '/target_masker/', gender, '/'), fs);
            
        otherwise
            fprintf(2, 'Unrecognized configuration type! Try again!\n');
    end
end

num_snr = numel(SNRs);

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