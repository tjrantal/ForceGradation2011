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
function printForceResults(results,constants,indices,dataFile)
	resultsFile = fopen([constants.resultsFolder dataFile(1:length(dataFile)-4) '.xls'],'w'); %Open file for writing
	%Print header row
	fprintf(resultsFile,'%s\t%s\n','File name','MVC [Nm]');
	fprintf(resultsFile,'\n');
	fprintf(resultsFile,'%s\t',dataFile);
	for i = 1:length(indices)	%Loop through conditions names
		%MVC
		temp = [];
		for j = 1:length(results(i).trial)
			temp(j) = results(i).trial(j).MVC;
		end
		tempOut = mean(temp);
		fprintf(resultsFile,'%f\t',tempOut);
	end
	
	fprintf(resultsFile,'\n');
	fclose(resultsFile);		%Close file
return
