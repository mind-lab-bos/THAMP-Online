clc 
clear all
close all

%to run this on more participants: need to update the liking_fam matrix
%with updated data, and update the subs array as well
% the first two columns of the liking_fam matrix are the group number (mod
% or unmod) and the song order number (1 - 5)

songref = [19	17	13	9	2	4	26	22	27	10	3	25;
18	14	8	24	23	21	1	7	20	30	5	16;
26	22	27	10	3	25	18	14	8	24	23	21;
1	7	20	30	5	16	29	11	31	32	12	28;
18	14	8	24	23	21	1	7	20	30	5	16;
29	11	31	32	12	28	19	17	13	9	2	4;
1	7	20	30	5	16	29	11	31	32	12	28;
19	17	13	9	2	4	26	22	27	10	3	25;
29	11	31	32	12	28	19	17	13	9	2	4;
26	22	27	10	3	25	18	14	8	24	23	21];

liking_fam = [2	3	3	3	4	4	4	4	4	4	4	2	4	4	4	3	4	4	4	0	4	2	4	2	4	4	3	1	4	4	2	1	3	0	4	2	3	1	4	0	3	0	4	4	4	2	4	0	4	3	2	2	1	1	4	1	3	4	4	4	4	2	4	3	4	3;
2	5	3	3	1	2	4	4	4	4	4	4	4	3	3	3	4	2	4	4	4	2	1	1	2	2	2	2	4	2	2	0	3	0	0	3	2	3	2	3	4	4	4	4	0	2	4	4	3	1	3	1	1	1	4	4	3	1	4	3	3	1	4	2	2	2;
1	4	2	4	3	4	4	4	3	3	4	4	2	3	1	3	4	2	1	2	4	3	0	2	0	3	0	2	1	2	1	2	1	1	1	2	4	3	0	1	0	2	0	1	4	4	0	2	0	2	0	2	0	2	4	4	2	3	3	3	1	3	0	3	0	2;
2	5	4	4	4	4	4	4	4	3	4	3	4	2	4	3	4	3	4	2	4	2	2	2	4	2	2	2	4	2	4	2	2	3	4	3	3	3	4	4	4	4	2	2	4	2	4	4	4	2	2	2	4	4	4	3	4	2	4	2	4	3	4	3	4	3;
2	4	0	4	4	4	1	0	4	4	4	2	0	2	4	2	4	3	0	0	4	4	0	0	4	4	0	2	0	1	0	1	4	3	4	4	0	0	4	3	4	4	0	2	4	2	4	4	4	3	0	0	0	0	1	2	1	1	1	1	4	4	3	2	4	4;
1	2	0	0	0	0	4	4	4	4	2	1	3	1	4	3	4	1	4	4	4	3	3	1	4	4	4	1	1	1	2	1	3	1	4	1	3	0	4	1	4	3	3	3	2	0	4	2	2	1	1	0	4	1	2	0	4	3	4	1	3	1	4	3	4	2;
1	1	1	1	4	4	4	4	4	0	4	0	0	0	3	0	4	0	1	0	2	1	3	0	3	1	0	0	4	1	4	0	2	4	4	3	4	0	2	0	4	0	4	4	4	0	2	0	3	2	0	0	2	0	4	0	4	0	4	1	1	1	4	2	4	1;
1	3	3	3	3	3	4	4	0	0	4	4	4	4	2	2	0	0	0	0	4	4	3	1	2	2	1	1	2	2	2	2	0	0	3	3	1	1	3	3	2	2	3	3	3	3	4	4	1	1	1	1	1	1	4	4	0	3	3	4	4	4	3	4	3	4;
2	4	4	4	4	4	4	4	4	4	4	4	4	4	0	0	0	0	3	1	4	4	4	3	4	4	3	4	4	3	4	2	0	2	4	0	0	0	2	2	3	1	0	1	4	3	4	3	4	1	1	2	4	2	2	4	4	4	4	4	4	3	4	3	4	3;
2	3	4	4	4	4	4	3	4	4	4	4	4	4	4	2	4	2	4	3	4	0	0	0	4	4	0	0	4	3	4	2	3	1	4	4	4	4	4	2	4	2	0	1	4	1	4	0	3	1	0	1	4	4	4	2	4	4	4	4	4	2	4	1	4	0;
2	3	4	3	4	4	4	4	4	3	4	4	4	0	4	4	4	4	4	0	4	4	2	4	0	3	1	4	4	4	4	3	3	4	2	3	4	2	4	1	1	2	4	4	4	0	4	1	0	3	3	1	4	1	4	4	4	3	4	1	4	2	0	2	4	3;
1	2	4	4	4	4	4	4	4	4	4	4	4	3	3	3	4	4	4	4	4	4	4	4	2	2	3	3	4	4	4	4	2	2	4	4	3	3	4	4	3	3	3	3	4	4	4	4	3	3	3	3	4	3	4	4	4	3	3	3	4	3	4	4	4	4;
2	4	1	1	2	1	3	2	3	2	4	3	1	1	3	2	4	2	2	1	2	1	0	1	0	1	1	1	1	1	0	1	1	1	1	1	3	1	0	1	0	1	0	1	3	2	2	1	0	1	0	1	0	1	2	2	3	2	3	2	2	2	0	1	1	2;
2	1	4	2	4	3	4	4	4	1	4	4	2	1	1	1	4	1	1	1	4	1	1	1	0	2	1	1	4	2	4	2	1	2	1	2	4	2	4	2	4	2	1	1	4	1	3	1	1	1	2	3	4	3	4	4	4	4	3	1	4	2	4	2	4	2;
1	2	3	0	4	0	4	3	4	1	4	4	4	1	1	0	4	0	2	1	4	0	2	0	2	1	0	0	3	1	1	0	0	0	2	0	4	0	0	0	0	0	0	0	4	0	1	0	0	1	0	0	1	0	4	3	4	1	4	1	0	2	4	0	1	0;
1	3	2	3	4	4	4	4	3	2	4	3	2	2	3	2	4	4	2	3	3	3	4	4	2	2	4	4	4	4	3	3	1	2	1	2	4	3	4	4	2	3	4	4	4	3	1	1	1	3	1	3	4	4	4	4	4	4	4	3	2	2	2	3	3	3;
2	4	2	2	2	2	4	4	4	3	4	4	2	2	4	4	4	4	4	4	4	2	0	0	4	3	0	0	4	3	0	1	0	0	4	4	0	1	4	4	2	2	2	2	4	4	4	4	4	4	0	3	0	2	4	4	4	4	4	4	4	4	4	4	4	4;
2	3	4	4	4	4	4	4	4	3	4	4	4	4	4	1	4	4	4	4	4	4	4	4	4	4	3	2	4	4	4	4	4	4	4	1	4	4	4	4	3	3	3	3	4	4	4	4	3	3	1	1	4	4	4	4	4	4	4	4	4	1	4	4	4	4];

subs = {'?', '5c43bf421b4ea30001cc6898', '63bb98852cdc67dece8adb8e', '5e1f7b2a4c9b832b34e7c9d3', '5ee1be444c9d75206ce5aa92', '5ed543442db0060a955d12e1', '5e5fe64a8278d103d35cac54', '55b2d3f2fdf99b525bc839aa', '5e872f5b3a32c337ba65aa68', '5ad57f5c27c301000101d9c5', '58935d5d4d77be0001689f14', '5d88db42c1d06e001a1fdcab', '55eb04337480920010aa9e0d', '5a8d8079190420000156435d', '5d23460ad4c57900192b129c', '5b9b422307c6960001614c35', '5fb0a3d6a8e4224b973e750b', '63d193c45e01ccb694993e7f'};

subs_array = cellfun(@(x) string(x), subs, 'UniformOutput', false);
subs_array = [subs_array{:}];

%original data is order 32F, 32L, 31F, 31L ....
fam = fliplr(liking_fam(:, 3:2:end)); %flip the matrix left to right 
liking = fliplr(liking_fam(:, 4:2:end));


current_sub = input('Enter the prolific ID: ','s');
id = current_sub;

for i = 1:length(subs)
    if subs_array(i) == current_sub
        position = i;
    end
end

group = liking_fam(position,1);    %modded first is 1, unmodded first is 2
triplet = liking_fam(position,2);  %song list 1,2,3,4,5

songlist_sart = songref(triplet*2-1,:);
songlist_nback = songref(triplet*2,:);


like_sart = [liking(position,songlist_sart(1)),liking(position,songlist_sart(2)),liking(position,songlist_sart(3)),...
    liking(position,songlist_sart(4)),liking(position,songlist_sart(5)),liking(position,songlist_sart(6)),...
    liking(position,songlist_sart(7)),liking(position,songlist_sart(8)),liking(position,songlist_sart(9)),...
    liking(position,songlist_sart(10)),liking(position,songlist_sart(11)),liking(position,songlist_sart(12))];

like_nback = [liking(position,songlist_nback(1)),liking(position,songlist_nback(2)),liking(position,songlist_nback(3)),...
    liking(position,songlist_nback(4)),liking(position,songlist_nback(5)),liking(position,songlist_nback(6)),...
    liking(position,songlist_nback(7)),liking(position,songlist_nback(8)),liking(position,songlist_nback(9)),...
    liking(position,songlist_nback(10)),liking(position,songlist_nback(11)),liking(position,songlist_nback(12))];

fam_sart = [fam(position,songlist_sart(1)),fam(position,songlist_sart(2)),fam(position,songlist_sart(3)),...
    fam(position,songlist_sart(4)),fam(position,songlist_sart(5)),fam(position,songlist_sart(6)),...
    fam(position,songlist_sart(7)),fam(position,songlist_sart(8)),fam(position,songlist_sart(9)),...
    fam(position,songlist_sart(10)),fam(position,songlist_sart(11)),fam(position,songlist_sart(12))];

fam_nback = [fam(position,songlist_nback(1)),fam(position,songlist_nback(2)),fam(position,songlist_nback(3)),...
    fam(position,songlist_nback(4)),fam(position,songlist_nback(5)),fam(position,songlist_nback(6)),...
    fam(position,songlist_nback(7)),fam(position,songlist_nback(8)),fam(position,songlist_nback(9)),...
    fam(position,songlist_nback(10)),fam(position,songlist_nback(11)),fam(position,songlist_nback(12))];

if group == 2
    mod = {'U' 'U' 'U' 'M' 'M' 'M' 'U' 'U' 'U' 'M' 'M' 'M'};
elseif group == 1
    mod = {'M' 'M' 'M' 'U' 'U' 'U' 'M' 'M' 'M' 'U' 'U' 'U'};
end

%SART, 12 songs grouped by order heard, 1-12
sart_modfam = [];
sart_unmodfam = [];
sart_modunfam = [];
sart_unmodunfam = [];
sart_modlike = [];
sart_unmodlike = [];
sart_modunlike = [];
sart_unmodunlike = [];

for j = 1:12
    %familiarity
    if fam_sart(j) > 2 && mod{j} == 'M'
        sart_modfam = [sart_modfam j];
    elseif fam_sart(j) > 2 && mod{j} == 'U'
        sart_unmodfam = [sart_unmodfam j];
    elseif fam_sart(j) <= 2 && mod{j} == 'M'
        sart_modunfam = [sart_modunfam j];
    elseif fam_sart(j) <= 2 && mod{j} == 'U'
        sart_unmodunfam = [sart_unmodunfam j];
    end
    %liking
    if like_sart(j) > 2 && mod{j} == 'M'
        sart_modlike = [sart_modlike j];
    elseif like_sart(j) > 2 && mod{j} == 'U'
        sart_unmodlike = [sart_unmodlike j];
    elseif like_sart(j) <= 2 && mod{j} == 'M'
        sart_modunlike = [sart_modunlike j];
    elseif like_sart(j) <= 2 && mod{j} == 'U'
        sart_unmodunlike = [sart_unmodunlike j];
    end
end

 
%NBACK
nback_modfam = [];
nback_unmodfam = [];
nback_modunfam = [];
nback_unmodunfam = [];
nback_modlike = [];
nback_unmodlike = [];
nback_modunlike = [];
nback_unmodunlike = [];

for j = 1:12
    % familiarity
    if fam_nback(j) > 2 && mod{j} == 'M'
        nback_modfam = [nback_modfam j];
    elseif fam_nback(j) > 2 && mod{j} == 'U'
        nback_unmodfam = [nback_unmodfam j];
    elseif fam_nback(j) <= 2 && mod{j} == 'M'
        nback_modunfam = [nback_modunfam j];
    elseif fam_nback(j) <= 2 && mod{j} == 'U'
        nback_unmodunfam = [nback_unmodunfam j];
    end
    % liking
    if like_nback(j) > 2 && mod{j} == 'M'
        nback_modlike = [nback_modlike j];
    elseif like_nback(j) > 2 && mod{j} == 'U'
        nback_unmodlike = [nback_unmodlike j];
    elseif like_nback(j) <= 2 && mod{j} == 'M'
        nback_modunlike = [nback_modunlike j];
    elseif like_nback(j) <= 2 && mod{j} == 'U'
        nback_unmodunlike = [nback_unmodunlike j];
    end
end

sart_modfam
sart_unmodfam
sart_modunfam
sart_unmodunfam
sart_modlike
sart_unmodlike
sart_modunlike
sart_unmodunlike
nback_modfam
nback_unmodfam
nback_modunfam
nback_unmodunfam
nback_modlike
nback_unmodlike
nback_modunlike
nback_unmodunlike

%%

date = input('date (ex: 7_13 or 11_29) ','s');
gd = append(string(group),' ',date);
%search through each survey data txt for prolific id
pathsurvey = append('/Users/Kob/Documents/MINDLab/THAMP/thamp 1b/thamp 1b data/group', gd,'/survey_data');
filelist = fullfile(pathsurvey);
d = dir(filelist);
d(1) = [];
d(1) = [];
d(1) = [];
for i=1:length(d)
    name = d(i).name;
    sname = split(name,'-');
    sname = split(sname(5),'.');
    sname = sname(1);
    a = readtable( append(pathsurvey,'/',string(name)) );
    realID = a{20,2};
    if string(realID) == id
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
d2 = dir(filelist2);
d2(1) = [];
d2(1) = [];
out2 = [];
for i=1:length(d2)
    name2 = d2(i).name;
    sname2 = split(name2,'-');
    sname2 = split(sname2(8),'.');
    sname2 = sname2(1);
    if string(sname2) == out1
        %get the nback file and the sart file that match the id
        out2 = [out2,'_',name2]; %two file names in an array
    end
end
out2;
out2 = split(out2,'_'); %use out{2} for NBACK and out{3} for SART

%%
%take sart file and extract reaction time column
%plot average reaction time for unmodded compared to modded SART
sart = readtable( append(pathexp,'/',string(out2{3})) );
%column 12 is reaction time, column 11 is song
%if group=1 s1,s2,s3,s7,s8,s9 = modded, 4,5,6,10,11,12 = unmodded
%if group=2 s1,s2,s3,s7,s8,s9 = unmodded, 4,5,6,10,11,12 = modded
table1mod = [];
table1unmod = [];

table_sart_modfam = [];
table_sart_unmodfam = [];
table_sart_modunfam = [];
table_sart_unmodunfam = [];
table_sart_modlike = [];
table_sart_unmodlike = [];
table_sart_modunlike = [];
table_sart_unmodunlike = [];

for i = 1:height(sart)
%     if ~strcmp(char(sart{i,1}),'training') && (sart{i,2} == 3 ||sart{i,2} == 4||sart{i,2} == 5||sart{i,2} == 9||sart{i,2} == 10||sart{i,2} == 11)
%         if sart{i,4} ~= 3 && sart{i,7} == 3
%             table1mod = [table1mod;sart(i,10)];
%         end
%     end
%     if ~strcmp(char(sart{i,1}), 'training') && (sart{i,2} == 6 || sart{i,2} == 7 || sart{i,2} == 8 || sart{i,2} == 12 || sart{i,2} == 13 || sart{i,2} == 14)
%         if sart{i,4} ~= 3 && sart{i,7} == 3
%             table1unmod = [table1unmod;sart(i,10)];
%         end
%     end
    for j = 1:length(sart_modfam) %mod fam
        if ~strcmp(char(sart{i,1}), 'training') && sart{i,2} == sart_modfam(j)
            if sart{i,4} ~= 3 && sart{i,7} == 3
                table_sart_modfam = [table_sart_modfam;sart(i,10)];
            end
        end
    end
    for j = 1:length(sart_unmodfam) %unmod fam
        if ~strcmp(char(sart{i,1}), 'training') && sart{i,2} == sart_unmodfam(j)
            if sart{i,4} ~= 3 && sart{i,7} == 3
                table_sart_unmodfam = [table_sart_unmodfam;sart(i,10)];
            end
        end
    end

    for j = 1:length(sart_modunfam) %mod unfam
        if ~strcmp(char(sart{i,1}), 'training') && sart{i,2} == sart_modunfam(j)
            if sart{i,4} ~= 3 && sart{i,7} == 3
                table_sart_modunfam = [table_sart_modunfam;sart(i,10)];
            end
        end
    end

    for j = 1:length(sart_unmodunfam) %unmod unfam
        if ~strcmp(char(sart{i,1}), 'training') && sart{i,2} == sart_unmodunfam(j)
            if sart{i,4} ~= 3 && sart{i,7} == 3
                table_sart_unmodunfam = [table_sart_unmodunfam;sart(i,10)];
            end
        end
    end

    for j = 1:length(sart_modlike) %mod like
        if ~strcmp(char(sart{i,1}), 'training') && sart{i,2} == sart_modlike(j)
            if sart{i,4} ~= 3 && sart{i,7} == 3
                table_sart_modlike = [table_sart_modlike;sart(i,10)];
            end
        end
    end
    for j = 1:length(sart_unmodlike) %unmod like
        if ~strcmp(char(sart{i,1}), 'training') && sart{i,2} == sart_unmodlike(j)
            if sart{i,4} ~= 3 && sart{i,7} == 3
                table_sart_unmodlike = [table_sart_unmodlike;sart(i,10)];
            end
        end
    end

    for j = 1:length(sart_modunlike) %mod unlike
        if ~strcmp(char(sart{i,1}), 'training') && sart{i,2} == sart_modunlike(j)
            if sart{i,4} ~= 3 && sart{i,7} == 3
                table_sart_modunlike = [table_sart_modunlike;sart(i,10)];
            end
        end
    end

    for j = 1:length(sart_unmodunlike) %unmod unlike
        if ~strcmp(char(sart{i,1}), 'training') && sart{i,2} == sart_unmodunlike(j)
            if sart{i,4} ~= 3 && sart{i,7} == 3
                table_sart_unmodunlike = [table_sart_unmodunlike;sart(i,10)];
            end
        end
    end
end

for k = 1:height(sart)
    if sart{k,6} == 0
        %plot mistake, plot an x? or plot a vertical line at each
        %mistake?
    end
end

% table1mod = table2array(table1mod);
% table1unmod = table2array(table1unmod);
% figure(1)
% plot(table1mod)
% title('MODDED REACTION TIME')
% ylabel('Reaction Time (ms)')
% figure(2)
% plot(table1unmod)
% title('UNMODDED REACTION TIME')
% ylabel('Reaction Time (ms)')
% 
% total = 0;
% for l = 1:length(table1mod)
%     total = total + table1mod(l);
% end
% avg_mod_reaction = total / length(table1mod)
% std_mod = std(table1mod)
% total = 0;
% for l = 1:length(table1unmod)
%     total = total + table1unmod(l);
% end
% avg_unmod_reaction = total / length(table1unmod)
% std_mod = std(table1unmod)

if ~isempty(table_sart_modfam), table_sart_modfam = table2array(table_sart_modfam); end
if ~isempty(table_sart_unmodfam), table_sart_unmodfam = table2array(table_sart_unmodfam); end
if ~isempty(table_sart_modunfam), table_sart_modunfam = table2array(table_sart_modunfam); end
if ~isempty(table_sart_unmodunfam), table_sart_unmodunfam = table2array(table_sart_unmodunfam); end
if ~isempty(table_sart_modlike), table_sart_modlike = table2array(table_sart_modlike); end
if ~isempty(table_sart_unmodlike), table_sart_unmodlike = table2array(table_sart_unmodlike); end
if ~isempty(table_sart_modunlike), table_sart_modunlike = table2array(table_sart_modunlike); end
if ~isempty(table_sart_unmodunlike), table_sart_unmodunlike = table2array(table_sart_unmodunlike); end

total = 0; %modfam
for l = 1:length(table_sart_modfam)
    total = total + table_sart_modfam(l);
end
avg_modfam_reaction = total / length(table_sart_modfam)
std_modfam = std(table_sart_modfam)

total = 0; %unmodfam
for l = 1:length(table_sart_unmodfam)
    total = total + table_sart_unmodfam(l);
end
avg_unmodfam_reaction = total / length(table_sart_unmodfam)
std_unmodfam = std(table_sart_unmodfam)

total = 0; %modunfam
for l = 1:length(table_sart_modunfam)
    total = total + table_sart_modunfam(l);
end
avg_modunfam_reaction = total / length(table_sart_modunfam)
std_modunfam = std(table_sart_modunfam)

total = 0; %unmodunfam
for l = 1:length(table_sart_unmodunfam)
    total = total + table_sart_unmodunfam(l);
end
avg_unmodunfam_reaction = total / length(table_sart_unmodunfam)
std_unmodunfam = std(table_sart_unmodunfam)

total = 0; %modlike
for l = 1:length(table_sart_modlike)
    total = total + table_sart_modlike(l);
end
avg_modlike_reaction = total / length(table_sart_modlike)
std_modlike = std(table_sart_modlike)

total = 0; %unmodlike
for l = 1:length(table_sart_unmodlike)
    total = total + table_sart_unmodlike(l);
end
avg_unmodlike_reaction = total / length(table_sart_unmodlike)
std_unmodlike = std(table_sart_unmodlike)

total = 0; %modunlike
for l = 1:length(table_sart_modunlike)
    total = total + table_sart_modunlike(l);
end
avg_modunlike_reaction = total / length(table_sart_modunlike)
std_modunlike = std(table_sart_modunlike)

total = 0; %unmodunlike
for l = 1:length(table_sart_unmodunlike)
    total = total + table_sart_unmodunlike(l);
end
avg_unmodunlike_reaction = total / length(table_sart_unmodunlike)
std_unmodunlike = std(table_sart_unmodunlike)


%%
% take nback file and extract status, current letter, predet
%import all predet array
%match to appropriate predet array
%answer key: check to see if current letter matches predet from 2 ago
%               then compare status and assign hit, miss, CR, FA
% plot the nback accuracy for unmodded compared to modded
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
unmod1 = [];
table_nback_modfam = [];
table_nback_unmodfam = [];
table_nback_modunfam = [];
table_nback_unmodunfam = [];
table_nback_modlike = [];
table_nback_unmodlike = [];
table_nback_modunlike = [];
table_nback_unmodunlike = [];


for i = 1:height(nback_u)
    %IN THESE TWO IFS, INSTEAD OF SPLITTING INTO MOD AND UNMOD, SPLIT
    %BASED ON THE LIK/FAM CATEGORIES (8 CATEGORIES PER TASK)
    % add 2 to song input number
%     if nback_u{i,2} == 3 ||nback_u{i,2} == 4||nback_u{i,2} == 5||nback_u{i,2} == 9||nback_u{i,2} == 10||nback_u{i,2} == 11
%         mod1 = [mod1;nback_u(i,9)];
%     end
%     if nback_u{i,2} == 6 || nback_u{i,2} == 7 || nback_u{i,2} == 8 || nback_u{i,2} == 12 || nback_u{i,2} == 13 || nback_u{i,2} == 14
%         unmod1 = [unmod1;nback_u(i,9)];
%     end
    for j = 1:length(nback_modfam) %mod fam
        if nback_u{i,2} == nback_modfam(j)
            table_nback_modfam = [table_nback_modfam;nback_u(i,9)];
        end
    end
    for j = 1:length(nback_unmodfam) %unmod fam
        if nback_u{i,2} == nback_unmodfam(j)
            table_nback_unmodfam = [table_nback_unmodfam;nback_u(i,9)];
        end
    end

    for j = 1:length(nback_modunfam) %mod unfam
        if nback_u{i,2} == nback_modunfam(j)
                table_nback_modunfam = [table_nback_modunfam;nback_u(i,9)];
        end
    end

    for j = 1:length(nback_unmodunfam) %unmod unfam
        if nback_u{i,2} == nback_unmodunfam(j)
                table_nback_unmodunfam = [table_nback_unmodunfam;nback_u(i,9)];
        end
    end

    for j = 1:length(nback_modlike) %mod like
        if nback_u{i,2} == nback_modlike(j)
            table_nback_modlike = [table_nback_modlike;nback_u(i,9)];
        end
    end
    for j = 1:length(nback_unmodlike) %unmod like
        if nback_u{i,2} == nback_unmodlike(j)
            table_nback_unmodlike = [table_nback_unmodlike;nback_u(i,9)];
        end
    end

    for j = 1:length(nback_modunlike) %mod unlike
        if nback_u{i,2} == nback_modunlike(j)
                table_nback_modunlike = [table_nback_modunlike;nback_u(i,9)];
        end
    end

    for j = 1:length(nback_unmodlike) %unmod unlike
        if nback_u{i,2} == nback_unmodlike(j)
                table_nback_unmodunlike = [table_nback_unmodunlike;nback_u(i,9)];
        end
    end

end
% %PERCENT CORRECT CALC mod group 1
% correct = 0;
% for k = 1:height(mod1)
%     if mod1{k,1} == 1 || mod1{k,1} == 4
%         correct = correct + 1;
%     end
% end
% disp('CORRECT PERCENTAGE MOD NBACK = ') 
% disp(correct/height(mod1))
% %PERCENT CORRECT CALC unmod group 1
% correct = 0;
% for k = 1:height(unmod1)
%     if unmod1{k,1} == 1 || unmod1{k,1} == 4
%         correct = correct + 1;
%     end
% end
% 
% disp('CORRECT PERCENTAGE UNMOD NBACK = ')
% disp(correct/height(unmod1))

%PERCENT CORRECT CALC modfam
correct = 0;
for k = 1:height(table_nback_modfam)
    if table_nback_modfam{k,1} == 1 || table_nback_modfam{k,1} == 4
        correct = correct + 1;
    end
end
disp('CORRECT PERCENTAGE modfam NBACK = ')
disp(correct/height(table_nback_modfam))
nb1=correct/height(table_nback_modfam);

%PERCENT CORRECT CALC unmodfam
correct = 0;
for k = 1:height(table_nback_unmodfam)
    if table_nback_unmodfam{k,1} == 1 || table_nback_unmodfam{k,1} == 4
        correct = correct + 1;
    end
end
disp('CORRECT PERCENTAGE unmodfam NBACK = ')
disp(correct/height(table_nback_unmodfam))
nb2=correct/height(table_nback_unmodfam);

%PERCENT CORRECT CALC modunfam
correct = 0;
for k = 1:height(table_nback_modunfam)
    if table_nback_modunfam{k,1} == 1 || table_nback_modunfam{k,1} == 4
        correct = correct + 1;
    end
end
disp('CORRECT PERCENTAGE modunfam NBACK = ')
disp(correct/height(table_nback_modunfam))
nb3=correct/height(table_nback_modunfam);

%PERCENT CORRECT CALC unmodunfam
correct = 0;
for k = 1:height(table_nback_unmodunfam)
    if table_nback_unmodunfam{k,1} == 1 || table_nback_unmodunfam{k,1} == 4
        correct = correct + 1;
    end
end
disp('CORRECT PERCENTAGE unmodunfam NBACK = ')
disp(correct/height(table_nback_unmodunfam))
nb4=correct/height(table_nback_unmodunfam);

%PERCENT CORRECT CALC modlike
correct = 0;
for k = 1:height(table_nback_modlike)
    if table_nback_modlike{k,1} == 1 || table_nback_modlike{k,1} == 4
        correct = correct + 1;
    end
end
disp('CORRECT PERCENTAGE modlike NBACK = ')
disp(correct/height(table_nback_modlike))
nb5=correct/height(table_nback_modlike);

%PERCENT CORRECT CALC unmodlike
correct = 0;
for k = 1:height(table_nback_unmodlike)
    if table_nback_unmodlike{k,1} == 1 || table_nback_unmodlike{k,1} == 4
        correct = correct + 1;
    end
end
disp('CORRECT PERCENTAGE unmodlike NBACK = ')
disp(correct/height(table_nback_unmodlike))
nb6=correct/height(table_nback_unmodlike);

%PERCENT CORRECT CALC modunlike
correct = 0;
for k = 1:height(table_nback_modunlike)
    if table_nback_modunlike{k,1} == 1 || table_nback_modunlike{k,1} == 4
        correct = correct + 1;
    end
end
disp('CORRECT PERCENTAGE modunlike NBACK = ')
disp(correct/height(table_nback_modunlike))
nb7=correct/height(table_nback_modunlike);

%PERCENT CORRECT CALC unmodunlike
correct = 0;
for k = 1:height(table_nback_unmodunlike)
    if table_nback_unmodunlike{k,1} == 1 || table_nback_unmodunlike{k,1} == 4
        correct = correct + 1;
    end
end
disp('CORRECT PERCENTAGE unmodunlike NBACK = ')
nb8=correct/height(table_nback_unmodunlike);
disp(correct/height(table_nback_unmodunlike))



results_sart = [std_modfam/avg_modfam_reaction std_unmodfam/avg_unmodfam_reaction std_modunfam/avg_modunfam_reaction std_unmodunfam/avg_unmodunfam_reaction std_modlike/avg_modlike_reaction std_unmodlike/avg_unmodlike_reaction std_modunlike/avg_modunlike_reaction std_unmodunlike/avg_unmodunlike_reaction];
results_nback = [nb1 nb2 nb3 nb4 nb5 nb6 nb7 nb8];
openvar('results_sart');
openvar('results_nback');
