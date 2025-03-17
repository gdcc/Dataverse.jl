using Dataverse, PythonCall, UUIDs, Test

do_py_test=1
if do_py_test>0
    Dataverse.pyDataverse_install()
    (DataAccessApi,NativeApi)=Dataverse.pyDataverse_APIs()
    @test typeof(DataAccessApi)==Py
end

if do_py_test>1
    tmp=pyDataverse.demo_download()
    @test isfile(tmp[1])
end

@testset "Dataverse.jl" begin
    (header,dataverses,datasets)=Dataverse.dataverse_scan()
    @test isa(header,Dict)

    j=json_ld.get("10.7910/DVN/CAGYQL")
    @test j["@type"]=="sc:Dataset"

    lst=Dataverse.file_list(:OCCA_clim)
    pth=joinpath(tempdir(),string(UUIDs.uuid4()))
    mkdir(pth)
    
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

