
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
    dataverse_scan(nam::Symbol=:ECCOv4r2)

Use HTTP, JSON, and DataFrames to list contents in a dataverse.

Returns header (Dict), dataverses (DataFrame), and datasets (DataFrame).

```
(header,dataverses,datasets)=Dataverse.dataverse_scan()
Dataverse.file_list(datasets.persistentUrl[1])
```
"""
function dataverse_scan(nam::Symbol=:ECCOv4r2)
    #header
    r=HTTP.get("https://dataverse.harvard.edu/api/dataverses/$(nam)")
    header=JSON.parse(String(r.body))["data"]
    #contents
    r=HTTP.get("https://dataverse.harvard.edu/api/dataverses/$(nam)/contents")
    tmp=JSON.parse(String(r.body))["data"]
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
        dataverses=DataFrame(id=[],type=[],persistentUrl=[])
    end
    #
    return header,dataverses,datasets
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
        tmp="https://dataverse.harvard.edu/api/access/datafile/"
        url=[tmp*"$(id[ff])" for ff in 1:nf]
        DataFrame(filename=filename,filesize=filesize,id=id,url=url)
end

end

