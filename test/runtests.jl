using Dataverse
using Test
using UUIDs

@testset "Dataverse.jl" begin
    lst=example_lists.OCCA_list
    nams=example_lists.OCCA_files.name
 
    pth=joinpath(tempdir(),string(UUIDs.uuid4())) 
    mkdir(pth)

    nam=nams[2]
    get_from_dataverse(lst,string(nam),pth)
    @test isfile(joinpath(pth,nam))
end
