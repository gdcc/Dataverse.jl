using HTTP, JSON

const RestAPI = Dataverse.restDataverse

@testset "Dataverse URL construction" begin
    @test RestAPI._normalize_base_url(" https://example.org/ ") == "https://example.org"
    @test_throws ArgumentError RestAPI._normalize_base_url("  ")

    url = RestAPI._build_url(
        "https://example.org/",
        "/api/datasets/:persistentId/";
        query=Dict("persistentId" => "doi:10.5072/FK2/ABC123"),
    )
    @test url == "https://example.org/api/datasets/:persistentId/?persistentId=doi%3A10.5072%2FFK2%2FABC123"
end

@testset "Dataverse JSON response validation" begin
    url = "https://example.org/api/info/version"

    valid = HTTP.Response(
        200,
        ["Content-Type" => "application/json;charset=UTF-8"],
        JSON.json(Dict("status" => "OK")),
    )
    @test RestAPI._parse_json_response(valid, url)["status"] == "OK"

    # A valid JSON body should remain compatible with Dataverse installations
    # whose proxy does not set an ideal Content-Type header.
    unusual_content_type = HTTP.Response(200, ["Content-Type" => "text/plain"], "{\"status\":\"OK\"}")
    @test RestAPI._parse_json_response(unusual_content_type, url)["status"] == "OK"

    empty_response = HTTP.Response(202, ["Content-Type" => "text/html"], "")
    empty_error = try
        RestAPI._parse_json_response(empty_response, url)
        nothing
    catch error
        error
    end
    @test empty_error isa ArgumentError
    @test occursin("HTTP 202", sprint(showerror, empty_error))
    @test occursin("empty response body", sprint(showerror, empty_error))
    @test occursin("expected JSON", sprint(showerror, empty_error))

    not_found = HTTP.Response(404, ["Content-Type" => "application/json"], "{\"status\":\"ERROR\"}")
    status_error = try
        RestAPI._parse_json_response(not_found, url)
        nothing
    catch error
        error
    end
    @test status_error isa ArgumentError
    @test occursin("HTTP 404", sprint(showerror, status_error))

    invalid_json = HTTP.Response(200, ["Content-Type" => "text/html"], "not JSON")
    json_error = try
        RestAPI._parse_json_response(invalid_json, url)
        nothing
    catch error
        error
    end
    @test json_error isa ArgumentError
    @test occursin("not valid JSON", sprint(showerror, json_error))
    @test occursin("Content-Type text/html", sprint(showerror, json_error))
end

@testset "File metadata uses the selected Dataverse instance" begin
    files = [
        Dict(
            "dataFile" => Dict(
                "filename" => "fixture.txt",
                "filesize" => 18,
                "id" => 42,
            ),
        ),
    ]

    table = RestAPI.files_to_DataFrame(files; base_url="http://localhost:8080/")
    @test table.filename == ["fixture.txt"]
    @test table.filesize == [18]
    @test table.id == [42]
    @test table.url == ["http://localhost:8080/api/access/datafile/42"]
end
