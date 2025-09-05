using Documenter
using DocumenterVitepress
using NASAPrecipitation
using Literate

using CairoMakie # to avoid capturing precompilation output by Literate
CairoMakie.activate!(type = "svg")

setup(
    login = "nasaprecipitationjl@gmail.com",
    password = "NASAPrecipitation1",
    overwrite = true
)

makedocs(;
    modules  = [NASAPrecipitation, GeoRegions],
    authors  = "Nathanael Wong <natgeo.wong@outlook.com>",
    sitename = "NASAPrecipitation.jl",
    doctest  = false,
    warnonly = true,
    format   = DocumenterVitepress.MarkdownVitepress(
        repo = "https://github.com/GeoRegionsEcosystem/NASAPrecipitation.jl",
    ),
    pages    = [
        "Home"       => "index.md",
        "The Basics" => "basics.md",
        "Setup"      => "setup.md",
        "Datasets"   => [
            "Available Datasets" => "datasets/intro.md",
            "Defining a NPD"     => "datasets/define.md",
            "GPM IMERG Datasets" => "datasets/imerg.md",
            "TRMM TMPA Datasets" => "datasets/trmm.md",
            "Dummy Datasets"     => "datasets/dummy.md",
        ],
        "Tutorials"  => [
            "Downloading Datasets"        => "using/download.md",
        #     "Integration with LandSea.jl" => "using/landsea.md",
        #     "Extraction of subGeoRegions" => "using/extract.md",
        #     "Spatialtemporal Smoothing"   => "using/smoothing.md",
        ],
        "API"       => [
            "IMERG Datasets" => "api/imerg.md",
            "TRMM Datasets"  => "api/trmm.md",
            "Dummy Datasets" => "api/dummy.md",
        ],
    ],
)

DocumenterVitepress.deploydocs(
    repo      = "github.com/GeoRegionsEcosystem/NASAPrecipitation.jl.git",
    target    = "build", # this is where Vitepress stores its output
    devbranch = "main",
    branch    = "gh-pages",
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