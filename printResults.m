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

%Function for printing out data to a results file
function printResults(results,constants,indices,dataFile)
	resultsFile = fopen([constants.resultsFolder dataFile(1:length(dataFile)-4) '.xls'],'w'); %Open file for writing
	%Print header row
	fprintf(resultsFile,'%s\t','File name');
	for i = 1:length(indices)	%Loop through conditions names
		%Background EMG
		fprintf(resultsFile,'%s\t%s\t',['Ch 1 500ms BG RMS ' constants.trialGroups{i}],['Ch 3 500ms BG RMS ' constants.trialGroups{i}]);
	end
	for i = 1:length(indices)	%Loop through conditions names
				%ResponseRMS
		fprintf(resultsFile,'%s\t%s\t',['Ch 1 MEP 30ms RMS ' constants.trialGroups{i}],['Ch 3 MEP 30ms RMS ' constants.trialGroups{i}]);
	end
	for i = 1:length(indices)	%Loop through conditions names
		%Response peak to peak
		fprintf(resultsFile,'%s\t%s\t',['Ch 1 MEP peak-to-peak ' constants.trialGroups{i}],['Ch 3MEP peak-to-peak ' constants.trialGroups{i}]);
	end
	for i = 1:length(indices)	%Loop through conditions names
		%Force fluctuation
		fprintf(resultsFile,'%s\t%s\t%s\t%s\t',['Ch 2 Mean ' constants.trialGroups{i}],['Ch 2 STDev ' constants.trialGroups{i}],['Ch 2 CV  ' constants.trialGroups{i}],['Ch 2 MDF  ' constants.trialGroups{i}]);
	end
	for i = 1:length(indices)	%Loop through conditions names
		%NORMALIZED RESULTS
		%Background EMG
		fprintf(resultsFile,'%s\t%s\t',['Ch 1 Normalized 500ms BG RMS ' constants.trialGroups{i}],['Ch 3 Normalized 500ms BG RMS ' constants.trialGroups{i}]);
	end
	for i = 1:length(indices)	%Loop through conditions names
		%ResponseRMS
		fprintf(resultsFile,'%s\t%s\t',['Ch 1 Normalized MEP 30ms RMS ' constants.trialGroups{i}],['Ch 3 Normalized MEP 30ms RMS ' constants.trialGroups{i}]);
	end
	for i = 1:length(indices)	%Loop through conditions names
		%Response peak to peak
		fprintf(resultsFile,'%s\t%s\t',['Ch 1 Normalized MEP peak-to-peak ' constants.trialGroups{i}],['Ch 3 Normalized MEP peak-to-peak ' constants.trialGroups{i}]);
	end
	
	%Inhibition RMS results
	for i = 1:length(constants.inhibitionResultTitlesRMS)	%Loop through conditions names
		%Response peak to peak
		fprintf(resultsFile,'%s\t%s\t',['Ch 1 Normalized MEP peak-to-peak ' constants.inhibitionResultTitlesRMS{i}],['Ch 3 Normalized MEP peak-to-peak ' constants.inhibitionResultTitlesRMS{i}]);
	end
	%Inhibition Peak to Peak results
	for i = 1:length(constants.inhibitionResultTitlesPtoP)	%Loop through conditions names
		%Response peak to peak
		fprintf(resultsFile,'%s\t%s\t',['Ch 1 Normalized MEP peak-to-peak ' constants.inhibitionResultTitlesPtoP{i}],['Ch 3 Normalized MEP peak-to-peak ' constants.inhibitionResultTitlesPtoP{i}]);
	end

	fprintf(resultsFile,'\n');
	
	%Get MAX M for normalization
	i = length(indices);	%M Max is the last trial group
	%RMS
	temp = [];
	for j = 1:length(results(i).trial)
		temp(j,1) = results(i).trial(j).ResponseRMS{1};	
		temp(j,2) = results(i).trial(j).ResponseRMS{3};
	end
	tempOut = mean(temp);
	normalize.MMaxRMS = tempOut;
	%peak to peak
	temp = [];
	for j = 1:length(results(i).trial)
		temp(j,1) = results(i).trial(j).ResponseAmplitude{1};	
		temp(j,2) = results(i).trial(j).ResponseAmplitude{3};
	end
	tempOut = mean(temp);
	normalize.MMaxAMP = tempOut;

	%Print results
	fprintf(resultsFile,'%s\t',dataFile);
	for i = 1:length(indices)	%Loop through conditions names
		%Background EMG
		temp = [];
		for j = 1:length(results(i).trial)
			temp(j,1) = results(i).trial(j).backgroundEMG{1};
			temp(j,2) = results(i).trial(j).backgroundEMG{3};
		end
		tempOut = mean(temp);
		if isnan(tempOut)
			fprintf(resultsFile,'%f\t%f\t',NaN,NaN);		
		else
			fprintf(resultsFile,'%f\t%f\t',tempOut(1),tempOut(2));
		end
	end
	for i = 1:length(indices)	%Loop through conditions names

		%ResponseRMS
		temp = [];
		for j = 1:length(results(i).trial)
			temp(j,1) = results(i).trial(j).ResponseRMS{1};	
			temp(j,2) = results(i).trial(j).ResponseRMS{3};
		end
		tempOut = mean(temp);
		if isnan(tempOut)
			fprintf(resultsFile,'%f\t%f\t',NaN,NaN);		
		else
			fprintf(resultsFile,'%f\t%f\t',tempOut(1),tempOut(2));
		end
	end
	for i = 1:length(indices)	%Loop through conditions names

		%Response peak to peak
		temp = [];
		for j = 1:length(results(i).trial)
			temp(j,1) = results(i).trial(j).ResponseAmplitude{1};	
			temp(j,2) = results(i).trial(j).ResponseAmplitude{3};
		end
		tempOut = mean(temp);
		if isnan(tempOut)
			fprintf(resultsFile,'%f\t%f\t',NaN,NaN);		
		else
			fprintf(resultsFile,'%f\t%f\t',tempOut(1),tempOut(2));
		end
	end
	for i = 1:length(indices)	%Loop through conditions names
		%Force fluctuation
		temp = [];
		for j = 1:length(results(i).trial)
			temp(j,1) = results(i).trial(j).forceMEAN;	
			temp(j,2) = results(i).trial(j).forceSTD;	
			temp(j,3) = results(i).trial(j).forceCV;
			temp(j,4) = results(i).trial(j).forceMDF;
		end
		tempOut = mean(temp);
		if isnan(tempOut)
			fprintf(resultsFile,'%f\t%f\t%f\t%f\t',NaN,NaN,NaN,NaN);		
		else
			fprintf(resultsFile,'%f\t%f\t%f\t%f\t',tempOut(1),tempOut(2),tempOut(3),tempOut(4));
		end
		
	end
	for i = 1:length(indices)	%Loop through conditions names
		%NORMALIZED RESULTS
		%Background EMG
		temp = [];
		for j = 1:length(results(i).trial)
			temp(j,1) = results(i).trial(j).backgroundEMG{1}/normalize.MMaxRMS(1)*100;
			temp(j,2) = results(i).trial(j).backgroundEMG{3}/normalize.MMaxRMS(2)*100;
		end
		tempOut = mean(temp);
		normalize.BGEMG = tempOut;
		if isnan(tempOut)
			fprintf(resultsFile,'%f\t%f\t',NaN,NaN);		
		else
			fprintf(resultsFile,'%f\t%f\t',tempOut(1),tempOut(2));
		end
	end
	for i = 1:length(indices)	%Loop through conditions names

		%ResponseRMS
		temp = [];
		for j = 1:length(results(i).trial)
			temp(j,1) = results(i).trial(j).ResponseRMS{1}/normalize.MMaxRMS(1)*100;	
			temp(j,2) = results(i).trial(j).ResponseRMS{3}/normalize.MMaxRMS(2)*100;
		end
		tempOut = mean(temp);
		normalize.MEPRMS{i} = tempOut;
		if isnan(tempOut)
			fprintf(resultsFile,'%f\t%f\t',NaN,NaN);		
		else
			fprintf(resultsFile,'%f\t%f\t',tempOut(1),tempOut(2));
		end
	end
	for i = 1:length(indices)	%Loop through conditions names

		%Response peak to peak
		temp = [];
		for j = 1:length(results(i).trial)
			temp(j,1) = results(i).trial(j).ResponseAmplitude{1}/normalize.MMaxAMP(1)*100;	
			temp(j,2) = results(i).trial(j).ResponseAmplitude{3}/normalize.MMaxAMP(2)*100;
		end
		tempOut = mean(temp);
		normalize.MEPAMP{i} = tempOut;
		if isnan(tempOut)
			fprintf(resultsFile,'%f\t%f\t',NaN,NaN);		
		else
			fprintf(resultsFile,'%f\t%f\t',tempOut(1),tempOut(2));
		end
		
	end

	%Inhibition RMS results..
	for i = 1:length(constants.inhibitionResultTitlesRMS)	%Loop through conditions names
		if isnan(normalize.MEPRMS{i})
			fprintf(resultsFile,'%f\t%f\t',NaN,NaN);		
		else
			for j = 1:2
				tempOut(j) =(1-normalize.MEPRMS{i}(j)/normalize.MEPRMS{i+length(constants.inhibitionResultTitlesRMS)}(j))*100.0;
			end
			fprintf(resultsFile,'%f\t%f\t',tempOut(1),tempOut(2));
		end
	end
	%Inhibition PtoP results..
	for i = 1:length(constants.inhibitionResultTitlesRMS)	%Loop through conditions names
		if isnan(normalize.MEPAMP{i})
			fprintf(resultsFile,'%f\t%f\t',NaN,NaN);		
		else
			for j = 1:2
				tempOut(j) =(1-normalize.MEPAMP{i}(j)/normalize.MEPAMP{i+length(constants.inhibitionResultTitlesRMS)}(j))*100.0;
			end

			fprintf(resultsFile,'%f\t%f\t',tempOut(1),tempOut(2));
		end
	end

	fprintf(resultsFile,'\n');	%Print new line
	fclose(resultsFile);		%Close file
return
