% plot(results(3).trial(4).spMovingRMS{3})
%plot(results(3).trial(4).trialTrace{3})
%set(gcf,'position',[10 10 800 300])

%plot(results(9).trial(4).trialTrace{3})
%set(gcf,'position',[10 10 800 300])

function [results] = analyseEMG(i,j,k,constants,tempData,results)
	results(i).trial(j).backgroundEMG{k} = sqrt(mean(tempData(constants.trigger+constants.backroundEpoc:constants.trigger-1).^2)); %500 ms RMS window up to trigger
	
	%Use amplitude peaks to figure out RMS epoc position
	[temp(1) ind(1)] = max(tempData(constants.trigger+constants.amplitudeDelay:constants.trigger+constants.amplitudeDelay+constants.amplitudeEpoc)); %Max value from 80 ms epoc 10 ms after trigger
	[temp(2) ind(2)] = min(tempData(constants.trigger+constants.amplitudeDelay:constants.trigger+constants.amplitudeDelay+constants.amplitudeEpoc)); %Min value from 80 ms epoc 10 ms after trigger
	results(i).trial(j).ResponseLatency{k} = int32(constants.amplitudeDelay+floor(mean([ind(1) ind(2)]))-floor(constants.rmsEpoc/2));	%Calculate the response latency as the mean time of the min and max peaks and subtract half of the RMS epoc.
	if results(i).trial(j).ResponseLatency{k} < 5	%Can't accept a latency of less than 5 ms to avoid trigger...
		results(i).trial(j).ResponseLatency{k} = 5;
	end
	results(i).trial(j).ResponseRMS{k} = sqrt(mean(tempData(constants.trigger+results(i).trial(j).ResponseLatency{k}:constants.trigger+results(i).trial(j).ResponseLatency{k}+constants.rmsEpoc).^2)); % RMS epoc
	results(i).trial(j).ResponseAmplitude{k} = temp(1)-temp(2); %Peak to peak amplitude			
	results(i).trial(j).visualizationTrace{k} = tempData(constants.trigger+constants.visualizationInit+constants.channelDelays(k):constants.trigger+constants.visualizationInit+constants.channelDelays(k)+constants.visualizationEpoc);
	%results(i).trial(j).trialTrace{k} = tempData;
	
	%Analyse silent period. Find out 100 ms BG EMG prior to trigger. End of SP is when EMG returns to 90% of the BG
	%results(i).trial(j).silentBG{k} = sqrt(mean(tempData(constants.trigger-constants.silentPeriodEpoc:constants.trigger-1).^2)); %500 ms RMS window up to trigger
	results(i).trial(j).silentBG{k} = std(tempData(constants.trigger+constants.backroundEpoc:constants.trigger-1)); %500 ms RMS window up to trigger
	spMovingRMS = [];
	for l = constants.trigger+constants.spVisualizationInit:constants.trigger+150
			%spMovingRMS(l) = sqrt(mean(tempData(l:l+constants.silentPeriodEpoc-1).^2));
			spMovingRMS(l-constants.trigger-constants.spVisualizationInit+1) = std(tempData(l:l+constants.silentPeriodEpoc-1));
	end
	results(i).trial(j).spMovingRMS{k} = spMovingRMS;
	%decreasingMEP = find(spMovingRMS >= 1.5*results(i).trial(j).backgroundEMG{k},1,'last');										%Find decreasing MEP
	results(i).trial(j).silentPeriod{k} = NaN;
	%spInit = find(spMovingRMS(decreasingMEP:length(spMovingRMS)) <= 0.8*results(i).trial(j).backgroundEMG{k},1,'first');			%Find init of SP
	[discard spInit] = min(spMovingRMS);			%Find SP, should be where we have minimal RMS or SD
	if spInit > results(i).trial(j).ResponseLatency{k}
		spEnd = find(spMovingRMS(spInit:length(spMovingRMS)) >= 0.95*results(i).trial(j).silentBG{k},1,'first');	%Find end of SP
		if ~isempty(spEnd)
			spEndInd = spInit+spEnd+constants.spVisualizationInit;
			results(i).trial(j).silentPeriod{k} = spEndInd-results(i).trial(j).ResponseLatency{k};
		end
	end
	
return					
