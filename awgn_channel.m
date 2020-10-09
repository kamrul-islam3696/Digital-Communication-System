function [ n_signal ] = awgn_channel(signal,SNR )

n_signal = awgn(signal,SNR,'measured');

end

