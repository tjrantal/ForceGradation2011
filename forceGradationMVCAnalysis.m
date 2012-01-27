%	This program is free software: you can redistribute it and/or modify
%    it under the terms of the GNU General Public License as published by
%    the Free Software Foundation, either version 3 of the License, or
%    (at your option) any later version.
%
%    This program is distributed in the hope that it will be useful,
%    but WITHOUT ANY WARRANTY; without even the implied warranty of
%    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
%    GNU General Public License for more details.
%
%    You should have received a copy of the GNU General Public License
%   along with this program.  If not, see <http://www.gnu.org/licenses/>.
%
%	N.B.  the above text was copied from http://www.gnu.org/licenses/gpl.html
%	unmodified. I have not attached a copy of the GNU license to the source...
%
%    Copyright (C) 2011-2012 Timo Rantalainen tjrantal@gmail.com

%% Octave/Matlab script to analyse MEPs for the force gradation project. Written by Timo Rantalainen 2011 

setenv("GSC","GSC"); %To get rid of annoying error messages, when printing images...
clear all;
close all;
%HARD CODED CONSTANTS saved in constants structure %headings = fieldnames(data);
constants.forceEpoc = 500;
constants.forceScaling = 9.8*1.356;		%Force scaling
constants.baseFolder = 'H:\UserData\winMigrationBU\Deakin\TMS_KIDGELL2011';
constants.baseFolder = '/media/sf_Deakin/TMS_KIDGELL2011';
separator = '\';
separator = '/';
constants.visualizationFolder =[constants.baseFolder separator 'forceResultImages' separator];
constants.resultsFolder = [constants.baseFolder separator 'forceResults' separator];
constants.dataFolder =[constants.baseFolder separator 'Data' separator];
cd(constants.baseFolder);
constants.visualizationTitles= {'Force'};

%Get MVC page (added manually to protocols...)
constants.trialGroups = {'MVC'};
%Read pages from tab separated txt file
constants.protocolFilePath =  [constants.baseFolder separator 'Protocols'];
constants.protocolFiles = dir(constants.protocolFilePath);

%List data files
constants.dataFiles = dir(constants.dataFolder);

%Loop through files..	DEBUG p =6 p = 4 p = 12
for p = 3:length(constants.dataFiles)
	%Reading the data
	protocolFullFileName = [constants.protocolFilePath separator constants.protocolFiles(p).name];
	dataFile = [constants.dataFolder constants.dataFiles(p).name];
	%Check that we have a matching data file. If not, do nothing and go to next file...
	try
		data = load(dataFile);
		data.data = data.data.*1000.0;		%Change V to mV
		disp(['Analysing ' dataFile])
		continueAnalysis =1;
	catch	
		disp(['Data file not found ' dataFile])
		continueAnalysis = 0;
	end
	if continueAnalysis ==1	%Do nothing unless a corresponding data file was found ...
		%Go through the data
		clear protocolData;	%May be unnecessary, as a function is used to create the var...
		protocolData = readProtocolFile(protocolFullFileName);	%Read data from protocol file
		%Find indices for trials to be grouped
		clear indices;		%May be unnecessary, as a function is used to create the var...
		indices = groupTrials(protocolData,constants);	%Group trials according to the hardcoded trial names and corresponding names in protocol files
		clear results;		%May be unnecessary, as a function is used to create the var...
		%DEBUG 
		results = analyseForceData(data,constants,indices);
		%Print results out
		printForceResults(results,constants,indices,constants.dataFiles(p).name);
		%Visualize the data
		figureToPlotTo = figure;
		set(figureToPlotTo,'position',[10 10 1200 1200],'visible','off');%'on');%
		hold on;
		for t = 1:length(results(1).trial)
			plot(results(1).trial(t).forceTrace,'b');
			plot(results(1).trial(t).interestingIndices,results(1).trial(t).forceTrace(results(1).trial(t).interestingIndices),'g');
			plot(results(1).trial(t).selectedEpocIndex:results(1).trial(t).selectedEpocIndex+constants.forceEpoc,results(1).trial(t).forceTrace(results(1).trial(t).selectedEpocIndex:results(1).trial(t).selectedEpocIndex+constants.forceEpoc),'r');
		end
		title('Force Trace');
		print('-dpng',['-S' num2str(1200) ',' num2str(1200)],[constants.visualizationFolder constants.dataFiles(p).name(1:length(constants.dataFiles(p).name)-4) '_MVC_' num2str(i) '.png']);
		close(figureToPlotTo);
	end	%Come all the way down here, if the data file does not exist...
end %Get next file to analyse
close all;
clear all;

