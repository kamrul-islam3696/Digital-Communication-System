function [encoded,new_bits] = conv_code(G,bit,k)

new_bits=0;
if(mod(length(bit),k)~=0)
    new_bits=k-mod(length(bit),k);
end
bit=[bit zeros(1,new_bits)];

encoded = conv2(bit, G);
encoded = rem(encoded,2);
encoded(:,(end-(size(G,2)-2)):end)=[];
encoded = encoded (:, k:k:end);
encoded=reshape(encoded,1,numel(encoded));


end

