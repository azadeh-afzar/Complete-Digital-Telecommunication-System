% source/source encoding/source encoder.m
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

function bit_stream = source_encoding(unique_symbol, code_word, msg)
    % INPUT:
    %   unique_symbol = a string of unique symbols
    %   code_word = cell array of code to represent each probability of the symbols
    % OUTPUT:
    %   msg = message that has to be converted into bit stream

    % add subfolders to matlab file path.
    addpath(genpath('.'));

    bit_stream = '';
    increment = length(char(unique_symbol(1)));

    for i = 1:increment:length(msg)
        index = strfind(unique_symbol, msg(i:i + increment - 1));
        bit_stream = [bit_stream char(code_word(index))];
    end

    % converting string bit stream to double vector array
    bit_stream = double(bit_stream - double('0'));
end
