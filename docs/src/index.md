```@meta
CurrentModule = Dataverse
```

# Dataverse.jl

This package is about interfaces to the [Dataverse](https://dataverse.org) data collections and APIs.

👉 [demo notebook](notebook.html) and [notebook code](https://github.com/gdcc/Dataverse.jl/blob/main/docs/src/notebook.jl)

!!! warning
    This package is in early development stage.

For example, list and download files from the default Harvard Dataverse instance:

```julia
using Dataverse

DOI = "doi:10.7910/DVN/EE3C40"
files = Dataverse.file_list(DOI)
Dataverse.file_download(DOI, files.filename[1])
```

Use `base_url` to connect to another Dataverse installation:

```julia
base_url = "https://data.example.edu"
files = Dataverse.file_list("doi:10.1234/EXAMPLE"; base_url=base_url)
header, dataverses, datasets = Dataverse.dataverse_scan(:root; base_url=base_url)
```

The documentation build does not execute these network examples. The CI integration
tests use an isolated Dataverse instance created for each test run.

## Julia Dataverse API

```@docs
file_list
file_download
dataverse_scan
unzip
untargz
```

