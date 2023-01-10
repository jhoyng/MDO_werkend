function [W_f] = performance(x)
dOverL = 16; %get vvv
%dOverL = C_Lwing/(C_Dwing + C_DAW)


W_endOverStart = exp(-R*C_T/V*(dOverL));
W_AW = 3000;        %get
W_TO_max = W_AW+W_strWing / (0.938*W_endOverStart);

W_f = (1-0.938*W_endOverStart)*W_TO_max;
end