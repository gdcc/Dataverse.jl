using Dataverse
using Test
using UUIDs

pyDataverse.APIs(do_install=true)

@testset "Dataverse.jl" begin
    lst=DataverseDownloads.OCCA_files()
    pth=joinpath(tempdir(),string(UUIDs.uuid4()))
    mkdir(pth)
    DataverseDownloads.download_files(lst,lst.name[1],pth)
    @test isfile(joinpath(pth,lst.name[1]))

    tmp=pyDataverse.demo("download")
    @test isfile(tmp[1])

    df1,df2=pyDataverse.demo("metadata")
    @test size(df1,1)==56
    @test size(df2,1)==11
end
