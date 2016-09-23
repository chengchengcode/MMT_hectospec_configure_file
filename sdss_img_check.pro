readcol, '../XMM-LSS/CC_nospec.txt', ra, dec, mag, weight, color,format = 'd,d,f,f,f,f'
rank = indgen(n_elements(mag))
index_rank = where(mag ge 21 and color gt 1.5)
if index_rank ne [-1] then rank[index_rank] = 1
index_rank = where((mag ge 20 and mag lt 21) or (mag ge 21 and color lt 1.5))
if index_rank ne [-1] then rank[index_rank] = 3
index_rank = where(mag ge 19 and mag lt 20)
if index_rank ne [-1] then rank[index_rank] = 4
index_rank = where(mag lt 19)
if index_rank ne [-1] then rank[index_rank] = 5

for i_F = 0, n_elements(ra) - 1 do begin
http_string = "'http://skyserver.sdss.org/dr12/SkyserverWS/ImgCutout/getjpeg?TaskName=Skyserver.Chart.Image&ra="+strtrim(ra[[i_F]],2)+"&dec="+strtrim(dec[[i_F]],2)+"&scale=0.39612&width=300&height=300&opt=GST&query=SR(10,20)"
print, http_string
spawn, 'wget -c '+http_string+'''' + '  -O ./SDSS_img_check/cc_'+strtrim([i_F],2)+'_'+strtrim(mag[i_F],2)+'_'+strtrim(color[i_F],2)+'_'+strtrim(rank[i_F],2)+'.jpg'
;
endfor


readcol, '../XMM-LSS/CC_nospec_SWIRE.txt', ra, dec, mag, mag_ch4, weight, format = 'd,d,f,f,f'
rank = indgen(n_elements(mag))
index_rank = where(mag ge 21)
if index_rank ne [-1] then rank[index_rank] = 1
index_rank = where(mag ge 20 and mag lt 21)
if index_rank ne [-1] then rank[index_rank] = 3
index_rank = where(mag lt 20)
if index_rank ne [-1] then rank[index_rank] = 4
for i_F = 0, n_elements(ra) - 1 do begin
http_string = "'http://skyserver.sdss.org/dr12/SkyserverWS/ImgCutout/getjpeg?TaskName=Skyserver.Chart.Image&ra="+strtrim(ra[[i_F]],2)+"&dec="+strtrim(dec[[i_F]],2)+"&scale=0.39612&width=300&height=300&opt=GST&query=SR(10,20)"
print, http_string
spawn, 'wget -c '+http_string+'''' + '  -O ./SDSS_img_check/SWIRE_'+strtrim([i_F],2)+'_'+strtrim(mag[i_F],2)+'_'+strtrim(color[i_F],2)+'_'+strtrim(rank[i_F],2)+'.jpg'
;
endfor

readcol, '../XMM-LSS/CC_spec_with_low_Q.txt', ra, dec, mag, weight,color, format = 'd,d,f,f,f'
rank = indgen(n_elements(mag))
index_rank = where(mag ge 21 and color gt 1.5)
if index_rank ne [-1] then rank[index_rank] = 1
index_rank = where((mag ge 20 and mag lt 21) or (mag ge 21 and color lt 1.5))
if index_rank ne [-1] then rank[index_rank] = 3
index_rank = where(mag ge 19 and mag lt 20)
if index_rank ne [-1] then rank[index_rank] = 4
index_rank = where(mag lt 19)
if index_rank ne [-1] then rank[index_rank] = 5


for i_F = 0, n_elements(ra) - 1 do begin
http_string = "'http://skyserver.sdss.org/dr12/SkyserverWS/ImgCutout/getjpeg?TaskName=Skyserver.Chart.Image&ra="+strtrim(ra[[i_F]],2)+"&dec="+strtrim(dec[[i_F]],2)+"&scale=0.39612&width=300&height=300&opt=GST&query=SR(10,20)"
print, http_string
spawn, 'wget -c '+http_string+'''' + '  -O ./SDSS_img_check/lowzq_'+strtrim([i_F],2)+'_'+strtrim(mag[i_F],2)+'_'+strtrim(color[i_F],2)+'_'+strtrim(rank[i_F],2)+'.jpg'
;
endfor


end