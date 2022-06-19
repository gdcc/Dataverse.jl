module pyDataverse

using Conda, PyCall, DataFrames

"""
    APIs(;do_install=true,base_url = "https://dataverse.harvard.edu/")

```
(DataAccessApi,NativeApi)=pyDataverse.APIs()
```
"""
function APIs(;do_install=true,base_url = "https://dataverse.harvard.edu/")
    if do_install
        Conda.pip_interop(true)
        Conda.pip("install", "pyDataverse")
    end
    tmp=pyimport("pyDataverse")
    api=pyimport("pyDataverse.api")
    return api.DataAccessApi(base_url), api.NativeApi(base_url)
end

"""
    demo(option::String)

- call `demo_download` if `option=="download"`
- call `demo_metadata` if `option=="metadata"`
"""
function demo(option="download")
    if option=="download"
        demo_download()
    elseif option=="metadata"
        demo_metadata()
    else
        println("unknown option")
    end
end

"""
    demo_download(;path=tempdir(),DOI = "doi:10.7910/DVN/KBHLOD")

Replicate the worflow example from 

<https://pydataverse.readthedocs.io/en/latest/user/basic-usage.html#download-and-save-a-dataset-to-disk>    

```
pyDataverse.demo_download()
```
"""
function demo_download(;path=tempdir(),DOI = "doi:10.7910/DVN/KBHLOD")
    (DataAccessApi,NativeApi)=pyDataverse.APIs(do_install=false)
    dataset = NativeApi.get_dataset(DOI)
    files_list = dataset.json()["data"]["latestVersion"]["files"]
    filenames=String[]
    for file in files_list
        filename = joinpath(path,file["dataFile"]["filename"])
        file_id = file["dataFile"]["id"]
        response=DataAccessApi.get_datafile(file_id)
        write(filename,response.content)
        push!(filenames,filename)
    end
    filenames
end

#Deprecated : see `dataset_file_list`+`files_to_DataFrame` instead
function tree_children_to_DataFrame(files)	
	nf=length(files)
	filename=[files[ff]["filename"] for ff in 1:nf]
	pid=[files[ff]["pid"] for ff in 1:nf]
	datafile_id=[files[ff]["datafile_id"] for ff in 1:nf]
	DataFrame(filename=filename,pid=pid,datafile_id=datafile_id)
end

"""
    files_to_DataFrame(files)

Convert output from `dataset.json()["data"]["latestVersion"]["files"]` to DataFrame. 

See notebook for a more complete example.
"""
function files_to_DataFrame(files)	
	nf=length(files)
	filename=[files[ff]["dataFile"]["filename"] for ff in 1:nf]
	filesize=[files[ff]["dataFile"]["filesize"] for ff in 1:nf]
	id=[files[ff]["dataFile"]["id"] for ff in 1:nf]    
	pidURL=[files[ff]["dataFile"]["pidURL"] for ff in 1:nf]
	DataFrame(filename=filename,filesize=filesize,id=id,pidURL=pidURL)
end
   

"""
    demo_metadata()

```
pyDataverse.demo_metadata()
```
"""
function demo_metadata()
    df1=dataset_file_list(:OCCA_clim)
	df2=dataverse_file_list(:ECCOv4r2)
    df1,df2
end

##

"""
    dataset_file_list(nam::Symbol=:OCCA_clim)

Lookup DOI from list of demo data sets.

```
dataset_file_list(:OCCA_clim)
```
"""
function dataset_file_list(nam::Symbol)
    (DataAccessApi,NativeApi)=pyDataverse.APIs(do_install=false)
    DOI=(OCCA_clim="doi:10.7910/DVN/RNXA2A",ECCO_clim="doi:10.7910/DVN/3HPRZI")
    dataset_file_list(DOI[nam])
end

"""
    dataset_file_list(DOI::String="doi:10.7910/DVN/ODM2IQ")

Use `NativeApi.get_dataset` to derive the list of files (name, etc) via `files_to_DataFrame`.

```
dataset_file_list("doi:10.7910/DVN/ODM2IQ")
```
"""
function dataset_file_list(DOI::String)
    (DataAccessApi,NativeApi)=pyDataverse.APIs(do_install=false)
    dataset = NativeApi.get_dataset(DOI)
    dataset_files = dataset.json()["data"]["latestVersion"]["files"]
    files_to_DataFrame(dataset_files)
end

"""
    dataverse_file_list(nam::Symbol=:ECCOv4r2)

- Use `NativeApi.get_children` to get the tree of datasets
- Loop through and return vector of `dataset_file_list` output
"""
function dataverse_file_list(nam::Symbol=:ECCOv4r2)
    (DataAccessApi,NativeApi)=pyDataverse.APIs(do_install=false)
    tree = NativeApi.get_children(string(nam), children_types= ["datasets", "datafiles"])
    #[tree_children_to_DataFrame(leaf["children"]) for leaf in tree]
    [dataset_file_list(leaf["pid"]) for leaf in tree]
end

end
