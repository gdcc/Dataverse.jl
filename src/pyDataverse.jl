module pyDataverse

using DataFrames
import Dataverse: pyDataverse_APIs

"""
    demo_download(;path=tempdir(),DOI = "doi:10.7910/DVN/KBHLOD")

Replicate the worflow example from 

<https://pydataverse.readthedocs.io/en/latest/user/basic-usage.html#download-and-save-a-dataset-to-disk>    

```
pyDataverse.demo_download()
```
"""
function demo_download(;path=tempdir(),DOI = "doi:10.7910/DVN/KBHLOD")
    (DataAccessApi,NativeApi)=pyDataverse_APIs(true)
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
