clear
clc

savefigures = 0; %set to 1 or 0 to save plots or not for
windowsize = 20;
figure;

%open the text file with all the approved prolific ids
path = "/Users/Kob/Documents/MINDLab/THAMP/thamp 1b/thamp 1b data/participant_list.txt";
fileID = fopen(path, 'r');

data_cell = textscan(fileID, '%s', 'Delimiter', '\n');
data = data_cell{1};

%extra ids of participants who got the bonus payment and still wanted to
%complete the survey again
extra_ids = {'63852498bcb698988baa11c2',...
'5a78b8355292b800012284ca',...
'5df89cab69a117620a70f1ee',...
'6470f0a74d3e8cc83f27be31',...
'61bb392e40db417c1a138dcb',...
'5c1c2c51e2d9150001b5737e',...
'659a0d020c80c3b946e05be7'};

%id_list = [data;extra_ids];
id_list = data;

%simple qualtrics data, just ids and group/song order, no survey data (
path2 = "/Users/Kob/Documents/MINDLab/THAMP/thamp 1b/thamp 1b data/simple_qualtrics_data_2_9";
q_data = readtable("/Users/Kob/Documents/MINDLab/THAMP/thamp 1b/thamp 1b data/simple_qualtrics_data_2_9");

%full qualtrics data
path3 = "/Users/Kob/Documents/MINDLab/THAMP/thamp 1b/thamp 1b data/THAMP_Qualtrics_2_9";
full_data = readtable("/Users/Kob/Documents/MINDLab/THAMP/thamp 1b/thamp 1b data/THAMP_Qualtrics_2_9");

%%
% will process all 400 online subjects and include time sensitive
% performance analysis

%import qualtrics data and obtain group number from corresponding prolific
%id
%put all the survey/experiment data from psytoolkit in the same date folder

%for each entry in id_list calc each thing and add a new row of
%final_results
%final_results = [1 avg_mod_reaction std_mod std_mod/avg_mod_reaction avg_unmod_reaction std_unmod std_unmod/avg_unmod_reaction avg_nomusic_reaction std_nomusic_nm std_nomusic_nm/avg_nomusic_reaction 1 1 nb1 nb2 nb3];
   
final_results_all = [];
final_results_asrs = [];
final_results_asrs0 = [];
final_results_mus = [];
final_results_mus0 = [];
final_results_all_like = [];
final_results_all_fam = [];
id_error_list = []; %out2 empty error
id_error_list2 = []; %table1mod empty error
id_error_list3 = []; %table2mod empty error
id_error_list4 = []; %table1mod empty error line 161
id_error_list5 = []; %table1unmod empty error line 161
    
for h = 1:length(id_list)    
    %loop through all of the ids and for each calc all desired metrics for
    %sart and nback
    id = id_list{h};
    
    %subject ids that are throwing errors here (non out2 errors)
    %628bb has empty table1mod
    %655fd1c has empty table1mod
%     if strcmp(id,'628bbe2c0f8080e6985e8592') || strcmp(id,'655fd1c6919a4ddb98818eae')
%         x=8
%         continue;
%     end

    %within each id, loop through qualtrics data
    for j = 1:height(q_data)
        %7 is prolific id, 8 is group 1 or 2, 9 is song order 1-5
        if strcmp(id_list{h},string(q_data{j,7}))
            group = q_data{j,8};
            triplet = q_data{j,9};
        end
    end

    for j = 1:height(full_data)
        %328 total columns
        %prolific id is column 38
        %song 1 fam is 114
        %song 1 like is 115
        %song 2 fam is 120
        %song 2 like is 121 ... etc up to 32
        % 126, 127

        %ars is kt - lk (306 - 323)
        if strcmp(id_list{h},string(full_data{j,38}))
            position = j;
        end
    end
    
    columns = [114, 115, 120, 121, 126, 127, 132, 133, 138, 139, 144, 145, 150, 151, 156, 157,...
    162, 163, 168, 169, 174, 175, 180, 181, 186, 187, 192, 193, 198, 199, 204, 205,...
    210, 211, 216, 217, 222, 223, 228, 229, 234, 235, 240, 241, 246, 247, 252, 253,...
    258, 259, 264, 265, 270, 271, 276, 277, 282, 283, 288, 289, 294, 295, 300, 301];
    liking_fam = full_data{position,columns};
    current_asrs = full_data{position, 306:323};
    fam = fliplr(liking_fam(:, 1:2:end)); %flip the matrix left to right 
    liking = fliplr(liking_fam(:, 2:2:end));

    %asrs ranking
    asrs_final = 1; %past threshold or not, then sum them into final_asrs if == 1


    if triplet == 1, songref = [19	17	13	9	2	4	26	22	27	10	3	25; ...
        18	14	8	24	23	21	1	7	20	30	5	16]; end
    if triplet == 2, songref = [26	22	27	10	3	25	18	14	8	24	23	21; ...
        1	7	20	30	5	16	29	11	31	32	12	28]; end
    if triplet == 3, songref = [18	14	8	24	23	21	1	7	20	30	5	16; ...
        29	11	31	32	12	28	19	17	13	9	2	4]; end
    if triplet == 4, songref = [1	7	20	30	5	16	29	11	31	32	12	28; ...
        19	17	13	9	2	4	26	22	27	10	3	25]; end
    if triplet == 5, songref = [29	11	31	32	12	28	19	17	13	9	2	4; ...
        26	22	27	10	3	25	18	14	8	24	23	21]; end
    if group == 2
        mod = {'U' 'U' 'U' 'M' 'M' 'M' 'U' 'U' 'U' 'M' 'M' 'M'};
    elseif group == 1
        mod = {'M' 'M' 'M' 'U' 'U' 'U' 'M' 'M' 'M' 'U' 'U' 'U'};
    end
    songlist_sart = songref(1,:);
    songlist_nback = songref(2,:);

    like_sart = [liking(songlist_sart(1)),liking(songlist_sart(2)),liking(songlist_sart(3)),...
    liking(songlist_sart(4)),liking(songlist_sart(5)),liking(songlist_sart(6)),...
    liking(songlist_sart(7)),liking(songlist_sart(8)),liking(songlist_sart(9)),...
    liking(songlist_sart(10)),liking(songlist_sart(11)),liking(songlist_sart(12))];

    like_nback = [liking(songlist_nback(1)),liking(songlist_nback(2)),liking(songlist_nback(3)),...
    liking(songlist_nback(4)),liking(songlist_nback(5)),liking(songlist_nback(6)),...
    liking(songlist_nback(7)),liking(songlist_nback(8)),liking(songlist_nback(9)),...
    liking(songlist_nback(10)),liking(songlist_nback(11)),liking(songlist_nback(12))];

    fam_sart = [fam(songlist_sart(1)),fam(songlist_sart(2)),fam(songlist_sart(3)),...
    fam(songlist_sart(4)),fam(songlist_sart(5)),fam(songlist_sart(6)),...
    fam(songlist_sart(7)),fam(songlist_sart(8)),fam(songlist_sart(9)),...
    fam(songlist_sart(10)),fam(songlist_sart(11)),fam(songlist_sart(12))];

    fam_nback = [fam(songlist_nback(1)),fam(songlist_nback(2)),fam(songlist_nback(3)),...
    fam(songlist_nback(4)),fam(songlist_nback(5)),fam(songlist_nback(6)),...
    fam(songlist_nback(7)),fam(songlist_nback(8)),fam(songlist_nback(9)),...
    fam(songlist_nback(10)),fam(songlist_nback(11)),fam(songlist_nback(12))];

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




    date = '2_9';
    gd = append(string(group),' ',date);
    %search through each survey data txt for prolific id
    pathsurvey = append('/Users/Kob/Documents/MINDLab/THAMP/thamp 1b/thamp 1b data/group', gd,'/survey_data');
    filelist = fullfile(pathsurvey);
    d = dir(filelist);
    d(1) = [];
    d(1) = [];
    d(1) = [];
    for k=1:length(d)
        name = d(k).name;
        sname = split(name,'-');
        sname = split(sname(5),'.');
        sname = sname(1);
        a = readtable( append(pathsurvey,'/',string(name)) );
        if height(a) >= 20
            realID = a{20,2};
        else
            continue;
        end
        if string(realID) == id
            out1 = sname;
            a_real = a;
            d(k).name
        end
    end
    out1;
     
    %save the end of survey data txt file name
    %find the two matching txt files in experiment data
    pathexp = append('/Users/Kob/Documents/MINDLab/THAMP/thamp 1b/thamp 1b data/group', gd,'/experiment_data');
    filelist2 = fullfile(pathexp);
    d2 = dir(filelist2);
    d2(1) = [];
    d2(1) = [];
    out2 = [];
    for k=1:length(d2)
        name2 = d2(k).name;
        sname2 = split(name2,'-');
        sname2 = split(sname2(8),'.');
        sname2 = sname2(1);
        if string(sname2) == out1
            %get the nback file and the sart file that match the id
            out2 = [out2,'+',name2]; %two file names in an array
        end
    end
    out2;

    %if out2 is empty then save the problem id and continue
    if isempty(out2)
        id_error_list = [id_error_list;id];
        continue;
    end

    out2 = split(out2,'+'); %use out2{2} for NBACK and out2{3} for SART
    
    %maybe here is where you would be able to split into FOUR groups for nback,
    %sart, nback no music, sart no music
    %maybe?: out2{2} out2{3} out2{4} out2{5}
    
    %%
    %SART
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
    table_modlike = [];
    table_unmodlike = [];
    table_modunlike = [];
    table_unmodunlike = [];
    table_modfam = [];
    table_unmodfam = [];
    table_modunfam = [];
    table_unmodunfam = [];

    if group == 1
        for i = 1:height(sart)
            if ~strcmp(char(sart{i,1}),'training') && (sart{i,2} == 3 ||sart{i,2} == 4||sart{i,2} == 5||sart{i,2} == 9||sart{i,2} == 10||sart{i,2} == 11)
                if sart{i,4} ~= 3 && sart{i,7} == 3
                    table1mod = [table1mod;sart(i,10)];
                end
            end
            if ~strcmp(char(sart{i,1}), 'training') && (sart{i,2} == 6 || sart{i,2} == 7 || sart{i,2} == 8 || sart{i,2} == 12 || sart{i,2} == 13 || sart{i,2} == 14)
                if sart{i,4} ~= 3 && sart{i,7} == 3
                    table1unmod = [table1unmod;sart(i,10)];
                end
            end
        end
    
        for k = 1:height(sart)
            if sart{k,6} == 0
                %plot mistake, plot an x? or plot a vertical line at each
                %mistake?
            end
        end
    
        if isempty(table1mod)
            id_error_list4 = [id_error_list4;id];
            continue;
        end

        if isempty(table1unmod)
            id_error_list5 = [id_error_list5;id];
            continue;
        end

        table1mod = table2array(table1mod);
        table1unmod = table2array(table1unmod);
%         figure(1)
%         plot(table1mod)
%         title('MODDED REACTION TIME')
%         ylabel('Reaction Time (ms)')
%         figure(2)
%         plot(table1unmod)
%         title('UNMODDED REACTION TIME')
%         ylabel('Reaction Time (ms)')

%SART response time plot
% loop through the sart variablea column 10
%         for p = 1:length(sart)
%             %rt = sart{p,10}
%         end
        filtered_sart = sart(sart{:,10} ~= max(sart{:,10}),:); %removes all rows that have max RT (no button was pressed)
        rt_rolling = movstd(filtered_sart{:,10},windowsize);
        rt_rolling_avg = movmean(filtered_sart{:,10},windowsize);
        subplot(2,1,1);
        plot(rt_rolling/rt_rolling_avg);
        xlabel('Trials')
        ylabel('RT CV')
        title('SART (Modded First) Rolling Window CV of Response Times')
        xlim([1, length(rt_rolling)]);
        line([mean(xlim), mean(xlim)], ylim, 'Color', 'r', 'LineStyle', '--');
        line([mean(xlim), mean(xlim)]/2, ylim, 'Color', 'r', 'LineStyle', '--');
        line([mean(xlim), mean(xlim)]*(3/2), ylim, 'Color', 'r', 'LineStyle', '--');


        total = 0;
        for l = 1:length(table1mod)
            total = total + table1mod(l);
        end
        avg_mod_reaction = total / length(table1mod);
        std_mod = std(table1mod);
        total = 0;
        for l = 1:length(table1unmod)
            total = total + table1unmod(l);
        end
        avg_unmod_reaction = total / length(table1unmod);
        std_unmod = std(table1unmod);
    
    
    end
    if group == 2
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

        if isempty(table2mod)
            id_error_list3 = [id_error_list3;id];
            continue;
        end
        
        table2mod = table2array(table2mod);
        table2unmod = table2array(table2unmod);
%         figure(1)
%         plot(table2mod)
%         title('MODDED REACTION TIME')
%         ylabel('Reaction Time (ms)')
%         figure(2)
%         plot(table2unmod)
%         title('UNMODDED REACTION TIME')
%         ylabel('Reaction Time (ms)')

%SART response time plot
% loop through the sart variablea column 10
        filtered_sart = sart(sart{:,10} ~= max(sart{:,10}),:); %removes all rows that have max RT (no button was pressed)
        rt_rolling = movstd(filtered_sart{:,10},windowsize);
        rt_rolling_avg = movmean(filtered_sart{:,10},windowsize);
        subplot(2,1,1);
        plot(rt_rolling/rt_rolling_avg);
        xlabel('Trials')
        ylabel('RT CV')
        title('SART (Unmodded First) Rolling Window CV of Response Times')
        xlim([1, length(rt_rolling)]);
        line([mean(xlim), mean(xlim)], ylim, 'Color', 'r', 'LineStyle', '--');
        line([mean(xlim), mean(xlim)]/2, ylim, 'Color', 'r', 'LineStyle', '--');
        line([mean(xlim), mean(xlim)]*(3/2), ylim, 'Color', 'r', 'LineStyle', '--');

        total = 0;
        for l = 1:length(table2mod)
            total = total + table2mod(l);
        end
        avg_mod_reaction = total / length(table2mod);
        std_mod = std(table2mod);
        total = 0;
        for l = 1:length(table2unmod)
            total = total + table2unmod(l);
        end
        avg_unmod_reaction = total / length(table2unmod);
        std_unmod = std(table2unmod);
    end

    %same analysis as group 1 and group 2 but for liked and fam categories
    for i = 1:height(sart)
            %LIKED + modded 
        if ~isempty(sart_modlike)
        if ~strcmp(char(sart{i,1}),'training') && any(sart{i,2},sart_modlike+2)
            if sart{i,4} ~= 3 && sart{i,7} == 3
                table_modlike = [table_modlike;sart(i,10)];
            end
        end
        end
        
        %liked + unmodded
        if ~isempty(sart_unmodlike)
        if ~strcmp(char(sart{i,1}), 'training') && any(sart{i,2},sart_unmodlike+2)
            if sart{i,4} ~= 3 && sart{i,7} == 3
                table_unmodlike = [table_unmodlike;sart(i,10)];
            end
        end
        end
    
        %FAMILIAR  + modded
        if ~isempty(sart_modfam)
        if ~strcmp(char(sart{i,1}),'training') && any(sart{i,2},sart_modfam+2)
            if sart{i,4} ~= 3 && sart{i,7} == 3
                table_modfam = [table_modfam;sart(i,10)];
            end
        end
        end
        %familiar + unmodded
        if ~isempty(sart_unmodfam)
        if ~strcmp(char(sart{i,1}), 'training') && any(sart{i,2},sart_unmodfam+2)
            if sart{i,4} ~= 3 && sart{i,7} == 3
                table_unmodfam = [table_unmodfam;sart(i,10)];
            end
        end  
        end
    end
    if ~isempty(table_modlike),table_modlike = table2array(table_modlike); end
    if ~isempty(table_unmodlike),table_unmodlike = table2array(table_unmodlike); end
    if ~isempty(table_modfam),table_modfam = table2array(table_modfam); end
    if ~isempty(table_unmodfam),table_unmodfam = table2array(table_unmodfam); end
   
    %liked
    total = 0;
    for l = 1:length(table_modlike)
        total = total + table_modlike(l);
    end
    avg_modlike_reaction = total / length(table_modlike);
    std_modlike = std(table_modlike);
    total = 0;
    for l = 1:length(table_unmodlike)
        total = total + table_unmodlike(l);
    end
    avg_unmodlike_reaction = total / length(table_unmodlike);
    std_unmodlike = std(table_unmodlike);
    
    %familiar
    total = 0;
    for l = 1:length(table_modfam)
        total = total + table_modfam(l);
    end
    avg_modfam_reaction = total / length(table_modfam);
    std_modfam = std(table_modfam);
    total = 0;
    for l = 1:length(table_unmodfam)
        total = total + table_unmodfam(l);
    end
    avg_unmodfam_reaction = total / length(table_unmodfam);
    std_unmodfam = std(table_unmodfam);

    %TO DO NEXT: gather up the fam and like results into their own variable
    %grade asrs and gather that
    %put all in spreadsheet
    
    
    %%
    % take nback file and extract status, current letter, predet
    %import all predet array
    %match to appropriate predet array
    %answer key: check to see if current letter matches predet from 2 ago
    %               then compare status and assign hit, miss, CR, FA
    % plot the nback accuracy for unmodded compared to modded
    nback = readtable( append(pathexp,'/',string(out2{3})) );
    
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
    modlike = [];
    unmodlike = [];
    modfam = [];
    unmodfam = [];

    if group == 1
        for i = 1:height(nback_u)
            if nback_u{i,2} == 3 ||nback_u{i,2} == 4||nback_u{i,2} == 5||nback_u{i,2} == 9||nback_u{i,2} == 10||nback_u{i,2} == 11
                mod1 = [mod1;nback_u(i,9)];
            end
            if nback_u{i,2} == 6 || nback_u{i,2} == 7 || nback_u{i,2} == 8 || nback_u{i,2} == 12 || nback_u{i,2} == 13 || nback_u{i,2} == 14
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
        %disp('CORRECT PERCENTAGE MOD NBACK = ') 
        %disp(correct/height(mod1))
        nb1 = correct/height(mod1);
        %PERCENT CORRECT CALC unmod group 1
        correct = 0;
        for k = 1:height(unmod1)
            if unmod1{k,1} == 1 || unmod1{k,1} == 4
                correct = correct + 1;
            end
        end
        
        %disp('CORRECT PERCENTAGE UNMOD NBACK = ')
        %disp(correct/height(unmod1))
        nb2 = correct/height(unmod1);

        %NBACK MODDED RESPONSE TIME PLOTS
        %loop through nback_u and use nback_u{i,5} for RT
%         rt_rolling = movstd(nback_u{:,5},windowsize);
%         subplot(2,2,2);
%         plot(rt_rolling);
%         xlabel('Trials')
%         ylabel('Std Dev (ms)')
%         title('NBACK (Modded First) Rolling Window Std Dev of Response Times')
%         xlim([1, length(rt_rolling)]);
%         line([mean(xlim), mean(xlim)], ylim, 'Color', 'r', 'LineStyle', '--');
%         line([mean(xlim), mean(xlim)]/2, ylim, 'Color', 'r', 'LineStyle', '--');
%         line([mean(xlim), mean(xlim)]*(3/2), ylim, 'Color', 'r', 'LineStyle', '--');
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
            if mod2{k,1} == 1 || mod2{k,1} == 4
                correct = correct + 1;
            end
        end
        %disp('CORRECT PERCENTAGE MOD NBACK = ')
        %disp(correct/height(mod2))
        nb1 = correct/height(mod2);
        %PERCENT CORRECT CALC unmod group 2
        correct = 0;
        for k = 1:height(unmod2)
            if unmod2{k,1} == 1 || unmod2{k,1} == 4
                correct = correct + 1;
            end
        end
        %disp('CORRECT PERCENTAGE UNMOD NBACK = ')
        %disp(correct/height(unmod2))
        nb2 = correct/height(unmod2);

        %NBACK MODDED RESPONSE TIME PLOTS
        %loop through nback_u and use nback_u{i,5} for RT
%         rt_rolling = movstd(nback_u{:,5},windowsize);
%         subplot(2,2,2);
%         plot(rt_rolling);
%         xlabel('Trials')
%         ylabel('Std Dev (ms)')
%         title('NBACK (Unodded First) Rolling Window Std Dev of Response Times')
%         xlim([1, length(rt_rolling)]);
%         line([mean(xlim), mean(xlim)], ylim, 'Color', 'r', 'LineStyle', '--');
%         line([mean(xlim), mean(xlim)]/2, ylim, 'Color', 'r', 'LineStyle', '--');
%         line([mean(xlim), mean(xlim)]*(3/2), ylim, 'Color', 'r', 'LineStyle', '--');
    end

    %liking and fam results for nback
    for i = 1:height(nback_u)
        %liked modded
        if ~isempty(nback_modlike)
            if any(nback_u{i,2},nback_modlike+2)
            modlike = [modlike;nback_u(i,9)];
            end
        end
        %liked unmodded
        if ~isempty(nback_unmodlike)
        if any(nback_u{i,2},nback_unmodlike+2)
            unmodlike = [unmodlike;nback_u(i,9)];
        end
        end
        %familiar modded
        if ~isempty(nback_modfam)
        if any(nback_u{i,2},nback_modfam+2)
            modfam = [modfam;nback_u(i,9)];
        end
        end
        %familiar unmodded
        if ~isempty(nback_unmodfam)
        if any(nback_u{i,2},nback_unmodfam+2)
            unmodfam = [unmodfam;nback_u(i,9)];
        end
        end
    end
        
        %correctness for liking modded and unmodded
        correct = 0;
        for k = 1:height(modlike)
            if modlike{k,1} == 1 || modlike{k,1} == 4
                correct = correct + 1;
            end
        end
        %disp('CORRECT PERCENTAGE MOD NBACK = ') 
        %disp(correct/height(modlike))
        nb1_like = correct/height(modlike);
        %PERCENT CORRECT CALC unmod group 1
        correct = 0;
        for k = 1:height(unmodlike)
            if unmodlike{k,1} == 1 || unmodlike{k,1} == 4
                correct = correct + 1;
            end
        end
        %disp('CORRECT PERCENTAGE UNMOD NBACK = ')
        %disp(correct/height(unmodlike))
        nb2_like = correct/height(unmodlike);

        %correctness for familiar modded and unmodded
        correct = 0;
        for k = 1:height(modfam)
            if modfam{k,1} == 1 || modfam{k,1} == 4
                correct = correct + 1;
            end
        end
        %disp('CORRECT PERCENTAGE MOD NBACK = ') 
        %disp(correct/height(modfam))
        nb1_fam = correct/height(modfam);
        %PERCENT CORRECT CALC unmod group 1
        correct = 0;
        for k = 1:height(unmodlike)
            if unmodlike{k,1} == 1 || unmodlike{k,1} == 4
                correct = correct + 1;
            end
        end
        %disp('CORRECT PERCENTAGE UNMOD NBACK = ')
        %disp(correct/height(unmodlike))
        nb2_fam = correct/height(unmodlike);
        
    
    %%
    % SART NO MUSIC
    %take sart file and extract reaction time column
    %plot average reaction time for unmodded compared to modded SART
    sart = readtable( append(pathexp,'/',string(out2{4})) );
    %column 12 is reaction time, column 11 is song
    %if group=1 s1,s2,s3,s7,s8,s9 = modded, 4,5,6,10,11,12 = unmodded
    %if group=2 s1,s2,s3,s7,s8,s9 = unmodded, 4,5,6,10,11,12 = modded
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
                %mistake?
            end
        end

        if isempty(table1mod)
            id_error_list2 = [id_error_list2;id];
            continue;
        end
    
        table1mod = table2array(table1mod);
        %table1unmod = table2array(table1unmod);
%         figure(3)
%         plot(table1mod)
%         title('NO MUSIC REACTION TIME')
%         ylabel('Reaction Time (ms)')  
        
        %loop through table1mod for sart nm RT
        filtered_sart = sart(sart{:,10} ~= max(sart{:,10}),:);
        rt_rolling = movstd(filtered_sart{:,10},windowsize);
        rt_rolling_avg = movmean(filtered_sart{:,10},windowsize);
        subplot(2,1,2);
        plot(rt_rolling/rt_rolling_avg);
        xlabel('Trials')
        ylabel('RT CV')
        title('SART (No Music) Rolling Window CV of Response Times')

        total = 0;
        for l = 1:length(table1mod)
            total = total + table1mod(l);
        end
        avg_nomusic_reaction = total / length(table1mod);
        std_nomusic_nm = std(table1mod);
    
    
    
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
        %disp('CORRECT PERCENTAGE NO MUSIC NBACK = ') 
        %disp(correct/height(mod1))
        nb3 = correct/height(mod1);

        %no music nback response time figure
        %loop through nback_u and use nback_u{i,5} for RT
%         rt_rolling = movstd(nback_u{:,5},windowsize);
%         subplot(2,2,4);
%         plot(rt_rolling);
%         title('NBACK (No Music) Rolling Window Std Dev of Response Times')
        
    
    %ASRS grading
    %ars is kt - lk (306 - 323)
    asrs = full_data{position,306:323};

    %check if columns 1,2,3,4,5,6 are shaded darkly
    count = 0;
    if strcmp(asrs{1}, 'Sometimes') || strcmp(asrs{1}, 'Often') || strcmp(asrs{1}, 'Very Often')
        count = count + 1;
    end
    if strcmp(asrs{2}, 'Sometimes') || strcmp(asrs{2}, 'Often') || strcmp(asrs{2}, 'Very Often')    
        count = count + 1;
    end    
    if strcmp(asrs{3}, 'Sometimes') || strcmp(asrs{3}, 'Often') || strcmp(asrs{3}, 'Very Often')    
        count = count + 1;
    end    
    if strcmp(asrs{4}, 'Often') || strcmp(asrs{4}, 'Very Often')   
        count = count + 1;
    end    
    if strcmp(asrs{5}, 'Often') || strcmp(asrs{5}, 'Very Often')   
        count = count + 1;
    end    
    if strcmp(asrs{6}, 'Often') || strcmp(asrs{6}, 'Very Often')   
        count = count + 1;
    end

    if count >= 4
        asrs_final = 1;
    else
        asrs_final = 0;
    end


    %MUSIC LISTENING HABITS
    %row 324
    mushabit = full_data{position,324};
    if strcmp(mushabit{1},'Often') || strcmp(mushabit{1},'Usually')
        muscheck = 1;
    end
    if strcmp(mushabit{1},'Never') || strcmp(mushabit{1},'Seldom')
        muscheck = 0;
    end


    %gathering final results    
    final_results = {string(id) group triplet 1 avg_mod_reaction std_mod std_mod/avg_mod_reaction avg_unmod_reaction std_unmod std_unmod/avg_unmod_reaction avg_nomusic_reaction std_nomusic_nm std_nomusic_nm/avg_nomusic_reaction 1 1 nb1 nb2 nb3};
    if asrs_final == 1
        final_results_asrs = [final_results_asrs;final_results];
    end

    if asrs_final == 0
        final_results_asrs0 = [final_results_asrs0;final_results];
    end

    if muscheck == 1
        final_results_mus = [final_results_mus;final_results];
    end

    if muscheck == 0
        final_results_mus0 = [final_results_mus0;final_results];
    end

    final_results_all = [final_results_all;final_results];
   
    final_results_like = {string(id) group triplet 1 avg_modlike_reaction std_modlike std_modlike/avg_modlike_reaction avg_unmodlike_reaction std_unmodlike std_unmodlike/avg_unmodlike_reaction 1 1 nb1 nb2 nb1_like nb2_like};
    final_results_fam = {string(id) group triplet 1 avg_modfam_reaction std_modfam std_modfam/avg_modfam_reaction avg_unmodfam_reaction std_unmodfam std_unmodfam/avg_unmodfam_reaction 1 1 nb1 nb2 nb1_fam nb2_fam};

    final_results_all_like = [final_results_all_like;final_results_like];
    final_results_all_fam = [final_results_all_fam;final_results_fam];

    
    sgtitle(id);
    if savefigures == 1
        saveas(gcf, strcat(id,'.fig'));
        saveas(gcf, strcat(id,'.png'));
    end
end

openvar('final_results_all')
