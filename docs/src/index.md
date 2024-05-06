```@meta
CurrentModule = Dataverse
```

# Dataverse.jl

This package is about interfaces to the [Dataverse](https://dataverse.org) data collections and APIs.

👉 [demo notebook](notebook.html) and [notebook code](https://github.com/gdcc/Dataverse.jl/blob/main/docs/src/notebook.jl)

!!! warning
    This package is in early development stage.

For example:

```@example 1
using Dataverse 

DOI="doi:10.7910/DVN/EE3C40"
files=Dataverse.file_list(DOI)
Dataverse.file_download(DOI,files.filename[1])
```

or 

```@example 1
(header,dataverses,datasets)=Dataverse.dataverse_scan(:ECCOv4r2)
```

then

```@example 1
files=Dataverse.file_list(datasets.persistentUrl[1])
```

and 

```@example 1
Dataverse.file_download(files,files.filename[1])
```

## Julia Dataverse API

```@docs
file_list
file_download
dataverse_scan
unzip
untargz
```

