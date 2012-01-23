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

%Function for grouping trials according to hard coded trial names and corresponding rows of data in 
%Protocol file. Last column of data is the number of data page corresponding to the trial
function [indices] = groupTrials(protocolData,constants)
	trialColumn = size(protocolData,1)
	for i = 1:length(constants.trialGroups)	%Loop through trial names to get the corresponding indices
		foundIndices = 0;
		for j  = 1:size(protocolData,2)
			if ~(isempty(findstr(protocolData{2,j},constants.trialGroups{i}))) 	%If trial name matches a row in file -> add to indices list
				foundIndices = foundIndices+1;
				indices(i).index(foundIndices) =str2num(protocolData{trialColumn,j});
			end
		end
	end
return
