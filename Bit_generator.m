function [Bit_stream] = Bit_generator(symbol,Code,msg)
N = length(msg);
M = length(symbol);
Bit_stream = [];

for i = 1:N
    for j = 1:M
        if strcmp(msg(i),symbol(j))
            Bit_stream = strcat(Bit_stream,Code(j));
        end
    end
end

end

