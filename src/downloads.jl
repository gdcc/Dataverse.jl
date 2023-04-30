module DataverseDownloads

import Dataverse.restDataverse.dataset_file_list
using Downloads, DataFrames

##

"""
    download_files(DOI::String,nam::String,pth=tempdir())

```
DOI="doi:10.7910/DVN/OYBLGK"
filename="polygons_MBON_seascapes.geojson"
DataverseDownloads.download_files(DOI,filename)
```
"""
function download_files(DOI::String,nam::String,pth=tempdir())
    df=restDataverse.dataset_file_list(DOI)
    lst=download_urls(df)
    ownload_files(lst,filename,pth)
end

"""
    download_files(lst::NamedTuple,nam::String,pth::String)

```
lst0=restDataverse.dataset_file_list("doi:10.7910/DVN/RNXA2A")
lst=DataverseDownloads.download_urls(lst0)
DataverseDownloads.download_files(lst,lst.name[2],tempdir())
```
"""
function download_files(lists::NamedTuple,nam::String,pth=tempdir())
    ii = findall([occursin("$nam", lists.name[i]) for i=1:length(lists.ID)])
    for i in ii
        nam1=Downloads.download(lists.URL[i])
        if length(ii)>1
            !isdir(joinpath(pth,nam)) ? mkdir(joinpath(pth,nam)) : nothing
            nam2=joinpath(pth,nam,lists.name[i])
            mv(nam1,nam2)
        else
            nam2=joinpath(pth,lists.name[i])
            mv(nam1,nam2)
        end
    end
end

"""
    download_urls(lst::DataFrame)

Add download URL (using df.id) and return as NamedTuple.
"""
download_urls(df::DataFrame) = begin
    tmp="https://dataverse.harvard.edu/api/access/datafile/"
    URL=[tmp*"$(df.id[j])" for j=1:length(df.id)]
    (ID=df.id,name=df.filename,URL=URL)
end

##

OCCA_files()=download_urls(dataset_file_list(:OCCA_clim))
ECCO_files()=download_urls(dataset_file_list(:ECCO_clim))

end
