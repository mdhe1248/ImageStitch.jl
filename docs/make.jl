using ImageStitch
using Documenter

DocMeta.setdocmeta!(ImageStitch, :DocTestSetup, :(using ImageStitch); recursive=true)

makedocs(;
    modules=[ImageStitch],
    authors="Donghoon Lee <mdhe1248@gmail.com>",
    repo="https://github.com/mdhe1248/ImageStitch.jl/blob/{commit}{path}#{line}",
    sitename="ImageStitch.jl",
    format=Documenter.HTML(;
        prettyurls=get(ENV, "CI", "false") == "true",
        canonical="https://mdhe1248.github.io/ImageStitch.jl",
        assets=String[],
    ),
    pages=[
        "Home" => "index.md",
    ],
)

deploydocs(;
    repo="github.com/mdhe1248/ImageStitch.jl",
    devbranch="main",
)
