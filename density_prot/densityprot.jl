#
# Multifile fasta density calculation
# use:
#  julia density.jl archivo,[archivo,...] [> output]
#
using Printf
mutable struct Prot dens; hdr; seq; end 
function protein_density(filename::String)
    amino = Dict(
        'A' => 89.1, 'R' => 174.2, 'N' => 132.1, 'D' => 133.1, 'C' => 121.2, 'E' => 147.1, 'Q' => 146.2, 
        'G' => 75.1, 'H' => 155.2, 'I' => 131.2, 'L' => 131.2, 'K' => 146.2, 'M' => 149.2, 'F' => 165.2, 
        'P' => 115.1, 'S' => 105.1, 'T' => 119.1,'W' => 204.2, 'Y' => 181.2, 'V' => 117.1, 
        'U' => 168.1, '*' => 0.0, '\n' => 0.0
    )
    Ψ = ""
    max , cur = Prot(0,Ψ,Ψ), Prot(0,Ψ,Ψ)
    density(seq) = begin # asterisk aminos, are used as a mean of the rest amino acids
        net_length = (length(seq) - count(==('\n'),seq))
        weight = sum(amino[c] for c in seq)
        prom = weight / (net_length - (asterisks = count(==('*'),seq)))
        (weight + asterisks * prom) / net_length
    end
    reset() = cur.hdr, cur.seq = Ψ,Ψ
    check() = (dens = density(cur.seq)) > max.dens && (max = Prot(dens, cur.hdr, cur.seq))
    open(filename) do io
        cur.hdr = strip(readline(io))
        while !eof(io)
            line = readline(io)
            if !startswith(line,'>')
                cur.seq *= line
            else
                check()
                cur.hdr, cur.seq = strip(line),Ψ
            end
        end
        check()
    end
    max
end

function main()
    if length(ARGS) == 0
        println("Fasta file name missing. Use one or more fasta files.")
        return
    end
    for f in ARGS
        max = protein_density(f)
        @printf("%s [density=%5.2f]\n%s\n",max.hdr, max.dens, max.seq)
    end
end
main()