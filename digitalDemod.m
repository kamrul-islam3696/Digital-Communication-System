function [demodulated_signal] = digitalDemod(type,received, M, A, f, k, Rb,N)
Tb = 1/Rb;
Fs = k*Rb;
Ts = 1/Fs;

%% BASK
if strcmp(type,'BASK')
    
    m = received;
    t = 0:Ts:N*Tb-Ts;
    f1 = f;
    m1 = sin(2*pi*f1*t);
    A0 = A(1);
    A1 = A(2);
    tr = (A0+A1)/4;
    
    md1 = m.*m1;
    
    for i = 1:N
        yd1(i) = sum(md1(k*(i-1)+1:k*i))/k;
    end
    
    for i = 1:length(yd1)
        if yd1(i) >= tr
            yr(i) = 1;
        else
            yr(i) = 0;
        end
    end
    demodulated_signal = yr;
end


%% PSK
if strcmp(type,'PSK')
    
    r = received;    
    bn = log2(M);
    t = 0:Ts:bn*Tb-Ts;
    output = [];
    for i = 1:length(t):length(r)
        sig = r(i:(i-1)+length(t));
        r1 = sig .* sin(2*pi*f*t);
        r2 = sig .* cos(2*pi*f*t);
        ai = mean(r1);
        aq = mean(r2);
        phi = (0:M-1) * 2 * pi ./ M;
        distance = (A*cos(phi) - 2*ai).^2 + (A*sin(phi) - 2*aq).^2;
        [~, min_ind] = min(distance);
        min_ind = min_ind - 1;
        sym = de2bi(min_ind, bn, 'left-msb');
        output = [output sym];
    end
    demodulated_signal = output;
end

end

