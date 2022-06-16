module pyDataverse

using Conda, PyCall

"""
    HarvardAPIs(;do_install=true)

```
(DataAccessApi,NativeApi)=pyDataverse.HarvardAPIs()
```
"""
function HarvardAPIs(;do_install=true)
#    if do_install
        Conda.pip_interop(true)
        Conda.pip("install", "pyDataverse")
#    end
    tmp=pyimport("pyDataverse")
    api=pyimport("pyDataverse.api")
    base_url = "https://dataverse.harvard.edu/"
    return api.DataAccessApi(base_url), api.NativeApi(base_url)
end

"""
    demo(path=tempdir())

Replicate the worflow example from 

<https://pydataverse.readthedocs.io/en/latest/user/basic-usage.html#download-and-save-a-dataset-to-disk>    

```
pyDataverse.demo()
```
"""
function demo(path=tempdir())
    (DataAccessApi,NativeApi)=pyDataverse.HarvardAPIs()
    DOI = "doi:10.7910/DVN/KBHLOD"
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

end
