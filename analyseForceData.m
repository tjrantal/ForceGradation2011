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

%Function for analysing the MVC force data
function [results] = analyseForceData(data,constants)
	forceTrace = data.data(data.datastart(2,1):data.dataend(2,1));	%force is on channel 2 and MVC is always page 1
	zeroLevel = median(forceTrace);
	forceTrace = forceTrace -zeroLevel;
	results.forceTrace = forceTrace;
	forceTrigger = max(forceTrace)/2;
	results.interestingIndices = find(forceTrace > forceTrigger);
	interestingData = forceTrace(results.interestingIndices);
	MVC = 0
	for i =1:length(interestingData)-constants.forceEpoc
		if mean(interestingData(i+constants.forceEpoc)) > MVC
			MVC = mean(interestingData(i:i+constants.forceEpoc)) ;
			selectedEpoc = i;
		end		
	end
	results.MVC = MVC;
	results.selectedEpocIndex = results.interestingIndices(selectedEpoc);
	
return