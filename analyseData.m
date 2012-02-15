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
	results = struct;
	for i = 1:length(indices)	%Loop through condition names
		%i = 2;
		for j = 1:length(indices(i).index)	%Loop through trials
			
			%k = 3;
			for k = 1:size(data.titles,1)	%Go through recorded channels k = 2
				if (k == 1) |  (k == 3)
					%Remove DC offset from EMG data
					tempData = data.data(data.datastart(k,indices(i).index(j)):data.dataend(k,indices(i).index(j)));
					dcOffset = mean(tempData(constants.trigger+constants.backroundEpoc:constants.trigger-1));
					tempData =tempData-dcOffset;
					results = analyseEMG(i,j,k,constants,tempData,results);
				end
				
				if k == 2	%If force channel, calculate STD, coefficient of variation and frequency i = 1, j = 1,k =2
					forceTrace = data.data(data.datastart(k,indices(i).index(j)):data.dataend(k,indices(i).index(j)))/constants.forceScaling;	%Scale to Nms	
					results(i).trial(j).trace{k} =forceTrace;
					forceEpoc = forceTrace(constants.trigger+constants.backroundEpoc+constants.channelDelays(k):constants.trigger-1+constants.channelDelays(k));
					fSTD = std(forceEpoc); %500 ms stdev epoc from -600 to -100  prior to trigger
					fMEAN = mean(forceEpoc);	%500 ms mean epoc from -600 to -100  prior to trigger

					results(i).trial(j).forceMEAN = fMEAN; %500 ms mean window from -600 to -100ms prior to trigger
					results(i).trial(j).forceSTD = fSTD; %500 ms stdev window from -600 to -100  prior to trigger
					results(i).trial(j).forceCV = fSTD/fMEAN*100.0; %500 ms stdev window from -600 to -100  prior totrigger

					%FFT analysis
					fftData =  forceEpoc - mean(forceEpoc);		%Remove DC component
					hannWindow = hanning(length(fftData));	%Create hann window
					hanData = fftData.*hannWindow';		%Apply Hann windowing function
					fftForce = fft(hanData); %500 ms stdev epoc from -600 to -100  prior to trigger
					fftForceNonWindowed = fft(fftData);
					freqs = linspace(0,constants.samplingRate/2,floor(length(fftForce)/2))';					
					powerSpectrum = (abs(fftForce).^2)/(length(fftForce)/2); 
					powerSpectrum(1) = powerSpectrum(1)/2; 
					nonWindowedPowerSpectrum = (abs(fftForceNonWindowed).^2)/(length(fftForceNonWindowed)/2); 
					nonWindowedPowerSpectrum(1) = nonWindowedPowerSpectrum(1)/2; 
					results(i).trial(j).forcePowerSpectrum = powerSpectrum(1:length(freqs));
					results(i).trial(j).nonWindowedForcePowerSpectrum = nonWindowedPowerSpectrum(1:length(freqs));
					results(i).trial(j).forcePowerSpectrumFreqs = freqs;
					totalSum = sum(powerSpectrum(1:length(freqs)));
					cumSum = cumsum(powerSpectrum(1:length(freqs)));
					results(i).trial(j).forceMDF = freqs(find(cumSum>=totalSum/2,1,'first' ));
					clear cumSum totalSum nonWindowedPowerSpectrum powerSpectrum freqs fftForceNonWindowed fftForce hanData hannWindow fftData forceTrace forceEpoc;
				end
				
			end

		end
	end
return