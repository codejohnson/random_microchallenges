export execute_command

~ = length
calc_avg(nfile, sep, locations) = calc(nfile, sep, locations, sum_fld) / calc(nfile, sep, locations, count_fld)
sum_fld(rec, locs) = begin s = 0.0; for i in 1:~locs; s += value(rec[locs[i]]) end; s end
count_fld(rec, locs) = begin c = 0; for i in 1:~locs; c += unit(rec[locs[i]]) end; c end
value(s) = begin val = tryparse(Float64,s); val !== nothing ? val : 0.0 end
unit(s) = begin val = tryparse(Float64,s); val !== nothing ? 1 : 0 end
get_cmds() = Dict("select"=>[select],"sum"=>[calc,sum_fld],"count"=>[calc,count_fld],"avg"=>[calc_avg])
get_sep(sep) = sep == "colon" ? ',' : sep == "colon" ? ':' : sep == "tab" ? '\t' : sep == "semicolon" ? ';' : sep == "space" ? ' ' : '?'   
get_hdrs(nfile,sep) = open(nfile) do io return split(readline(io),sep) end
query_name(cmd) = split(cmd,'=')[1]
query_fields(cmd) = split(split(cmd,'=')[2],',')

function calc(nfile, sep, locs, fx)
    hdrs = get_hdrs(nfile,sep)
    calc = 0.0
    open(nfile) do io
        while !eof(io)
            rec = split(readline(io),sep)
            ~rec == ~hdrs && (calc += fx(rec, locs))
        end
    end
    fx == count_fld ? Int(calc) : calc
end

function select(nfile, sep, locs)
    hdrs = get_hdrs(nfile,sep)
    total = ~hdrs
    open(nfile) do io
        while !eof(io)
            rec = split(readline(io),sep)
            ~rec != total && continue 
            cols = ~locs 
            for c in 1:cols
                print(rec[locs[c]], c < cols ? sep : '\n')
            end
        end
    end
end

function locations(nfile, sep, cmd)
    fields = get_hdrs(nfile,sep)
    locs = []
    for field in query_fields(cmd)
        for idx in 1:~fields
            (field == fields[idx] || "\""*field*"\"" == fields[idx]) && push!(locs,idx)
        end
    end
    locs
end

function doquery(nfile,sep,cmd)
    fx = get_cmds()[query_name(cmd)]
    ~fx == 1 && (result = fx[1](nfile, sep, locations(nfile, sep, cmd)))
    ~fx == 2 && (result = fx[1](nfile, sep, locations(nfile, sep, cmd),fx[2]))
    result !== nothing && println(result)
end

function execute_command(nfile, sep, cmd)
    if !(split(cmd,'=')[1] in keys(get_cmds()))
        println("invalid query: use sum,avg,count,select")
    else
        separator = get_sep(sep)
        fields, qry_flds = get_hdrs(nfile,separator), query_fields(cmd)
        if !all(x in fields || "\""*x*"\"" in fields for x in qry_flds)
            println("bad field in query. Check fieldnames or separator used.")
        else
            doquery(nfile,separator,cmd)
        end
    end
end
