% database/script/language_statistics.m
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

function [total_chars_count, unique_symbol, probability] = language_statistics(reference_directory)
    % INPUT:
    %   reference_directory = path to the directory of language reference text data.
    %
    % OUTPUT:
    %   total_chars_count   = total number of characters analyzed.
    %   unique_symbol       = string of unique symbols
    %   probability         = probability of each unique symbols

    file_list = get_all_files(reference_directory);

    tic
    fprintf('Reading labguage reference books data ...\n');

    % variable to hold all the data.
    text = char();

    for index = 1:numel(file_list)
        current_file = file_list{index};
        [~, ~, extension] = fileparts(current_file);
        % only read text files, ignore all other type of files.
        if strcmp(extension, char('.txt'))
            file = fopen(current_file, 'r');
            text = append(text, '\n', fread(file, '*char')');
            fclose(file);
        end

    end

    fprintf('Done.\n');
    toc
    fprintf('\n');

    % Sanitize text: remove all none-ascii codes to only use clean ASCII codes
    % accepted range for information source data is 0 - 127 decimal, 00 - 7F Hexadecimal.
    tic
    fprintf('Sanitizing data data ...\n');
    text(regexp(text, '[^\x00-\x7F]')) = [];
    fprintf('Done.\n');
    toc
    fprintf('\n');

    % Use source_statistics function to compute uniqe symbols
    % and probability of each symbol.
    tic
    fprintf('Analyzing data and computing probability ...\n');
    [unique_symbol, probability] = source_statistics(text);
    fprintf('Done.\n');
    toc
    fprintf('\n');

    % Count number of characters.
    total_chars_count = size(text); total_chars_count = total_chars_count(2);
end
