
function [results] = analyseSP(i,constants,results);
	%Get the mean trace
	k = 3;
	%figure
	%hold on
	
	disp([num2str(i) ' trials ' num2str(length(results(i).trial))]);
	trace= [];
	latency = [];
	for j = 1:length(results(i).trial)
		trace(:,j) =  results(i).trial(j).spMovingRMS{k};
		latency(j) = results(i).trial(j).ResponseLatency{k};
		%plot(trace(:,j));
	end
	medianTrace = median(trace,2);
	results(i).meanLatency{k} = int32(round(mean(latency)));
	results(i).spMovingRMS{k} = medianTrace;
	results(i).bgSp{k} = mean(medianTrace(1:-constants.spVisualizationInit));
	%decreasingMEP = find(spMovingRMS >= 1.5*results(i).trial(j).backgroundEMG{k},1,'last');										%Find decreasing MEP
	results(i).silentPeriod{k} = NaN;
	%spInit = find(spMovingRMS(decreasingMEP:length(spMovingRMS)) <= 0.8*results(i).trial(j).backgroundEMG{k},1,'first');			%Find init of SP
	spInit = find(results(i).spMovingRMS{k}(results(i).meanLatency{k}+(-constants.spVisualizationInit):length(results(i).spMovingRMS{k}))<results(i).bgSp{k},1,'first');			%Find SP, should be where we have minimal RMS or SD
	if ~isempty(spInit)
		spInit = spInit +results(i).meanLatency{k}+(-constants.spVisualizationInit);
		spEnd = find(results(i).spMovingRMS{k}(spInit:length(results(i).spMovingRMS{k})) >= results(i).bgSp{k},1,'first');	%Find end of SP
		if ~isempty(spEnd)
			spEndInd = spInit+spEnd+constants.spVisualizationInit;
			results(i).silentPeriod{k} = spEndInd-results(i).meanLatency{k};
		end
	end
return