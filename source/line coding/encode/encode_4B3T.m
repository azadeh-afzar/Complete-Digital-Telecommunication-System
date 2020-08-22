% source/line coding/encode/encode_4B3T.m
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

function line_code = encode_4B3T(bit_stream, amplitude, option)
    % INPUT:
    %   line_mode       = encode or decode mode switch.
    %   line_code_name  = name of line coding algorithm.
    %   stream          = source stream to be line coded.
    %   amplitude       = magnitude levels for high, zero and low.
    %   option          = other algorithm specific options.
    % OUTPUT:
    %   signal          = line coded stream.

    % get options.
    enable_upsampling = option(1);

    % to avoid any problems, multiply bits to 4, this reduces 
    % Rb by 1/4 (although it should manually be set).
    if enable_upsampling == 1
        bit_stream = repelem(bit_stream, 4);
    end

    % set accumulated DC offset starting from 1.
    dc_offset = 1;

    % assign amplitudes.
    high_a = amplitude(1);
    zero_a = amplitude(2);
    low_a = amplitude(3);

    % empty line code to be filled with 4B3T algorithm.
    % this transforms stream length with 3/4 multipication.
    % final Rb will be Rb/3 .
    stream_length = length(bit_stream);
    line_code = zeros(1, (stream_length / 4) * 3);
    line_index = 1;

    % this mapping from 4 bits to three ternary states is given in a table
    % known as Modified Monitoring State 4 to 3 (MMS43).
    for stream_index = 1:4:length(bit_stream)
        % extract a 4 bit binary block.
        binary_block = bit_stream(stream_index:stream_index + 3);

        if (sum(binary_block == [0 0 0 0]) / 4) == 1

            if dc_offset == 1
                line_code(line_index:line_index + 2) = [high_a zero_a high_a];
                dc_offset = dc_offset + 2;
            else
                line_code(line_index:line_index + 2) = [zero_a low_a zero_a];
                dc_offset = dc_offset - 1;
            end

        elseif (sum(binary_block == [0 0 0 1]) / 4) == 1
            
            line_code(line_index:line_index + 2) = [zero_a low_a high_a];
        
        elseif (sum(binary_block == [0 0 1 0]) / 4) == 1
            
            line_code(line_index:line_index + 2) = [high_a low_a zero_a];
        
        elseif (sum(binary_block == [0 0 1 1]) / 4) == 1

            if dc_offset == 4
                line_code(line_index:line_index + 2) = [low_a low_a zero_a];
                dc_offset = dc_offset - 2;
            else
                line_code(line_index:line_index + 2) = [zero_a zero_a high_a];
                dc_offset = dc_offset + 1;
            end

        elseif (sum(binary_block == [0 1 0 0]) / 4) == 1
            
            line_code(line_index:line_index + 2) = [low_a high_a zero_a];
        
        elseif (sum(binary_block == [0 1 0 1]) / 4) == 1

            if dc_offset == 1
                line_code(line_index:line_index + 2) = [zero_a high_a high_a];
                dc_offset = dc_offset + 2;
            else
                line_code(line_index:line_index + 2) = [low_a zero_a zero_a];
                dc_offset = dc_offset - 1;
            end

        elseif (sum(binary_block == [0 1 1 0]) / 4) == 1

            if dc_offset == 1 || dc_offset == 2
                line_code(line_index:line_index + 2) = [low_a high_a high_a];
                dc_offset = dc_offset + 1;
            else
                line_code(line_index:line_index + 2) = [low_a low_a high_a];
                dc_offset = dc_offset - 1;
            end

        elseif (sum(binary_block == [0 1 1 1]) / 4) == 1

            line_code(line_index:line_index + 2) = [low_a zero_a high_a];

        elseif (sum(binary_block == [1 0 0 0]) / 4) == 1

            if dc_offset == 4
                line_code(line_index:line_index + 2) = [zero_a low_a low_a];
                dc_offset = dc_offset - 2;
            else
                line_code(line_index:line_index + 2) = [high_a zero_a zero_a];
                dc_offset = dc_offset + 1;
            end

        elseif (sum(binary_block == [1 0 0 1]) / 4) == 1

            if dc_offset == 4
                line_code(line_index:line_index + 2) = [low_a low_a low_a];
                dc_offset = dc_offset - 3;
            else
                line_code(line_index:line_index + 2) = [high_a low_a high_a];
                dc_offset = dc_offset + 1;
            end

        elseif (sum(binary_block == [1 0 1 0]) / 4) == 1

            if dc_offset == 1 || dc_offset == 2
                line_code(line_index:line_index + 2) = [high_a high_a low_a];
                dc_offset = dc_offset + 1;
            else
                line_code(line_index:line_index + 2) = [high_a low_a low_a];
                dc_offset = dc_offset - 1;
            end

        elseif (sum(binary_block == [1 0 1 1]) / 4) == 1

            line_code(line_index:line_index + 2) = [high_a zero_a low_a];

        elseif (sum(binary_block == [1 1 0 0]) / 4) == 1

            if dc_offset == 1
                line_code(line_index:line_index + 2) = [high_a high_a high_a];
                dc_offset = dc_offset + 3;
            else
                line_code(line_index:line_index + 2) = [low_a high_a low_a];
                dc_offset = dc_offset - 1;
            end

        elseif (sum(binary_block == [1 1 0 1]) / 4) == 1

            if dc_offset == 4
                line_code(line_index:line_index + 2) = [low_a zero_a low_a];
                dc_offset = dc_offset - 2;
            else
                line_code(line_index:line_index + 2) = [zero_a high_a zero_a];
                dc_offset = dc_offset + 1;
            end

        elseif (sum(binary_block == [1 1 1 0]) / 4) == 1

            line_code(line_index:line_index + 2) = [zero_a high_a low_a];

        elseif (sum(binary_block == [1 1 1 1]) / 4) == 1

            if dc_offset == 1
                line_code(line_index:line_index + 2) = [high_a high_a zero_a];
                dc_offset = dc_offset + 2;
            else
                line_code(line_index:line_index + 2) = [zero_a zero_a low_a];
                dc_offset = dc_offset - 1;
            end

        end

        % line index increment for next loop.
        line_index = line_index + 3;
    end

end
