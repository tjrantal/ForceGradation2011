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
constants.trigger = 1000;	%Occurrence of trigger in data points
constants.backroundEpoc = -500;
constants.rmsDelay = 20;	
constants.rmsEpoc = 30;
constants.amplitudeDelay = 10;
constants.amplitudeEpoc =30;	%Used to be 40
constants.visualizationInit = -100;
constants.visualizationEpoc = 200;
constants.samplingRate = 1000;	%Hz
constants.channelDelays =  [0,-200,0];	%EMGs have a delay compared to force...
constants.baseFolder = 'H:\UserData\winMigrationBU\Deakin\TMS_KIDGELL2011';
constants.baseFolder = '/media/sf_Deakin/TMS_KIDGELL2011';
separator = '\';
constants.scriptFolder = [constants.baseFolder separator 'octaveAnalysisScripts'];
cd(constants.scriptFolder);
%separator = '/';
constants.visualizationFolder =[constants.baseFolder separator 'resultImages'];
constants.resultsFolder = [constants.baseFolder separator 'results' separator];

constants.dataFolder =[constants.baseFolder separator 'Data' separator];
%Hard coded trial names to find
constants.trialGroups = {'Skilled 5% Paired','Skilled 20% Paired','Skilled 40% Paired', ...
 	'Unskilled 5% Paired', 'Unskilled 20% Paired','Unskilled 40% Paired', ...
 	'Skilled 5% Single','Skilled 20% Single','Skilled 40% Single', ...
 	'Unskilled 5% Single','Unskilled 20% Single','Unskilled 40% Single', ...
 	'Max'};

constants.visualizationTitles= {'Skilled_5_Paired','Skilled_20_Paired','Skilled_40_Paired','Unskilled_5_Paired', ...
	'Unskilled_20_Paired','Unskilled_40-Paired','Skilled_5_Single','Skilled_20_Single', ...
	'Skilled_40_Single','Unskilled_5_Single','Unskilled_20_Single','Unskilled_40_Single','Max_M'};
	
constants.inhibitionResultTitlesRMS = {'Normalized RMS Skilled 5%', 'Normalized RMS Skilled 20%', 'Normalized RMS Skilled 40%', 'Normalized RMS UnSkilled 5%', 'Normalized RMS UnSkilled 20%', 'Normalized RMS UnSkilled 40%'};
constants.inhibitionResultTitlesPtoP = {'Normalized peak-to-peak Skilled 5%', 'Normalized peak-to-peak Skilled 20%', 'Normalized peak-to-peak Skilled 40%', 'Normalized peak-to-peak UnSkilled 5%', 'Normalized peak-to-peak UnSkilled 20%', 'Normalized peak-to-peak UnSkilled 40%'};
%Read pages from tab separated txt file
constants.protocolFilePath =  [constants.baseFolder separator 'Protocols'];
constants.protocolFiles = dir(constants.protocolFilePath);

%Visualizeoverlays, manual plotting..
constants.overlayTitles = {'Skilled Paired Unskilled Paired','Skilled Paired Skilled Single', ...
	'Skilled Single Unskilled Single','Unskilled Paired Unskilled Single'};

constants.forceLevels = {'5% ','20% ','40% '};

constants.overlayPairMatrix	= [1,2,3;4,5,6];		%Skilled paired unskilled paired
constants.overlayPairMatrix(:,:,2)	= [1,2,3;7,8,9];		%Skilled paired skilled single
constants.overlayPairMatrix(:,:,3)	= [7,8,9;10,11,12];	%Skilled single unskilled single
constants.overlayPairMatrix(:,:,4)	= [4,5,6;10,11,12];	%Unskilled paired unskilled single

%Loop through files..	DEBUG p = 6 p =5 p = 12 p = 4
for p = 3:length(constants.protocolFiles)
	%Reading the protocol text file
	protocolFullFileName = [constants.protocolFilePath separator constants.protocolFiles(p).name];
	dataFile = [constants.protocolFiles(p).name(1:length(constants.protocolFiles(p).name)-4) '.mat'];
	%Check that we have a matching data file. If not, do nothing and go to next file...
	try
		data = load([constants.dataFolder dataFile]);
		data.data = data.data.*1000.0;		%Change V to mV
		disp(['Analysing ' dataFile])
		continueAnalysis =1;
	catch	
		disp(['Data file not found ' dataFile])
		continueAnalysis = 0;
	end
	if continueAnalysis ==1	%Do nothing unless a corresponding data file was found ...
		%Read protocol data
		clear protocolData;	%May be unnecessary, as a function is used to create the var...
		protocolData = readProtocolFile(protocolFullFileName);	%Read data from protocol file
		%Find indices for trials to be grouped
		clear indices;		%May be unnecessary, as a function is used to create the var...
		indices = groupTrials(protocolData,constants);	%Group trials according to the hardcoded trial names and corresponding names in protocol files
		%Go through the data
		clear results;		%May be unnecessary, as a function is used to create the var...
		results = analyseData(data,constants,indices);
		%Debug 
		%figure;,hold on;,k = 1;
		% plot(results(13).trial(k).visualizationTrace{3}) ,k = k+1;
		%figure;,hold on
		%for k = [4 7 8 9]
		%	plot(results(13).trial(k).visualizationTrace{3})
		%end
		%Print results out
		printResults(results,constants,indices,dataFile);
		%Visualize the data
		printTrialGroupImages(data,results,constants,indices,dataFile);
		%Visualizeoverlays, manual plotting..
		printVisualOverlays(data,results,constants,indices,dataFile);
	end	%Come all the way down here, if the data file does not exist...
	clear data results indices;
end %Get next file to analyse
close all;
clear all;
