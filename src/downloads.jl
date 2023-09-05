module downloads

import Dataverse.restDataverse: file_list
using Downloads, DataFrames

##

"""
    file_download(DOI::String,nam::String,pth=tempdir())

```
DOI="doi:10.7910/DVN/OYBLGK"
filename="polygons_MBON_seascapes.geojson"
Dataverse.file_download(DOI,filename)
```
"""
function file_download(DOI::String,nam::String,pth=tempdir())
    df=file_list(DOI)
    lst=url_list(df)
    file_download(lst,nam,pth)
end

"""
    file_download(lst::NamedTuple,nam::String,pth::String)

```
lst0=Dataverse.file_list("doi:10.7910/DVN/RNXA2A")
lst=Dataverse.url_list(lst0)
Dataverse.file_download(lst,lst.name[2],tempdir())
```
"""
function file_download(lists::NamedTuple,nam::String,pth=tempdir())
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
    url_list(lst::DataFrame)

Add download URL (using df.id) and return as `NamedTuple`.
"""
url_list(df::DataFrame) = begin
    tmp="https://dataverse.harvard.edu/api/access/datafile/"
    URL=[tmp*"$(df.id[j])" for j=1:length(df.id)]
    (ID=df.id,name=df.filename,URL=URL)
end

##

OCCA_file_list()=url_list(file_list(:OCCA_clim))
ECCO_file_list()=url_list(file_list(:ECCO_clim))

end
