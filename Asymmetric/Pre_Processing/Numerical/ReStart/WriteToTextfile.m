Name = {'1.txt','2.txt','3.txt','4.txt','5.txt','6.txt','7.txt','8.txt','9.txt','10.txt','11.txt','12.txt','13.txt','14.txt','15.txt','16.txt','17.txt','18.txt'};
comma = 0;
for i = 1:numel(Name)
	comma = comma + sum(Name{i} == ",");
end
comma = comma + 1;
for k = 1:comma
	diary (Name{k});
	FunctionH{k};
	diary off;
end
