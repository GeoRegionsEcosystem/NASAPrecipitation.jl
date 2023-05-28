using Documenter
using NASAPrecipitation
using Literate

using CairoMakie # to avoid capturing precompilation output by Literate
CairoMakie.activate!(type = "svg")

makedocs(;
    modules  = [NASAPrecipitation],
    doctest  = false,
    format   = Documenter.HTML(collapselevel=1,prettyurls=false),
    authors  = "Nathanael Wong <natgeo.wong@outlook.com>",
    sitename = "NASAPrecipitation.jl",
    pages    = [
        "Home"                        => "index.md",
        "NASAPrecipitation Datasets" => [
            "What is a NASA Precipitation Dataset?" => "nasaprecipitation/intro.md",
            "Defining NASA Precipitation Datasets"  => "nasaprecipitation/define.md",
            "GPM IMERG Datasets" => "nasaprecipitation/imerg.md",
            "TRMM TMPA Datasets" => "nasaprecipitation/trmm.md",
            "Dummy Datasets"     => "nasaprecipitation/dummy.md",
        ],
        "A Basic Primer to `GeoRegion`s" => "georegions/basics.md",
        "Downloading Datasets" => "download.md",
        "Reading Downloaded Data" => "read.md",
        "Examples" => [
            "Downloading IMERG Data"  => "examples/download.md",
            "Land-Sea Mask Filtering" => "examples/landseamask.md",
        ],
    ],
)

deploydocs(
    repo = "github.com/natgeo-wong/NASAPrecipitation.jl.git",
    devbranch = "main"
)
