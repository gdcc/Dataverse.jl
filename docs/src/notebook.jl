### A Pluto.jl notebook ###
# v0.19.27

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
	using Dataverse, PlutoUI, Downloads
	using DataFrames, PrettyTables
	"Packages ready"
end

# ╔═╡ 52c81a38-0b73-4585-8833-40a834c12312
md"""# Dataverse.jl

The [Dataverse.jl](https://github.com/gdcc/Dataverse.jl) package provide an interface to the [Dataverse](https://dataverse.org) project APIs, collections, datasets, etc.

!!! note
    Topics covered by this notebok include the following.

- retrieve a `dataset` meta data from `DOI`
- browse `dataverse` and select `dataset`
- select a `datafile` by name and download it

!!! tip
    Some documentation on available APIs is linked just below.

- <https://demo.dataverse.org>
- <https://gdcc.github.io/Dataverse.jl/dev/>
- <https://pydataverse.readthedocs.io/en/latest/index.html>
- <https://guides.dataverse.org/en/5.11/api/index.html>
"""

# ╔═╡ bff0a085-9636-4b42-a3bb-67ec705529a9
TableOfContents()

# ╔═╡ e90fc026-b134-4694-87db-b5fc8fd1dcb2
begin
	doi_select = @bind DOI Select(["doi:10.7910/DVN/AVVGYX","doi:10.7910/DVN/EE3C40","doi:10.7910/DVN/RNXA2A"])
	md"""## Explore a Dataset

	Select doi : $(doi_select)

	A Dataset may contain multiple files.		
	"""
end

# ╔═╡ 2240395b-4112-4e8a-a233-26fde9dffbc4
begin
	df=Dataverse.file_list(DOI)

	#alternative : 
	#🏁
	#dataset = NativeApi.get_dataset(DOI)
	#df=pyDataverse.dataset_file_list(DOI)

	"Done scanning dataset files"
end

# ╔═╡ eb402ef0-96fb-41d0-93e4-7fe5a69e8465
let
	with_terminal() do
	pretty_table(df,header_crayon=crayon"light_yellow",alignment=:l,
		  highlighters       = hl_col(1, crayon"light_blue"))
	end
end


# ╔═╡ 061ea815-66ef-4e06-987f-fbd1f7e837d7
md"""## Explore a Dataverse

A Dataverse may contain multiple Datasets. Here each index of `tree` is one Dataset. Below we select one of them.
"""

# ╔═╡ e34e0d5b-7e43-4acd-9cf4-5916cd1b5404
md""" Download file ? $(@bind dl Select([true,false],default=true))"""

# ╔═╡ e448e0ce-4991-4a75-b611-570aa64439f3
md"""## Appendix"""

# ╔═╡ d216f95e-fc57-4b89-b796-be08b3f137d2
begin
	(DataAccessApi,NativeApi)=pyDataverse.APIs(do_install=true)
	🏁=true
	"pyDataverse APIs are ready to use"
end


# ╔═╡ 756bec67-c27e-49c1-9573-9521746cf856
begin
	🏁
	tree=pyDataverse.dataverse_file_list()
	"Done scanning dataverse files"
end

# ╔═╡ c3c4448f-63bb-481f-a28a-dc4ad0311519
tree

# ╔═╡ ecfc53da-38b4-478c-8559-41746d3cd8d0
begin
	nf=length(tree)
	num_select = @bind num Select(1:nf)
	md"""Select a dataset : $(num_select)"""
end

# ╔═╡ 135e1777-6a29-4736-9b6d-60f88dbd405a
let
	with_terminal() do
	pretty_table(tree[num],header_crayon=crayon"light_yellow",alignment=:l,
		  highlighters       = hl_col(1, crayon"light_blue"))
	end
end

# ╔═╡ dc40c42c-6d5a-4110-a8b5-7b00568c4312
begin
	nfi=length(tree[num].filename)
	file_select = @bind file Select(tree[num].filename)
	ii=findall(tree[num].filename.==file)
	md"""## Select & Download File
	
	Select file : $(file_select)
	"""
end

# ╔═╡ ffe06b1c-0e0e-44df-93d5-c33d88bf7e7e
begin
	dl ? Dataverse.file_download(DOI,file) : nothing
end

# ╔═╡ 1a5a27c9-7f72-49b7-a406-2576c11f0f3c
begin
	filePATH=joinpath(tempdir(),file)
	if isfile(filePATH)
		stat(filePATH)
	else
		println("file not found")
	end
end

# ╔═╡ Cell order:
# ╟─52c81a38-0b73-4585-8833-40a834c12312
# ╟─bff0a085-9636-4b42-a3bb-67ec705529a9
# ╟─e90fc026-b134-4694-87db-b5fc8fd1dcb2
# ╟─eb402ef0-96fb-41d0-93e4-7fe5a69e8465
# ╟─2240395b-4112-4e8a-a233-26fde9dffbc4
# ╟─061ea815-66ef-4e06-987f-fbd1f7e837d7
# ╟─756bec67-c27e-49c1-9573-9521746cf856
# ╟─c3c4448f-63bb-481f-a28a-dc4ad0311519
# ╟─ecfc53da-38b4-478c-8559-41746d3cd8d0
# ╟─135e1777-6a29-4736-9b6d-60f88dbd405a
# ╟─dc40c42c-6d5a-4110-a8b5-7b00568c4312
# ╟─e34e0d5b-7e43-4acd-9cf4-5916cd1b5404
# ╟─ffe06b1c-0e0e-44df-93d5-c33d88bf7e7e
# ╟─1a5a27c9-7f72-49b7-a406-2576c11f0f3c
# ╟─e448e0ce-4991-4a75-b611-570aa64439f3
# ╟─8e7742bc-ed2e-11ec-2bbe-adbcf21330e7
# ╟─d216f95e-fc57-4b89-b796-be08b3f137d2
