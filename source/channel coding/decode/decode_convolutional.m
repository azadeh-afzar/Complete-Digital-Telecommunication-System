% source/channel coding/decode/decode_convolutional.m
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

function out_stream = decode_convolutional(stream, g_matrix, shift, option)
    % INPUT:
    %   stream          = uncoded bit stream vector.
    %   g_matrix        = generator matrix.
    %   shift           = states shift.
    %   option          = other algorithm specific options.
    % OUTPUT:
    %   out_stream      = decoded data stream.

    % decode.
    [row, col] = size(g_matrix);
    % l = constraint length.
    l = col;

    if l < 3
        fprintf('\n');
        warning('Generator matrix should have at least 3 columns.');
        return;
    end

    % n = output size.
    n = row;
    states = de2bi(0:2^(l - shift) - 1, (l - shift), 'left-msb');
    [~, s_col] = size(states);

    % output for zero and one contains possible output for each state for input
    % zero and one.
    output_for_zero = zeros(2^n, n);
    output_for_one = zeros(2^n, n);

    for i = 1:size(states, 1)
        output = sum(bsxfun(@times, g_matrix, [0 states(i, :)]), 2);
        output_for_zero(i, :) = output';
        output = sum(bsxfun(@times, g_matrix, [1 states(i, :)]), 2);
        output_for_one(i, :) = output';
    end

    output_for_zero = rem(output_for_zero, 2);
    output_for_one = rem(output_for_one, 2);

    row = length(stream) / n;
    col = n;
    stream = reshape(stream, col, row);

    path_metric = zeros(2^(l - shift), size(stream, 2) + 1);
    path_metric(2:end) = Inf;
    decoded_stream = [];

    % assigning alpha and beta (where from each state comes).
    alpha = zeros(1, 2^n);
    beta = zeros(1, 2^n);

    for i = 1:size(states, 1)
        alpha(i) = find(ismember(states, [states(i, 2:end) 0], 'rows'));
        beta(i) = find(ismember(states, [states(i, 2:end) 1], 'rows'));
    end

    % decoding.
    for i = 1:size(path_metric, 2) - 1
        rcvd = stream(:, i)';
        branch_metric_0 = sum(abs(bsxfun(@minus, output_for_zero, rcvd)), 2);
        branch_metric_1 = sum(abs(bsxfun(@minus, output_for_one, rcvd)), 2);
        branch_metric = [branch_metric_0 branch_metric_1];
        pos_out = [];

        for j = 1:size(states, 1)
            pos_out = [pos_out states(j, 2)];
            a = path_metric(alpha(j), i) + branch_metric(alpha(j), states(j, 1) + 1);
            b = path_metric(beta(j), i) + branch_metric(beta(j), states(j, 1) + 1);
            path_metric(j, i + 1) = min(a, b);
        end

        [~, min_ind] = min(path_metric(:, i + 1));
        decoded_stream = [decoded_stream pos_out(min_ind)];
    end

    decoded_stream(1) = [];
    decoded_stream(end - s_col + 2:end) = [];
    out_stream = decoded_stream;
end
