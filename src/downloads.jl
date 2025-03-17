
module downloads

import Dataverse.restDataverse: file_list
using Downloads, DataFrames
using Tar, CodecZlib, ZipFile

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

"""
    untargz(fil)

Decompress and extract data from a `.tar.gz` file.
"""
function untargz(fil)
    open(fil) do io
        Tar.extract(CodecZlib.GzipDecompressorStream(io))
    end
end

"""
function unzip(file,exdir="")
    
Source : @sylvaticus, https://discourse.julialang.org/t/
how-to-extract-a-file-in-a-zip-archive-without-using-os-specific-tools/34585/5
"""
function unzip(file,exdir="")
    fileFullPath = isabspath(file) ?  file : joinpath(pwd(),file)
    basePath = dirname(fileFullPath)
    outPath = (exdir == "" ? basePath : (isabspath(exdir) ? exdir : joinpath(pwd(),exdir)))
    isdir(outPath) ? "" : mkdir(outPath)
    zarchive = ZipFile.Reader(fileFullPath)
    for f in zarchive.files
        fullFilePath = joinpath(outPath,f.name)
        if (endswith(f.name,"/") || endswith(f.name,"\\"))
            mkdir(fullFilePath)
        else
            write(fullFilePath, read(f))
        end
    end
    close(zarchive)
end
    
end
