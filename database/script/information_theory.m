% database/script/information_theory.m
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

function [information_I, antropy_Hx, ...
          code_word_Ni, code_word_average_len_N, ...
          keraft_K] = information_theory(probability, code_word)

    information_I = log2(1 ./ probability);
    antropy_Hx = sum(probability .* information_I);
    
    len = length(code_word);
    code_word_Ni = zeros(1, len);
    
    for i = 1:len
        code_word_Ni(1, i) = length(code_word{i});
    end

    code_word_average_len_N = sum(probability .* code_word_Ni);
    
    keraft_K = sum(2 .^ - code_word_Ni);
        
     
