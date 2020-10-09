function [Code] = Huffman_encoding(symbol,P)
P = P';
N = length(P);
X = zeros(N,N);
Code = cell(1,N);
Probability = zeros(N,N);
Probability(:,1) = P;
X(:,1) = 1:N';

i = 2;
while (1)           
   [~,min1] = min(P);
   temp = P;
   temp(min1) = 100;
   
   [~,min2] = min(temp);       
   
   P(min1) = P(min1)+ P(min2);
   P(min2) = 100;
   
   
   Probability(:,i) = P;
   X(:,i) = X(:,i-1);
   
   for j = 1:N
        if X(j,i) == min2
            X(j,i) = min1;
            Code(j) = strcat('1', Code(j));
        elseif X(j,i) == min1
            Code(j) = strcat('0', Code(j));
        end
   end
   
   if i == N
       break;
   end
    
   i = i+1;
    
end

end

