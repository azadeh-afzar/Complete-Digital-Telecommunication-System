% source/channel coding/decode/decode_interleaver.m
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

function out_stream = decode_interleaver(stream, g_vector, option)
    % INPUT:
    %   stream            = input data stream.
    %   g_vector          = index generator vector.
    %   option            = other algorithm specific options.
    % OUTPUT:
    %   out_stream        = decoded data stream.

    % get options.
    enable_second_downsampling = option(1);
    enable_first_downsampling = option(2);
    first_downsample_rate = option(3);

    % get lengths.
    length_g_vector = size(g_vector, 2);
    length_stream = size(stream, 2);

    if enable_first_downsampling == 1 && first_downsample_rate > 0
        % downsample.
        stream = reshape(stream, first_downsample_rate, length_stream / first_downsample_rate);
        % attemp to correct possible erros.
        stream = round(mean(stream(:, :)));
        % update stream length.
        length_stream = size(stream, 2);
    end

    % create zero filled scrambled data.
    unscrambled_data = zeros(1, length_stream);

    for i = 1:length_g_vector:length_stream
        index_vector = g_vector + i - 1;
        unscrambled_data(i:i + length_g_vector - 1) = stream(index_vector);
    end

    % second auto downsampling by length generator vector.
    if enable_second_downsampling == 1
        unscrambled_data = reshape(unscrambled_data, length_g_vector, length_stream / length_g_vector);
        unscrambled_data = round(mean(unscrambled_data(:, :)));
    end

    out_stream = unscrambled_data;
end
