using DataFrames, CSV, Plots, Query
theme(:dark)
μ = (lc)->length(lc) < 12 ? lc : lc[1:12]
df = CSV.read("plastics.csv", DataFrame);
df = @from i in df begin
     @where i.parent_company in ["null", "Grand Total"] && i.grand_total != "NA"
     @select {Ω = i.country, Σ = i.grand_total}
     @collect DataFrame
    end;
df[!, :Σ], df[!, :Ω] = parse.(UInt32, df[:, :Σ ]), uppercase.(μ.(df[:,:Ω]));
df = combine(groupby(df, :Ω), :Σ => sum)
sort!(df , :Σ_sum);

bar(title = "Recolección de Plástico", ylabel = "Países", xlabel = "Cantidades");
bar!(  df[!,:Ω], df[!,:Σ_sum], orientation=:h, bar_edges=true, legends=false, 
       yticks=(1:65,df.Ω), bar_width=0.7, size = [1000, 950])