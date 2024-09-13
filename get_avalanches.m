function [av_bin, av_ts] = get_avalanches(ts, thres, delta_t, avlen)
% Function to identify neuronal avalances in MEG data
%
% Output:
%       av_bin - cell array, each element corresponds to an avalanche
%       and contains the binarized timeseries (without discretization!!)
%       av_ts - same structure as av_ts, but with the z-scored segments
% Input:
%       ts - MEG data (channels x timepoints)
%       thres - threshold to binarize z-scored data
%       delta_t - interval to discretize data when looking for avalanches
%       avlen - (optional) only to be used to keep only longer avalanches

if ~exist('avlen','var')
    avlen = 0;
end

% computing z-score for each channel
ts_z = ts;
for i=1:84
    ts_z(i,:) = (ts_z(i,:) - mean(ts_z(i,:)))/std(ts_z(i,:));
end
% binarize according to thres (number of standard deviations)
ts_bin = int8(abs(ts_z) > thres);
% zero-padding the data according to delta_t
pad = 2*delta_t - mod(size(ts_bin, 2), delta_t);
ts_z = padarray(ts_z, [0, pad], 'replicate', 'post');
ts_bin = padarray(ts_bin, [0, pad], 0, 'post');

start = nan;
av_bin = {};
av_ts = {};
k=0;
% loop every window of length delta_t looking for avalances
for i=1:delta_t:size(ts_bin,2)
    % if there's a sample over threshold and start is not set, we found it
    if any(ts_bin(:, i:i+delta_t-1),'all') && isnan(start)
        start = i;
        % if start is set and no more samples over threshold, it's over
    elseif all(~ts_bin(:, i:i+delta_t-1),'all') && ~isnan(start)
        if i-start > avlen
            disp(['Avalanche! From ', num2str(start), ' to ', ...
                num2str(i), ' - Length: ', num2str(i-start)]);
            k = k+1;
            av_bin{k} = ts_bin(:, start:i-1); %#ok<AGROW>
            av_ts{k} = ts_z(:, start:i-1); %#ok<AGROW>
        end
        start = nan; % once recorded in the arrays, we start over!
    end
end