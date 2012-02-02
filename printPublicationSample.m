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
function printPublicationSample(data,results,constants,indices,dataFile)

	figureToPlotTo = figure;
	set(figureToPlotTo,'position',[10 10 1200 1200],'visible','off');
	for k = 1:6
		subFigureToPlotTo(k) = subplot(3,2,k);
	end
	%Loop through to visualize the data...
	plotTo = 0;
	figureOrder = [2,4,6,1,3,5];
	for i = [2 4]	%Loop through the overlay pairs
		for k = 1:size(constants.overlayPairMatrix,2)
			for t = [3]
				plotTo = plotTo +1;
				set(figureToPlotTo,'currentaxes',subFigureToPlotTo(figureOrder(plotTo)) );
				hold on;
				%First data
				for j = 1:length(indices(constants.overlayPairMatrix(1,k,i)).index)
					plot(results(constants.overlayPairMatrix(1,k,i)).trial(j).visualizationTrace{t},'color',[0.5 0.5 0.5])
					plot(-constants.visualizationInit+results(constants.overlayPairMatrix(1,k,i)).trial(j).ResponseLatency{t}:-constants.visualizationInit+results(constants.overlayPairMatrix(1,k,i)).trial(j).ResponseLatency{t}+constants.rmsEpoc
						,results(constants.overlayPairMatrix(1,k,i)).trial(j).visualizationTrace{t}(-constants.visualizationInit+results(constants.overlayPairMatrix(1,k,i)).trial(j).ResponseLatency{t}:-constants.visualizationInit+results(constants.overlayPairMatrix(1,k,i)).trial(j).ResponseLatency{t}+constants.rmsEpoc),'color',[0 0 0]);
				end
				%Overlay data
				for j = 1:length(indices(constants.overlayPairMatrix(2,k,i)).index)
					%Plot dashed line manually...
					step =5;
					for p = 1:step:length(results(constants.overlayPairMatrix(2,k,i)).trial(j).visualizationTrace{t})-step+1
						plot(p:(p+step-2),results(constants.overlayPairMatrix(2,k,i)).trial(j).visualizationTrace{t}(p:(p+step-2)),'color',[0.5 0.5 0.5])
					end
				end
				title([constants.forceLevels{k} constants.overlayTitles{i}]);
				box;
			end
		end
		
	end											
	print('-dpng',['-S' num2str(1200) ',' num2str(1200)],[constants.publicationSamples constants.separator dataFile(1:length(dataFile)-4) '_0_' constants.overlayTitles{i} '_' num2str(i) '.png']);
	close(figureToPlotTo);

return
