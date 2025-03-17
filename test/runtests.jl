using Dataverse, PythonCall, UUIDs, Test

do_py_test=1
if do_py_test>0
    Dataverse.pyDataverse_install()
    (DataAccessApi,NativeApi)=Dataverse.pyDataverse_APIs()
    @test typeof(DataAccessApi)==Py
end

if do_py_test>1
    tmp=pyDataverse.demo("download")
    @test isfile(tmp[1])

    df1,df2=pyDataverse.demo("metadata")
    @test size(df1,1)==56
    @test size(df2,1)==11
end

@testset "Dataverse.jl" begin
    lst=Dataverse.downloads.OCCA_file_list()
    pth=joinpath(tempdir(),string(UUIDs.uuid4()))
    mkdir(pth)

    j=json_ld.get("10.7910/DVN/CAGYQL")
    @test j["@type"]=="sc:Dataset"
    
    jj=2
    Dataverse.file_download(lst,lst.filename[jj],pth)
    @test isfile(joinpath(pth,lst.filename[jj]))

    url="https://zenodo.org/records/11062685/files/OCCA2HR1_analysis.tar.gz"
    fil=joinpath(tempdir(),"OCCA2HR1_analysis.tar.gz")
    Dataverse.downloads.Downloads.download(url,fil)
    tmp=Dataverse.untargz(fil)
    @test ispath(joinpath(tmp,"OCCA2HR1_analysis"))

    url="https://naturalearth.s3.amazonaws.com/110m_cultural/ne_110m_admin_0_countries.zip"
    fil=joinpath(tempdir(),"ne_110m_admin_0_countries.zip")
    Dataverse.downloads.Downloads.download(url,fil)
    Dataverse.unzip(fil,tempdir())
    @test ispath(joinpath(tempdir(),"ne_110m_admin_0_countries.shp"))
end

