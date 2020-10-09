function [decoded] =conv_decode(G,received,k,new_bits)
L = size(G,2);
states = 0:2^(L-k)-1;
states = dec2bin(states)-'0';
output_length = size(G,1);
x_n = 0:2^(k)-1;
x_n = dec2bin(x_n)-'0';
previous_state = zeros(2^k,output_length+k+1,size(states,1));
G = G';

for i = 1:length(states)
    for j = 1:size(x_n,1)
        temp = [fliplr(x_n(j,:)) states(i,:)];
        index = find(ismember(states,temp(1:end-k), 'rows'), 1);
        output = mod(temp*G,2);
        new_entry_row = find(previous_state(:,1,index)==0);
        previous_state(new_entry_row(1),:,index) = [i x_n(j,:) output];
    end
end

arc_bits = zeros(size(states,1),k,length(received)/output_length);

path = inf(size(states,1),length(received)/output_length+1);
coming_from_state = zeros(size(path)-[0,1]);

path(1,1) = 0;
step = 2;

for i = 1:output_length:length(received)
    rcvd_parity = received(i:i+output_length-1);
    for j = 1:2^(L-k)
        
        temp_path = zeros(1,2^k);
        for l = 1:2^k
            temp_path(l) = path(previous_state(l,1,j),step-1)+sum(abs(previous_state(l,(2+k):end,j)-rcvd_parity));
        end
        
        [path(j,step),index] = min(temp_path);
        coming_from_state(j,step-1) = previous_state(index,1,j);
        arc_bits(j,:,step-1) = previous_state(index,2:2+(k-1),j); 
    end
    step=step+1;
end

decoded=[];
[~,index]=min(path(:,end));
for i = size(coming_from_state,2):-1:1
    decoded = [decoded fliplr(arc_bits(index,:,i))];
    index = coming_from_state(index,i);
end
decoded(1:new_bits)=[];
decoded=fliplr(decoded);

end

