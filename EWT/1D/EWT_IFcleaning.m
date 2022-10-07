function f=EWT_IFcleaning(fin,lb,ub)
%==========================================================================
% function f=EWT_IFcleaning(fin,lb,ub)
%
% This function clean the frequencies which are out of the range [lb,ub].
% After detecting such intervals, an interpolation is used to replace these
% outliers.
%
% Inputs:
%   -fin: vector containing the instantaneous frequencies to be cleaned
%   -lb: lower frequency bound
%   -ub: upper frequency bound
%
% Outputs:
%   -f: cleaned instantaneous frequencies
%
% Author: Jerome Gilles
% Institution: UCLA - Department of Mathematics
% Year: 2014
% Version: 1.0
%==========================================================================


% Find the intervals where the frequency is out of the range
indi=1:length(fin);
ind=find((fin>=lb) & (fin<=ub));
if isempty(ind)
    f=fin;
else
    fe=fin(ind);

    % check if we removed the first point, if yes then we need an initial point
    % so, as we don't have any a priori, we fix this initial point to the first
    % kept value
    if ind(1)~=1
        fe=[fe(1) ; fe];   
        ind=[1 ; ind];
    end

    % check if we removed the last point, if yes then we need a final point so,
    % as we don't have any a priori, we fix this final point to the last kept
    % value
    if ind(end)~=length(fin)
        fe=[fe ; fe(end)];
        ind=[ind ; length(fin)];
    end

    % we interpolate within the intervals previously detected (for the lowest
    % frequency band we use a linear interpolation in order to avoid possible
    % osccillation which will return us back to negative frequencies,
    % otherwise we use spline interpolation
    if lb==0
        f=interp1(ind,fe,indi,'linear');
    else
        f=interp1(ind,fe,indi,'pchip');
    end
end
f=f';