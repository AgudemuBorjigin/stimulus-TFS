function out = sig_vocode(audio_names, fs, f_low, f_high, fileRoot, gender, masker)
if masker == 1
    Nchans = numel(audio_names);
    if gender == 'M'
        pitch_freq = 90;
    else
        pitch_freq = 240;
    end
    for i = 1: Nchans
        audioname = audio_names{i};
        [sig, fs_sig] = audioread(strcat(fileRoot, '/harvard_sentences/', audioname(1:6), '/audio/', audioname));
        single_band = simulateCI_clicktrain(sig, fs, fs_sig, pitch_freq, f_low, f_high, Nchans, masker, i);
        if i == 1
            out = single_band;
        else
            [out, single_band] = zeroPadding(out, single_band);
            out = out + single_band;
        end
        fprintf('Done with band # %d/%d ...\n', i, Nchans);
    end
else % for the target
    Nchans = 32;
    if gender == 'M'
        pitch_freq = 100;
    else
        pitch_freq = 250;
    end
    [sig, fs_sig] = audioread(audio_names);
    out = simulateCI_clicktrain(sig, fs, fs_sig, pitch_freq, f_low, f_high, Nchans, masker, []);
end
out = sigNorm(out);
end