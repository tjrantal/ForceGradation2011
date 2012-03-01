
function [results] = analyseSP(i,constants,results);
	%Get the mean trace
	k = 3;
	%figure
	%hold on
	
	disp([num2str(i) ' trials ' num2str(length(results(i).trial))]);
	trace= [];
	latency = [];
	for j = 1:length(results(i).trial)
		trace(:,j) =  sqrt((results(i).trial(j).trialTrace{k}(1:1201)).^2);
		latency(j) = results(i).trial(j).ResponseLatency{k};
		%plot(trace(:,j));
	end
	sdTrace = std(trace,0,2);
	meanTrace = mean(trace,2);
	sumTrace = sum(trace,2);
	results(i).meanLatency{k} = int32(round(mean(latency)));
	%plot(sdTrace,'r');
	%plot(meanTrace,'r');
	%plot(sumTrace,'r');
	%set(gcf,'position',[10 10 800 300]);
	%Analyse silent period. Find out 100 ms BG EMG prior to trigger. End of SP is when EMG returns to 90% of the BG
	%results(i).trial(j).silentBG{k} = sqrt(mean(tempData(constants.trigger-constants.silentPeriodEpoc:constants.trigger-1).^2)); %500 ms RMS window up to trigger
	results(i).silentBG{k} = std(sumTrace(constants.trigger+constants.backroundEpoc:constants.trigger-1)); %500 ms RMS window up to trigger
	spMovingRMS = [];
	for l = constants.trigger+constants.spVisualizationInit:constants.trigger+150
			%spMovingRMS(l) = sqrt(mean(tempData(l:l+constants.silentPeriodEpoc-1).^2));
			spMovingRMS(l-constants.trigger-constants.spVisualizationInit+1) = std(sumTrace(l:l+constants.silentPeriodEpoc-1));
	end
	results(i).spMovingRMS{k} = spMovingRMS;
	%decreasingMEP = find(spMovingRMS >= 1.5*results(i).trial(j).backgroundEMG{k},1,'last');										%Find decreasing MEP
	results(i).silentPeriod{k} = NaN;
	%spInit = find(spMovingRMS(decreasingMEP:length(spMovingRMS)) <= 0.8*results(i).trial(j).backgroundEMG{k},1,'first');			%Find init of SP
	[discard spInit] = min(spMovingRMS);			%Find SP, should be where we have minimal RMS or SD
	if spInit > results(i).meanLatency{k}
		spEnd = find(spMovingRMS(spInit:length(spMovingRMS)) >= 0.95*results(i).silentBG{k},1,'first');	%Find end of SP
		if ~isempty(spEnd)
			spEndInd = spInit+spEnd+constants.spVisualizationInit;
			results(i).silentPeriod{k} = spEndInd-results(i).meanLatency{k};
		end
	end
return