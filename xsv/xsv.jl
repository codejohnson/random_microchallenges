include("xsvfiles.jl")
function main()
    if length(ARGS) <3 
        println("syntax: julia sourcefile.jl {coma|colon|tab|space} {select|sum|avg|count}=fieldname{,...}")
        return
    end
    execute_command(ARGS[1],ARGS[2],ARGS[3])
end
main()