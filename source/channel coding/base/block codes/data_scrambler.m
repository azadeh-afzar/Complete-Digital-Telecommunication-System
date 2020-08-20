% source/channel coding/base/block codes/data_scrambler.m
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

function out_data_block = data_scrambler(data_block, g_vector)
    % INPUT:
    %   data_block        = input data block.
    %   g_vector          = index generator vector.
    % OUTPUT:
    %   out_block         = output data block.

    % determine block size for scrambling based on generator vector.
    len_g_vector_block = size(g_vector, 2);
    len_g_vector_uniqe = size(unique(g_vector));
    max_index_g_vector = max(g_vector);
    len_data_block = size(data_block, 2);

    % do checks.
    if len_data_block ~= len_g_vector_block
        fprintf('\n');
        error('data block length is not equal to generator vector length!');
    end

    if len_g_vector_block ~= len_g_vector_uniqe
        fprintf('\n');
        error('generator vector must not have duplicate index');
    end

    if len_g_vector_block ~= max_index_g_vector
        fprintf('\n');
        error('generator vector does not have all indexes for this block size!');
    end

    out_data_block = data_block(g_vector);

end
