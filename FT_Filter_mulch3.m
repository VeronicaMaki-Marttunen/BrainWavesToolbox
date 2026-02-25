function X_f = FT_Filter_mulch3(X, thres, type, Fs)
    % FT_Filter_mulch3 filters data in Fourier Space based on the given thresholds and sampling rate.
    %
    % Inputs:
    %   X    - Input data matrix (e.g., rows as channels, columns as time points)
    %   thres - Threshold(s) for filtering, should be [low_threshold, high_threshold] for bandpass
    %   type  - Type of filter: 'low', 'high', 'bandpass', or 'stop'
    %   Fs    - Sampling frequency in Hz (e.g., 0.25 for data sampled every 4 seconds)
    %
    % Output:
    %   X_f   - Filtered output data matrix (time series)

    % Check input arguments
    if nargin < 3
        if length(thres) == 1
            type = 'low';
        elseif length(thres) == 2
            type = 'bandpass';
        else
            error('Invalid threshold input.');
        end
    elseif ~any(strcmp(type, {'low', 'high', 'bandpass', 'stop'}))
        error('The type of the filter is not correct!');
    end

    if (strcmp(type, 'low') || strcmp(type, 'high')) && length(thres) == 2
        error('The dimension of threshold is not right');
    end

    if (strcmp(type, 'bandpass') || strcmp(type, 'stop')) && length(thres) == 1
        error('The dimension of threshold is not right');
    end

    nfft = size(X, 1);  % Number of samples in the input data
    temp = fft(X, nfft, 1);  % Perform the FFT along the first dimension (time)

    % Calculate frequency bins
    frequency_bins = (0:nfft-1) * (Fs/nfft); % Frequency vector from 0 to Fs

    % Apply filtering based on the specified type
    if strcmp(type, 'low')
        cutoff_idx = ceil(thres * nfft / Fs);
        temp(cutoff_idx+1:end, :) = 0; % Zero out frequencies above the cutoff
    elseif strcmp(type, 'high')
        cutoff_idx = ceil(thres * nfft / Fs);
        temp(1:cutoff_idx+1, :) = 0; % Zero out frequencies below cutoff
        temp(end-cutoff_idx+1:end, :) = 0; % Zero out frequencies above cutoff
    elseif strcmp(type, 'bandpass')
        low_idx = ceil(thres(1) * nfft / Fs);
        high_idx = ceil(thres(2) * nfft / Fs);
        temp(1:low_idx, :) = 0; % Zero out frequencies below the low cutoff
        temp(high_idx+1:end, :) = 0; % Zero out frequencies above the high cutoff
    elseif strcmp(type, 'stop')
        low_idx = ceil(thres(1) * nfft / Fs);
        high_idx = ceil(thres(2) * nfft / Fs);
        temp(low_idx+1:high_idx, :) = 0; % Zero out the stop band
    end

    % Perform inverse transformation to get back to the time domain
    X_f_complex = ifft(temp, nfft, 1); 

    % Convert to real part as double
    X_f = real(X_f_complex); 

    % Ensure it is in double format
    X_f = double(X_f);
end

