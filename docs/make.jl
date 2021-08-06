using NASAPrecipitation
using Documenter

makedocs(;
    modules  = [NASAPrecipitation],
    doctest  = false,
    format   = Documenter.HTML(collapselevel=1,prettyurls=false),
    authors  = "Nathanael Wong <natgeo.wong@outlook.com>",
    sitename = "NASAPrecipitation.jl",
    pages    = [
        "Home" => "index.md",
    ],
)

deploydocs(
    repo = "github.com/natgeo-wong/NASAPrecipitation.jl.git",
    devbranch = "main"
)
