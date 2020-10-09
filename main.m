clc;
clear all;
close all;


%% collecting the message from the file
file=fopen('source_data.txt','r');
data=fread(file,inf);
fclose(file);
msg = char(data)';


%% Source Statistics
[sym,prob] = source_stat(msg);


%% Huffman Encoding
Code = Huffman_encoding(sym,prob);




%% Bit generating
bit_stream = Bit_generator(sym,Code,msg);
bit = bit_stream{1} - '0';


%% conv encoding
% Generator
G = [1 1 1 ; 1 0 1];
k = 1;
[y,new_bits] = conv_code(G,bit,k);


%% modulation
M = 4;      %  QPSK
% A = 1;
freq = 4000;
Rb = 1000;  %bit rate
spb = 20;     %samples per bit
e_bit = 0;

if(mod(length(y),log2(M))~=0)
    e_bit=log2(M)-mod(length(y),log2(M));
end
y=[y zeros(1,e_bit)];

modulated = digitalMod('PSK',M,y,1,freq,spb,Rb); %PSK
% modulated = digitalMod('BASK',M,y,[4 1],freq,spb,Rb); %BASK

%% noise
SNR = -30:5:10;
for z = 1:length(SNR)
    
    received = awgn_channel(modulated,SNR(z));
    
    %% demodulation
    
    output = digitalDemod('PSK',received,M,1,freq,spb,Rb,length(y)); %PSK
%     output = digitalDemod('BASK',received,M,[4 1],freq,spb,Rb,length(y)); %BASK
    
    
    output((end-e_bit+1):end)=[];
    
    
    %% Viterbi Decoder
    
    out = conv_decode(G,output,k,new_bits);
    
    BER(z) = mean(abs(out - bit));
    
end
figure()
plot(SNR, BER,'LineWidth', 2);
grid on;
title('BER Vs SNR');


%% Huffman Decoding
a = num2str(out);
out_bit = cellstr(a(find(~isspace(a))));
decoded_msg = Huffman_decoding(sym,Code,out_bit);


%% checking whether the decoded msg is accurate or not
if strcmp(decoded_msg,msg)
    disp('accurate')
else
    disp('wrong')
end


% dlmwrite('received.txt',decoded_msg,'delimiter','');
