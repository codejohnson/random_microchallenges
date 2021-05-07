function max_collantz_speed(a,b)
    ms = (0,0)
    next = (x) -> x % 2 == 1 ? 3 * x + 1 : x / 2 
    speed = (s) -> s == 1 ? 0 : speed(next(s)) + 1      
    for i in a:b+1
        s= speed(i)
        if s > ms[2] ms = (i,s) end
    end
    ms
end
print(max_collantz_speed(1,100))
