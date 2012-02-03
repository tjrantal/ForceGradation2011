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

	%Get scaling limits here...
	minVals = [];	%Save min and max EMG values here...
	maxVals = [];	%Save min and max EMG values here...
	for i = [2 4]	%Loop through the overlay pairs
		for k = 1:size(constants.overlayPairMatrix,2)
			for t = [3]
				for j = 1:length(indices(constants.overlayPairMatrix(1,k,i)).index)
					responseIndices = -constants.visualizationInit+results(constants.overlayPairMatrix(1,k,i)).trial(j).ResponseLatency{t}:-constants.visualizationInit+results(constants.overlayPairMatrix(1,k,i)).trial(j).ResponseLatency{t}+constants.rmsEpoc;
					minVal = min(results(constants.overlayPairMatrix(1,k,i)).trial(j).visualizationTrace{t});
					maxVal = max(results(constants.overlayPairMatrix(1,k,i)).trial(j).visualizationTrace{t});
					minVals = cat(2,minVals,minVal);
					maxVals = cat(2,maxVals,maxVal);
				end
				for j = 1:length(indices(constants.overlayPairMatrix(2,k,i)).index)
					responseIndices = -constants.visualizationInit+results(constants.overlayPairMatrix(2,k,i)).trial(j).ResponseLatency{t}:-constants.visualizationInit+results(constants.overlayPairMatrix(2,k,i)).trial(j).ResponseLatency{t}+constants.rmsEpoc;
					minVal = min(results(constants.overlayPairMatrix(2,k,i)).trial(j).visualizationTrace{t});
					maxVal = max(results(constants.overlayPairMatrix(2,k,i)).trial(j).visualizationTrace{t});
					minVals = cat(2,minVals,minVal);
					maxVals = cat(2,maxVals,maxVal);
				end
			end
		end
	end
	yScale = [min(minVals) max(maxVals)]*1.05;
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
					responseIndices = -constants.visualizationInit+results(constants.overlayPairMatrix(1,k,i)).trial(j).ResponseLatency{t}:-constants.visualizationInit+results(constants.overlayPairMatrix(1,k,i)).trial(j).ResponseLatency{t}+constants.rmsEpoc;
					plot(responseIndices,results(constants.overlayPairMatrix(1,k,i)).trial(j).visualizationTrace{t}(responseIndices),'color',[0 0 0]);
				end
				%Overlay data
				for j = 1:length(indices(constants.overlayPairMatrix(2,k,i)).index)
					responseIndices = -constants.visualizationInit+results(constants.overlayPairMatrix(2,k,i)).trial(j).ResponseLatency{t}:-constants.visualizationInit+results(constants.overlayPairMatrix(2,k,i)).trial(j).ResponseLatency{t}+constants.rmsEpoc;
					%Plot dashed line manually...
					step =5;

					for p = 1:step:length(results(constants.overlayPairMatrix(2,k,i)).trial(j).visualizationTrace{t})-step+1
						paintBlack = [];
						plotIndices = p:(p+step-2);
						for pb =  plotIndices
							if ~isempty(find(responseIndices == pb))
								paintBlack = cat(2,paintBlack, pb);
							end
						end
						plot(plotIndices,results(constants.overlayPairMatrix(2,k,i)).trial(j).visualizationTrace{t}(plotIndices),'color',[0.5 0.5 0.5])
						if ~isempty(paintBlack)
							plot(paintBlack,results(constants.overlayPairMatrix(2,k,i)).trial(j).visualizationTrace{t}(paintBlack),'color',[0 0 0]);%,'linewidth',2)
						end
				
					end

				end
				%Figure out suitable yScale...
				lisa = mod(floor(min(yScale))-ceil(max(yScale)),4);
				%gset arrow from 20,20 to 20,0
				quiver(20,7,0,-3,'linewidth',2,'color',[0 0 0]);
				quiver(23,7,0,-3,'linewidth',2,'color',[0.5 0.5 0.5]);
				set(gca,'xtick',[0:20:constants.visualizationEpoc],'xticklabel',[constants.visualizationInit:20:constants.visualizationInit+constants.visualizationEpoc],
				
				'ytick', [floor(min(yScale)):4:ceil(max(yScale))+lisa],
				'fontsize',24);
				title([constants.forceLevels{k} constants.overlayTitles{i}],'fontsize',24);
				box;
				axis([0 constants.visualizationEpoc yScale(1) yScale(2)]);
				xlabel('time [ms]','fontsize',24);
				ylabel('Biceps Brachii EMG [mV]','fontsize',24);
				
			end
		end
		
	end											
	print('-dgif',['-S' num2str(1200) ',' num2str(1200)],[constants.publicationSamples constants.separator dataFile(1:length(dataFile)-4) '_0_' constants.overlayTitles{i} '.gif']);
	close(figureToPlotTo);

return
