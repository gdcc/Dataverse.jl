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

- call `demo_basic` if `option=="basic"`
- call `demo_ECCO` if `option=="ECCO"`
"""
function demo(option="basic")
    if option=="basic"
        demo_basic()
    elseif option=="ECCO"
        demo_ECCO()
    end
end

"""
    demo_basic(;path=tempdir(),DOI = "doi:10.7910/DVN/KBHLOD")

Replicate the worflow example from 

<https://pydataverse.readthedocs.io/en/latest/user/basic-usage.html#download-and-save-a-dataset-to-disk>    

```
pyDataverse.demo_basic()
```
"""
function demo_basic(;path=tempdir(),DOI = "doi:10.7910/DVN/KBHLOD")
    (DataAccessApi,NativeApi)=pyDataverse.APIs()
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

"""
    tree_children_to_DataFrame(files)

Convert output of e.g. `tree[1]["children"]` to DataFrame. See notebook for a more complete example.
"""
function tree_children_to_DataFrame(files)	
	nf=length(files)
	filename=[files[ff]["filename"] for ff in 1:nf]
	pid=[files[ff]["pid"] for ff in 1:nf]
	datafile_id=[files[ff]["datafile_id"] for ff in 1:nf]
	DataFrame(filename=filename,pid=pid,datafile_id=datafile_id)
end

"""
    dataset_children_to_DataFrame(files)

Convert output of e.g. `dataset.json()["data"]["latestVersion"]["files"]` to DataFrame. See notebook for a more complete example.
"""
function dataset_files_to_DataFrame(files)	
	nf=length(files)
	filename=[files[ff]["dataFile"]["filename"] for ff in 1:nf]
	filesize=[files[ff]["dataFile"]["filesize"] for ff in 1:nf]
	id=[files[ff]["dataFile"]["id"] for ff in 1:nf]    
	pidURL=[files[ff]["dataFile"]["pidURL"] for ff in 1:nf]
	DataFrame(filename=filename,filesize=filesize,id=id,pidURL=pidURL)
end
   

"""
    demo_ECCO()

```
pyDataverse.demo_ECCO()
```
"""
function demo_ECCO()
    df1=dataset_file_list(:OCCA_clim)
	df2=dataverse_file_list(:ECCOv4r2)
    df1,df2
end

##

function dataset_file_list(nam::Symbol=:OCCA_clim)
    (DataAccessApi,NativeApi)=pyDataverse.APIs(do_install=false)
    DOI=(OCCA_clim="doi:10.7910/DVN/RNXA2A",ECCO_clim="doi:10.7910/DVN/3HPRZI")
    dataset = NativeApi.get_dataset(DOI[nam])
    dataset_files = dataset.json()["data"]["latestVersion"]["files"]
    dataset_files_to_DataFrame(dataset_files)
end

function dataset_file_list(DOI::String="doi:10.7910/DVN/ODM2IQ")
    (DataAccessApi,NativeApi)=pyDataverse.APIs(do_install=false)
    dataset = NativeApi.get_dataset(DOI)
    dataset_files = dataset.json()["data"]["latestVersion"]["files"]
    dataset_files_to_DataFrame(dataset_files)
end

function dataverse_file_list(nam::Symbol=:ECCOv4r2)
    (DataAccessApi,NativeApi)=pyDataverse.APIs(do_install=false)
    tree = NativeApi.get_children(string(nam), children_types= ["datasets", "datafiles"])
    #[tree_children_to_DataFrame(leaf["children"]) for leaf in tree]
    [dataset_file_list(leaf["pid"]) for leaf in tree]
end

end
