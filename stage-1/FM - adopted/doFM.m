fclist = 1e3 * 0.5; %[0.125, 0.750, 1.5]; AB: carrier frequency list, fm rate should be less than 10 Hz, such as 2 Hz


useTDT = 1;
screenDist = 0.4;
screenWidth = 0.3;
buttonBox = 1;
subj = input('Please enter subject ID:', 's'); % AB: enter
earflag = 1;
nreps = 4;

while earflag == 1
    ear = input('Please enter which ear (L or R):', 's'); % AB: year->ear
    switch ear
        case {'L', 'l', 'Left', 'left', 'LEFT'}
            earname = 'LeftEar';
            earnumber = 1;
            earflag = 0;
        case {'R', 'r', 'Right', 'right', 'RIGHT'}
            earname = 'RightEar';
            earnumber = 2;
            earflag = 0;
        otherwise
            fprintf(2, 'Unrecognized ear type! Try again!');
    end
end

sID = strcat(subj, '_',earname);
nBlocks = nreps * numel(fclist);
for k = 1:numel(fclist)
    fc = fclist(k);
    for p = 1:nreps
        blockNum = (k-1)*nreps + p;
        
        [respList, fdevList, thresh] = getThreshFM(sID,fc, blockNum,...
            nBlocks, earnumber,useTDT,screenDist,screenWidth,buttonBox);
        fprintf(1, 'Threshold at %d kHz is %f dB\n', fc, thresh);
    end
end

