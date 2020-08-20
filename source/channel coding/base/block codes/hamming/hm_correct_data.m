% source/channel coding/base/block codes/hamming/hm_correct_data.m
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

function data_corrected = hm_correct_data(data, m)
    % Checks error and correct data using general algorithm
    % INPUT:
    %   data            = n bit data block (must be equal to the n of (2^m) - 1).
    %   m               = hamming distance.
    % OUTPUT:
    %   data_corrected  = k bit original data block.

    % generate H matrix.
    [h_matrix, ~, ~, ~, ~] = hm_generator(m);

    % Multiply received data with parity-check matrix
    data_hamm_parity_check = h_matrix * data';
    data_hamm_parity_check = rem(data_hamm_parity_check, 2);
    data_parity_error = bi2de(data_hamm_parity_check', 'right-msb');

    % Find out which data is broken and fix the data
    if data_parity_error(1)
        data(data_parity_error(1)) = not(data(data_parity_error(1)));
    end

    data_corrected = reshape(data, 1, []);
end
