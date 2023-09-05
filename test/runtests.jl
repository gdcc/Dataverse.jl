using Dataverse
using Test
using UUIDs

pyDataverse.APIs(do_install=true)

@testset "Dataverse.jl" begin
    lst=Dataverse.downloads.OCCA_file_list()
    pth=joinpath(tempdir(),string(UUIDs.uuid4()))
    mkdir(pth)
    Dataverse.file_download(lst,lst.filename[1],pth)
    @test isfile(joinpath(pth,lst.filename[1]))

    tmp=pyDataverse.demo("download")
    @test isfile(tmp[1])

    df1,df2=pyDataverse.demo("metadata")
    @test size(df1,1)==56
    @test size(df2,1)==11
end
