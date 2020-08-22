%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%                           "Setup MATLAB"                            %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% clear memory and screen.
clc, clear, close all;

% add project's source to matlab file path.
addpath(genpath('../source'));

% define global variables.
% database file paths.
DATA_DIR_PATH = '../asset/language references/English';
DATABASE_FILE_PATH = '../database/English.mat';
TEXT_DATA_FILE = '../asset/text data/in.txt';

% plot options.
enable_waveform = 1;
enable_spectrum = 1;
enable_phase = 1;
enable_name = 1;
plot_option = [enable_waveform enable_spectrum enable_phase, enable_name];

% system specifications.
encryption_name = 'OTP';
encryption_key = [1 1 1 1 0 0 0 0 0 1 1 0 0 1 1 1 1 1 0 1 0 0 1 1 0 1 1 1 1 1 1 0];
encrypt_option = [0 0 0];

ch_code_layer1_name = 'interleaver';
ch_code_layer1_g_matrix = [3 1 2 4];
ch_code_layer1_option = [1, 0, 0];

ch_code_layer2_name = 'hamming';
ch_code_layer2_option = [3, 0, 0];

ch_code_layer3_name = 'convolutional';
ch_code_layer3_g_matrix = [0 0 1; 0 1 0; 0 1 1];
ch_code_layer3_shift = 1;

ch_code_layer4_name = 'interleaver';
ch_code_layer4_g_matrix = [1, 6, 8, 4, 7, 3, 2, 5];
ch_code_layer4_option = [1, 0, 0];

line_code_name = '4B3T';
line_code_amplitudes = [2 0 -2];
line_code_option = [0];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%                      "Reading Text Data File"                       %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

tic
% get source encoding data.
% database_generator(DATA_DIR_PATH, DATABASE_FILE_PATH);
load(DATABASE_FILE_PATH);
fprintf('Reading data: ');
file = fopen(TEXT_DATA_FILE);
data = fread(file, '*char')';
len_data = length(data);
fclose(file);
toc

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%                          "Source Encoder"                           %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
tic
fprintf('Stream generator: ');
bit_stream = source_encoder(unique_symbol, code_word, data);
len_stream = length(bit_stream);
toc

input1 = bit_stream;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%                            "Encrypting"                             %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
tic
fprintf('Encrypting: ');
% OTP [1]
opt_encoded_stream = channel_encryption('encode', encryption_name, encryption_key, bit_stream, encrypt_option);
len_encrypt = length(opt_encoded_stream);
toc

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%                          "Channel Encode"                           %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
tic
fprintf('Channel Encode: ');

% interleaver [4 1]
ch_encoded_layer1 = channel_coding('encode', ch_code_layer1_name, opt_encoded_stream, ch_code_layer1_option, ch_code_layer1_g_matrix, 0);
len_chce1 = length(ch_encoded_layer1);

% hamming [7 4]
ch_encoded_layer2 = channel_coding('encode', ch_code_layer2_name, ch_encoded_layer1, ch_code_layer2_option, 0, 0);
len_chce2 = length(ch_encoded_layer2);

% convolutional
ch_encoded_layer3 = channel_coding('encode', ch_code_layer3_name, ch_encoded_layer2, 0, ch_code_layer3_g_matrix, ch_code_layer3_shift);
len_chce3 = length(ch_encoded_layer3);

% interleaver [16 1]
ch_encoded_layer4 = channel_coding('encode', ch_code_layer4_name, ch_encoded_layer3, ch_code_layer4_option, ch_code_layer4_g_matrix, 0);
len_chce4 = length(ch_encoded_layer4);

toc

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%                             "Line Coding"                           %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
tic
fprintf('Line Encode: ');
% 4B3T [1]
line_en = line_coding('encode', line_code_name, ch_encoded_layer4, line_code_amplitudes, line_code_option);
len_line_en = length(line_en);
toc

Rb = 500;
Tb = 1 / Rb; % bit duration
spb = 50;
Fs = spb * Rb; % sampling frequency
Ts = 1 / Fs;
N = length(line_en);
time = 0:Ts:N * Tb - Ts;
freq = 5000;

amp_carrier = 5;
u = 0.5;

line_en_sampled = repelem(line_en, spb);
modulated = amp_carrier .* (1 + u .* line_en_sampled) .* cos(2 * pi * freq * time);
plotspec(modulated, Ts, "Modulated", plot_option);

channel = awgn(modulated, -20);


demod1 = envelope(channel);
plotspec(demod1, Ts, "Demodulated", plot_option);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%                             "Line Decode"                           %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
tic
fprintf('Line Decode: ');
line_de = line_coding('decode', line_code_name, line_en, line_code_amplitudes, line_code_option);
len_line_de = length(line_de);
toc

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%                           "Channel Decode"                          %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
tic
fprintf('Channel Decode: ');
ch_decoded_layer4 = channel_coding('decode', ch_code_layer4_name, line_de, ch_code_layer4_option, ch_code_layer4_g_matrix, 0);
len_chcd4 = length(ch_decoded_layer4);

ch_decoded_layer3 = channel_coding('decode', ch_code_layer3_name, ch_decoded_layer4, 0, ch_code_layer3_g_matrix, ch_code_layer3_shift);
len_chcd3 = length(ch_decoded_layer3);

ch_decoded_layer2 = channel_coding('decode', ch_code_layer2_name, ch_decoded_layer3, ch_code_layer2_option, 0, 0);
len_chcd2 = length(ch_decoded_layer2);

ch_decoded_layer1 = channel_coding('decode', ch_code_layer1_name, ch_decoded_layer2, ch_code_layer1_option, ch_code_layer1_g_matrix, 0);
len_chcd1 = length(ch_decoded_layer1);
toc

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%                            "Decrypting"                             %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
tic
fprintf('Decrypting: ');
opt_decoded_stream = channel_encryption('decode', encryption_name, encryption_key, ch_decoded_layer1, encrypt_option);
len_decrypt = length(opt_decoded_stream);
toc

output1 = opt_decoded_stream;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%                          "Source Decoder"                           %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
tic
fprintf('Source Decoder: ');
recieved_data = source_decoder(unique_symbol, code_word, opt_decoded_stream);
len_data_r = length(recieved_data);
toc

bit_err = sum(input1 ~= output1);
ber = sum(input1 ~= output1) / length(input1);
