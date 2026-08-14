
module restDataverse

using HTTP, JSON, DataFrames

const DEFAULT_BASE_URL = "https://dataverse.harvard.edu"

# Normalize a Dataverse base URL so endpoint construction is consistent.
function _normalize_base_url(base_url::AbstractString)
    normalized = rstrip(strip(String(base_url)), '/')
    isempty(normalized) && throw(ArgumentError("Dataverse base_url must not be empty."))
    normalized
end

# Build a URL relative to a Dataverse installation.
function _build_url(base_url::AbstractString, path::AbstractString; query=Dict{String,String}())
    url = string(_normalize_base_url(base_url), "/", lstrip(String(path), '/'))
    string(HTTP.URI(url; query=query))
end

# Parse a Dataverse API response and provide useful context when it is not JSON.
function _parse_json_response(response::HTTP.Response, url::AbstractString)
    content_type = HTTP.header(response, "Content-Type", "unknown")
    context = "HTTP $(response.status) with Content-Type $(content_type)"
    body = String(response.body)

    if !(200 <= response.status < 300)
        throw(ArgumentError(
            "Dataverse API request to $(url) returned $(context); expected a successful JSON response.",
        ))
    elseif isempty(strip(body))
        throw(ArgumentError(
            "Dataverse API request to $(url) returned $(context) and an empty response body; expected JSON.",
        ))
    end

    try
        JSON.parse(body)
    catch error
        detail = sprint(showerror, error)
        throw(ArgumentError(
            "Dataverse API request to $(url) returned $(context), but the response body was not valid JSON: $(detail)",
        ))
    end
end

# Perform a GET request to a Dataverse API endpoint and return parsed JSON.
function _get_json(path::AbstractString; base_url=DEFAULT_BASE_URL, query=Dict{String,String}())
    url = _build_url(base_url, path; query=query)
    response = HTTP.get(url; status_exception=false)
    _parse_json_response(response, url)
end

"""
    file_list(DOI::String="doi:10.7910/DVN/ODM2IQ"; base_url=DEFAULT_BASE_URL)

Use HTTP, JSON, and DataFrames to list files in a dataset.

Return a DataFrame with filename, filesize, id, and download URL. Use `base_url`
to connect to a Dataverse installation other than Harvard Dataverse.

```
file_list("doi:10.7910/DVN/ODM2IQ")
file_list("doi:10.1234/EXAMPLE"; base_url="https://data.example.edu")
```
"""
function file_list(doi="doi:10.7910/DVN/EE3C40"; base_url=DEFAULT_BASE_URL)
 response=_get_json("/api/datasets/:persistentId/";
    base_url=base_url,query=Dict("persistentId"=>String(doi)))
 files=response["data"]["latestVersion"]["files"]
 files_to_DataFrame(files;base_url=base_url)
end

"""
    file_list(nam::Symbol=:OCCA_clim; base_url=DEFAULT_BASE_URL)

Lookup DOI from list of demo data sets (:OCCA_clim or :ECCO_clim).
"""
function file_list(nam::Symbol;base_url=DEFAULT_BASE_URL)
    DOI=(OCCA_clim="doi:10.7910/DVN/RNXA2A",ECCO_clim="doi:10.7910/DVN/3HPRZI")
    file_list(DOI[nam];base_url=base_url)
end

"""
    dataverse_scan(nam::Symbol=:ECCOv4r2; base_url=DEFAULT_BASE_URL)

Use HTTP, JSON, and DataFrames to list contents in a dataverse.

Returns header (Dict), dataverses (DataFrame), and datasets (DataFrame).

```
(header,dataverses,datasets)=Dataverse.dataverse_scan()
Dataverse.file_list(datasets.persistentUrl[1])
```
"""
function dataverse_scan(nam::Symbol=:ECCOv4r2;base_url=DEFAULT_BASE_URL)
    alias=HTTP.escapeuri(string(nam))
    #header
    header=_get_json("/api/dataverses/$(alias)";base_url=base_url)["data"]
    #contents
    tmp=_get_json("/api/dataverses/$(alias)/contents";base_url=base_url)["data"]
    type=[f["type"] for f in tmp]
    #1. dataverses
    ii=findall(type.=="dataverse")
    if !isempty(ii)
        id=[f["id"] for f in tmp[ii]]
        title=[f["title"] for f in tmp[ii]]
        dataverses=DataFrame(id=id,type=type[ii],title=title)
    else
        dataverses=DataFrame(id=[],type=[],title=[])
    end
    #2. datasets
    ii=findall(type.=="dataset")
    if !isempty(ii)
        id=[f["id"] for f in tmp[ii]]
        persistentUrl=[f["persistentUrl"] for f in tmp[ii]]
        datasets=DataFrame(id=id,type=type[ii],persistentUrl=persistentUrl)
    else
        datasets=DataFrame(id=[],type=[],persistentUrl=[])
    end
    #
    return header,dataverses,datasets
end

"""
    files_to_DataFrame(files; base_url=DEFAULT_BASE_URL)

Convert output from `dataset.json()["data"]["latestVersion"]["files"]` to a `DataFrame`.
"""
function files_to_DataFrame(files;base_url=DEFAULT_BASE_URL)
        nf=length(files)
        filename=[files[ff]["dataFile"]["filename"] for ff in 1:nf]
        filesize=[files[ff]["dataFile"]["filesize"] for ff in 1:nf]
        id=[files[ff]["dataFile"]["id"] for ff in 1:nf]
        url=[_build_url(base_url,"/api/access/datafile/$(id[ff])") for ff in 1:nf]
        DataFrame(filename=filename,filesize=filesize,id=id,url=url)
end

end

