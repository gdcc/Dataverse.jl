module DataverseTestFixture

using HTTP, JSON, UUIDs

export Fixture, create_fixture

struct Fixture
    dataverse_alias::String
    persistent_id::String
    file_id::Int
    filename::String
    contents::String
end

normalize_base_url(base_url) = rstrip(String(base_url), '/')

function build_url(base_url, path; query=Dict{String,String}())
    url = string(normalize_base_url(base_url), "/", lstrip(String(path), '/'))
    string(HTTP.URI(url; query=query))
end

function request_json(method, url, api_token; body=nothing, headers=Pair{String,String}[])
    request_headers = ["X-Dataverse-key" => api_token, headers...]
    response = if body === nothing
        HTTP.request(method, url, request_headers; status_exception=false)
    else
        HTTP.request(method, url, request_headers, body; status_exception=false)
    end

    if !(200 <= response.status < 300)
        error("Fixture request $(method) $(url) returned HTTP $(response.status): $(String(response.body))")
    end

    isempty(response.body) ? Dict{String,Any}() : JSON.parse(String(response.body))
end

function dataset_metadata()
    Dict(
        "datasetVersion" => Dict(
            "metadataBlocks" => Dict(
                "citation" => Dict(
                    "displayName" => "Citation Metadata",
                    "fields" => [
                        Dict(
                            "typeName" => "title",
                            "typeClass" => "primitive",
                            "multiple" => false,
                            "value" => "Dataverse.jl CI Dataset",
                        ),
                        Dict(
                            "typeName" => "author",
                            "typeClass" => "compound",
                            "multiple" => true,
                            "value" => [
                                Dict(
                                    "authorName" => Dict(
                                        "typeName" => "authorName",
                                        "typeClass" => "primitive",
                                        "multiple" => false,
                                        "value" => "Dataverse.jl CI",
                                    ),
                                ),
                            ],
                        ),
                        Dict(
                            "typeName" => "datasetContact",
                            "typeClass" => "compound",
                            "multiple" => true,
                            "value" => [
                                Dict(
                                    "datasetContactName" => Dict(
                                        "typeName" => "datasetContactName",
                                        "typeClass" => "primitive",
                                        "multiple" => false,
                                        "value" => "Dataverse.jl CI",
                                    ),
                                    "datasetContactEmail" => Dict(
                                        "typeName" => "datasetContactEmail",
                                        "typeClass" => "primitive",
                                        "multiple" => false,
                                        "value" => "dataverse-jl-ci@example.org",
                                    ),
                                ),
                            ],
                        ),
                        Dict(
                            "typeName" => "dsDescription",
                            "typeClass" => "compound",
                            "multiple" => true,
                            "value" => [
                                Dict(
                                    "dsDescriptionValue" => Dict(
                                        "typeName" => "dsDescriptionValue",
                                        "typeClass" => "primitive",
                                        "multiple" => false,
                                        "value" => "Ephemeral integration fixture for Dataverse.jl.",
                                    ),
                                ),
                            ],
                        ),
                        Dict(
                            "typeName" => "subject",
                            "typeClass" => "controlledVocabulary",
                            "multiple" => true,
                            "value" => ["Computer and Information Science"],
                        ),
                    ],
                ),
            ),
        ),
    )
end

function wait_until_released(base_url, persistent_id; timeout_seconds=120)
    url = build_url(
        base_url,
        "/api/datasets/:persistentId/";
        query=Dict("persistentId" => persistent_id),
    )
    deadline = time() + timeout_seconds

    while time() < deadline
        response = HTTP.get(url; status_exception=false)
        if response.status == 200 && !isempty(response.body)
            data = JSON.parse(String(response.body))
            state = get(data["data"]["latestVersion"], "versionState", "")
            state == "RELEASED" && return data
        end
        sleep(2)
    end

    error("Timed out waiting for integration dataset $(persistent_id) to become RELEASED.")
end

function create_fixture(base_url, api_token)
    suffix = lowercase(first(string(uuid4()), 8))
    alias = "dataversejl-ci-$(suffix)"
    filename = "dataverse-jl-fixture.txt"
    contents = "Dataverse.jl integration fixture\n"

    dataverse_payload = Dict(
        "name" => "Dataverse.jl CI $(suffix)",
        "alias" => alias,
        "dataverseContacts" => [Dict("contactEmail" => "dataverse-jl-ci@example.org")],
        "affiliation" => "Dataverse.jl",
        "description" => "Ephemeral collection for Dataverse.jl integration tests.",
        "dataverseType" => "RESEARCH_PROJECTS",
    )
    request_json(
        "POST",
        build_url(base_url, "/api/dataverses/root"),
        api_token;
        body=JSON.json(dataverse_payload),
        headers=["Content-Type" => "application/json"],
    )
    request_json(
        "POST",
        build_url(
            base_url,
            "/api/dataverses/$(HTTP.escapeuri(alias))/actions/:publish",
        ),
        api_token,
    )

    dataset = request_json(
        "POST",
        build_url(base_url, "/api/dataverses/$(HTTP.escapeuri(alias))/datasets"),
        api_token;
        body=JSON.json(dataset_metadata()),
        headers=["Content-Type" => "application/json"],
    )
    persistent_id = dataset["data"]["persistentId"]

    upload_url = build_url(
        base_url,
        "/api/datasets/:persistentId/add";
        query=Dict("persistentId" => persistent_id),
    )
    form = HTTP.Form(
        Dict(
            "file" => HTTP.Multipart(filename, IOBuffer(contents), "text/plain"),
            "jsonData" => JSON.json(Dict("description" => "Dataverse.jl CI fixture")),
        ),
    )
    upload = request_json("POST", upload_url, api_token; body=form)
    file_id = upload["data"]["files"][1]["dataFile"]["id"]

    publish_url = build_url(
        base_url,
        "/api/datasets/:persistentId/actions/:publish";
        query=Dict("persistentId" => persistent_id, "type" => "major"),
    )
    request_json("POST", publish_url, api_token)
    wait_until_released(base_url, persistent_id)

    Fixture(alias, persistent_id, file_id, filename, contents)
end

end
