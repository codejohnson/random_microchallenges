def max_collantz_speed(x:int,n:int)->tuple:
    ms = (0,0)
    next = lambda x: 3 * x + 1 if x % 2 else x / 2 
    speed = lambda s: 1 + speed(next(s)) if s - 1 else 0      
    while (x:=x+1) < n+1:
        if (s:= speed(x)) > ms[1]:
            ms = (x,s)
    return ms

print(max_collantz_speed(1,10_000_000))
