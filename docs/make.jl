using NASAPrecipitation
using Documenter

DocMeta.setdocmeta!(NASAPrecipitation, :DocTestSetup, :(using NASAPrecipitation); recursive=true)

makedocs(;
    modules=[NASAPrecipitation],
    authors="Nathanael Wong <natgeo.wong@outlook.com>",
    repo="https://github.com/natgeo-wong/NASAPrecipitation.jl/blob/{commit}{path}#{line}",
    sitename="NASAPrecipitation.jl",
    format=Documenter.HTML(;
        prettyurls=get(ENV, "CI", "false") == "true",
        assets=String[],
    ),
    pages=[
        "Home" => "index.md",
    ],
)
