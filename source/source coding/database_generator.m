% source/source encoding/database_generator.m
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

function database_generator(data_dir_path, database_file_path)
    % INPUT:
    %   data_dir_path       = path to the directory of language reference text data.
    %   database_file_path  = path to a database file to save results.
    %
    % OUTPUT:
    %   a database .m file that can be loaded into other matlab programs and provide
    %   them with 'total_chars_count', 'unique_symbol', 'probability', 'code_word',
    %   'I', 'Hx', 'Ni', 'N', 'K' variables.
    %    

    % get language symbol frequency statistics.
    [total_chars_count, unique_symbol, ...
            probability] = language_statistics(data_dir_path);

    % generate code worr for symbols based on the probability of each symbol.
    code_word = huffman_encoding(probability);

    % get information theory values for this information source.
    [I, Hx, Ni, N, K] = information_theory(probability, code_word);

    % save data in database.
    save(database_file_path, 'total_chars_count', 'unique_symbol', 'probability', 'code_word', ...
        'I', 'Hx', 'Ni', 'N', 'K')

end
