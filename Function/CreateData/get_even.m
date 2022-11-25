function val = get_even(input)
a = round(input);
if mod(a,2)==0
    val = a;
else
    if abs(input-a-1)<abs(input-a+1)
        val = a+1;
    else
        val = a-1;
    end
end

