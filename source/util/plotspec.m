% source/util/plotspec.m
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

function plotspec(signal, ts, figure_property, option)
    % plotspec(signal,ts) plots the spectrum of the signal
    % INPUT:
    %   signal          = the signal for plotting it's frequency spectrum.
    %   ts              = time (in seconds) between adjacent samples in signal.
    %   figure_property = either figure name or figure number.
    %   option          = an array to define options of figure [waveform,
    %                     spectrums, phase, name];
    % OUTPUT:
    %   a plot consist 2 sub plots of waveform and frequency domain.

    % unwrap options.
    waveform = option(1);
    spectrums = option(2);
    phase = option(3);
    name_or_num = option(4);

    % num of plots.
    plot_n = sum(option);

    % length of the signal signal.
    n = length(signal);

    % frequency vector.
    frequencies = (ceil(-n / 2):ceil(n / 2) - 1) / (ts * n);

    % do FFT.
    fft_signal = fft(signal);

    % shift fft for plotting.
    shifted_fft = fftshift(fft_signal);
    abs_shifted_fft = abs(shifted_fft);

    % define figure plot.
    if name_or_num == 1
        figure('Name', figure_property, 'NumberTitle', 'off');
    else
        figure(figure_property);
    end

    if waveform
        time = ts * (1:n);
        max_data_points = n;
        % limit data points to show.
        if n > 50
            max_data_points = round(n / (log10(n) / log10(50)));
        end
        % plot the waveform.
        subplot(plot_n, 1, 1);
        plot(time(1:max_data_points), signal(1:max_data_points));
        % label the axes.
        title('Waveform');
        xlabel('seconds');
        ylabel('amplitude');
    end

    if spectrums
        % set subplot location.
        loc = 2;

        if waveform == 0
            loc = 1;
        end

        % plot magnitude spectrum.
        subplot(plot_n, 1, loc);
        plot(frequencies, abs(abs_shifted_fft), 'b');
        % label the axes.
        title('Magnitude Spectrum.');
        xlabel('frequency (Hz)');
        ylabel('magnitude');
    end

    if phase
        % find phase of fft.
        angles = mod(unwrap(angle(shifted_fft)), 2 * pi);
        shifted_angles = angles - pi;
        % convert radian to degree.
        shifted_angles = shifted_angles * 180 / pi;

        % set subplot location.
        loc = 3;

        if waveform == 0
            loc = 2;
        end

        if waveform == 0 && spectrums == 0
            loc = 1;
        end

        % plot phase.
        subplot(plot_n, 1, loc);
        plot(frequencies, shifted_angles);
        % label the axes.
        title('Phase.');
        xlabel('frequency (Hz)');
        ylabel('arg (Degrees)');
    end

end
