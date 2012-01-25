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
return					
