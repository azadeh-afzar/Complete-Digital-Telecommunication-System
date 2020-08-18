% source/line coding/decode/decode_4B3T.m
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

function bit_stream = decode_4B3T(line_code, amplitude)

    % assign amplitudes.
    high_a = amplitude(1);
    zero_a = amplitude(2);
    low_a = amplitude(3);

    % empty bit stream to be filled with 4B3T algorithm.
    % this transforms line code length with 4/3 multipication.
    line_code_length = length(line_code);
    bit_stream = zeros(1, (line_code_length / 3) * 4);
    bit_stream_index = 1;

    % this mapping from 3 ternary states to 4 is given in a table
    % known as Modified Monitoring State 4 to 3 (MMS43).
    for line_index = 1:3:length(line_code)
        % extract a 3 symbol ternary block.
        ternary_block = line_code(line_index:line_index + 2);

        if (sum(ternary_block == [high_a zero_a high_a]) / 3) == 1

            bit_stream(bit_stream_index:bit_stream_index + 3) = [0 0 0 0];

        elseif (sum(ternary_block == [zero_a low_a zero_a]) / 3) == 1

            bit_stream(bit_stream_index:bit_stream_index + 3) = [0 0 0 0];

        elseif (sum(ternary_block == [zero_a low_a high_a]) / 3) == 1

            bit_stream(bit_stream_index:bit_stream_index + 3) = [0 0 0 1];

        elseif (sum(ternary_block == [high_a low_a zero_a]) / 3) == 1

            bit_stream(bit_stream_index:bit_stream_index + 3) = [0 0 1 0];

        elseif (sum(ternary_block == [zero_a zero_a high_a]) / 3) == 1

            bit_stream(bit_stream_index:bit_stream_index + 3) = [0 0 1 1];

        elseif (sum(ternary_block == [low_a low_a zero_a]) / 3) == 1

            bit_stream(bit_stream_index:bit_stream_index + 3) = [0 0 1 1];

        elseif (sum(ternary_block == [low_a high_a zero_a]) / 3) == 1

            bit_stream(bit_stream_index:bit_stream_index + 3) = [0 1 0 0];

        elseif (sum(ternary_block == [zero_a high_a high_a]) / 3) == 1

            bit_stream(bit_stream_index:bit_stream_index + 3) = [0 1 0 1];

        elseif (sum(ternary_block == [low_a zero_a zero_a]) / 3) == 1

            bit_stream(bit_stream_index:bit_stream_index + 3) = [0 1 0 1];

        elseif (sum(ternary_block == [low_a high_a high_a]) / 3) == 1

            bit_stream(bit_stream_index:bit_stream_index + 3) = [0 1 1 0];

        elseif (sum(ternary_block == [low_a zero_a high_a]) / 3) == 1

            bit_stream(bit_stream_index:bit_stream_index + 3) = [0 1 1 1];

        elseif (sum(ternary_block == [high_a zero_a zero_a]) / 3) == 1

            bit_stream(bit_stream_index:bit_stream_index + 3) = [1 0 0 0];

        elseif (sum(ternary_block == [zero_a low_a low_a]) / 3) == 1

            bit_stream(bit_stream_index:bit_stream_index + 3) = [1 0 0 0];

        elseif (sum(ternary_block == [high_a low_a high_a]) / 3) == 1

            bit_stream(bit_stream_index:bit_stream_index + 3) = [1 0 0 1];

        elseif (sum(ternary_block == [low_a low_a low_a]) / 3) == 1

            bit_stream(bit_stream_index:bit_stream_index + 3) = [1 0 0 1];

        elseif (sum(ternary_block == [high_a high_a low_a]) / 3) == 1

            bit_stream(bit_stream_index:bit_stream_index + 3) = [1 0 1 0];

        elseif (sum(ternary_block == [high_a low_a low_a]) / 3) == 1

            bit_stream(bit_stream_index:bit_stream_index + 3) = [1 0 1 0];

        elseif (sum(ternary_block == [high_a zero_a low_a]) / 3) == 1

            bit_stream(bit_stream_index:bit_stream_index + 3) = [1 0 1 1];

        elseif (sum(ternary_block == [high_a high_a high_a]) / 3) == 1

            bit_stream(bit_stream_index:bit_stream_index + 3) = [1 1 0 0];

        elseif (sum(ternary_block == [low_a high_a low_a]) / 3) == 1

            bit_stream(bit_stream_index:bit_stream_index + 3) = [1 1 0 0];

        elseif (sum(ternary_block == [zero_a high_a zero_a]) / 3) == 1

            bit_stream(bit_stream_index:bit_stream_index + 3) = [1 1 0 1];

        elseif (sum(ternary_block == [low_a zero_a low_a]) / 3) == 1

            bit_stream(bit_stream_index:bit_stream_index + 3) = [1 1 0 1];

        elseif (sum(ternary_block == [zero_a high_a low_a]) / 3) == 1

            bit_stream(bit_stream_index:bit_stream_index + 3) = [1 1 1 0];

        elseif (sum(ternary_block == [high_a high_a zero_a]) / 3) == 1

            bit_stream(bit_stream_index:bit_stream_index + 3) = [1 1 1 1];

        elseif (sum(ternary_block == [zero_a zero_a low_a]) / 3) == 1

            bit_stream(bit_stream_index:bit_stream_index + 3) = [1 1 1 1];

        end

        % bit stream index increment for next loop.
        bit_stream_index = bit_stream_index + 4;
    end

    % down sampling.
    bit_stream = reshape(bit_stream, 4, length(bit_stream) / 4);
    bit_stream = bit_stream(1, :);

end
