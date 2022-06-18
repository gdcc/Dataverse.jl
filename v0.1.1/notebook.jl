### A Pluto.jl notebook ###
# v0.19.8

using Markdown
using InteractiveUtils

# This Pluto notebook uses @bind for interactivity. When running this notebook outside of Pluto, the following 'mock version' of @bind gives bound variables a default value (instead of an error).
macro bind(def, element)
    quote
        local iv = try Base.loaded_modules[Base.PkgId(Base.UUID("6e696c72-6542-2067-7265-42206c756150"), "AbstractPlutoDingetjes")].Bonds.initial_value catch; b -> missing; end
        local el = $(esc(element))
        global $(esc(def)) = Core.applicable(Base.get, el) ? Base.get(el) : iv(el)
        el
    end
end

# ╔═╡ 8e7742bc-ed2e-11ec-2bbe-adbcf21330e7
begin
	using Pkg; Pkg.activate()
	using Dataverse, PlutoUI
	using DataFrames, PrettyTables
	"Packages ready"
end

# ╔═╡ 52c81a38-0b73-4585-8833-40a834c12312
md"""# Dataverse.jl

This package is about interfaces to the [Dataverse](https://dataverse.org) project APIs, collections, datasets, etc.

!!! tip
    Some documentation on available APIs is linked to here.

- <https://demo.dataverse.org>
- <https://pydataverse.readthedocs.io/en/latest/index.html>
- <https://guides.dataverse.org/en/5.11/api/index.html>
"""

# ╔═╡ e90fc026-b134-4694-87db-b5fc8fd1dcb2
begin
	doi_select = @bind doi Select(["10.7910/DVN/EE3C40","10.7910/DVN/RNXA2A","10.7910/DVN/AVVGYX"])
	md"""## `get_dataset`

	Select doi : $(doi_select)
		
	"""
end

# ╔═╡ 306ced7d-005e-4e50-8295-d911403ff5fa
DOI="doi:"*doi

# ╔═╡ 061ea815-66ef-4e06-987f-fbd1f7e837d7
md"""## `get_children`"""

# ╔═╡ e448e0ce-4991-4a75-b611-570aa64439f3
md"""## Appendix"""

# ╔═╡ d216f95e-fc57-4b89-b796-be08b3f137d2
begin
	(DataAccessApi,NativeApi)=pyDataverse.APIs(do_install=false)
	"APIs ready"
end

# ╔═╡ 2240395b-4112-4e8a-a233-26fde9dffbc4
dataset = NativeApi.get_dataset(DOI)

# ╔═╡ ae0a3032-73ad-482b-a020-822f9a212fe1
tree = NativeApi.get_children("ECCOv4r2", children_types= ["datasets", "datafiles"])

# ╔═╡ ecfc53da-38b4-478c-8559-41746d3cd8d0
begin
	nf=length(tree[1]["children"])
	num_select = @bind num Select(1:nf)
	md"""Select file : $(num_select)"""
end

# ╔═╡ d8ee1f2c-2017-492c-8ad1-190072756936
tree[1]["children"][num]

# ╔═╡ ec69221f-fc55-441f-8e83-e14f13b33088
string.(keys(tree[num]["children"][1]))

# ╔═╡ b2795505-9109-4320-9724-9ec2a00929eb
function files_to_DataFrame(files)	
	nf=length(files)
	filename=[files[ff]["filename"] for ff in 1:nf]
	pid=[files[ff]["pid"] for ff in 1:nf]
	datafile_id=[files[ff]["datafile_id"] for ff in 1:nf]
	DataFrame(filename=filename,pid=pid,datafile_id=datafile_id)
end

# ╔═╡ 5933462e-8d94-40ca-b7ef-cdcabb892444
let
	files=tree[num]["children"]
	df=files_to_DataFrame(files)
	@pt df
end

# ╔═╡ 893b7e8c-3adb-411e-a1c2-5917d98d5a14
function files_list_to_DataFrame(files)	
	nf=length(files)
	filename=[files[ff]["dataFile"]["filename"] for ff in 1:nf]
	filesize=[files[ff]["dataFile"]["filesize"] for ff in 1:nf]
	pidURL=[files[ff]["dataFile"]["pidURL"] for ff in 1:nf]
	DataFrame(filename=filename,filesize=filesize,pidURL=pidURL)
end

# ╔═╡ 52dab617-8f6b-4166-8aac-21b221ed9120
begin
	files_list = dataset.json()["data"]["latestVersion"]["files"]
	df1=files_list_to_DataFrame(files_list)
	@pt df1
end

# ╔═╡ 266d8126-fbe9-4c47-a66e-95120a3cbbd5
files_list[1]

# ╔═╡ b37d33a3-7c44-477a-a8cb-df9511e15ce3
files_list[1]["dataFile"]

# ╔═╡ Cell order:
# ╟─52c81a38-0b73-4585-8833-40a834c12312
# ╟─e90fc026-b134-4694-87db-b5fc8fd1dcb2
# ╟─306ced7d-005e-4e50-8295-d911403ff5fa
# ╟─2240395b-4112-4e8a-a233-26fde9dffbc4
# ╟─52dab617-8f6b-4166-8aac-21b221ed9120
# ╟─266d8126-fbe9-4c47-a66e-95120a3cbbd5
# ╟─b37d33a3-7c44-477a-a8cb-df9511e15ce3
# ╟─061ea815-66ef-4e06-987f-fbd1f7e837d7
# ╟─ecfc53da-38b4-478c-8559-41746d3cd8d0
# ╟─5933462e-8d94-40ca-b7ef-cdcabb892444
# ╟─d8ee1f2c-2017-492c-8ad1-190072756936
# ╟─ec69221f-fc55-441f-8e83-e14f13b33088
# ╟─ae0a3032-73ad-482b-a020-822f9a212fe1
# ╟─e448e0ce-4991-4a75-b611-570aa64439f3
# ╟─8e7742bc-ed2e-11ec-2bbe-adbcf21330e7
# ╟─d216f95e-fc57-4b89-b796-be08b3f137d2
# ╟─b2795505-9109-4320-9724-9ec2a00929eb
# ╟─893b7e8c-3adb-411e-a1c2-5917d98d5a14
