function [symbol,probability] = source_stat(msg)
symbol = unique(msg);
probability = histc(msg,symbol)/length(msg);

end

