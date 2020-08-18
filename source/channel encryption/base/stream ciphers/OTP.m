% source/channel encryption/base/stream ciphers/OTP.m
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

function out_stream = OTP(key, stream, option)
    % INPUT:
    %   key             = key for encryption.
    %   stream          = input stream.
    %   option          = other algorithm specific options.
    % OUTPUT:
    %   out_stream      = out put stream.

    stream_upsample = floor(option(1));
    stream_downsample = floor(option(2));
    sampling_method = floor(option(3));

    % upsample stream or not.
    if stream_upsample > 0

        if sampling_method == 1
            % upsample stream by adding zeros between symbols
            % of stream for 'stream_upsample' - 1 times.
            stream = upsample(stream, stream_upsample);
        else
            % upsample stream by repeating each bit
            % of stream by 'stream_upsample' times.
            stream = repelem(stream, stream_upsample);

        end

    end

    % get lengths of key and stream;
    len_key = length(key);
    len_stream = length(stream);

    % find stream propertise with respect to key.
    dividend = floor(len_stream / len_key);
    reminder = rem(len_stream, len_key);

    % create one time pad adjusted to stream length.
    if dividend >= 1
        otp = repelem(key, dividend);
        otp = [otp key(1:reminder)];
    else
        otp = key(1:reminder);
    end

    % XOR stream and otp code.
    mid_stream = double(xor(stream, otp));

    % upsample stream or not.
    if stream_downsample > 0

        if sampling_method == 1
            % upsample stream by adding zeros between symbols
            % of stream for 'stream_upsample' - 1 times.
            out_stream = downsample(mid_stream, stream_downsample);
        else
            % upsample stream by repeating each bit
            % of stream by 'stream_upsample' times.
            mid_stream = reshape(mid_stream, stream_downsample, len_stream / stream_downsample);
            % select upper row.
            out_stream = mid_stream(1, :);
        end

    else
        % do not down sample.
        out_stream = mid_stream;
    end

end
