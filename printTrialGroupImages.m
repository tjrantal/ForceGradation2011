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

%Function for printing out result images
function printTrialGroupImages(data,results,constants,indices,dataFile)
	for i = 1:length(indices)	%Loop through conditions names
		figureToPlotTo = figure;
		set(figureToPlotTo,'position',[10 10 1200 1200],'visible','off');
		for k = 1:size(data.titles,1)+1
			subFigureToPlotTo(k) = subplot(ceil(sqrt(size(data.titles,1))),ceil(sqrt(size(data.titles,1))),k);
		end
		%Loop through to visualize the data...
		for k = 1:size(data.titles,1)
			set(figureToPlotTo,'currentaxes',subFigureToPlotTo(k) );
			hold on;
			for j = 1:length(indices(i).index)	%Loop through trials
				if k == 2
					%Plot force trace
					set(figureToPlotTo,'currentaxes',subFigureToPlotTo(k) );
					hold on;
					plot(results(i).trial(j).trace{k},'b')
					fIndices =constants.trigger+constants.backroundEpoc+constants.channelDelays(k):constants.trigger-1+constants.channelDelays(k);									plot(fIndices, results(i).trial(j).trace{k}(fIndices),'r')
					
					%Plot power spectrum
					set(figureToPlotTo,'currentaxes',subFigureToPlotTo(k+2) );
					hold on;
					freqIndicesToPlot = find(results(i).trial(j).forcePowerSpectrumFreqs <= 40);
					plot(results(i).trial(j).forcePowerSpectrumFreqs(freqIndicesToPlot),results(i).trial(j).forcePowerSpectrum(freqIndicesToPlot),'b')
				else
					plot(results(i).trial(j).visualizationTrace{k},'b')
					plot(-constants.visualizationInit+results(i).trial(j).ResponseLatency{k}:-constants.visualizationInit+results(i).trial(j).ResponseLatency{k}+constants.rmsEpoc
						,results(i).trial(j).visualizationTrace{k}(-constants.visualizationInit+results(i).trial(j).ResponseLatency{k}:-constants.visualizationInit+results(i).trial(j).ResponseLatency{k}+constants.rmsEpoc),'r')
					
				end
			end
			title(constants.visualizationTitles{i});
		end
											
		print('-dpng',['-S' num2str(1200) ',' num2str(1200)],[constants.visualizationFolder '\'  dataFile(1:length(dataFile)-4) '_' constants.trialGroups{i} '_' num2str(i) '.png']);
		close(figureToPlotTo);
	end
return
