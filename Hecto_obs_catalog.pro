
ra_center = 352.51207	;36.364144		;36.481048	;36.388494	;34.547447		;36.313058d
dec_center = 0.16035086	;-4.58464		;-4.4962997	;-4.5825442	;-4.9496561		;-4.5753333d


readcol, 'CC_deep2_nospec.txt', ra, dec, mag, color, format = 'd,d,f'
rank = indgen(n_elements(mag))
index_rank = where(mag ge 21 and color gt 1.4)
if index_rank ne [-1] then rank[index_rank] = 1
index_rank = where((mag ge 20 and mag lt 21) or (mag ge 21 and color lt 1.4))
if index_rank ne [-1] then rank[index_rank] = 3
index_rank = where(mag ge 19 and mag lt 20)
if index_rank ne [-1] then rank[index_rank] = 4
index_rank = where(mag lt 19)
if index_rank ne [-1] then rank[index_rank] = 5

target_name = sindgen(n_elements(ra))

print, max(rank), min(rank)

radec, ra, dec, ihr, imin, xsec, ideg, imn, xsc

plot, ra, dec, psy = 3, xran = [351.6, 353.], yran = [-0.4, 0.7]
;0:40:30.289    41:16:08.73    008-060       1    TARGET
openw, lun_obs, 'MMT_config_deep2.cat', /get_lun
printf, lun_obs, 'ra	dec	object	rank	type	mag'
printf, lun_obs, '-----------	-----------	----------	----	----	---'

for i_target = 0LL, n_elements(ra) - 1 do begin
	
	if i_target eq 500 then continue
	if i_target eq 638 then continue
	
	
	
	if imn[i_target] ge 0 and xsc[i_target] ge 0 then begin
	printf, lun_obs, strcompress(STRJOIN([string(ihr[i_target]), string(imin[i_target]), string(xsec[i_target])],':'), /rem )+'	'+strcompress(STRJOIN([string(ideg[i_target]), string(imn[i_target]), string(xsc[i_target])],':'), /rem )+'	cc_'+strtrim(target_name[i_target],2), '	'+strtrim(rank[i_target],2)+'	target	'+strtrim(mag[i_target],2)
	endif
	if imn[i_target] lt 0 or xsc[i_target] le 0 then begin
	printf, lun_obs, strcompress(STRJOIN([string(ihr[i_target]), string(imin[i_target]), string(xsec[i_target])],':'), /rem )+'	-'+strcompress(STRJOIN([string(ideg[i_target]), string(abs(imn[i_target])), string(abs(xsc[i_target]))],':'), /rem )+'	cc_'+strtrim(target_name[i_target],2), '	'+strtrim(rank[i_target],2)+'	target	'+strtrim(mag[i_target],2)
	endif
	
	if rank[i_target] eq 1 then begin
		
		if imn[i_target] ge 0 and xsc[i_target] ge 0 then begin
		printf, lun_obs, strcompress(STRJOIN([string(ihr[i_target]), string(imin[i_target]), string(xsec[i_target])],':'), /rem )+'	'+strcompress(STRJOIN([string(ideg[i_target]), string(imn[i_target]), string(xsc[i_target])],':'), /rem )+'	cc2_'+strtrim(target_name[i_target],2), '	'+strtrim(rank[i_target],2)+'	target	'+strtrim(mag[i_target],2)
		endif
		if imn[i_target] lt 0 or xsc[i_target] le 0 then begin
		printf, lun_obs, strcompress(STRJOIN([string(ihr[i_target]), string(imin[i_target]), string(xsec[i_target])],':'), /rem )+'	-'+strcompress(STRJOIN([string(ideg[i_target]), string(abs(imn[i_target])), string(abs(xsc[i_target]))],':'), /rem )+'	cc2_'+strtrim(target_name[i_target],2), '	'+strtrim(rank[i_target],2)+'	target	'+strtrim(mag[i_target],2)
		endif
		
		if imn[i_target] ge 0 and xsc[i_target] ge 0 then begin
		printf, lun_obs, strcompress(STRJOIN([string(ihr[i_target]), string(imin[i_target]), string(xsec[i_target])],':'), /rem )+'	'+strcompress(STRJOIN([string(ideg[i_target]), string(imn[i_target]), string(xsc[i_target])],':'), /rem )+'	cc3_'+strtrim(target_name[i_target],2), '	'+strtrim(rank[i_target],2)+'	target	'+strtrim(mag[i_target],2)
		endif
		if imn[i_target] lt 0 or xsc[i_target] le 0 then begin
		printf, lun_obs, strcompress(STRJOIN([string(ihr[i_target]), string(imin[i_target]), string(xsec[i_target])],':'), /rem )+'	-'+strcompress(STRJOIN([string(ideg[i_target]), string(abs(imn[i_target])), string(abs(xsc[i_target]))],':'), /rem )+'	cc3_'+strtrim(target_name[i_target],2), '	'+strtrim(rank[i_target],2)+'	target	'+strtrim(mag[i_target],2)
		endif
		
		if imn[i_target] ge 0 and xsc[i_target] ge 0 then begin
		printf, lun_obs, strcompress(STRJOIN([string(ihr[i_target]), string(imin[i_target]), string(xsec[i_target])],':'), /rem )+'	'+strcompress(STRJOIN([string(ideg[i_target]), string(imn[i_target]), string(xsc[i_target])],':'), /rem )+'	cc4_'+strtrim(target_name[i_target],2), '	'+strtrim(rank[i_target],2)+'	target	'+strtrim(mag[i_target],2)
		endif
		if imn[i_target] lt 0 or xsc[i_target] le 0 then begin
		printf, lun_obs, strcompress(STRJOIN([string(ihr[i_target]), string(imin[i_target]), string(xsec[i_target])],':'), /rem )+'	-'+strcompress(STRJOIN([string(ideg[i_target]), string(abs(imn[i_target])), string(abs(xsc[i_target]))],':'), /rem )+'	cc3_'+strtrim(target_name[i_target],2), '	'+strtrim(rank[i_target],2)+'	target	'+strtrim(mag[i_target],2)
		endif
		
	endif
	
	if rank[i_target] eq 3 then begin
		
		if imn[i_target] ge 0 and xsc[i_target] ge 0 then begin
		printf, lun_obs, strcompress(STRJOIN([string(ihr[i_target]), string(imin[i_target]), string(xsec[i_target])],':'), /rem )+'	'+strcompress(STRJOIN([string(ideg[i_target]), string(imn[i_target]), string(xsc[i_target])],':'), /rem )+'	cc5_'+strtrim(target_name[i_target],2), '	'+strtrim(rank[i_target],2)+'	target	'+strtrim(mag[i_target],2)
		endif
		if imn[i_target] lt 0 or xsc[i_target] le 0 then begin
		printf, lun_obs, strcompress(STRJOIN([string(ihr[i_target]), string(imin[i_target]), string(xsec[i_target])],':'), /rem )+'	-'+strcompress(STRJOIN([string(ideg[i_target]), string(abs(imn[i_target])), string(abs(xsc[i_target]))],':'), /rem )+'	cc5_'+strtrim(target_name[i_target],2), '	'+strtrim(rank[i_target],2)+'	target	'+strtrim(mag[i_target],2)
		endif
	endif
	
endfor


readcol, 'CC_SDSS.txt', ra, dec, mag, color, format = 'd,d,f,f'
rank = indgen(n_elements(mag))
index_rank = where(mag ge 21 and color gt 1.4)
if index_rank ne [-1] then rank[index_rank] = 1
index_rank = where((mag ge 20 and mag lt 21)  or (mag ge 21 and color lt 1.4))
if index_rank ne [-1] then rank[index_rank] = 3
index_rank = where(mag ge 19 and mag lt 20)
if index_rank ne [-1] then rank[index_rank] = 4
index_rank = where(mag lt 19)
if index_rank ne [-1] then rank[index_rank] = 5

readcol, 'ra_dec_offset_SDSS_fillin.txt', a0, a1, a2, a3, a4
delta_ra = a1[0]
delta_dec = a1[1]

ra = ra + delta_ra / 3600.d / cos(dec)
dec = dec + delta_dec / 3600.d  

target_name = sindgen(n_elements(ra))
radec, ra, dec, ihr, imin, xsec, ideg, imn, xsc

oplot, ra, dec, psy = 3, color = cgcolor('red')

for i_target = 0LL, n_elements(ra) - 1 do  begin	
	
	if i_target eq 1621 then continue
	if i_target eq 1602 then continue

	if i_target eq 255 then continue
	if i_target eq 280 then continue
	if i_target eq 308 then continue
	if i_target eq 384 then continue
	if i_target eq 393 then continue
	if i_target eq 438 then continue
	
	if i_target eq 439 then continue
	if i_target eq 440 then continue
	if i_target eq 455 then continue

	if i_target eq 462 then continue
	if i_target eq 465 then continue
	if i_target eq 473 then continue
	if i_target eq 483 then continue	
	if i_target eq 585 then continue	

if i_target eq 646 then continue	
if i_target eq 682 then continue	
if i_target eq 683 then continue	
if i_target eq 716 then continue	
if i_target eq 721 then continue	
if i_target eq 734 then continue	
if i_target eq 742 then continue	
if i_target eq 756 then continue	
if i_target eq 764 then continue	
if i_target eq 773 then continue	
if i_target eq 777 then continue	
if i_target eq 779 then continue	
if i_target eq 785 then continue	
if i_target eq 789 then continue	
if i_target eq 816 then continue	
if i_target eq 824 then continue	

if i_target eq 963 then continue	
if i_target eq 965 then continue	
if i_target eq 1004 then continue	
if i_target eq 1071 then continue	
if i_target eq 1081 then continue	
if i_target eq 1114 then continue	

if i_target eq 1115 then continue	
if i_target eq 1119 then continue	
if i_target eq 1118 then continue	
if i_target eq 1122 then continue	
if i_target eq 1162 then continue	
if i_target eq 1173 then continue	
if i_target eq 1172 then continue	

if i_target eq 1171 then continue	
if i_target eq 1185 then continue	
if i_target eq 1212 then continue	
if i_target eq 1211 then continue	
if i_target eq 1217 then continue	
if i_target eq 1227 then continue	
if i_target eq 1225 then continue	
if i_target eq 1236 then continue	
if i_target eq 1235 then continue	

if i_target eq 1238 then continue	
if i_target eq 1237 then continue	
if i_target eq 1248 then continue	
if i_target eq 1247 then continue	
if i_target eq 1264 then continue	
if i_target eq 1280 then continue	
if i_target eq 1282 then continue	

if i_target eq 1297 then continue	
if i_target eq 1298 then continue	
if i_target eq 1521 then continue	
if i_target eq 1520 then continue	
if i_target eq 1575 then continue	

if i_target eq 1586 then continue	
if i_target eq 1599 then continue	
if i_target eq 1602 then continue	
if i_target eq 1621 then continue	


	
	if imn[i_target] ge 0 and xsc[i_target] ge 0 then begin
	printf, lun_obs, strcompress(STRJOIN([string(ihr[i_target]), string(imin[i_target]), string(xsec[i_target])],':'), /rem )+'	'+strcompress(STRJOIN([string(ideg[i_target]), string(imn[i_target]), string(xsc[i_target])],':'), /rem )+'	SDSS_fill_'+strtrim(target_name[i_target],2), '	'+strtrim(rank[i_target],2)+'	target	'+strtrim(mag[i_target],2)
	endif
	
	if imn[i_target] lt 0 or xsc[i_target] le 0 then begin
	printf, lun_obs, strcompress(STRJOIN([string(ihr[i_target]), string(imin[i_target]), string(xsec[i_target])],':'), /rem )+'	-'+strcompress(STRJOIN([string(ideg[i_target]), string(abs(imn[i_target])), string(abs(xsc[i_target]))],':'), /rem )+'	SDSS_fill_'+strtrim(target_name[i_target],2), '	'+strtrim(rank[i_target],2)+'	target	'+strtrim(mag[i_target],2)
	endif
	
	
	if rank[i_target] eq 1 then begin
		if imn[i_target] ge 0 and xsc[i_target] ge 0 then begin
		printf, lun_obs, strcompress(STRJOIN([string(ihr[i_target]), string(imin[i_target]), string(xsec[i_target])],':'), /rem )+'	'+strcompress(STRJOIN([string(ideg[i_target]), string(imn[i_target]), string(xsc[i_target])],':'), /rem )+'	SDSS_fill2_'+strtrim(target_name[i_target],2), '	'+strtrim(rank[i_target],2)+'	target	'+strtrim(mag[i_target],2)
		endif
		if imn[i_target] lt 0 or xsc[i_target] le 0 then begin
		printf, lun_obs, strcompress(STRJOIN([string(ihr[i_target]), string(imin[i_target]), string(xsec[i_target])],':'), /rem )+'	-'+strcompress(STRJOIN([string(ideg[i_target]), string(abs(imn[i_target])), string(abs(xsc[i_target]))],':'), /rem )+'	SDSS_fill2_'+strtrim(target_name[i_target],2), '	'+strtrim(rank[i_target],2)+'	target	'+strtrim(mag[i_target],2)
		endif

		if imn[i_target] ge 0 and xsc[i_target] ge 0 then begin
		printf, lun_obs, strcompress(STRJOIN([string(ihr[i_target]), string(imin[i_target]), string(xsec[i_target])],':'), /rem )+'	'+strcompress(STRJOIN([string(ideg[i_target]), string(imn[i_target]), string(xsc[i_target])],':'), /rem )+'	SDSS_fill3_'+strtrim(target_name[i_target],2), '	'+strtrim(rank[i_target],2)+'	target	'+strtrim(mag[i_target],2)
		endif
		if imn[i_target] lt 0 or xsc[i_target] le 0 then begin
		printf, lun_obs, strcompress(STRJOIN([string(ihr[i_target]), string(imin[i_target]), string(xsec[i_target])],':'), /rem )+'	-'+strcompress(STRJOIN([string(ideg[i_target]), string(abs(imn[i_target])), string(abs(xsc[i_target]))],':'), /rem )+'	SDSS_fill3_'+strtrim(target_name[i_target],2), '	'+strtrim(rank[i_target],2)+'	target	'+strtrim(mag[i_target],2)
		endif
		
		if imn[i_target] ge 0 and xsc[i_target] ge 0 then begin
		printf, lun_obs, strcompress(STRJOIN([string(ihr[i_target]), string(imin[i_target]), string(xsec[i_target])],':'), /rem )+'	'+strcompress(STRJOIN([string(ideg[i_target]), string(imn[i_target]), string(xsc[i_target])],':'), /rem )+'	SDSS_fill4_'+strtrim(target_name[i_target],2), '	'+strtrim(rank[i_target],2)+'	target	'+strtrim(mag[i_target],2)
		endif
		if imn[i_target] lt 0 or xsc[i_target] le 0 then begin
		printf, lun_obs, strcompress(STRJOIN([string(ihr[i_target]), string(imin[i_target]), string(xsec[i_target])],':'), /rem )+'	-'+strcompress(STRJOIN([string(ideg[i_target]), string(abs(imn[i_target])), string(abs(xsc[i_target]))],':'), /rem )+'	SDSS_fill4_'+strtrim(target_name[i_target],2), '	'+strtrim(rank[i_target],2)+'	target	'+strtrim(mag[i_target],2)
		endif
		
		
	endif
	
	
	
	if rank[i_target] eq 3 then begin
		if imn[i_target] ge 0 and xsc[i_target] ge 0 then begin
		printf, lun_obs, strcompress(STRJOIN([string(ihr[i_target]), string(imin[i_target]), string(xsec[i_target])],':'), /rem )+'	'+strcompress(STRJOIN([string(ideg[i_target]), string(imn[i_target]), string(xsc[i_target])],':'), /rem )+'	SDSS_fill5_'+strtrim(target_name[i_target],2), '	'+strtrim(rank[i_target],2)+'	target	'+strtrim(mag[i_target],2)
		endif
		if imn[i_target] lt 0 or xsc[i_target] le 0 then begin
		printf, lun_obs, strcompress(STRJOIN([string(ihr[i_target]), string(imin[i_target]), string(xsec[i_target])],':'), /rem )+'	-'+strcompress(STRJOIN([string(ideg[i_target]), string(abs(imn[i_target])), string(abs(xsc[i_target]))],':'), /rem )+'	SDSS_fill5_'+strtrim(target_name[i_target],2), '	'+strtrim(rank[i_target],2)+'	target	'+strtrim(mag[i_target],2)
		endif
		
		
	endif
endfor










readcol, 'CC_deep2_spec_low_zq.txt', ra, dec, mag, color, format = 'd,d,f,f'
rank = indgen(n_elements(mag))
index_rank = where(mag ge 21 and color gt 1.4)
if index_rank ne [-1] then rank[index_rank] = 1
index_rank = where((mag ge 20 and mag lt 21) or (mag ge 21 and color lt 1.4))
if index_rank ne [-1] then rank[index_rank] = 3
index_rank = where(mag lt 20)
if index_rank ne [-1] then rank[index_rank] = 5

target_name = sindgen(n_elements(ra))
radec, ra, dec, ihr, imin, xsec, ideg, imn, xsc


oplot, ra, dec, psy = 3, color = cgcolor('green')

for i_target = 0LL, n_elements(ra) - 1 do  begin	
	if imn[i_target] ge 0 and xsc[i_target] ge 0 then begin
	printf, lun_obs, strcompress(STRJOIN([string(ihr[i_target]), string(imin[i_target]), string(xsec[i_target])],':'), /rem )+'	'+strcompress(STRJOIN([string(ideg[i_target]), string(imn[i_target]), string(xsc[i_target])],':'), /rem )+'	low_zq_'+strtrim(target_name[i_target],2), '	'+strtrim(rank[i_target],2)+'	target	'+strtrim(mag[i_target],2)
	endif
	
	if imn[i_target] lt 0 or xsc[i_target] le 0 then begin
	printf, lun_obs, strcompress(STRJOIN([string(ihr[i_target]), string(imin[i_target]), string(xsec[i_target])],':'), /rem )+'	-'+strcompress(STRJOIN([string(ideg[i_target]), string(abs(imn[i_target])), string(abs(xsc[i_target]))],':'), /rem )+'	low_zq_'+strtrim(target_name[i_target],2), '	'+strtrim(rank[i_target],2)+'	target	'+strtrim(mag[i_target],2)
	endif
	
	if rank[i_target] eq 2 then begin
		if imn[i_target] ge 0 and xsc[i_target] ge 0 then begin
		printf, lun_obs, strcompress(STRJOIN([string(ihr[i_target]), string(imin[i_target]), string(xsec[i_target])],':'), /rem )+'	'+strcompress(STRJOIN([string(ideg[i_target]), string(imn[i_target]), string(xsc[i_target])],':'), /rem )+'	low_zq2_'+strtrim(target_name[i_target],2), '	'+strtrim(rank[i_target],2)+'	target	'+strtrim(mag[i_target],2)
		endif
		if imn[i_target] lt 0 or xsc[i_target] le 0 then begin
		printf, lun_obs, strcompress(STRJOIN([string(ihr[i_target]), string(imin[i_target]), string(xsec[i_target])],':'), /rem )+'	-'+strcompress(STRJOIN([string(ideg[i_target]), string(abs(imn[i_target])), string(abs(xsc[i_target]))],':'), /rem )+'	low_zq2_'+strtrim(target_name[i_target],2), '	'+strtrim(rank[i_target],2)+'	target	'+strtrim(mag[i_target],2)
		endif
	endif
	
endfor






;tab_SDSS_fstar = mrdfits('xmmlss_f_stars_cnaw.fits',1)

tab_SDSS_fstar = mrdfits('../F_star/Skyserver_SQL_deep2_F.fits',1)


readcol, 'ra_dec_offset_SDSS_fstar.txt', a0, a1, a2, a3, a4
delta_ra = a1[0]
delta_dec = a1[1]

ra_new = tab_SDSS_fstar.ra + delta_ra / 3600.d / cos(tab_SDSS_fstar.dec)
dec_new = tab_SDSS_fstar.dec + delta_dec / 3600.d  

distance_radec = sphdist(ra_center, dec_center, ra_new, dec_new,/degrees)
index = where(distance_radec lt 0.6 and tab_SDSS_fstar.PROBPSF_R eq 1 and tab_SDSS_fstar.TYPE eq 6 and tab_SDSS_fstar.PSFMAG_R gt 16 and tab_SDSS_fstar.PSFMAG_R lt 18)

oplot, tab_SDSS_fstar[index].ra, tab_SDSS_fstar[index].dec, psy = symcat(16)


radec, ra_new[index], dec_new[index], ihr, imin, xsec, ideg, imn, xsc

oplot, ra_new[index], dec_new[index], psy = symcat(16), color = cgcolor('blue')


for i_fstar = 0LL, n_elements(index) - 1 do  begin	
	if imn[i_fstar] ge 0 and xsc[i_fstar] ge 0 then begin
	printf, lun_obs, strcompress(STRJOIN([string(ihr[i_fstar]), string(imin[i_fstar]), string(xsec[i_fstar])],':'), /rem )+'	'+strcompress(STRJOIN([string(ideg[i_fstar]), string(imn[i_fstar]), string(xsc[i_fstar])],':'), /rem )+'	'+strcompress(tab_SDSS_fstar[i_fstar].OBJID, /rem)+'	2	target	'+strtrim(tab_SDSS_fstar[index[i_fstar]].PSFMAG_R,2)
	endif
	
	if imn[i_fstar] lt 0 or xsc[i_fstar] le 0 then begin
	printf, lun_obs, strcompress(STRJOIN([string(ihr[i_fstar]), string(imin[i_fstar]), string(xsec[i_fstar])],':'), /rem )+'	-'+strcompress(STRJOIN([string(ideg[i_fstar]), string(abs(imn[i_fstar])), string(abs(xsc[i_fstar]))],':'), /rem )+'	'+strcompress(tab_SDSS_fstar[i_fstar].OBJID, /rem)+'	2	target	'+strtrim(tab_SDSS_fstar[index[i_fstar]].PSFMAG_R,2)
	endif
endfor







tab_gsc = mrdfits('gsc.fits',1)

readcol, 'gsc_ra_dec_offset.txt', a0, a1, a2, a3, a4
delta_ra = a1[0]
delta_dec = a1[1]

ra_new = tab_gsc.raj2000 + delta_ra / 3600.d / cos(tab_gsc.dej2000)
dec_new = tab_gsc.dej2000 + delta_dec / 3600.d  

distance_radec = sphdist(ra_center, dec_center, ra_new, dec_new,/degrees)

index = where(distance_radec lt 0.6 and tab_gsc.fmag gt 14.5 and tab_gsc.fmag lt 15.5)

radec, ra_new[index], dec_new[index], ihr, imin, xsec, ideg, imn, xsc

oplot, ra_new[index], dec_new[index], psy = symcat(16), color = cgcolor('purple')


for i_gsc = 0LL, n_elements(index) - 1 do  begin	
	if imn[i_gsc] ge 0 and xsc[i_gsc] ge 0 then begin
	printf, lun_obs, strcompress(STRJOIN([string(ihr[i_gsc]), string(imin[i_gsc]), string(xsec[i_gsc])],':'), /rem )+'	'+strcompress(STRJOIN([string(ideg[i_gsc]), string(imn[i_gsc]), string(xsc[i_gsc])],':'), /rem )+'	'+strcompress(tab_gsc[index[i_gsc]].GSC2_3, /rem)+'	0	guide	'+strtrim(tab_gsc[index[i_gsc]].fmag,2)
	endif
	
	if imn[i_gsc] lt 0 or xsc[i_gsc] le 0 then begin
	printf, lun_obs, strcompress(STRJOIN([string(ihr[i_gsc]), string(imin[i_gsc]), string(xsec[i_gsc])],':'), /rem )+'	-'+strcompress(STRJOIN([string(ideg[i_gsc]), string(abs(imn[i_gsc])), string(abs(xsc[i_gsc]))],':'), /rem )+'	'+strcompress(tab_gsc[index[i_gsc]].GSC2_3, /rem)+'	0	guide	'+strtrim(tab_gsc[index[i_gsc]].fmag,2)
	endif
endfor




free_lun, lun_obs

end
