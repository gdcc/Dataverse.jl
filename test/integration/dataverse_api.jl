include(joinpath(@__DIR__, "..", "support", "dataverse_fixture.jl"))
using .DataverseTestFixture

@testset "Ephemeral Dataverse integration" begin
    base_url = ENV["DATAVERSE_BASE_URL"]
    api_token = ENV["DATAVERSE_API_TOKEN"]
    fixture = create_fixture(base_url, api_token)

    header, child_dataverses, datasets = Dataverse.dataverse_scan(
        Symbol(fixture.dataverse_alias);
        base_url=base_url,
    )
    @test header["alias"] == fixture.dataverse_alias
    @test isempty(child_dataverses)
    @test size(datasets, 1) == 1
    expected_persistent_url = replace(fixture.persistent_id, r"^doi:" => "https://doi.org/")
    @test datasets.persistentUrl == [expected_persistent_url]

    files = Dataverse.file_list(fixture.persistent_id; base_url=base_url)
    @test size(files, 1) == 1
    @test files.filename == [fixture.filename]
    @test files.id == [fixture.file_id]
    @test startswith(files.url[1], rstrip(base_url, '/'))
    @test !occursin("dataverse.harvard.edu", files.url[1])

    output_directory = mktempdir()
    Dataverse.file_download(
        fixture.persistent_id,
        fixture.filename,
        output_directory;
        base_url=base_url,
    )
    downloaded = joinpath(output_directory, fixture.filename)
    @test isfile(downloaded)
    @test read(downloaded, String) == fixture.contents
end
