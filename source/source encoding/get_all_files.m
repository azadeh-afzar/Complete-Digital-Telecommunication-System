% source/source encoding/get_all_files.m
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

function file_list = get_all_files(directory_name)
    % INPUT:
    %   directory_name  = path to the desired directory.
    % OUTPUT:
    %   file_list       = list of files in that directory.

    directory_data = dir(directory_name);                   % Get data of assets/books directory.
    directory_index = [directory_data.isdir];               % Find index of subdirectories.
    file_list = {directory_data(~directory_index).name}';   % Get list of files.

    % append path to filenames.
    if ~isempty(file_list)
        file_list = cellfun(@(file) fullfile(directory_name, file), ...
            file_list, 'UniformOutput', false);
    end

    % specify valid subdirectories. (filter out . and .. dirs).
    sub_directories = { directory_data(directory_index).name };
    valid_index = ~ismember(sub_directories, {'.', '..'});

    % recursively read all file names in sub directories.
    for directory = find(valid_index)
        next_directory = fullfile(directory_name, sub_directories{directory});
        file_list = [file_list; get_all_files(next_directory)];
    end

end
