using Conda, PyCall
using Dataverse
using Test
using UUIDs

pyDataverse.APIs(do_install=true)

@testset "Dataverse.jl" begin
    lst=example_lists.OCCA_list
    nams=example_lists.OCCA_files.name
 
    pth=joinpath(tempdir(),string(UUIDs.uuid4())) 
    mkdir(pth)

    nam=nams[2]
    get_from_dataverse(lst,string(nam),pth)
    @test isfile(joinpath(pth,nam))

    tmp=pyDataverse.demo("download")
    @test isfile(tmp[1])

    df1,df2=pyDataverse.demo("metadata")
    @test size(df1,1)==56
    @test size(df2,1)==11
end
