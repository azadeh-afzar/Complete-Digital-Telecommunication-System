% source/channel coding/base/block codes/hamming/hm_generator.m
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

function [H, G, R, n, k] = hm_generator(m)
    % Generate Hamming code matrices with general algorithm.
    % INPUT:
    %   m               = hamming distance.
    % OUTPUT:
    %   H               = parity-check matrix.
    %   G               = generator matrix.
    %   R               = recover matrix.
    %   n               = block length.
    %   k               = message length.

    % get [n, k] size of hamming code.
    n = (2^m) - 1;
    k = n - m;

    % Generate [n x m] parity-check matrix H
    H = zeros(m, n);

    for X = 1:m

        for Y = 0:length(H) - 1
            kk = Y < n / 2^X;

            if kk
                Z = ((2^X) * Y + 2^(X - 1)):((2^X) * Y + (2^X) - 1);
                H(X, Z) = 1;
            end

        end

    end

    % Generate generator matrix G
    % Extract parity matrix
    for ii = 1:m% ii : row number 1~k th row
        iii = 1; % iii : column number
        cn = 0; % H matrix column number

        for i = 1:n% H matrix column search

            if i == 2^cn
                cn = cn + 1;
                continue
            end

            gg(ii, iii) = H(ii, i);
            iii = iii + 1;
        end

    end

    % Combine parity matrix and identity matrix
    gg = gg';
    G = zeros(k, n);
    I = eye(k);
    % H matrix parity column number
    cn = 1;
    % identity matrix column number
    ii = 1;

    % H matrix column search
    for i = 1:n

        if i == 2^(cn - 1)
            G(:, i) = gg(:, cn);
            cn = cn + 1;
            continue
        end

        G(:, i) = I(:, ii);
        ii = ii + 1;
    end

    G = G';

    % Generate recover matrix R
    R = zeros(k, n);
    I = eye(k);
    % H matrix parity column number
    cn = 1;
    % identity matirx column number
    ii = 1;

    for i = 1:n% R matrix column search

        if i == 2^(cn - 1)
            cn = cn + 1;
            continue
        end

        R(:, i) = I(:, ii);
        ii = ii + 1;
    end

end
