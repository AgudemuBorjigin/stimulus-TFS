% this file calibrates subject's response from audiogram into hearng level
datadir = '/Users/Agudemu/Desktop/Lab/Experiment/stimulus-TFS/stage-2/screenig/Audiogram/Results/S140/';
%datadir = '/Users/baoagudemu1/Desktop/Lab/Experiment/DataAnalysis/Data/S199_behavior/Audiogram/';
%cd '/Users/baoagudemu1/Desktop/Lab/Experiment/DataAnalysis/Data/S199_behavior/Audiogram/';
ears = dir(strcat(datadir, '*Ear'));
fid = fopen('AudiogramData.csv', 'w');
freqs  = [0.5, 1, 2, 4, 8]*1000;
avgThresh = [8.6, 2.7, 0.5, 0.1, 23.1];
fprintf(fid, 'Subject, Ear, 500, 1000, 2000, 4000, 8000\n');
threshHL = zeros(2, numel(freqs));
threshSPL = zeros(2, numel(freqs));
for k = 1:numel(ears)
    ear = ears(k);
    subjID = ear.name(1:4);
    whichear = ear.name(6);
    fprintf(fid, '%s, %s', subjID, whichear);
    j = 0;
    for freq = freqs
        j = j + 1;
        fpath = strcat(ear.folder, '/', ear.name, '/', ear.name, '_', ...
            num2str(freq), '*.mat');
        fnames = dir(fpath);
        fname = fnames.name;
        data = load(strcat(ear.folder, '/', ear.name, '/', fname), 'thresh');
        hearingLevel = data.thresh - avgThresh(j);
        threshHL(k, j) = hearingLevel;
        threshSPL(k, j) = data.thresh;
        fprintf(fid, ',%f',hearingLevel);
    end
    fprintf(fid, '\n');
end
fprintf(fid, '%s, %s', subjID, 'diff');
for i = 1:numel(freqs)
    diff = abs(threshHL(1, i) - threshHL(2, i));
    fprintf(fid, ',%f', diff);
end
fclose(fid);

% plot
v = [250 -10; 8200 -10; 8200 15; 250 15];
f = [1 2 3 4];
transparency = 0.6;
h(1) = patch('Faces', f, 'Vertices', v, 'FaceColor', [0 1 1], 'FaceAlpha',transparency, 'LineStyle', 'none');
hold on;
v = [250 15; 8200 15; 8200 25; 250 25];
f = [1 2 3 4];
h(2) = patch('Faces', f, 'Vertices', v, 'FaceColor', [0 1 0.5], 'FaceAlpha',transparency, 'LineStyle', 'none');
v = [250 25; 8200 25; 8200 40; 250 40];
f = [1 2 3 4];
h(3) = patch('Faces', f, 'Vertices', v, 'FaceColor', [0 1 0], 'FaceAlpha',transparency, 'LineStyle', 'none');
v = [250 40; 8200 40; 8200 55; 250 55];
f = [1 2 3 4];
h(4) = patch('Faces', f, 'Vertices', v, 'FaceColor', [0.5 1 0], 'FaceAlpha',transparency, 'LineStyle', 'none');
v = [250 55; 8200 55; 8200 70; 250 70];
f = [1 2 3 4];
h(5) = patch('Faces', f, 'Vertices', v, 'FaceColor', [1 1 0], 'FaceAlpha',transparency, 'LineStyle', 'none');
v = [250 70; 8200 70; 8200 90; 250 90];
f = [1 2 3 4];
h(6) = patch('Faces', f, 'Vertices', v, 'FaceColor', [1 0.5 0], 'FaceAlpha',transparency, 'LineStyle', 'none');
v = [250 90; 8200 90; 8200 120; 250 120];
f = [1 2 3 4];
h(7) = patch('Faces', f, 'Vertices', v, 'FaceColor', [1 0 0], 'FaceAlpha',transparency, 'LineStyle', 'none');

h(8) = plot(freqs, threshHL(1, :), '-xb', 'LineWidth', 2, 'MarkerSize', 8);
h(9) = plot(freqs, threshHL(2, :), '-or', 'LineWidth', 2, 'MarkerSize', 8);
xticks([500 1000 2000 4000 8000]);
yticks([-10 0 10 20 30 40 50 60 70 80 90 100 110 120]);
ylim([-10 120]); xlim([250 8200]);
xlabel('Frequency [Hz]'); ylabel('Hearing Level [dB HL]');
set(gca,'YDir','reverse'); set(gca,'xaxisLocation','top');
set(gca, 'FontSize', 12);set(gca, 'LineWidth', 1.5);set(gca, 'GridLineStyle', '--');
grid on;

label = {'Normal', 'Slight', 'Mild', 'Moderate', 'Moderate-severe', 'Severe', 'Profound', 'Left ear: patient 1', 'Right ear: patient 1'};
legend(h, label, 'Location', 'southwest');
