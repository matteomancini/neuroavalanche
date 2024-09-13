function tmat = get_transition(av_bin, lag, delta_t)
% Function to compute average transition matrix from neuronal avalanches
%
% Output:
%       tmat - transition matrix, representing the probability of regions
%       being active after an avalanche starting fro a given region
% Input:
%       av_bin - cell array of binarized avalanches (each avalanche
%       expected to be structured as channels x timepoints)
%       lag - time lag to wait before look for transitions
%       delta_t - interval after lag where to look for transitions

n_aval = length(av_bin);
tmat = zeros(n);
for a=1:n_aval
    ch_activity = sum(av_bin{a}, 2);
    [c, t] = find(av_bin{a}(:, 1:end-lag-delta_t));
    for k=1:length(c)
        lagged = any(av_bin{a}(:, t(k)+lag:t(k)+lag+delta_t), 2);
        lagged(c(k)) = 0;
        tmat(c(k), :) = tmat(c(k), :) + lagged;
    end
    tmat = tmat ./ (ch_activity + (ch_activity == 0));
end
tmat = tmat / n_aval;