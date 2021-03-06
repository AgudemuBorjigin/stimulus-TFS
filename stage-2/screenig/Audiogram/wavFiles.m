% NmaxTrials = 50;
% NminTrials = 5;
% target = (randperm(NmaxTrials) > NmaxTrials/2);

% converged = 0;
% respList = [];
% Llist = [];
% correctCount = 0;
fileRoot = '/Users/Agudemu/Dropbox/Lab/Experiment/stimulus-TFS/stage-2/screenig/Audiogram';

fs = 48828;
fm = 4;
m = 0.8;
bw = 50;
dur = 1.0;
dur_gap = 0.5;
rampSize = 0.025;
steps = 90:-10:-20;
ears = {'left', 'right'};

t_dur = 0:1/fs:dur - 1/fs;
t_dur_gap = 0:1/fs:dur_gap - 1/fs;
dummy = int32(zeros(1, length(t_dur)));
gap = int32(zeros(2, length(t_dur_gap)));
z = [dummy; dummy];

fcList = [0.5, 1, 2, 4 8]; % kHz
fileNames_1 = cell(1, numel(fcList)*numel(ears)*numel(steps));
fileNames_2 = cell(1, numel(fcList)*numel(ears)*numel(steps));
count = 0;
for fc = fcList
    count = count + 1;
    sig = int32(2^31 * maketranstone(fc*1000,fm,m,bw,fs,dur,rampSize));
    % sig = scaleSound(sig); % reference: 0 HL
    for step = steps
        for ear = ears
            if strcmp(ear, 'left')
                y = [sig; int32(zeros(size(sig)))];
            else
                y = [int32(zeros(size(sig))); sig];
            end
            % answer: one
            sig_one = [y'; gap'; z'];
            sig_one = sig_one * db2mag(-abs(step-max(steps)));
            wavName_1 = strcat(ear{1}, '_', num2str(fc), 'kHz_', num2str(step), 'dB_one.wav');
            fileNames_1{count} = wavName_1;
            audiowrite(strcat(fileRoot, '/wavFiles/', wavName_1), sig_one, fs, 'BitsPerSample', 32);
            % answer: two
            sig_two = [z'; gap'; y'];
            sig_two = sig_two * db2mag(-abs(step-max(steps)));
            wavName_2 = strcat(ear{1}, '_', num2str(fc), 'kHz_', num2str(step), 'dB_two.wav');
            fileNames_2{count} = wavName_2;
            audiowrite(strcat(fileRoot, '/wavFiles/', wavName_2), sig_two, fs, 'BitsPerSample', 32);
        end
    end
end

T_1 = cell2table(fileNames_1(:));
writetable(T_1, 'fileNames_1.csv');
T_2 = cell2table(fileNames_2(:));
writetable(T_2, 'fileNames_2.csv');


