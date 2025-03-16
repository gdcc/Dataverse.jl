
module json_ld

"""
- read html, edit json, output html'
- add function to generate sitemap from Dataverse folder? zenodo?
"""

import HTTP, JSON

"""
    get(doi; to_file=false)

```
j=json_ld.get("10.7910/DVN/CAGYQL")
```
"""
get(doi; to_file=false) = begin
  h=doi_to_html("10.7910/DVN/CAGYQL")
  j,f=html_to_json_ld(h)
  to_file ? f : j
end

"""
    html_to_json_ld(file_html1)

```
h=json_ld.doi_to_html("10.7910/DVN/CAGYQL")
```
"""
doi_to_html(doi) = begin
  url="https://dataverse.harvard.edu/dataset.xhtml?persistentId=doi:$(doi)"
  r=HTTP.get(url)
  f=tempname()*".html"
  write(f,r)
  f
end

"""
    html_to_json_ld(file_html1)

```
h=json_ld.doi_to_html("10.7910/DVN/CAGYQL")
j,f=json_ld.html_to_json_ld(h)
```
"""
function html_to_json_ld(file_html1)
file_json1=tempname()*".json"
file_json2=tempname()*".json"

txt1=read(file_html1,String)
txt2=split(txt1,"<script type=\"application/ld+json\">")[2]
txt3=split(txt2,"</script>")[1]
write(file_json1,txt3)

j=JSON.parsefile(file_json1)

di=j["distribution"]
for ii in 1:length(di)
  d_in=di[ii]
  d_out=Dict()
  kd=keys(d_in)
  for kk in kd
    if kk=="@id"
      nothing
    elseif (kk=="@type")&&(d_in[kk]=="cr:FileObject")
      merge!(d_out,Dict("@type"=>"DataDownload","additionalType"=>d_in["@type"]))
    else
      merge!(d_out,Dict(kk=>d_in[kk]))
    end
  end
  di[ii]=d_out
end

open(file_json2,"w") do f
       JSON.print(f,j)
end

j,file_json2
end

end #module json_ld

