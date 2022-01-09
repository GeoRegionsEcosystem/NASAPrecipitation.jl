using NASAPrecipitation
using Documenter

makedocs(;
    modules  = [NASAPrecipitation],
    doctest  = false,
    format   = Documenter.HTML(collapselevel=1,prettyurls=false),
    authors  = "Nathanael Wong <natgeo.wong@outlook.com>",
    sitename = "NASAPrecipitation.jl",
    pages    = [
        "Home"                        => "index.md",
        "NASAPrecipitation Datasets" => [
            "The NASAPrecipitation Dataset Type" => "datasets/npd.md",
            "GPM IMERG Datasets"             => "datasets/imerg.md",
            "TRMM TMPA Datasets"             => "datasets/trmm.md",
            "Land-Sea Mask Datasets"         => "datasets/landseamask.md",
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
