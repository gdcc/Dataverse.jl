using Dataverse
using Documenter

DocMeta.setdocmeta!(Dataverse, :DocTestSetup, :(using Dataverse); recursive=true)

pyDataverse.HarvardAPIs(do_install=true)

makedocs(;
    modules=[Dataverse],
    authors="gaelforget <gforget@mit.edu> and contributors",
    repo="https://github.com/gaelforget/Dataverse.jl/blob/{commit}{path}#{line}",
    sitename="Dataverse.jl",
    format=Documenter.HTML(;
        prettyurls=get(ENV, "CI", "false") == "true",
        canonical="https://gaelforget.github.io/Dataverse.jl",
        edit_link="main",
        assets=String[],
    ),
    pages=[
        "Home" => "index.md",
        "APIs" => "dataverse_access.md",
    ],
)

deploydocs(;
    repo="github.com/gaelforget/Dataverse.jl",
    devbranch="main",
)
