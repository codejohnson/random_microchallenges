mutable struct Rec; hdr; seq; more; qual; end
_SANGER_BASE = 33; _NEW_LINE = '\n'
show(rec) = print(rec.hdr,_NEW_LINE, rec.seq,_NEW_LINE, rec.more,_NEW_LINE, rec.qual,_NEW_LINE)

# trimation of fasta record on first good average
function trim_extremes_in_fastaq(fastq, phred, frame)::Rec
    qual = fastq.qual
    left, right = 1, length(qual) - frame
    mean(from) = sum(map(c -> Int(c) - _SANGER_BASE, collect(qual[from : from + frame]))) / frame
    while left  < right && mean(left)        < phred    left  += 1  end
    while right > left  && mean(right-frame) < phred    right -= 1  end
    right += frame
    Rec(fastq.hdr, fastq.seq[left : right],fastq.more, qual[left : right])
end

# trimation with output for fastaq file. #For output file use a command line redirector
function trim_fastq(filename, phred, frame)
    read_fastaq(io; δ = readline) = Rec(δ(io),δ(io),δ(io),δ(io))
    open(filename) do reader
        while !eof(reader)
            show(trim_extremes_in_fastaq(read_fastaq(reader),phred,frame))
        end
    end
end

# interaction with command line arguments
function main()
    nul = isnothing
    num(s) = tryparse(Int64, s; base = 10)
    length(ARGS) != 3 && return println(stderr,"sintax is: filename, phred, frame")
    file, frame, phred = ARGS[1], num(ARGS[2]), num(ARGS[3])
    (nul(phred) || nul(frame)) && return println(stderr,"invalid numerical value in parameters")
    trim_fastq(file,phred,frame)
end

main()

