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

%Function for reading tab separated text file
function [protocolData] = readProtocolFile(protocolFullFileName)
	protocolFile = fopen(protocolFullFileName,'r');
	protocolData = {};
	rows = 0;
	while (dataRow = fgetl(protocolFile) ) ~= -1
		rows = rows+1;
		values = strsplit(dataRow,"\t");
		for i = 1:length(values)
			protocolData{i,rows} =values{i};
		end	
	end
	fclose(protocolFile);
return
