% source/channel coding/decode/decode_hamming.m
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

function out_stream = decode_hamming(stream, option)
    % INPUT:
    %   stream            = input data stream.
    %   option            = other algorithm specific options.
    % OUTPUT:
    %   out_stream        = decoded data stream.

    % get options.
    hamming_distance = option(1);
    stream_downsample_rate = floor(option(2));

    % get message block size.
    input_data_block_size = (2^hamming_distance) - 1;
    output_data_block_size = input_data_block_size - hamming_distance;

    % get length of input data.
    len_data_stream = length(stream);

    % create empty ecncoded data.
    decoded_data_size = (len_data_stream / input_data_block_size) * output_data_block_size;
    decoded_data = zeros(1, decoded_data_size);
    decoded_data_index = 1;

    for i = 1:input_data_block_size:len_data_stream
        next_index = decoded_data_index + output_data_block_size;
        decoded_data(decoded_data_index:next_index - 1) = hm_decoder(stream(i:i + input_data_block_size - 1), hamming_distance);
        decoded_data_index = next_index;
    end

    % manually downsample stream or not.
    if stream_downsample_rate > 0
        % downsample.
        stream_downsampled = reshape(decoded_data, stream_downsample_rate, length(decoded_data) / stream_downsample_rate);
        % attemp to correct possible erros.
        decoded_data = round(mean(stream_downsampled(:, :)));
    end

    % downsample.
    stream_downsampled = reshape(decoded_data, output_data_block_size, length(decoded_data) / output_data_block_size);

    % attemp to correct possible erros.
    decoded_data = round(mean(stream_downsampled(:, :)));

    % send out coded data block.
    out_stream = decoded_data;
end
