module downloads

using Downloads, OceanStateEstimation, CSV, DataFrames

##

"""
    get_from_dataverse(lst::String,nam::String,pth::String)

```
lst=example_lists.OCCA_list
nams=example_lists.OCCA_files.name
[get_from_dataverse(lst,string(nam),tempdir()) for nam in nams[:]]
```
"""
function get_from_dataverse(lst::String,nam::String,pth::String)
    lists=dataverse_lists(lst)
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
    dataverse_lists(lst::String)

Read and derive lists (ID,name,URL) from csv file (ID,name) and return as tuple

```
lst=example_lists.OCCA_list
ECCO_files=dataverse_lists(lst)
```
"""
function dataverse_lists(lst::String)
    tmp=readlines(lst)
    ID=[parse(Int,tmp[j][1:findfirst(isequal(','),tmp[j])-1]) for j=2:length(tmp)]
    name=[tmp[j][findfirst(isequal(','),tmp[j])+1:end] for j=2:length(tmp)]
    tmp="https://dataverse.harvard.edu/api/access/datafile/"
    URL=[tmp*"$(ID[j])" for j=1:length(ID)]
    return (ID=ID,name=name,URL=URL)
end

##

pth=dirname(pathof(OceanStateEstimation))

OCCA_list=joinpath(pth,"../examples/OCCA_climatology.csv")
OCCA_files=dataverse_lists(OCCA_list)

ECCO_list=joinpath(pth,"../examples/nctiles_climatology.csv")
ECCO_files=dataverse_lists(ECCO_list)

example_lists=( OCCA_list=OCCA_list,OCCA_files=OCCA_files,
                ECCO_list=ECCO_list,ECCO_files=ECCO_files)

end
