function [Decoded_msg] = Huffman_decoding(symbol,Code,Bit_stream)
Bit_stream = char(Bit_stream);
N = length(Bit_stream);
Decoded_msg = [];

%%determining the maximum length of code word
for i = 1:length(Code)
    c(i) = length(Code{i});
end
maxlen = max(c);

%%decoding 
i = 1;
while i <= N
    temp = [];
    flag = 0;
    for j = i:i+maxlen
        temp = strcat(temp,Bit_stream(j));
        for k = 1:length(Code)
            if strcmp(temp,Code{k})
                  Decoded_msg = [Decoded_msg symbol(k)];
                flag = 1;
                break;
            end
        end
        if flag
            break;
        end
    end
    i = i+ length(temp);
end

end

