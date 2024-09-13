function delay = get_delays(av_bin, delta_t, symm)
% Function to compute transmission delays from neuronal avalanches
%
% Output:
%       delay - delay matrix, expressed in samples (needs to be converted
%       to seconds using the sampling frequency
% Input:
%       av_bin - cell array of binarized avalanches (each avalanche
%       expected to be structured as channels x timepoints)
%       delta_t - same threshold used to discretize data for avalanches

if ~exist('symm','var')
    symm = 0;
end

delay = zeros(size(av_bin{1}, 1));
countmat = zeros(size(av_bin{1}, 1));
% loop over avalanches
for a=1:size(av_bin, 2)
    % look for the channels over threshold in the first time window
    [source, ~] = find(av_bin{a}(:, 1:delta_t)==1);
    source = unique(source);
    % loop over channels to look for subsequent values over threshold
    for c=1:size(av_bin{a}, 1)
        if ~isempty(find(av_bin{a}(c, delta_t+1:end), 1)) && ...
                ~ismember(c, source)
            d = find(av_bin{a}(c, delta_t+1:end), 1) + (delta_t - 1);
            % discretizing delays according to delta_t
            d = fix(d / delta_t) * delta_t;
            delay(source, c) = delay(source, c) + d;
            countmat(source, c) = countmat(source, c) + 1;
        end
    end
end
delay = delay ./ countmat;
delay(~isfinite(delay)) = 0;

if symm
    delay = delay + delay';
end
