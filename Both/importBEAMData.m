function [importedData, fileName] = importBEAMData(filename, dataLines)
%% Input handling

% If dataLines is not specified, define defaults
if nargin < 2
    dataLines = [2, Inf];
end

%% Set up the Import Options and import the data
opts = delimitedTextImportOptions("NumVariables", 6);

% Specify range and delimiter
opts.DataLines = dataLines;
opts.Delimiter = ",";

% Specify column names and types
opts.VariableNames = ["Header", "Right_Eye_X", "Right_Eye_Y", "Right_Eye_Radius", "Right_Eye_Found", "Left_Eye_X", "Left_Eye_Y", "Left_Eye_Radius", "Left_Eye_Found" "Time_s"];
opts.VariableTypes = ["string", "double", "double", "double", "double" "double", "double", "double", "double" "double"];

% Specify file level properties
opts.ExtraColumnsRule = "ignore";
opts.EmptyLineRule = "read";

% Specify variable properties
opts = setvaropts(opts, "Header", "WhitespaceRule", "preserve");
opts = setvaropts(opts, "Header", "EmptyFieldRule", "auto");

% Import the data
importedData = readtable(filename, opts, 'ReadVariableNames',true);
fileName = filename(1:strfind(filename, '_17')-1);
end
