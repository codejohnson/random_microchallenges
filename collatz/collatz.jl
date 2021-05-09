function typed_flat_collantz(b::Int64)::Tuple{Int64,Int64}
    ms::Tuple{Int64,Int64} = (0,0)
    while b > 0
        n::Int64 = b
        c::Int64 = 0
        while n > 1
            c += 1
            n = if n % 2 == 1  3 * n + 1 else n / 2 end
        end
        if c > ms[2] ms = (b,c) end
        b -= 1
    end
    ms
end
print(max_collantz_speed(1,100000000))
