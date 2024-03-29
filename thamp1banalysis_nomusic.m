clear
clc

%This script analyzes the performance of a single subject at a time using
%the data from psytoolkit

%input prolific id
id = input('input desired prolific id:','s');
%input date and group (group1 7_13)
group = input('group (1 or 2) '); %group 1/2 is modded/unmodded first
date = input('date (ex: 1_9) ','s'); %date the specific subject was recorded (batch)
gd = append(string(group),' ',date);
%search through each survey data txt for prolific id
pathsurvey = append('/Users/Kob/Documents/MINDLab/THAMP/thamp 1b/thamp 1b data/group', gd,'/survey_data');
filelist = fullfile(pathsurvey);
d = dir(filelist);
d(1) = [];
d(1) = [];
d(1) = [];
for i=1:length(d)
    % this for loop checks every file to see which one matches the current
    % subject
    % d is the list of all the files in the survey folder
    name = d(i).name;
    sname = split(name,'-');
    sname = split(sname(5),'.');
    sname = sname(1);
    a = readtable( append(pathsurvey,'/',string(name)) ); %splits the file into sections
    realID = a{20,2}; %reads the the id from the location in the file
    if string(realID) == id
        % if the id matches, save the file as out1
        out1 = sname;
        a_real = a;
        d(i).name
    end
end
out1
 
%save the end of survey data txt file name
%find the two matching txt files in experiment data
pathexp = append('/Users/Kob/Documents/MINDLab/THAMP/thamp 1b/thamp 1b data/group', gd,'/experiment_data');
filelist2 = fullfile(pathexp);
d2 = dir(filelist2); %d2 is the experiment data (d is the survey data)
d2(1) = [];
d2(1) = [];
out2 = [];
for i=1:length(d2)
    %for loop to match the survey data to the experiment data
    name2 = d2(i).name;
    sname2 = split(name2,'-');
    sname2 = split(sname2(8),'.');
    sname2 = sname2(1);
    if string(sname2) == out1
        %get the nback file and the sart file that match the id
        out2 = [out2,'+',name2]; %two file names in an array
    end
end
out2;
out2 = split(out2,'+'); %use out2{2} for NBACK and out2{3} for SART

%maybe here is where you would be able to split into FOUR groups for nback,
%sart, nback no music, sart no music
%maybe?: out2{2} out2{3} out2{4} out2{5}

%%
%take sart file and extract reaction time column
%plot average reaction time for unmodded compared to modded SART
sart = readtable( append(pathexp,'/',string(out2{5})) );
%column 12 is reaction time, column 11 is song
%if group=1 s1,s2,s3,s7,s8,s9 = modded, 4,5,6,10,11,12 = unmodded
%if group=2 s1,s2,s3,s7,s8,s9 = unmodded, 4,5,6,10,11,12 = modded
table1mod = [];
table1unmod = [];
table2mod = [];
table2unmod = [];
if group == 1 %if modded first
    for i = 1:height(sart)
        if ~strcmp(char(sart{i,1}),'training') && (sart{i,2} == 3 ||sart{i,2} == 4||sart{i,2} == 5||sart{i,2} == 9||sart{i,2} == 10||sart{i,2} == 11)
            %if not training block, and modded block
            if sart{i,4} ~= 3 && sart{i,7} == 3
                table1mod = [table1mod;sart(i,10)]; %saves the sart results
            end
        end
        if ~strcmp(char(sart{i,1}), 'training') && (sart{i,2} == 6 || sart{i,2} == 7 || sart{i,2} == 8 || sart{i,2} == 12 || sart{i,2} == 13 || sart{i,2} == 14)
            %if not a training block and is an unmodded block
            if sart{i,4} ~= 3 && sart{i,7} == 3
                table1unmod = [table1unmod;sart(i,10)]; %saves the sart results
            end
        end
    end

    for k = 1:height(sart)
        if sart{k,6} == 0
            %plot mistake, plot an x? or plot a vertical line at each
            % use this for future time sensitive analysis
        end
    end
    
    %plotting reaction time
    table1mod = table2array(table1mod);
    table1unmod = table2array(table1unmod);
    figure(1)
    plot(table1mod)
    title('MODDED REACTION TIME')
    ylabel('Reaction Time (ms)')
    figure(2)
    plot(table1unmod)
    title('UNMODDED REACTION TIME')
    ylabel('Reaction Time (ms)')
    total = 0;
    for l = 1:length(table1mod)
        total = total + table1mod(l);
    end
    %outputs average reaction times and standard deviation for sart modded
    %and and sart unmodded
    avg_mod_reaction = total / length(table1mod)
    std_mod = std(table1mod)
    total = 0;
    for l = 1:length(table1unmod)
        total = total + table1unmod(l);
    end
    avg_unmod_reaction = total / length(table1unmod)
    std_unmod = std(table1unmod)


end
if group == 2
    %same as above but for unmodded first
    for i = 1:height(sart)
        if ~strcmp(char(sart{i,1}),'training') && (sart{i,2} == 3 ||sart{i,2} == 4||sart{i,2} == 5||sart{i,2} == 7||sart{i,2} == 10||sart{i,2} == 11)
            if sart{i,4} ~= 3 && sart{i,7} == 3
                table2unmod = [table2unmod;sart(i,10)];
            end
        end
        if ~strcmp(char(sart{i,1}), 'training') && (sart{i,2} == 6 || sart{i,2} == 7 || sart{i,2} == 8 || sart{i,2} == 12 || sart{i,2} == 13 || sart{i,2} == 14)
            if sart{i,4} ~= 3 && sart{i,7} == 3
                table2mod = [table2mod;sart(i,10)];
            end
        end
    end
    table2mod = table2array(table2mod);
    table2unmod = table2array(table2unmod);
    figure(1)
    plot(table2mod)
    title('MODDED REACTION TIME')
    ylabel('Reaction Time (ms)')
    figure(2)
    plot(table2unmod)
    title('UNMODDED REACTION TIME')
    ylabel('Reaction Time (ms)')
    total = 0;
    for l = 1:length(table2mod)
        total = total + table2mod(l);
    end
    avg_mod_reaction = total / length(table2mod)
    std_mod = std(table2mod)
    total = 0;
    for l = 1:length(table2unmod)
        total = total + table2unmod(l);
    end
    avg_unmod_reaction = total / length(table2unmod)
    std_unmod = std(table2unmod)
end


%%
% take nback file and extract status, current letter, predet
%import all predet array
%match to appropriate predet array
%answer key: check to see if current letter matches predet from 2 ago
%               then compare status and assign hit, miss, CR, FA
% plot the nback accuracy for unmodded compared to modded
nback = readtable( append(pathexp,'/',string(out2{3})) ); %loads nback response data

%predetermined order of stimuli for nback
predet1 = [9 8 9 15 9 15 9 3 14 3 8 1 6 1 11 7 14 14 1 13 1 15 8 5 8 11 8 13 5 13 6 6 13 5 13 5 1 6 5 6 5 6 13 1 3 4 3 7 6 7 6 6 11 12 14 4 14 5 8 5 11 5 4 8 8 3 8 3 4 10 12 10 7 10 7 2 7 2 14 2 3 3 15 3 1 14 6 1 12 1 6 4 9 12 9 9 13 6 13 12 4 12 1 12 1 10 15 10 7 2 7 9 5 9 11 9 9 13 11 14 13 14 13 9 13 9 15 4 13 13 14 13 4 13 4 14 2 8 2 5 10 1 10 1 1 1 3 2 3 2 10 2 5 2 14 12 14 2 4 2 14 10 12 13 12 5 12 11 12 13 12 6 9 8 12 8 10 8 8 13 6 9 6 12 9 14 9 5 2 5 2 4 2 10 11 10 3 3 1 6 5 6 5 6 13 1 3 4 3 7 6 7 6 6 11 12 6 4 9 12 9 9 13 6 13 12 4 12 1 12 1 10 15 10 1 13 1 15 8 5 8 11 8 13 5 13 6 6 13 5 13 5 1 1 3 2 3 2 10 2 5 2 14 12 14 2 4 2 14 10 6 9 6 12 9 14 9 5 2 5 2 4 2 10 11 10 3 3 15 4 13 13 14 13 4 13 4 14 2 8 2 5 10 1 10 1 7 10 7 2 7 2 14 2 3 3 15 3 1 14 6 1 12 1 12 13 12 5 12 11 12 13 12 6 9 8 12 8 10 8 8 13 9 8 9 15 9 15 9 3 14 3 8 1 6 1 11 7 14 14 7 2 7 9 5 9 11 9 9 13 11 14 13 14 13 9 13 9 14 4 14 5 8 5 11 5 4 8 8 3 8 3 4 10 12 10 6 4 9 12 9 9 13 6 13 12 4 12 1 12 1 10 15 10 9 8 9 15 9 15 9 3 14 3 8 1 6 1 11 7 14 14 1 13 1 15 8 5 8 11 8 13 5 13 6 6 13 5 13 5 7 10 7 2 7 2 14 2 3 3 15 3 1 14 6 1 12 1 15 4 13 13 14 13 4 13 4 14 2 8 2 5 10 1 10 1 14 4 14 5 8 5 11 5 4 8 8 3 8 3 4 10 12 10 1 1 3 2 3 2 10 2 5 2 14 12 14 2 4 2 14 10 6 9 6 12 9 14 9 5 2 5 2 4 2 10 11 10 3 3 12 13 12 5 12 11 12 13 12 6 9 8 12 8 10 8 8 13 1 6 5 6 5 6 13 1 3 4 3 7 6 7 6 6 11 12 7 2 7 9 5 9 11 9 9 13 11 14 13 14 13 9 13 9 7 10 7 2 7 2 14 2 3 3 15 3 1 14 6 1 12 1 14 4 14 5 8 5 11 5 4 8 8 3 8 3 4 10 12 10 12 13 12 5 12 11 12 13 12 6 9 8 12 8 10 8 8 13 9 8 9 15 9 15 9 3 14 3 8 1 6 1 11 7 14 14 6 9 6 12 9 14 9 5 2 5 2 4 2 10 11 10 3 3 15 4 13 13 14 13 4 13 4 14 2 8 2 5 10 1 10 1 6 4 9 12 9 9 13 6 13 12 4 12 1 12 1 10 15 10 1 13 1 15 8 5 8 11 8 13 5 13 6 6 13 5 13 5 7 2 7 9 5 9 11 9 9 13 11 14 13 14 13 9 13 9 1 1 3 2 3 2 10 2 5 2 14 12 14 2 4 2 14 10 1 6 5 6 5 6 13 1 3 4 3 7 6 7 6 6 11 12 ];
predet2 = [7 2 7 9 5 9 11 9 9 13 11 14 13 14 13 9 13 9 6 9 6 12 9 14 9 5 2 5 2 4 2 10 11 10 3 3 1 1 3 2 3 2 10 2 5 2 14 12 14 2 4 2 14 10 14 4 14 5 8 5 11 5 4 8 8 3 8 3 4 10 12 10 1 6 5 6 5 6 13 1 3 4 3 7 6 7 6 6 11 12 6 4 9 12 9 9 13 6 13 12 4 12 1 12 1 10 15 10 15 4 13 13 14 13 4 13 4 14 2 8 2 5 10 1 10 1 9 8 9 15 9 15 9 3 14 3 8 1 6 1 11 7 14 14 12 13 12 5 12 11 12 13 12 6 9 8 12 8 10 8 8 13 1 13 1 15 8 5 8 11 8 13 5 13 6 6 13 5 13 5 7 10 7 2 7 2 14 2 3 3 15 3 1 14 6 1 12 1 6 4 9 12 9 9 13 6 13 12 4 12 1 12 1 10 15 10 14 4 14 5 8 5 11 5 4 8 8 3 8 3 4 10 12 10 1 13 1 15 8 5 8 11 8 13 5 13 6 6 13 5 13 5 7 10 7 2 7 2 14 2 3 3 15 3 1 14 6 1 12 1 12 13 12 5 12 11 12 13 12 6 9 8 12 8 10 8 8 13 15 4 13 13 14 13 4 13 4 14 2 8 2 5 10 1 10 1 9 8 9 15 9 15 9 3 14 3 8 1 6 1 11 7 14 14 6 9 6 12 9 14 9 5 2 5 2 4 2 10 11 10 3 3 1 6 5 6 5 6 13 1 3 4 3 7 6 7 6 6 11 12 1 1 3 2 3 2 10 2 5 2 14 12 14 2 4 2 14 10 7 2 7 9 5 9 11 9 9 13 11 14 13 14 13 9 13 9 7 10 7 2 7 2 14 2 3 3 15 3 1 14 6 1 12 1 6 4 9 12 9 9 13 6 13 12 4 12 1 12 1 10 15 10 1 6 5 6 5 6 13 1 3 4 3 7 6 7 6 6 11 12 15 4 13 13 14 13 4 13 4 14 2 8 2 5 10 1 10 1 9 8 9 15 9 15 9 3 14 3 8 1 6 1 11 7 14 14 7 2 7 9 5 9 11 9 9 13 11 14 13 14 13 9 13 9 1 1 3 2 3 2 10 2 5 2 14 12 14 2 4 2 14 10 14 4 14 5 8 5 11 5 4 8 8 3 8 3 4 10 12 10 12 13 12 5 12 11 12 13 12 6 9 8 12 8 10 8 8 13 1 13 1 15 8 5 8 11 8 13 5 13 6 6 13 5 13 5 6 9 6 12 9 14 9 5 2 5 2 4 2 10 11 10 3 3 7 10 7 2 7 2 14 2 3 3 15 3 1 14 6 1 12 1 14 4 14 5 8 5 11 5 4 8 8 3 8 3 4 10 12 10 1 6 5 6 5 6 13 1 3 4 3 7 6 7 6 6 11 12 7 2 7 9 5 9 11 9 9 13 11 14 13 14 13 9 13 9 1 13 1 15 8 5 8 11 8 13 5 13 6 6 13 5 13 5 1 1 3 2 3 2 10 2 5 2 14 12 14 2 4 2 14 10 6 4 9 12 9 9 13 6 13 12 4 12 1 12 1 10 15 10 9 8 9 15 9 15 9 3 14 3 8 1 6 1 11 7 14 14 12 13 12 5 12 11 12 13 12 6 9 8 12 8 10 8 8 13 6 9 6 12 9 14 9 5 2 5 2 4 2 10 11 10 3 3 15 4 13 13 14 13 4 13 4 14 2 8 2 5 10 1 10 1 ];
predet3 = [1 13 1 15 8 5 8 11 8 13 5 13 6 6 13 5 13 5 1 1 3 2 3 2 10 2 5 2 14 12 14 2 4 2 14 10 15 4 13 13 14 13 4 13 4 14 2 8 2 5 10 1 10 1 6 9 6 12 9 14 9 5 2 5 2 4 2 10 11 10 3 3 7 10 7 2 7 2 14 2 3 3 15 3 1 14 6 1 12 1 12 13 12 5 12 11 12 13 12 6 9 8 12 8 10 8 8 13 9 8 9 15 9 15 9 3 14 3 8 1 6 1 11 7 14 14 1 6 5 6 5 6 13 1 3 4 3 7 6 7 6 6 11 12 6 4 9 12 9 9 13 6 13 12 4 12 1 12 1 10 15 10 14 4 14 5 8 5 11 5 4 8 8 3 8 3 4 10 12 10 7 2 7 9 5 9 11 9 9 13 11 14 13 14 13 9 13 9 15 4 13 13 14 13 4 13 4 14 2 8 2 5 10 1 10 1 6 4 9 12 9 9 13 6 13 12 4 12 1 12 1 10 15 10 7 10 7 2 7 2 14 2 3 3 15 3 1 14 6 1 12 1 7 2 7 9 5 9 11 9 9 13 11 14 13 14 13 9 13 9 6 9 6 12 9 14 9 5 2 5 2 4 2 10 11 10 3 3 9 8 9 15 9 15 9 3 14 3 8 1 6 1 11 7 14 14 1 1 3 2 3 2 10 2 5 2 14 12 14 2 4 2 14 10 1 13 1 15 8 5 8 11 8 13 5 13 6 6 13 5 13 5 14 4 14 5 8 5 11 5 4 8 8 3 8 3 4 10 12 10 1 6 5 6 5 6 13 1 3 4 3 7 6 7 6 6 11 12 12 13 12 5 12 11 12 13 12 6 9 8 12 8 10 8 8 13 1 6 5 6 5 6 13 1 3 4 3 7 6 7 6 6 11 12 14 4 14 5 8 5 11 5 4 8 8 3 8 3 4 10 12 10 7 2 7 9 5 9 11 9 9 13 11 14 13 14 13 9 13 9 1 1 3 2 3 2 10 2 5 2 14 12 14 2 4 2 14 10 7 10 7 2 7 2 14 2 3 3 15 3 1 14 6 1 12 1 6 4 9 12 9 9 13 6 13 12 4 12 1 12 1 10 15 10 1 13 1 15 8 5 8 11 8 13 5 13 6 6 13 5 13 5 9 8 9 15 9 15 9 3 14 3 8 1 6 1 11 7 14 14 12 13 12 5 12 11 12 13 12 6 9 8 12 8 10 8 8 13 6 9 6 12 9 14 9 5 2 5 2 4 2 10 11 10 3 3 15 4 13 13 14 13 4 13 4 14 2 8 2 5 10 1 10 1 14 4 14 5 8 5 11 5 4 8 8 3 8 3 4 10 12 10 12 13 12 5 12 11 12 13 12 6 9 8 12 8 10 8 8 13 1 13 1 15 8 5 8 11 8 13 5 13 6 6 13 5 13 5 6 4 9 12 9 9 13 6 13 12 4 12 1 12 1 10 15 10 7 10 7 2 7 2 14 2 3 3 15 3 1 14 6 1 12 1 1 6 5 6 5 6 13 1 3 4 3 7 6 7 6 6 11 12 1 1 3 2 3 2 10 2 5 2 14 12 14 2 4 2 14 10 7 2 7 9 5 9 11 9 9 13 11 14 13 14 13 9 13 9 6 9 6 12 9 14 9 5 2 5 2 4 2 10 11 10 3 3 15 4 13 13 14 13 4 13 4 14 2 8 2 5 10 1 10 1 9 8 9 15 9 15 9 3 14 3 8 1 6 1 11 7 14 14 ];
predet4 = [7 2 7 9 5 9 11 9 9 13 11 14 13 14 13 9 13 9 9 8 9 15 9 15 9 3 14 3 8 1 6 1 11 7 14 14 14 4 14 5 8 5 11 5 4 8 8 3 8 3 4 10 12 10 6 4 9 12 9 9 13 6 13 12 4 12 1 12 1 10 15 10 7 10 7 2 7 2 14 2 3 3 15 3 1 14 6 1 12 1 1 1 3 2 3 2 10 2 5 2 14 12 14 2 4 2 14 10 15 4 13 13 14 13 4 13 4 14 2 8 2 5 10 1 10 1 1 13 1 15 8 5 8 11 8 13 5 13 6 6 13 5 13 5 6 9 6 12 9 14 9 5 2 5 2 4 2 10 11 10 3 3 1 6 5 6 5 6 13 1 3 4 3 7 6 7 6 6 11 12 12 13 12 5 12 11 12 13 12 6 9 8 12 8 10 8 8 13 6 9 6 12 9 14 9 5 2 5 2 4 2 10 11 10 3 3 7 10 7 2 7 2 14 2 3 3 15 3 1 14 6 1 12 1 1 1 3 2 3 2 10 2 5 2 14 12 14 2 4 2 14 10 14 4 14 5 8 5 11 5 4 8 8 3 8 3 4 10 12 10 12 13 12 5 12 11 12 13 12 6 9 8 12 8 10 8 8 13 9 8 9 15 9 15 9 3 14 3 8 1 6 1 11 7 14 14 7 2 7 9 5 9 11 9 9 13 11 14 13 14 13 9 13 9 6 4 9 12 9 9 13 6 13 12 4 12 1 12 1 10 15 10 1 6 5 6 5 6 13 1 3 4 3 7 6 7 6 6 11 12 15 4 13 13 14 13 4 13 4 14 2 8 2 5 10 1 10 1 1 13 1 15 8 5 8 11 8 13 5 13 6 6 13 5 13 5 7 2 7 9 5 9 11 9 9 13 11 14 13 14 13 9 13 9 6 4 9 12 9 9 13 6 13 12 4 12 1 12 1 10 15 10 9 8 9 15 9 15 9 3 14 3 8 1 6 1 11 7 14 14 7 10 7 2 7 2 14 2 3 3 15 3 1 14 6 1 12 1 12 13 12 5 12 11 12 13 12 6 9 8 12 8 10 8 8 13 1 1 3 2 3 2 10 2 5 2 14 12 14 2 4 2 14 10 14 4 14 5 8 5 11 5 4 8 8 3 8 3 4 10 12 10 1 6 5 6 5 6 13 1 3 4 3 7 6 7 6 6 11 12 15 4 13 13 14 13 4 13 4 14 2 8 2 5 10 1 10 1 1 13 1 15 8 5 8 11 8 13 5 13 6 6 13 5 13 5 6 9 6 12 9 14 9 5 2 5 2 4 2 10 11 10 3 3 6 4 9 12 9 9 13 6 13 12 4 12 1 12 1 10 15 10 7 2 7 9 5 9 11 9 9 13 11 14 13 14 13 9 13 9 9 8 9 15 9 15 9 3 14 3 8 1 6 1 11 7 14 14 15 4 13 13 14 13 4 13 4 14 2 8 2 5 10 1 10 1 1 13 1 15 8 5 8 11 8 13 5 13 6 6 13 5 13 5 7 10 7 2 7 2 14 2 3 3 15 3 1 14 6 1 12 1 12 13 12 5 12 11 12 13 12 6 9 8 12 8 10 8 8 13 1 6 5 6 5 6 13 1 3 4 3 7 6 7 6 6 11 12 14 4 14 5 8 5 11 5 4 8 8 3 8 3 4 10 12 10 6 9 6 12 9 14 9 5 2 5 2 4 2 10 11 10 3 3 1 1 3 2 3 2 10 2 5 2 14 12 14 2 4 2 14 10];
predet5 = [7 10 7 2 7 2 14 2 3 3 15 3 1 14 6 1 12 1 1 13 1 15 8 5 8 11 8 13 5 13 6 6 13 5 13 5 15 4 13 13 14 13 4 13 4 14 2 8 2 5 10 1 10 1 6 9 6 12 9 14 9 5 2 5 2 4 2 10 11 10 3 3 1 6 5 6 5 6 13 1 3 4 3 7 6 7 6 6 11 12 6 4 9 12 9 9 13 6 13 12 4 12 1 12 1 10 15 10 12 13 12 5 12 11 12 13 12 6 9 8 12 8 10 8 8 13 1 1 3 2 3 2 10 2 5 2 14 12 14 2 4 2 14 10 7 2 7 9 5 9 11 9 9 13 11 14 13 14 13 9 13 9 9 8 9 15 9 15 9 3 14 3 8 1 6 1 11 7 14 14 14 4 14 5 8 5 11 5 4 8 8 3 8 3 4 10 12 10 15 4 13 13 14 13 4 13 4 14 2 8 2 5 10 1 10 1 1 13 1 15 8 5 8 11 8 13 5 13 6 6 13 5 13 5 1 1 3 2 3 2 10 2 5 2 14 12 14 2 4 2 14 10 1 6 5 6 5 6 13 1 3 4 3 7 6 7 6 6 11 12 7 2 7 9 5 9 11 9 9 13 11 14 13 14 13 9 13 9 14 4 14 5 8 5 11 5 4 8 8 3 8 3 4 10 12 10 9 8 9 15 9 15 9 3 14 3 8 1 6 1 11 7 14 14 7 10 7 2 7 2 14 2 3 3 15 3 1 14 6 1 12 1 6 9 6 12 9 14 9 5 2 5 2 4 2 10 11 10 3 3 6 4 9 12 9 9 13 6 13 12 4 12 1 12 1 10 15 10 12 13 12 5 12 11 12 13 12 6 9 8 12 8 10 8 8 13 7 10 7 2 7 2 14 2 3 3 15 3 1 14 6 1 12 1 12 13 12 5 12 11 12 13 12 6 9 8 12 8 10 8 8 13 7 2 7 9 5 9 11 9 9 13 11 14 13 14 13 9 13 9 1 13 1 15 8 5 8 11 8 13 5 13 6 6 13 5 13 5 15 4 13 13 14 13 4 13 4 14 2 8 2 5 10 1 10 1 9 8 9 15 9 15 9 3 14 3 8 1 6 1 11 7 14 14 1 1 3 2 3 2 10 2 5 2 14 12 14 2 4 2 14 10 6 9 6 12 9 14 9 5 2 5 2 4 2 10 11 10 3 3 1 6 5 6 5 6 13 1 3 4 3 7 6 7 6 6 11 12 14 4 14 5 8 5 11 5 4 8 8 3 8 3 4 10 12 10 6 4 9 12 9 9 13 6 13 12 4 12 1 12 1 10 15 10 7 2 7 9 5 9 11 9 9 13 11 14 13 14 13 9 13 9 1 13 1 15 8 5 8 11 8 13 5 13 6 6 13 5 13 5 9 8 9 15 9 15 9 3 14 3 8 1 6 1 11 7 14 14 6 9 6 12 9 14 9 5 2 5 2 4 2 10 11 10 3 3 7 10 7 2 7 2 14 2 3 3 15 3 1 14 6 1 12 1 1 6 5 6 5 6 13 1 3 4 3 7 6 7 6 6 11 12 14 4 14 5 8 5 11 5 4 8 8 3 8 3 4 10 12 10 1 1 3 2 3 2 10 2 5 2 14 12 14 2 4 2 14 10 12 13 12 5 12 11 12 13 12 6 9 8 12 8 10 8 8 13 15 4 13 13 14 13 4 13 4 14 2 8 2 5 10 1 10 1 6 4 9 12 9 9 13 6 13 12 4 12 1 12 1 10 15 10 ];
predet6 = [6 4 9 12 9 9 13 6 13 12 4 12 1 12 1 10 15 10 12 13 12 5 12 11 12 13 12 6 9 8 12 8 10 8 8 13 7 2 7 9 5 9 11 9 9 13 11 14 13 14 13 9 13 9 9 8 9 15 9 15 9 3 14 3 8 1 6 1 11 7 14 14 14 4 14 5 8 5 11 5 4 8 8 3 8 3 4 10 12 10 1 13 1 15 8 5 8 11 8 13 5 13 6 6 13 5 13 5 15 4 13 13 14 13 4 13 4 14 2 8 2 5 10 1 10 1 6 9 6 12 9 14 9 5 2 5 2 4 2 10 11 10 3 3 7 10 7 2 7 2 14 2 3 3 15 3 1 14 6 1 12 1 1 1 3 2 3 2 10 2 5 2 14 12 14 2 4 2 14 10 1 6 5 6 5 6 13 1 3 4 3 7 6 7 6 6 11 12 1 13 1 15 8 5 8 11 8 13 5 13 6 6 13 5 13 5 1 6 5 6 5 6 13 1 3 4 3 7 6 7 6 6 11 12 7 2 7 9 5 9 11 9 9 13 11 14 13 14 13 9 13 9 12 13 12 5 12 11 12 13 12 6 9 8 12 8 10 8 8 13 9 8 9 15 9 15 9 3 14 3 8 1 6 1 11 7 14 14 6 9 6 12 9 14 9 5 2 5 2 4 2 10 11 10 3 3 1 1 3 2 3 2 10 2 5 2 14 12 14 2 4 2 14 10 6 4 9 12 9 9 13 6 13 12 4 12 1 12 1 10 15 10 15 4 13 13 14 13 4 13 4 14 2 8 2 5 10 1 10 1 14 4 14 5 8 5 11 5 4 8 8 3 8 3 4 10 12 10 7 10 7 2 7 2 14 2 3 3 15 3 1 14 6 1 12 1 1 13 1 15 8 5 8 11 8 13 5 13 6 6 13 5 13 5 15 4 13 13 14 13 4 13 4 14 2 8 2 5 10 1 10 1 9 8 9 15 9 15 9 3 14 3 8 1 6 1 11 7 14 14 14 4 14 5 8 5 11 5 4 8 8 3 8 3 4 10 12 10 6 9 6 12 9 14 9 5 2 5 2 4 2 10 11 10 3 3 12 13 12 5 12 11 12 13 12 6 9 8 12 8 10 8 8 13 1 1 3 2 3 2 10 2 5 2 14 12 14 2 4 2 14 10 7 10 7 2 7 2 14 2 3 3 15 3 1 14 6 1 12 1 6 4 9 12 9 9 13 6 13 12 4 12 1 12 1 10 15 10 7 2 7 9 5 9 11 9 9 13 11 14 13 14 13 9 13 9 1 6 5 6 5 6 13 1 3 4 3 7 6 7 6 6 11 12 7 2 7 9 5 9 11 9 9 13 11 14 13 14 13 9 13 9 9 8 9 15 9 15 9 3 14 3 8 1 6 1 11 7 14 14 1 13 1 15 8 5 8 11 8 13 5 13 6 6 13 5 13 5 6 9 6 12 9 14 9 5 2 5 2 4 2 10 11 10 3 3 14 4 14 5 8 5 11 5 4 8 8 3 8 3 4 10 12 10 7 10 7 2 7 2 14 2 3 3 15 3 1 14 6 1 12 1 12 13 12 5 12 11 12 13 12 6 9 8 12 8 10 8 8 13 1 1 3 2 3 2 10 2 5 2 14 12 14 2 4 2 14 10 1 6 5 6 5 6 13 1 3 4 3 7 6 7 6 6 11 12 15 4 13 13 14 13 4 13 4 14 2 8 2 5 10 1 10 1 6 4 9 12 9 9 13 6 13 12 4 12 1 12 1 10 15 10 ];

if nback{1,7} == 1 %checks to see which nback order was used
    predet = predet1;
elseif nback{1,7} == 2
    predet = predet2;
elseif nback{1,7} == 3
    predet = predet3;
elseif nback{1,7} == 4
    predet = predet4;
elseif nback{1,7} == 5
    predet = predet5;
elseif nback{1,7} == 6
    predet = predet6;
end
%if var3 = 1 then key was pressed, if var3 = 3 then TIMEOUT


response = [];
for j = 1:height(nback) % looks through nback responses and checks if correct
    %answer key
    if j >= 3
        twoback = nback{j-2,6};
        twobackcheck = predet(j-2);
    else
        twoback = 0;
        twobackcheck = 0;
    end
    nback{j,6};
    twobackcheck;
    %HIT, MISS, CORRECT REJECTION, FALSE ALARM
    if nback{j,6} == twobackcheck && nback{j,3} == 1
        %hit
        response = [response; 1];
    elseif nback{j,6} == twobackcheck && nback{j,3} == 3
        %miss
        response = [response; 2];
    elseif nback{j,6} ~= twobackcheck && nback{j,3} == 1
        %falsealarm
        response = [response; 3];
    elseif nback{j,6} ~= twobackcheck && nback{j,3} == 3
        %correct rejection
        response = [response; 4];
    else
        response = [response; 5]; %AT LEAST PARTICIPANT 5AD57 needs this to keep sizes equal unclear why
    end
end
response;
%responsetable = table(response);
nback_u = addvars(nback,response);

%nbackplot
mod1 = [];
mod2 = [];
unmod1 = [];
unmod2 = [];
if group == 1
    for i = 1:height(nback_u)
        if nback_u{i,2} == 3 ||nback_u{i,2} == 4||nback_u{i,2} == 5||nback_u{i,2} == 9||nback_u{i,2} == 10||nback_u{i,2} == 11
            %if modded block
            mod1 = [mod1;nback_u(i,9)];
        end
        if nback_u{i,2} == 6 || nback_u{i,2} == 7 || nback_u{i,2} == 8 || nback_u{i,2} == 12 || nback_u{i,2} == 13 || nback_u{i,2} == 14
            %if unmodded block
            unmod1 = [unmod1;nback_u(i,9)];
        end
    end
    %PERCENT CORRECT CALC mod group 1
    correct = 0;
    for k = 1:height(mod1)
        if mod1{k,1} == 1 || mod1{k,1} == 4
            correct = correct + 1;
        end
    end
    disp('CORRECT PERCENTAGE MOD NBACK = ') 
    disp(correct/height(mod1))
    nb1 = correct/height(mod1);
    %PERCENT CORRECT CALC unmod group 1
    correct = 0;
    for k = 1:height(unmod1)
        if unmod1{k,1} == 1 || unmod1{k,1} == 4
            correct = correct + 1;
        end
    end
    
    disp('CORRECT PERCENTAGE UNMOD NBACK = ')
    disp(correct/height(unmod1))
    nb2 = correct/height(unmod1);
end

if group == 2
    for i = 1:height(nback_u)
        if nback_u{i,2} == 3 ||nback_u{i,2} == 4||nback_u{i,2} == 5||nback_u{i,2} == 9||nback_u{i,2} == 10||nback_u{i,2} == 11
            unmod2 = [unmod2;nback_u(i,9)];
        end
        if nback_u{i,2} == 6 || nback_u{i,2} == 7 || nback_u{i,2} == 8 || nback_u{i,2} == 12 || nback_u{i,2} == 13 || nback_u{i,2} == 14
            mod2 = [mod2;nback_u(i,9)];
        end
    end
    %PERCENT CORRECT CALC mod group 2
    correct = 0;
    for k = 1:height(mod2)
        if mod2{k,1} == 1 || mod2{k,1} == 4 % either correct rejection or hit
            correct = correct + 1; %sums the total correct responses
        end
    end
    disp('CORRECT PERCENTAGE MOD NBACK = ')
    disp(correct/height(mod2))
    nb1 = correct/height(mod2);
    %PERCENT CORRECT CALC unmod group 2
    correct = 0;
    for k = 1:height(unmod2)
        if unmod2{k,1} == 1 || unmod2{k,1} == 4 % either correct rejection or hit
            correct = correct + 1; %sums the total correct responses
        end
    end
    disp('CORRECT PERCENTAGE UNMOD NBACK = ')
    disp(correct/height(unmod2))
    nb2 = correct/height(unmod2);
end

%%
% SART NO MUSIC
% same code as above but doesnt need to check for modded or unmodded for
% the no music condition

%take sart file and extract reaction time column
%plot average reaction time for unmodded compared to modded SART

sart = readtable( append(pathexp,'/',string(out2{4})) ); %loads nomusic sart data

%column 12 is reaction time, column 11 is song
table1mod = [];
table1unmod = [];
table2mod = [];
table2unmod = [];
    for i = 1:height(sart)
        if ~strcmp(char(sart{i,1}),'training') && (sart{i,2} == 3 ||sart{i,2} == 4||sart{i,2} == 5||sart{i,2} == 9||sart{i,2} == 10||sart{i,2} == 11 || sart{i,2} == 6 || sart{i,2} == 7 || sart{i,2} == 8 || sart{i,2} == 12 || sart{i,2} == 13 || sart{i,2} == 14)
            if sart{i,4} ~= 3 && sart{i,7} == 3
                table1mod = [table1mod;sart(i,10)];
            end
        end
    end

    for k = 1:height(sart)
        if sart{k,6} == 0
            %plot mistake, plot an x? or plot a vertical line at each
            % use later for time sensitive analysis
        end
    end

    table1mod = table2array(table1mod);
    %table1unmod = table2array(table1unmod);
    figure(3)
    plot(table1mod)
    title('NO MUSIC REACTION TIME')
    ylabel('Reaction Time (ms)')
    total = 0;
    for l = 1:length(table1mod)
        total = total + table1mod(l);
    end
    avg_nomusic_reaction = total / length(table1mod)
    std_nomusic_nm = std(table1mod)



%%
% NBACK NO MUSIC

nback = readtable( append(pathexp,'/',string(out2{2})) );

predet1 = [9 8 9 15 9 15 9 3 14 3 8 1 6 1 11 7 14 14 1 13 1 15 8 5 8 11 8 13 5 13 6 6 13 5 13 5 1 6 5 6 5 6 13 1 3 4 3 7 6 7 6 6 11 12 14 4 14 5 8 5 11 5 4 8 8 3 8 3 4 10 12 10 7 10 7 2 7 2 14 2 3 3 15 3 1 14 6 1 12 1 6 4 9 12 9 9 13 6 13 12 4 12 1 12 1 10 15 10 7 2 7 9 5 9 11 9 9 13 11 14 13 14 13 9 13 9 15 4 13 13 14 13 4 13 4 14 2 8 2 5 10 1 10 1 1 1 3 2 3 2 10 2 5 2 14 12 14 2 4 2 14 10 12 13 12 5 12 11 12 13 12 6 9 8 12 8 10 8 8 13 6 9 6 12 9 14 9 5 2 5 2 4 2 10 11 10 3 3 1 6 5 6 5 6 13 1 3 4 3 7 6 7 6 6 11 12 6 4 9 12 9 9 13 6 13 12 4 12 1 12 1 10 15 10 1 13 1 15 8 5 8 11 8 13 5 13 6 6 13 5 13 5 1 1 3 2 3 2 10 2 5 2 14 12 14 2 4 2 14 10 6 9 6 12 9 14 9 5 2 5 2 4 2 10 11 10 3 3 15 4 13 13 14 13 4 13 4 14 2 8 2 5 10 1 10 1 7 10 7 2 7 2 14 2 3 3 15 3 1 14 6 1 12 1 12 13 12 5 12 11 12 13 12 6 9 8 12 8 10 8 8 13 9 8 9 15 9 15 9 3 14 3 8 1 6 1 11 7 14 14 7 2 7 9 5 9 11 9 9 13 11 14 13 14 13 9 13 9 14 4 14 5 8 5 11 5 4 8 8 3 8 3 4 10 12 10 6 4 9 12 9 9 13 6 13 12 4 12 1 12 1 10 15 10 9 8 9 15 9 15 9 3 14 3 8 1 6 1 11 7 14 14 1 13 1 15 8 5 8 11 8 13 5 13 6 6 13 5 13 5 7 10 7 2 7 2 14 2 3 3 15 3 1 14 6 1 12 1 15 4 13 13 14 13 4 13 4 14 2 8 2 5 10 1 10 1 14 4 14 5 8 5 11 5 4 8 8 3 8 3 4 10 12 10 1 1 3 2 3 2 10 2 5 2 14 12 14 2 4 2 14 10 6 9 6 12 9 14 9 5 2 5 2 4 2 10 11 10 3 3 12 13 12 5 12 11 12 13 12 6 9 8 12 8 10 8 8 13 1 6 5 6 5 6 13 1 3 4 3 7 6 7 6 6 11 12 7 2 7 9 5 9 11 9 9 13 11 14 13 14 13 9 13 9 7 10 7 2 7 2 14 2 3 3 15 3 1 14 6 1 12 1 14 4 14 5 8 5 11 5 4 8 8 3 8 3 4 10 12 10 12 13 12 5 12 11 12 13 12 6 9 8 12 8 10 8 8 13 9 8 9 15 9 15 9 3 14 3 8 1 6 1 11 7 14 14 6 9 6 12 9 14 9 5 2 5 2 4 2 10 11 10 3 3 15 4 13 13 14 13 4 13 4 14 2 8 2 5 10 1 10 1 6 4 9 12 9 9 13 6 13 12 4 12 1 12 1 10 15 10 1 13 1 15 8 5 8 11 8 13 5 13 6 6 13 5 13 5 7 2 7 9 5 9 11 9 9 13 11 14 13 14 13 9 13 9 1 1 3 2 3 2 10 2 5 2 14 12 14 2 4 2 14 10 1 6 5 6 5 6 13 1 3 4 3 7 6 7 6 6 11 12 ];
predet2 = [7 2 7 9 5 9 11 9 9 13 11 14 13 14 13 9 13 9 6 9 6 12 9 14 9 5 2 5 2 4 2 10 11 10 3 3 1 1 3 2 3 2 10 2 5 2 14 12 14 2 4 2 14 10 14 4 14 5 8 5 11 5 4 8 8 3 8 3 4 10 12 10 1 6 5 6 5 6 13 1 3 4 3 7 6 7 6 6 11 12 6 4 9 12 9 9 13 6 13 12 4 12 1 12 1 10 15 10 15 4 13 13 14 13 4 13 4 14 2 8 2 5 10 1 10 1 9 8 9 15 9 15 9 3 14 3 8 1 6 1 11 7 14 14 12 13 12 5 12 11 12 13 12 6 9 8 12 8 10 8 8 13 1 13 1 15 8 5 8 11 8 13 5 13 6 6 13 5 13 5 7 10 7 2 7 2 14 2 3 3 15 3 1 14 6 1 12 1 6 4 9 12 9 9 13 6 13 12 4 12 1 12 1 10 15 10 14 4 14 5 8 5 11 5 4 8 8 3 8 3 4 10 12 10 1 13 1 15 8 5 8 11 8 13 5 13 6 6 13 5 13 5 7 10 7 2 7 2 14 2 3 3 15 3 1 14 6 1 12 1 12 13 12 5 12 11 12 13 12 6 9 8 12 8 10 8 8 13 15 4 13 13 14 13 4 13 4 14 2 8 2 5 10 1 10 1 9 8 9 15 9 15 9 3 14 3 8 1 6 1 11 7 14 14 6 9 6 12 9 14 9 5 2 5 2 4 2 10 11 10 3 3 1 6 5 6 5 6 13 1 3 4 3 7 6 7 6 6 11 12 1 1 3 2 3 2 10 2 5 2 14 12 14 2 4 2 14 10 7 2 7 9 5 9 11 9 9 13 11 14 13 14 13 9 13 9 7 10 7 2 7 2 14 2 3 3 15 3 1 14 6 1 12 1 6 4 9 12 9 9 13 6 13 12 4 12 1 12 1 10 15 10 1 6 5 6 5 6 13 1 3 4 3 7 6 7 6 6 11 12 15 4 13 13 14 13 4 13 4 14 2 8 2 5 10 1 10 1 9 8 9 15 9 15 9 3 14 3 8 1 6 1 11 7 14 14 7 2 7 9 5 9 11 9 9 13 11 14 13 14 13 9 13 9 1 1 3 2 3 2 10 2 5 2 14 12 14 2 4 2 14 10 14 4 14 5 8 5 11 5 4 8 8 3 8 3 4 10 12 10 12 13 12 5 12 11 12 13 12 6 9 8 12 8 10 8 8 13 1 13 1 15 8 5 8 11 8 13 5 13 6 6 13 5 13 5 6 9 6 12 9 14 9 5 2 5 2 4 2 10 11 10 3 3 7 10 7 2 7 2 14 2 3 3 15 3 1 14 6 1 12 1 14 4 14 5 8 5 11 5 4 8 8 3 8 3 4 10 12 10 1 6 5 6 5 6 13 1 3 4 3 7 6 7 6 6 11 12 7 2 7 9 5 9 11 9 9 13 11 14 13 14 13 9 13 9 1 13 1 15 8 5 8 11 8 13 5 13 6 6 13 5 13 5 1 1 3 2 3 2 10 2 5 2 14 12 14 2 4 2 14 10 6 4 9 12 9 9 13 6 13 12 4 12 1 12 1 10 15 10 9 8 9 15 9 15 9 3 14 3 8 1 6 1 11 7 14 14 12 13 12 5 12 11 12 13 12 6 9 8 12 8 10 8 8 13 6 9 6 12 9 14 9 5 2 5 2 4 2 10 11 10 3 3 15 4 13 13 14 13 4 13 4 14 2 8 2 5 10 1 10 1 ];
predet3 = [1 13 1 15 8 5 8 11 8 13 5 13 6 6 13 5 13 5 1 1 3 2 3 2 10 2 5 2 14 12 14 2 4 2 14 10 15 4 13 13 14 13 4 13 4 14 2 8 2 5 10 1 10 1 6 9 6 12 9 14 9 5 2 5 2 4 2 10 11 10 3 3 7 10 7 2 7 2 14 2 3 3 15 3 1 14 6 1 12 1 12 13 12 5 12 11 12 13 12 6 9 8 12 8 10 8 8 13 9 8 9 15 9 15 9 3 14 3 8 1 6 1 11 7 14 14 1 6 5 6 5 6 13 1 3 4 3 7 6 7 6 6 11 12 6 4 9 12 9 9 13 6 13 12 4 12 1 12 1 10 15 10 14 4 14 5 8 5 11 5 4 8 8 3 8 3 4 10 12 10 7 2 7 9 5 9 11 9 9 13 11 14 13 14 13 9 13 9 15 4 13 13 14 13 4 13 4 14 2 8 2 5 10 1 10 1 6 4 9 12 9 9 13 6 13 12 4 12 1 12 1 10 15 10 7 10 7 2 7 2 14 2 3 3 15 3 1 14 6 1 12 1 7 2 7 9 5 9 11 9 9 13 11 14 13 14 13 9 13 9 6 9 6 12 9 14 9 5 2 5 2 4 2 10 11 10 3 3 9 8 9 15 9 15 9 3 14 3 8 1 6 1 11 7 14 14 1 1 3 2 3 2 10 2 5 2 14 12 14 2 4 2 14 10 1 13 1 15 8 5 8 11 8 13 5 13 6 6 13 5 13 5 14 4 14 5 8 5 11 5 4 8 8 3 8 3 4 10 12 10 1 6 5 6 5 6 13 1 3 4 3 7 6 7 6 6 11 12 12 13 12 5 12 11 12 13 12 6 9 8 12 8 10 8 8 13 1 6 5 6 5 6 13 1 3 4 3 7 6 7 6 6 11 12 14 4 14 5 8 5 11 5 4 8 8 3 8 3 4 10 12 10 7 2 7 9 5 9 11 9 9 13 11 14 13 14 13 9 13 9 1 1 3 2 3 2 10 2 5 2 14 12 14 2 4 2 14 10 7 10 7 2 7 2 14 2 3 3 15 3 1 14 6 1 12 1 6 4 9 12 9 9 13 6 13 12 4 12 1 12 1 10 15 10 1 13 1 15 8 5 8 11 8 13 5 13 6 6 13 5 13 5 9 8 9 15 9 15 9 3 14 3 8 1 6 1 11 7 14 14 12 13 12 5 12 11 12 13 12 6 9 8 12 8 10 8 8 13 6 9 6 12 9 14 9 5 2 5 2 4 2 10 11 10 3 3 15 4 13 13 14 13 4 13 4 14 2 8 2 5 10 1 10 1 14 4 14 5 8 5 11 5 4 8 8 3 8 3 4 10 12 10 12 13 12 5 12 11 12 13 12 6 9 8 12 8 10 8 8 13 1 13 1 15 8 5 8 11 8 13 5 13 6 6 13 5 13 5 6 4 9 12 9 9 13 6 13 12 4 12 1 12 1 10 15 10 7 10 7 2 7 2 14 2 3 3 15 3 1 14 6 1 12 1 1 6 5 6 5 6 13 1 3 4 3 7 6 7 6 6 11 12 1 1 3 2 3 2 10 2 5 2 14 12 14 2 4 2 14 10 7 2 7 9 5 9 11 9 9 13 11 14 13 14 13 9 13 9 6 9 6 12 9 14 9 5 2 5 2 4 2 10 11 10 3 3 15 4 13 13 14 13 4 13 4 14 2 8 2 5 10 1 10 1 9 8 9 15 9 15 9 3 14 3 8 1 6 1 11 7 14 14 ];
predet4 = [7 2 7 9 5 9 11 9 9 13 11 14 13 14 13 9 13 9 9 8 9 15 9 15 9 3 14 3 8 1 6 1 11 7 14 14 14 4 14 5 8 5 11 5 4 8 8 3 8 3 4 10 12 10 6 4 9 12 9 9 13 6 13 12 4 12 1 12 1 10 15 10 7 10 7 2 7 2 14 2 3 3 15 3 1 14 6 1 12 1 1 1 3 2 3 2 10 2 5 2 14 12 14 2 4 2 14 10 15 4 13 13 14 13 4 13 4 14 2 8 2 5 10 1 10 1 1 13 1 15 8 5 8 11 8 13 5 13 6 6 13 5 13 5 6 9 6 12 9 14 9 5 2 5 2 4 2 10 11 10 3 3 1 6 5 6 5 6 13 1 3 4 3 7 6 7 6 6 11 12 12 13 12 5 12 11 12 13 12 6 9 8 12 8 10 8 8 13 6 9 6 12 9 14 9 5 2 5 2 4 2 10 11 10 3 3 7 10 7 2 7 2 14 2 3 3 15 3 1 14 6 1 12 1 1 1 3 2 3 2 10 2 5 2 14 12 14 2 4 2 14 10 14 4 14 5 8 5 11 5 4 8 8 3 8 3 4 10 12 10 12 13 12 5 12 11 12 13 12 6 9 8 12 8 10 8 8 13 9 8 9 15 9 15 9 3 14 3 8 1 6 1 11 7 14 14 7 2 7 9 5 9 11 9 9 13 11 14 13 14 13 9 13 9 6 4 9 12 9 9 13 6 13 12 4 12 1 12 1 10 15 10 1 6 5 6 5 6 13 1 3 4 3 7 6 7 6 6 11 12 15 4 13 13 14 13 4 13 4 14 2 8 2 5 10 1 10 1 1 13 1 15 8 5 8 11 8 13 5 13 6 6 13 5 13 5 7 2 7 9 5 9 11 9 9 13 11 14 13 14 13 9 13 9 6 4 9 12 9 9 13 6 13 12 4 12 1 12 1 10 15 10 9 8 9 15 9 15 9 3 14 3 8 1 6 1 11 7 14 14 7 10 7 2 7 2 14 2 3 3 15 3 1 14 6 1 12 1 12 13 12 5 12 11 12 13 12 6 9 8 12 8 10 8 8 13 1 1 3 2 3 2 10 2 5 2 14 12 14 2 4 2 14 10 14 4 14 5 8 5 11 5 4 8 8 3 8 3 4 10 12 10 1 6 5 6 5 6 13 1 3 4 3 7 6 7 6 6 11 12 15 4 13 13 14 13 4 13 4 14 2 8 2 5 10 1 10 1 1 13 1 15 8 5 8 11 8 13 5 13 6 6 13 5 13 5 6 9 6 12 9 14 9 5 2 5 2 4 2 10 11 10 3 3 6 4 9 12 9 9 13 6 13 12 4 12 1 12 1 10 15 10 7 2 7 9 5 9 11 9 9 13 11 14 13 14 13 9 13 9 9 8 9 15 9 15 9 3 14 3 8 1 6 1 11 7 14 14 15 4 13 13 14 13 4 13 4 14 2 8 2 5 10 1 10 1 1 13 1 15 8 5 8 11 8 13 5 13 6 6 13 5 13 5 7 10 7 2 7 2 14 2 3 3 15 3 1 14 6 1 12 1 12 13 12 5 12 11 12 13 12 6 9 8 12 8 10 8 8 13 1 6 5 6 5 6 13 1 3 4 3 7 6 7 6 6 11 12 14 4 14 5 8 5 11 5 4 8 8 3 8 3 4 10 12 10 6 9 6 12 9 14 9 5 2 5 2 4 2 10 11 10 3 3 1 1 3 2 3 2 10 2 5 2 14 12 14 2 4 2 14 10];
predet5 = [7 10 7 2 7 2 14 2 3 3 15 3 1 14 6 1 12 1 1 13 1 15 8 5 8 11 8 13 5 13 6 6 13 5 13 5 15 4 13 13 14 13 4 13 4 14 2 8 2 5 10 1 10 1 6 9 6 12 9 14 9 5 2 5 2 4 2 10 11 10 3 3 1 6 5 6 5 6 13 1 3 4 3 7 6 7 6 6 11 12 6 4 9 12 9 9 13 6 13 12 4 12 1 12 1 10 15 10 12 13 12 5 12 11 12 13 12 6 9 8 12 8 10 8 8 13 1 1 3 2 3 2 10 2 5 2 14 12 14 2 4 2 14 10 7 2 7 9 5 9 11 9 9 13 11 14 13 14 13 9 13 9 9 8 9 15 9 15 9 3 14 3 8 1 6 1 11 7 14 14 14 4 14 5 8 5 11 5 4 8 8 3 8 3 4 10 12 10 15 4 13 13 14 13 4 13 4 14 2 8 2 5 10 1 10 1 1 13 1 15 8 5 8 11 8 13 5 13 6 6 13 5 13 5 1 1 3 2 3 2 10 2 5 2 14 12 14 2 4 2 14 10 1 6 5 6 5 6 13 1 3 4 3 7 6 7 6 6 11 12 7 2 7 9 5 9 11 9 9 13 11 14 13 14 13 9 13 9 14 4 14 5 8 5 11 5 4 8 8 3 8 3 4 10 12 10 9 8 9 15 9 15 9 3 14 3 8 1 6 1 11 7 14 14 7 10 7 2 7 2 14 2 3 3 15 3 1 14 6 1 12 1 6 9 6 12 9 14 9 5 2 5 2 4 2 10 11 10 3 3 6 4 9 12 9 9 13 6 13 12 4 12 1 12 1 10 15 10 12 13 12 5 12 11 12 13 12 6 9 8 12 8 10 8 8 13 7 10 7 2 7 2 14 2 3 3 15 3 1 14 6 1 12 1 12 13 12 5 12 11 12 13 12 6 9 8 12 8 10 8 8 13 7 2 7 9 5 9 11 9 9 13 11 14 13 14 13 9 13 9 1 13 1 15 8 5 8 11 8 13 5 13 6 6 13 5 13 5 15 4 13 13 14 13 4 13 4 14 2 8 2 5 10 1 10 1 9 8 9 15 9 15 9 3 14 3 8 1 6 1 11 7 14 14 1 1 3 2 3 2 10 2 5 2 14 12 14 2 4 2 14 10 6 9 6 12 9 14 9 5 2 5 2 4 2 10 11 10 3 3 1 6 5 6 5 6 13 1 3 4 3 7 6 7 6 6 11 12 14 4 14 5 8 5 11 5 4 8 8 3 8 3 4 10 12 10 6 4 9 12 9 9 13 6 13 12 4 12 1 12 1 10 15 10 7 2 7 9 5 9 11 9 9 13 11 14 13 14 13 9 13 9 1 13 1 15 8 5 8 11 8 13 5 13 6 6 13 5 13 5 9 8 9 15 9 15 9 3 14 3 8 1 6 1 11 7 14 14 6 9 6 12 9 14 9 5 2 5 2 4 2 10 11 10 3 3 7 10 7 2 7 2 14 2 3 3 15 3 1 14 6 1 12 1 1 6 5 6 5 6 13 1 3 4 3 7 6 7 6 6 11 12 14 4 14 5 8 5 11 5 4 8 8 3 8 3 4 10 12 10 1 1 3 2 3 2 10 2 5 2 14 12 14 2 4 2 14 10 12 13 12 5 12 11 12 13 12 6 9 8 12 8 10 8 8 13 15 4 13 13 14 13 4 13 4 14 2 8 2 5 10 1 10 1 6 4 9 12 9 9 13 6 13 12 4 12 1 12 1 10 15 10 ];
predet6 = [6 4 9 12 9 9 13 6 13 12 4 12 1 12 1 10 15 10 12 13 12 5 12 11 12 13 12 6 9 8 12 8 10 8 8 13 7 2 7 9 5 9 11 9 9 13 11 14 13 14 13 9 13 9 9 8 9 15 9 15 9 3 14 3 8 1 6 1 11 7 14 14 14 4 14 5 8 5 11 5 4 8 8 3 8 3 4 10 12 10 1 13 1 15 8 5 8 11 8 13 5 13 6 6 13 5 13 5 15 4 13 13 14 13 4 13 4 14 2 8 2 5 10 1 10 1 6 9 6 12 9 14 9 5 2 5 2 4 2 10 11 10 3 3 7 10 7 2 7 2 14 2 3 3 15 3 1 14 6 1 12 1 1 1 3 2 3 2 10 2 5 2 14 12 14 2 4 2 14 10 1 6 5 6 5 6 13 1 3 4 3 7 6 7 6 6 11 12 1 13 1 15 8 5 8 11 8 13 5 13 6 6 13 5 13 5 1 6 5 6 5 6 13 1 3 4 3 7 6 7 6 6 11 12 7 2 7 9 5 9 11 9 9 13 11 14 13 14 13 9 13 9 12 13 12 5 12 11 12 13 12 6 9 8 12 8 10 8 8 13 9 8 9 15 9 15 9 3 14 3 8 1 6 1 11 7 14 14 6 9 6 12 9 14 9 5 2 5 2 4 2 10 11 10 3 3 1 1 3 2 3 2 10 2 5 2 14 12 14 2 4 2 14 10 6 4 9 12 9 9 13 6 13 12 4 12 1 12 1 10 15 10 15 4 13 13 14 13 4 13 4 14 2 8 2 5 10 1 10 1 14 4 14 5 8 5 11 5 4 8 8 3 8 3 4 10 12 10 7 10 7 2 7 2 14 2 3 3 15 3 1 14 6 1 12 1 1 13 1 15 8 5 8 11 8 13 5 13 6 6 13 5 13 5 15 4 13 13 14 13 4 13 4 14 2 8 2 5 10 1 10 1 9 8 9 15 9 15 9 3 14 3 8 1 6 1 11 7 14 14 14 4 14 5 8 5 11 5 4 8 8 3 8 3 4 10 12 10 6 9 6 12 9 14 9 5 2 5 2 4 2 10 11 10 3 3 12 13 12 5 12 11 12 13 12 6 9 8 12 8 10 8 8 13 1 1 3 2 3 2 10 2 5 2 14 12 14 2 4 2 14 10 7 10 7 2 7 2 14 2 3 3 15 3 1 14 6 1 12 1 6 4 9 12 9 9 13 6 13 12 4 12 1 12 1 10 15 10 7 2 7 9 5 9 11 9 9 13 11 14 13 14 13 9 13 9 1 6 5 6 5 6 13 1 3 4 3 7 6 7 6 6 11 12 7 2 7 9 5 9 11 9 9 13 11 14 13 14 13 9 13 9 9 8 9 15 9 15 9 3 14 3 8 1 6 1 11 7 14 14 1 13 1 15 8 5 8 11 8 13 5 13 6 6 13 5 13 5 6 9 6 12 9 14 9 5 2 5 2 4 2 10 11 10 3 3 14 4 14 5 8 5 11 5 4 8 8 3 8 3 4 10 12 10 7 10 7 2 7 2 14 2 3 3 15 3 1 14 6 1 12 1 12 13 12 5 12 11 12 13 12 6 9 8 12 8 10 8 8 13 1 1 3 2 3 2 10 2 5 2 14 12 14 2 4 2 14 10 1 6 5 6 5 6 13 1 3 4 3 7 6 7 6 6 11 12 15 4 13 13 14 13 4 13 4 14 2 8 2 5 10 1 10 1 6 4 9 12 9 9 13 6 13 12 4 12 1 12 1 10 15 10 ];
if nback{1,7} == 1
    predet = predet1;
elseif nback{1,7} == 2
    predet = predet2;
elseif nback{1,7} == 3
    predet = predet3;
elseif nback{1,7} == 4
    predet = predet4;
elseif nback{1,7} == 5
    predet = predet5;
elseif nback{1,7} == 6
    predet = predet6;
end
%if var3 = 1 then key was pressed, if var3 = 3 then TIMEOUT

%response = table(var1);
response = [];
for j = 1:height(nback)
    %answer key
    if j >= 3
        twoback = nback{j-2,6};
        twobackcheck = predet(j-2);
    else
        twoback = 0;
        twobackcheck = 0;
    end
    nback{j,6};
    twobackcheck;
    %HIT, MISS, CORRECT REJECTION, FALSE ALARM
    if nback{j,6} == twobackcheck && nback{j,3} == 1
        %hit
        response = [response; 1];
    elseif nback{j,6} == twobackcheck && nback{j,3} == 3
        %miss
        response = [response; 2];
    elseif nback{j,6} ~= twobackcheck && nback{j,3} == 1
        %falsealarm
        response = [response; 3];
    elseif nback{j,6} ~= twobackcheck && nback{j,3} == 3
        %correct rejection
        response = [response; 4];
    else
        response = [response; 5]; %AT LEAST PARTICIPANT 5AD57 needs this to keep sizes equal unclear why
    end
end
response;
%responsetable = table(response);
nback_u = addvars(nback,response);

%nbackplot
mod1 = [];
mod2 = [];
unmod1 = [];
unmod2 = [];

    for i = 1:height(nback_u)
        if nback_u{i,2} == 3 ||nback_u{i,2} == 4||nback_u{i,2} == 5||nback_u{i,2} == 9||nback_u{i,2} == 10||nback_u{i,2} == 11 || nback_u{i,2} == 6 || nback_u{i,2} == 7 || nback_u{i,2} == 8 || nback_u{i,2} == 12 || nback_u{i,2} == 13 || nback_u{i,2} == 14
            mod1 = [mod1;nback_u(i,9)];
        end
    end
    %PERCENT CORRECT CALC mod group 1
    correct = 0;
    for k = 1:height(mod1)
        if mod1{k,1} == 1 || mod1{k,1} == 4
            correct = correct + 1;
        end
    end
    disp('CORRECT PERCENTAGE NO MUSIC NBACK = ') 
    disp(correct/height(mod1))
    nb3 = correct/height(mod1);
    

%save all the final results together to save into the spreadsheet
final_results = [1 avg_mod_reaction std_mod std_mod/avg_mod_reaction avg_unmod_reaction std_unmod std_unmod/avg_unmod_reaction avg_nomusic_reaction std_nomusic_nm std_nomusic_nm/avg_nomusic_reaction 1 1 nb1 nb2 nb3];
openvar('final_results')
