using Dataverse, PythonCall, Test

include("unit/rest_api.jl")

run_python_tests = lowercase(get(ENV, "DATAVERSE_TEST_PYTHON", "true")) == "true"
if run_python_tests
    Dataverse.pyDataverse_install()
    DataAccessApi, NativeApi = Dataverse.pyDataverse_APIs()
    @test typeof(DataAccessApi) == Py
end

if haskey(ENV, "DATAVERSE_BASE_URL") && haskey(ENV, "DATAVERSE_API_TOKEN")
    include("integration/dataverse_api.jl")
else
    @info "Skipping Dataverse integration tests. Set DATAVERSE_BASE_URL and DATAVERSE_API_TOKEN to enable them."
end

@testset "Archive downloads" begin
    url = "https://zenodo.org/records/11062685/files/OCCA2HR1_analysis.tar.gz"
    file = joinpath(tempdir(), "OCCA2HR1_analysis.tar.gz")
    Dataverse.downloads.Downloads.download(url, file)
    extracted = Dataverse.untargz(file)
    @test ispath(joinpath(extracted, "OCCA2HR1_analysis"))

    url = "https://naturalearth.s3.amazonaws.com/110m_cultural/ne_110m_admin_0_countries.zip"
    file = joinpath(tempdir(), "ne_110m_admin_0_countries.zip")
    Dataverse.downloads.Downloads.download(url, file)
    Dataverse.unzip(file, tempdir())
    @test ispath(joinpath(tempdir(), "ne_110m_admin_0_countries.shp"))
end
