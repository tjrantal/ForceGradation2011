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
	results(i).trial(j).silentBG{k} = sqrt(mean(tempData(constants.trigger-constants.silentPeriodEpoc:constants.trigger-1).^2)); %500 ms RMS window up to trigger
	spMovingRMS = [];
	for l = 1:constants.trigger+150
			spMovingRMS(l) = sqrt(mean(tempData(l:l+constants.silentPeriodEpoc-1).^2));
	end
	results(i).trial(j).spMovingRMS{k} = spMovingRMS;
	decreasingMEP = find(spMovingRMS >= 1.5*results(i).trial(j).backgroundEMG{k},1,'last');										%Find decreasing MEP
	results(i).trial(j).silentPeriod{k} = NaN;
	spInit = find(spMovingRMS(decreasingMEP:length(spMovingRMS)) <= 0.8*results(i).trial(j).backgroundEMG{k},1,'first');			%Find init of SP
	if ~isempty(spInit)
		spEnd = find(spMovingRMS(decreasingMEP+spInit:length(spMovingRMS)) >= 0.95*results(i).trial(j).backgroundEMG{k},1,'first');	%Find end of SP
		if ~isempty(spEnd)
			spEndInd = decreasingMEP+spInit+spEnd-constants.trigger;
			%disp(num2str(spEndInd));
			if ~isempty(spEndInd)
				results(i).trial(j).silentPeriod{k} = spEnd-results(i).trial(j).ResponseLatency{k};
			end
		end
	end
	
return					
