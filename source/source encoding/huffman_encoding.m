% source/source encoding/huffman_encoding.m
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

function code_word = huffman_encoding(probability)
    % INPUT:
    %   probability = a vector of probability of the unique symbols.
    % OUTPUT:
    %   code_word = cell array of huffman code word for each unique symbol.

    symbol_count = length(probability);
    code_word = cell(1, symbol_count);

    % from descending order to ascending order.
    probability = fliplr(probability);

    % initializing code word for symbol_count = 1 case.
    if symbol_count == 1
        code_word{1} = '1';
    end

    x = zeros(symbol_count, symbol_count);
    x(:, 1) = (1:symbol_count)';

    for i = 1:symbol_count - 1
        temp = probability;
        [~, min1] = min(temp);
        temp(min1) = 1;
        [~, min2] = min(temp);
        probability(min1) = probability(min1) + probability(min2);
        probability(min2) = 1;
        x(:, i + 1) = x(:, i);

        for j = 1:symbol_count

            if x(j, i + 1) == min1
                code_word(j) = strcat('0', code_word(j));
            elseif x(j, i + 1) == min2
                x(j, i + 1) = min1;
                code_word(j) = strcat('1', code_word(j));
            end

        end

    end

    code_word = fliplr(code_word);
end
