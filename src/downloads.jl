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
    file_download(df,nam,pth)
end

"""
    file_download(list::DataFrame,nam::String,pth::String)

```
lst=Dataverse.file_list("doi:10.7910/DVN/RNXA2A")
Dataverse.file_download(lst,lst.filename[2],tempdir())
```
"""
function file_download(list::DataFrame,nam::String,pth=tempdir())
    ii = findall([occursin("$nam", list.filename[i]) for i=1:length(list.id)])
    for i in ii
        if length(ii)>1
            !isdir(joinpath(pth,nam)) ? mkdir(joinpath(pth,nam)) : nothing
            nam2=joinpath(pth,nam,list.filename[i])
        else
            nam2=joinpath(pth,list.filename[i])
        end
        if !isfile(nam2)
            nam1=Downloads.download(list.url[i])
            mv(nam1,nam2)
            println("Downloading file : $(nam2)")
        else
            println("Skipping file that's already there : $(nam2)")
        end
    end
end

##

OCCA_file_list()=file_list(:OCCA_clim)
ECCO_file_list()=file_list(:ECCO_clim)

end
