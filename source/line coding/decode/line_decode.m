% source/line coding/decode/line_decode.m
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

function bit_stream = line_decode(line_code_name, line_code, amplitude, option)
    % INPUT:
    %   line_code_name  = name of line coding algorithm.
    %   line_code       = line coded signal to be converted to bit stream.
    %   amplitude       = magnitude levels for high, zero and low.
    %   option          = other algorithm specific options.
    % OUTPUT:
    %   signal          = line coded stream.

    switch line_code_name
        case '4B3T'
            bit_stream = decode_4B3T(line_code, amplitude, option);
        otherwise
            fprintf('\n');
            warning(['"', line_code_name, '" Line code is not supported! ONLY "4B3T" are supported.']);
            return;
    end

end