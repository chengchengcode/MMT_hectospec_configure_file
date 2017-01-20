;readcol, '../XMM-LSS/CC_nospec.txt', ra, dec, mag, weight, color,format = 'd,d,f,f,f,f'
;rank = indgen(n_elements(mag))
;index_rank = where(mag ge 21 and color gt 1.5)
;if index_rank ne [-1] then rank[index_rank] = 1
;index_rank = where((mag ge 20 and mag lt 21) or (mag ge 21 and color lt 1.5))
;if index_rank ne [-1] then rank[index_rank] = 3
;index_rank = where(mag ge 19 and mag lt 20)
;if index_rank ne [-1] then rank[index_rank] = 4
;index_rank = where(mag lt 19)
;if index_rank ne [-1] then rank[index_rank] = 5



tab = mrdfits('../target_ELAIS.fits',1)
ra = tab.ra
dec = tab.dec


mag_u = tab.AP_M_U + (  0.78534192)     
mag_g = tab.AP_M_G + (-0.077930473)  
mag_r = tab.AP_M_R + (  0.16371848)  
mag_i = tab.AP_M_I + (  0.42084096)  
mag_z = tab.AP_M_Z + (  0.53461082)  
mag_u_tot = tab.INT_M_U + (  0.78534192)  
mag_g_tot = tab.INT_M_G + (-0.077930473)  
mag_r_tot = tab.INT_M_R + (  0.16371848)  
mag_i_tot = tab.INT_M_I + (  0.42084096)  
mag_z_tot = tab.INT_M_Z + (  0.53461082)  


for i_F = 0, n_elements(ra) - 1 do begin
http_string = "'http://skyserver.sdss.org/dr12/SkyserverWS/ImgCutout/getjpeg?TaskName=Skyserver.Chart.Image&ra="+strtrim(ra[[i_F]],2)+"&dec="+strtrim(dec[[i_F]],2)+"&scale=0.39612&width=300&height=300&opt=GST&query=SR(10,20)"
print, http_string
spawn, 'wget -c '+http_string+'''' + '  -O ./cc_'+strtrim([i_F],2)+'_'+strtrim(mag_r_tot[i_F],2)+'.jpg'
;
endfor


;spawn, 'wget -c '+http_string+'''' + '  -O ./SDSS_img_check/lowzq_'+strtrim([i_F],2)+'_'+strtrim(mag[i_F],2)+'_'+strtrim(color[i_F],2)+'_'+strtrim(rank[i_F],2)+'.jpg'
;


end
