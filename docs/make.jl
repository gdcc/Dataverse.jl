using Dataverse, Conda, PyCall, Documenter, PlutoSliderServer

DocMeta.setdocmeta!(Dataverse, :DocTestSetup, :(using Dataverse); recursive=true)

Dataverse.pyDataverse_install()
Dataverse.pyDataverse_APIs()

makedocs(;
    modules=[Dataverse],
    authors="gaelforget <gforget@mit.edu> and contributors",
    repo="https://github.com/gdcc/Dataverse.jl/blob/{commit}{path}#{line}",
    sitename="Dataverse.jl",
    format=Documenter.HTML(;
        prettyurls=get(ENV, "CI", "false") == "true",
        canonical="https://gdcc.github.io/Dataverse.jl",
        edit_link="main",
    ),
    pages=[
        "Home" => "index.md",
        "Other" => "other.md",
    ],
    warnonly = [:cross_references,:missing_docs],
)

lst=("notebook.jl",)
for i in lst
    fil_in=joinpath(@__DIR__,"..", "docs","src",i)
    fil_out=joinpath(@__DIR__,"build", i[1:end-2]*"html")
    PlutoSliderServer.export_notebook(fil_in)
    mv(fil_in[1:end-2]*"html",fil_out)
end

deploydocs(;
    repo="github.com/gdcc/Dataverse.jl",
    devbranch="main",
)
