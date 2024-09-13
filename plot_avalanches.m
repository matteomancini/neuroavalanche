function [] = plot_avalanches(av_bin, av_ts, thres, index)
% Function to plot neuronal avalanches
%
% Input:
%       av_bin - cell array of binarized avalanches (each avalanche
%       expected to be structured as channels x timepoints)
%       av_ts - cell array of z-scored avalanches
%       thres - same threshold used to binarize z-scored data
%       index - (optional) specific avalanche within the cell arrays

if ~exist('index','var')
    index = randi(size(av_bin, 2), 1);
end

figure;
subplot(211), surf(av_bin{index}), view(2);
subplot(212), plot(av_ts{index}');
hold on, subplot(212), yline([-thres thres],'--','LineWidth',2.5);
subplot(212), xline(1:3:size(av_bin{index},2)+1);
subplot(211), xline(1:3:size(av_bin{index},2)+1);
