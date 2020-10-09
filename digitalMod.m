function [modulated_signal] = digitalMod(type,M, bit_stream, A, f, k, Rb)
Tb = 1/Rb;
Fs = k*Rb;
Ts = 1/Fs;
y = [];


%% BASK
if strcmp(type,'BASK')
    
    bit = bit_stream;
    N = length(bit);
    t = 0:Ts:N*Tb-Ts;
    f1 = f;
    m1 = sin(2*pi*f1*t);
    A0 = A(1);
    A1 = A(2);
    
    for i = 1:N
        y = [y bit(i)*ones(1,k)];
    end
    
    for j = 1:length(t)
        if y(j)
            m(j) = A0*m1(j);
        else
            m(j) = A1*m1(j);
        end
    end
    
    modulated_signal = m;
    
end



%% PSK
if strcmp(type,'PSK')
    
    bn = log2(M);
    t = 0:Ts:bn*Tb-Ts;
    msg = bit_stream;
    
    % Gray code generation
    x = 0:M-1;
    code = bin2gray(x, 'psk', M);
    gray_code = cell(1, M);
    for i = 1:M
        gray_code(i) = cellstr(dec2bin(code(i), bn));
    end
    
    for i = 1:bn:length(msg)
        s = msg(i:i+bn-1);
        sym = '';
        for j = 1:length(s)
            sym = [sym num2str(s(j))];
        end
        ind = find(strcmp(gray_code, sym), 1);
        val = bin2dec(char(gray_code(ind)));
        phi = 2 * pi * val / M;
        y = [y A*sin(2*pi*f*t + phi)];
    end
    modulated_signal = y;
    
end




end

