using Documenter
using NASAPrecipitation
using Literate

using CairoMakie # to avoid capturing precompilation output by Literate
CairoMakie.activate!(type = "svg")

setup(
    login = "nasaprecipitation",
    password = "NASAPrecipitation1"
)

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
        "Using NASAPrecipitation.jl" => [
            "Integration with GeoRegions.jl"  => "using/georegions.md",
            "Downloading and Saving Datasets" => "using/download.md",
            # "Reading a Dataset"               => "using/read.md",
            # "Extraction of subGeoRegions"     => "using/extract.md",
        ],
        "LandSea Datasets: GPM and TRMM" => [
            "What is a LandSea Dataset?" => "landsea/intro.md",
            "Loading LandSea Datasets"   => "landsea/create.md",
        ],
        # "Downloading Datasets" => "download.md",
        # "Reading Downloaded Data" => "read.md",
        # "Examples" => [
        #     "Downloading IMERG Data"  => "examples/download.md",
        #     "Land-Sea Mask Filtering" => "examples/landseamask.md",
        # ],
    ],
)

recursive_find(directory, pattern) =
    mapreduce(vcat, walkdir(directory)) do (root, dirs, files)
        joinpath.(root, filter(contains(pattern), files))
    end

files = []
for pattern in [r"\.txt", r"\.nc"]
    global files = vcat(files, recursive_find(@__DIR__, pattern))
end

for file in files
    rm(file)
end

deploydocs(
    repo = "github.com/natgeo-wong/NASAPrecipitation.jl.git",
    devbranch = "main"
)
