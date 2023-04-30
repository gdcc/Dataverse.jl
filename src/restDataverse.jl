
module restDataverse

using HTTP, JSON, DataFrames

"""
    restDataverse.dataset_file_list(DOI::String="doi:10.7910/DVN/ODM2IQ")

Use HTTP, JSON, DataFrames to list files (filename, filesize, id, pidURL).

```
restDataverse.dataset_file_list("doi:10.7910/DVN/ODM2IQ")
```
"""
function dataset_file_list(doi="doi:10.7910/DVN/EE3C40")
 r=HTTP.get("https://dataverse.harvard.edu/api/datasets/:persistentId/?persistentId=$(doi)")
 tmp=JSON.parse(String(r.body))
 files=tmp["data"]["latestVersion"]["files"]
 files_to_DataFrame(files)
end

function files_to_DataFrame(files)
        nf=length(files)
        filename=[files[ff]["dataFile"]["filename"] for ff in 1:nf]
        filesize=[files[ff]["dataFile"]["filesize"] for ff in 1:nf]
        id=[files[ff]["dataFile"]["id"] for ff in 1:nf]
        pidURL=[files[ff]["dataFile"]["pidURL"] for ff in 1:nf]
        DataFrame(filename=filename,filesize=filesize,id=id,pidURL=pidURL)
end

end

