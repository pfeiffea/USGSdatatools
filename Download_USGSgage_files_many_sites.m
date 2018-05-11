%% %%%%%%%%%%%%%%%%%%%%%%%%%%%

% The goal of this code is to download and save the following data for many
% USGS gage sites: Field data, rating curve, continuous (15 min) discharge
% data. Note that some (especially defunct) gages don't have continuous 
% data records. 

% WARNING: Original units! No conversions made!

% Allison Pfeiffer, Winter 2018

%% User directions: 
 
% make a tab delimited text file with one header line, site name (no
% spaces) in the first column, and USGS gage number in the second column. 
% Save this as SiteData.txt, in the same folder as this code. 

% e.g. 
%
% sitename   gagenum
% MiddleFkSnoq    12141300
% CarbonNrFairfax    12094000
%

%%
clear

% Open master site list...
    id=fopen('SiteData.txt'); %Open the file "F"
    A=textscan(id,'%s %s', 'Delimiter','\t','headerlines',1);    
    fclose(id); %Closes out the file
    SiteNames = A{1};
    StationNum = A{2};
    
%%    
    
for i = 1:length(StationNum) 
    name = string(SiteNames{i});
    stationnum = string(StationNum{i});

%% Download field data, save file
filename = strcat(name,'_Field.txt');
url = strcat('https://nwis.waterdata.usgs.gov/nwis/measurements?site_no=',stationnum,'&agency_cd=USGS&format=rdb_expanded');
 options = weboptions('Timeout',Inf);

outfilename = websave(filename,url,options);

%% Download rating curve, save file
filename = strcat(name,'_RatingCurve.txt');
url = strcat('https://nwis.waterdata.usgs.gov/nwisweb/data/ratings/exsa/USGS.',stationnum,'.exsa.rdb');
% or
url = strcat('https://waterdata.usgs.gov/nwisweb/get_ratings?site_no=',stationnum,'&file_type=exsa');
outfilename = websave(filename,url,options);

%% Download 'continuous' discharge data, save file

filename = strcat(name,'_NWIS.txt');
url = strcat(...
    'https://nwis.waterdata.usgs.gov/usa/nwis/uv/?cb_00010=on&cb_00060=on&cb_00065=on&format=rdb&site_no=',...
    stationnum,...
    '&period=&begin_date=1950-10-01&end_date=2018-05-10');

outfilename = websave(filename,url,options);


end

