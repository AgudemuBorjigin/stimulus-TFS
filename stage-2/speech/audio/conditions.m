% mixing target and masker for different configurations
fs = 44100;
% CHANGE AS NEEDED
configuration = 'pitch'; % 'pitch', 'space', 'anechoic', 'echo', 'sum'
rampdur = 0.01;
t_onset = 0.8;

SNRs = 12:-3:-3; % dB, change in 'target_masker.m' first
N = [50, 50, 50, 50, 50, 50]; 
num_snr = numel(SNRs);

root_audios = '/Users/baoagudemu1/Desktop/Lab/Experiment/speechAudiofiles_stage2';

if strcmp(configuration,'anechoic')
    num_trial = 0;
    for i = 1:num_snr
        for j = 1:N(i)
            num_trial = num_trial + 1;
            load(strcat(root_audios, '/target_masker/same_gender/trial', int2str(num_trial), '.mat'));
            mixture(stim_tar, stim_same, configuration, SNRs(i),  int2str(num_trial), target, wordlist, t_onset, fs, rampdur, root_audios);
        end
    end
elseif strcmp(configuration, 'pitch')
    num_trial = 0;
    for i = 1:num_snr
        for j = 1:N(i)
            num_trial = num_trial + 1;
            load(strcat(root_audios, '/target_masker/opposite_gender/trial', int2str(num_trial), '.mat'));
            mixture(stim_tar, stim_opposite, configuration, SNRs(i), int2str(num_trial), target, wordlist, t_onset, fs, rampdur, root_audios);
        end
    end
elseif strcmp(configuration, 'space')
    num_trial = 0;
    for i = 1:num_snr
        for j = 1:N(i)
            num_trial = num_trial + 1;
            load(strcat(root_audios, '/target_masker/same_gender/trial', int2str(num_trial), '.mat'));
            mixture(stim_tar, stim_same, configuration, SNRs(i),  int2str(num_trial), target, wordlist, t_onset, fs, rampdur, root_audios);
        end
    end
elseif strcmp(configuration, 'echo')
    num_trial = 0;
    for i = 1:num_snr
        for j = 1:N(i)
            num_trial = num_trial + 1;
            load(strcat(root_audios, '/target_masker/same_gender/trial', int2str(num_trial), '.mat'));
            mixture(stim_tar, stim_same, configuration, SNRs(i),  int2str(num_trial), target, wordlist, t_onset, fs, rampdur, root_audios);
        end
    end
elseif strcmp(configuration, 'sum')
    num_trial = 0;
    for i = 1:num_snr
        for j = 1:N(i)
            num_trial = num_trial + 1;
            load(strcat(root_audios, '/target_masker/opposite_gender/trial', int2str(num_trial), '.mat'));
            mixture(stim_tar, stim_opposite, configuration, SNRs(i), int2str(num_trial), target, wordlist, t_onset, fs, rampdur, root_audios);
        end
    end
end

% % ordered snrs for each repetition
% SNRcounts = zeros(nconds, 1);
% SNRlist = [];
% for rep = 1:max(N)
%     for k = 1:nconds
%         if SNRcounts(k) <= N(k)
%             SNRlist = [SNRlist, SNRs(k)]; %#ok<AGROW>
%             SNRcounts(k) = SNRcounts(k) + 1;
%         end
%     end
% end