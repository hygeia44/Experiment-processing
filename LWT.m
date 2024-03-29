function LWT = LWT(filename, startRow, endRow)
%IMPORTFILE Import numeric data from a text file as column vectors.
%   N3_UA_A_ASC_AORTA_CIRC = IMPORTFILE(FILENAME) Reads data from text file
%   FILENAME for the default selection.
%
%   N3_UA_A_ASC_AORTA_CIRC = IMPORTFILE(FILENAME, STARTROW, ENDROW) Reads
%   data from rows STARTROW through ENDROW of text file FILENAME.
%
% Example:
%   N3_UA_A_Asc_Aorta_Circ = importfile('N3_UA_A_Asc_Aorta_Circ.csv',3, 5);
%
%    See also TEXTSCAN.

% Auto-generated by MATLAB on 2019/02/21 12:31:58

%% Initialize variables.
delimiter = ',';
if nargin<=2
    startRow = 3;
    endRow = 5;
end

%% Format string for each line of text:
%   column2: double (%f)
% For more information, see the TEXTSCAN documentation.
formatSpec = '%*s%f%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%*s%[^\n\r]';

%% Open the text file.
fileID = fopen(filename,'r');

%% Read columns of data according to format string.
% This call is based on the structure of the file used to generate this
% code. If an error occurs for a different file, try regenerating the code
% from the Import Tool.
dataArray = textscan(fileID, formatSpec, endRow(1)-startRow(1)+1, 'Delimiter', delimiter, 'HeaderLines', startRow(1)-1, 'ReturnOnError', false);
for block=2:length(startRow)
    frewind(fileID);
    dataArrayBlock = textscan(fileID, formatSpec, endRow(block)-startRow(block)+1, 'Delimiter', delimiter, 'HeaderLines', startRow(block)-1, 'ReturnOnError', false);
    dataArray{1} = [dataArray{1};dataArrayBlock{1}];
end

%% Close the text file.
fclose(fileID);

%% Post processing for unimportable data.
% No unimportable data rules were applied during the import, so no post
% processing code is included. To generate code which works for
% unimportable data, select unimportable cells in a file and regenerate the
% script.

%% Allocate imported array to column variable names
LWT = dataArray{:, 1};


