function [protocolSampleData] = readprotocolFileSample(protocolFullFileName)
	protocolFileSample = fopen(protocolFullFileName,'r');
	protocolSampleData = {};
	rows = 0;
	while (dataRow = fgetl(protocolFileSample)) ~= -1	%Changed fget1 to fgetl (i.e. corrected a typo)
	rows = rows+1;
	splitString = strsplit(dataRow, "\t");	%Added trailing ) and changed values variable to splitString (values is a function name and consequently didn't work as a var name)
	for i = 1:length(splitString)
		protocolSampleData{i,rows} =splitString{i};
		end
	end
	fclose(protocolFileSample);	%Changed protocolSampleData to protocolFileSample.
return
