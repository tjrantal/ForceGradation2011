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

%Function for analysing the data
function [results] = analyseData(data,constants,indices)
	for i = 1:length(indices)	%Loop through condition names
		for j = 1:length(indices(i).index)	%Loop through trials
			for k = 1:size(data.titles,1)	%Go through recorded channels
				results(i).trial(j).trace{k} =data.data(data.datastart(k,indices(i).index(j)):data.dataend(k,indices(i).index(j)));
				results(i).trial(j).backgroundEMG{k} = sqrt(mean(data.data(data.datastart(k,indices(i).index(j))+constants.trigger+constants.backroundEpoc:data.datastart(k,indices(i).index(j))+constants.trigger-1).^2)); %500 ms RMS window up to trigger
				%Use amplitude peaks to figure out RMS epoc position
				[temp(1) ind(1)] = max(data.data(data.datastart(k,indices(i).index(j))+constants.trigger+constants.amplitudeDelay:data.datastart(k,indices(i).index(j))+constants.trigger+constants.amplitudeDelay+constants.amplitudeEpoc)); %Max value from 80 ms epoc 10 ms after trigger
				[temp(2) ind(2)] = min(data.data(data.datastart(k,indices(i).index(j))+constants.trigger+constants.amplitudeDelay:data.datastart(k,indices(i).index(j))+constants.trigger+constants.amplitudeDelay+constants.amplitudeEpoc)); %Min value from 80 ms epoc 10 ms after trigger
				results(i).trial(j).ResponseLatency{k} = int32(constants.amplitudeDelay+floor(mean([ind(1) ind(2)]))-floor(constants.rmsEpoc/2));	%Calculate the response latency as the mean time of the min and max peaks and subtract half of the RMS epoc.
				if results(i).trial(j).ResponseLatency{k} < 5	%Can't accept a latency of less than 5 ms to avoid trigger...
					results(i).trial(j).ResponseLatency{k} = 5;
				end
				results(i).trial(j).ResponseRMS{k} = sqrt(mean(data.data(data.datastart(k,indices(i).index(j))+constants.trigger+results(i).trial(j).ResponseLatency{k}:data.datastart(k,indices(i).index(j))+constants.trigger+results(i).trial(j).ResponseLatency{k}+constants.rmsEpoc).^2)); % RMS epoc
				results(i).trial(j).ResponseAmplitude{k} = temp(1)-temp(2); %Peak to peak amplitude			
				results(i).trial(j).visualizationTrace{k} = data.data(data.datastart(k,indices(i).index(j))+constants.trigger+constants.visualizationInit+constants.channelDelays(k):data.datastart(k,indices(i).index(j))+constants.trigger+constants.visualizationInit+constants.channelDelays(k)+constants.visualizationEpoc);
				if k == 2	%If force channel, calculate STD, coefficient of variation and frequency i = 1, j = 1,k =2
					fSTD = std(data.data(data.datastart(k,indices(i).index(j))+constants.trigger+constants.backroundEpoc+constants.channelDelays(k):data.datastart(k,indices(i).index(j))+constants.trigger-1+constants.channelDelays(k))); %500 ms stdev epoc from -600 to -100  prior to trigger
					fMEAN = mean(data.data(data.datastart(k,indices(i).index(j))+constants.trigger+constants.backroundEpoc+constants.channelDelays(k):data.datastart(k,indices(i).index(j))+constants.trigger-1+constants.channelDelays(k)));	%500 ms mean epoc from -600 to -100  prior to trigger
					results(i).trial(j).forceSTD = fSTD; %500 ms stdev window from -600 to -100  prior to trigger
					results(i).trial(j).forceCV = fMEAN/fSTD; %500 ms stdev window from -600 to -100  prior totrigger
					%FFT analysis
					fftForce = fft(data.data(data.datastart(k,indices(i).index(j))+constants.trigger+constants.backroundEpoc+constants.channelDelays(k):data.datastart(k,indices(i).index(j))+constants.trigger-1+constants.channelDelays(k))); %500 ms stdev epoc from -600 to -100  prior to trigger
					freqs = linspace(0,constants.samplingRate/2,floor(length(fftForce)/2))';
					powerSpectrum = (abs(fftForce).^2)/(length(fftForce)/2); 
					powerSpectrum(1) = powerSpectrum(1)/2; %Set DC to zero... plot(freqs,powerSpectrum(1:length(freqs)))
					powerSpectrum(1) = 0;
					results(i).trial(j).forcePowerSpectrum = powerSpectrum(1:length(freqs));
					results(i).trial(j).forcePowerSpectrumFreqs = freqs;
					totalSum = sum(powerSpectrum(1:length(freqs)));
					cumSum = cumsum(powerSpectrum(1:length(freqs)));
					results(i).trial(j).forceMDF = freqs(find(cumSum>=totalSum/2,1,'first' ));
				end
			end

		end
	end
return