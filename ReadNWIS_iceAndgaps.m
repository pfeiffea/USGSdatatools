function [t,Q,stage]= ReadNWIS_iceAndgaps(F,category)
%% In this version of the function, I replace all 'Ice' gauge readings with...
% the most recent Q value, assuming that Q doesn't change much during...
% iced-over periods. 
% 
% AND
% 
% fill in gaps in the data where starting and ending discharge is similar. This...
%     is my way of dealing with winter iced-over gage records in Rocky Mtn...
%     rivers. 

%% test data
% F = 'Selway_NWIS.txt';

%%
    id=fopen(F); %Open the file "F"
    A=textscan(id,'%s %n %s %s %s %s %s %f %s','headerlines',2);%read each line to figure out which is string, number, etc
    fclose(id); %Closes out the file
    
    Q = A{6}; % Curly bracket means cell. A{3} 
    
    for i = 2:length(Q)
       if strcmp(Q(i),'Ice')==1
           Q(i) = Q(i-1);
       end
    end
    
    Q = str2double(Q);
    
    stage=A{8}; 
    
    t1 = A{3};
    if length(strfind(t1{1},'/'))>=2 && length(t1{1})>=9
        t1=datenum(A{3},'mm/dd/yyyy'); % Thanks, Pennsylvania USGS. Argo...
    elseif length(strfind(t1{1},'/'))>=2 && length(t1{1})<9
        t1=datenum(A{3},'mm/dd/yy'); % Thanks, Pennsylvania USGS. Argo...
    else
        t1=datenum(A{3},'yyyy-mm-dd'); % Most USGS time formats...
    end
    
    t2 = datenum(A{4},'HH:MM'); 
    t2 = t2 - (datenum('00:00','HH:MM')); %actually this is wrong, because I should convert between GMT and PDT, but it doesn't matter for the calculations I'm going to do here
    t = t1+t2;
    
    %% Dealing with data gaps (esp. those due to snow cover)
    if category ==1
        Ts = mode(diff(t));                           % Sampling Time
        f1 = Q;                     
        f2 = stage;
        tn = round(t/Ts);                       % Create Indices With Gaps

        dt = diff([0; tn]);                      % Create Vector Of Differences
        tg = find(dt > 1);                      % Find Indices Of Gaps
        gaps = dt(tg)-1;                        % Find Lengths Of Gaps

        t_contin = [min(t):Ts:max(t)];   % Create Continuous Time Vector
        % sometimes our time vectors aren't monitonically increasing (why? no idea)
            repeatt = diff(t)== 0;
        if max(repeatt)==1;
            f1_contin = interp1(t(~repeatt),f1(~repeatt),t_contin);                   % Create Matching Data Vector
            f2_contin = interp1(t(~repeatt),f2(~repeatt),t_contin); 
        else
            f1_contin = interp1(t,f1,t_contin);                   % Create Matching Data Vector
            f2_contin = interp1(t,f2,t_contin); 
        end
        % Overwrite original stage, depth, and time data
        stage = f2_contin';
        Q = f1_contin';
        t = t_contin';
    end
    %% 
    
    