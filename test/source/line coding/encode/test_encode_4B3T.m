% test/source/line coding/encode/test_encode_4B3T.m
%
% This file is a part of:
% Azadeh Afzar - Complete Digital Telecommunication System.
%
% Copyright (C) 2020 Azadeh Afzar
% Copyright (C) 2020 Mohammad Mahdi Baghbani Pourvahid
%
% GNU AFFERO GENERAL PUBLIC LICENSE
%
% This program is free software; you can redistribute it and/or modify
% it under the terms of the GNU Affero General Public License as published by
% the Free Software Foundation; either version 3 of the License, or (at
% your option) any later version.
%
% This program is distributed in the hope that it will be useful, but
% WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
% Affero General Public License for more details.
%
% You should have received a copy of the GNU Affero General Public License
% along with this program; if not, write to the Free Software
% Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301, USA.
%
% ZLIB LICENSE
%
% Permission is granted to anyone to use this software for any purpose,
% including commercial applications, and to alter it and redistribute it
% freely, subject to the following restrictions:
%
% 1. The origin of this software must not be misrepresented; you must not
% claim that you wrote the original software. If you use this software
% in a product, an acknowledgement in the product documentation would be
% appreciated but is not required.
%
% 2. Altered source versions must be plainly marked as such, and must not be
% misrepresented as being the original software.
%
% 3. This notice may not be removed or altered from any source distribution.
%

clc, clear, close all;

addpath('../../../../source/util');
addpath('../../../../source/line coding/encode');
addpath('../../../../source/line coding/decode');

fs = 100;
ts = 1 / fs;
spb = 40;
Rb = 300;
freq = 1000;

enable_waveform = 1;
enable_spectrum = 1;
enable_phase = 1;
enable_name = 0;
plot_option = [enable_waveform enable_spectrum enable_phase, enable_name];

amplitude = [2, 0, -2];
bit_stream = randi(2, [1, 50]) - 1;
line_coded = encode_4B3T(bit_stream, amplitude);

rolloff = 0.25; % Rolloff factor
span = 1; % Filter span in symbols
sps = spb; % Samples per symbol
b = rcosdesign(rolloff, span, sps);

N = length(line_coded);
Tb = 1 / Rb; % bit duration
Fs = spb * Rb; % sampling frequency
Ts = 1 / Fs;
time = 0:Ts:N * Tb - Ts;

% pulse_shapedd = upfirdn(line_coded, b, sps);

pulse_shaped_n = repelem(line_coded, spb);
pulse_shaped = lowpass(pulse_shaped_n, Rb, Fs, 'ImpulseResponse', 'fir');

amp_carrier = 10;
u = 0.5;

% carrier = amp_carrier .* cos(2 * pi * freq * time);
% o1 = carrier .* pulse_shaped;
% o2 = amp_carrier .* (1 + u .* pulse_shaped) .* cos(2 * pi * freq * time);

carrier = (sqrt(2 / Ts) * cos(2 * pi * freq * time));

nrz = 20 .* (pulse_shaped_n == 2) + 0 .* (pulse_shaped_n == -2) + 10 .* (pulse_shaped_n == 0);


o2 = nrz .* carrier;

k1 = 1;
k2 = 1;
d22 = k1 .* o2 + k2 .* o2 .* o2;

% o3 = awgn(o2, 11, 'measured');

d2 = envelope(o2, floor(sps/4));
ld2 = lowpass(d2, Rb, Fs, 'ImpulseResponse', 'fir');
ld3 = ld2 - mean(ld2);

%t = lowpass(d2, 0.25, Fs, 'ImpulseResponse', 'fir');

%ld4 = ld2 - t;

%match_filteredd = upfirdn(ld3, b, 1, sps);

match_filtered = ld3;

%match_filtered = reshape(ld3, spb, length(ld3) / spb);
%match_filtered = match_filtered(1, :);

tabular = [time(1:length(match_filtered)); match_filtered]';
tabular2 = [time(1:length(ld3)); ld3]';

km = kmeans(tabular, 3);
km2 = kmeans(tabular2, 3);

idx1 = km == 1;
idx2 = km == 2;
idx3 = km == 3;

kms1 = sum(tabular(idx1, 2));
kms2 = sum(tabular(idx2, 2));
kms3 = sum(tabular(idx3, 2));

kmms = [kms1 kms2 kms3];

maxi = max(kmms);
mini = min(kmms);

if kms1 == maxi
    kml1 = 10;
elseif kms1 == mini
    kml1 = -10;
else
    kml1 = 0;
end

if kms2 == maxi
    kml2 = 10;
elseif kms2 == mini
    kml2 = -10;
else
    kml2 = 0;
end

if kms3 == maxi
    kml3 = 10;
elseif kms3 == mini
    kml3 = -10;
else
    kml3 = 0;
end

p = zeros(0, length(match_filtered));
p(idx1') = kml1;
p(idx2') = kml2;
p(idx3') = kml3;

match_filtered = reshape(p, spb, length(ld3) / spb);
match_filtered = match_filtered(1, :);

bit_stream2 = decode_4B3T(match_filtered, [10, 0, -10]);

err = sum(bit_stream == bit_stream2) / length(bit_stream);
err2 = sum(line_coded == match_filtered) / length(line_coded);
%r = x + randn(size(x)) * 0.01;
%y = upfirdn(r, b, 1, sps);

%line_decoded = decode_4B3T(line_coded, amplitude);

%plotspec(bit_stream, Ts, 1, plot_option);
%plotspec(line_coded, Ts, 2, plot_option);
plotspec(pulse_shaped_n, Ts, 3, plot_option);
%plotspec(pulse_shaped, Ts, 4, plot_option);
plotspec(nrz, Ts, 5, plot_option);
plotspec(carrier, Ts, 6, plot_option);
plotspec(o2, Ts, 7, plot_option);
%plotspec(o3, Ts, 8, plot_option);
plotspec(d2, Ts, 9, plot_option);
%plotspec(ld2, Ts, 9, plot_option);
plotspec(ld2, Ts, 10, plot_option);
plotspec(ld3, Ts, 11, plot_option);
%plotspec(ld4, Ts, 12, plot_option);
plotspec(match_filtered, Ts, 13, plot_option);
plotspec(p, Ts, 14, plot_option);
