function [Q,stage]= ReadRatingCurve(F)
%%
    id=fopen(F); %Open the file "F"
    A=textscan(id,'%s %s %s %s','CommentStyle','#','headerlines',2);%read each line to figure out which is string, number, etc
    fclose(id); %Closes out the file
    
    Q = A{3}(3:end);% Curly bracket means cell. A{3} 
    Q = str2double(Q);
    stage=A{1}(3:end);
    stage = str2double(stage);
    
    clear A id F 
    

    
    