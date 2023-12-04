clear
clc

%input prolific id
id = input('input desired prolific id:','s');
pathdata = '/Users/Kob/Documents/MINDLab/THAMP/thamp 1b/thamp 1b data/';
asrs = readtable(append(pathdata,'asrs_7_13.csv'))

for i = 1:height(asrs)
    if string(asrs{i,2}) == id
        matchrow = i;
    end
end

asrs(matchrow,3)
asrs(matchrow,4)
asrs(matchrow,5)
asrs(matchrow,6)
asrs(matchrow,7)
asrs(matchrow,8)
%if columns 3,4,5,6,7,8 are shaded darkly
count = 0;
if string(asrs{matchrow,3}) == 'Sometimes' || string(asrs{matchrow,3}) == 'Often' || string(asrs{matchrow,3}) == 'Very Often'

    count = count + 1
end
if string(asrs{matchrow,4}) == 'Sometimes' || string(asrs{matchrow,4}) == 'Often' || string(asrs{matchrow,4}) == 'Very Often'

    count = count + 1
end
if string(asrs{matchrow,5}) == 'Sometimes' || string(asrs{matchrow,5}) == 'Often' || string(asrs{matchrow,5}) == 'Very Often'

    count = count + 1
end
if string(asrs{matchrow,6}) == 'Often' || string(asrs{matchrow,6}) == 'Very Often'

    count = count + 1
end
if string(asrs{matchrow,7}) == 'Often' || string(asrs{matchrow,7}) == 'Very Often'

    count = count + 1
end
if string(asrs{matchrow,8}) == 'Often' || string(asrs{matchrow,8}) == 'Very Often'

    count = count + 1
end

disp('Total Count')
count