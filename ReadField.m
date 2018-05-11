function [t,Q,stage,ChanQ,w,Achan,v]= ReadField(file)%
%% note current problem: column order seems to be different in WA...? Maybe? Only getting stage and Q for now. Check....


    id=fopen(file); %Open the file "F"
    A=textscan(id,'%*s %*s %*s %s %*s %*s %*s %*s %s %s %*s %*s %*s %*s %*s %*s %*s %*s %*s %*s %s %s %s %s %*s %*s %*s %*s %*s %*s %*s %*s %*s %*s %*s', 'Delimiter','\t','headerlines',2,'CommentStyle','#');    
    fclose(id); %Closes out the file
    
    t1 = A{1}(3:end);
    t1 = cellstr(t1);
    
    if length(strfind(t1{1},'/'))>=2 && length(t1{1})>=9
        t1=datenum(t1,'mm/dd/yyyy'); % Thanks, Pennsylvania USGS. Argo...
    elseif length(strfind(t1{1},'/'))>=2 && length(t1{1})<9
        t1=datenum(t1,'mm/dd/yy'); % Thanks, Pennsylvania USGS. Argo...
    else
        t1=datenum(t1,'yyyy-mm-dd'); % Most USGS time formats...
    end

    t = t1;
    
    Q = A{3}(3:end); % Curly bracket means cell. A{3} 
    Q = str2double(Q);
    stage=A{2}(3:end); 
    stage = str2double(stage);
    
    ChanQ = A{4}(3:end); % How does this differ from Q??
    ChanQ = str2double(ChanQ);
    w = A{5}(3:end);
    w = str2double(w);
    Achan = A{6}(3:end);
    Achan = str2double(Achan);
    v = A{7}(3:end);
    v = str2double(v);
    
    
 