
module restDataverse

using HTTP, JSON, DataFrames

"""
    file_list(DOI::String="doi:10.7910/DVN/ODM2IQ")

Use HTTP, JSON, and DataFrames to list files in a dataset.

Return a DataFrame with filename, filesize, and id.

```
file_list("doi:10.7910/DVN/ODM2IQ")
```
"""
function file_list(doi="doi:10.7910/DVN/EE3C40")
 r=HTTP.get("https://dataverse.harvard.edu/api/datasets/:persistentId/?persistentId=$(doi)")
 tmp=JSON.parse(String(r.body))
 files=tmp["data"]["latestVersion"]["files"]
 files_to_DataFrame(files)
end

"""
    file_list(nam::Symbol=:OCCA_clim)

Lookup DOI from list of demo data sets (:OCCA_clim or :ECCO_clim).
"""
function file_list(nam::Symbol)
    DOI=(OCCA_clim="doi:10.7910/DVN/RNXA2A",ECCO_clim="doi:10.7910/DVN/3HPRZI")
    file_list(DOI[nam])
end

"""
    files_to_DataFrame(files)

Convert output from `dataset.json()["data"]["latestVersion"]["files"]` to a `DataFrame`.
"""
function files_to_DataFrame(files)
        nf=length(files)
        filename=[files[ff]["dataFile"]["filename"] for ff in 1:nf]
        filesize=[files[ff]["dataFile"]["filesize"] for ff in 1:nf]
        id=[files[ff]["dataFile"]["id"] for ff in 1:nf]
        DataFrame(filename=filename,filesize=filesize,id=id)
end

end

