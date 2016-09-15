readcol, '../XMM-LSS/nospecz.txt', ra, dec, mag, mag_auto, weight, format = 'd,d,f,f,f'
rank = long(( -1 * weight + 46 ) / 10.) + 2
target_name = sindgen(n_elements(ra))

print, max(rank), min(rank)

radec, ra, dec, ihr, imin, xsec, ideg, imn, xsc

;0:40:30.289    41:16:08.73    008-060       1    TARGET
openw, lun_obs, 'MMT_config_all.cat', /get_lun
printf, lun_obs, 'ra	dec	object	rank	type'
printf, lun_obs, '-----------	-----------	----------	----	----'


for i_target = 0LL, n_elements(ra) - 1 do printf, lun_obs, strcompress(STRJOIN([string(ihr[i_target]), string(imin[i_target]), string(xsec[i_target])],':'), /rem )+'	'+strcompress(STRJOIN([string(ideg[i_target]), string(imn[i_target]), string(xsc[i_target])],':'), /rem )+'	cc_'+strtrim(target_name[i_target],2), '	'+strtrim(rank[i_target],2)+'	target'

tab_SDSS_fstar = mrdfits('xmmlss_f_stars_cnaw.fits',1)

radec, tab_SDSS_fstar.ra, tab_SDSS_fstar.dec, ihr, imin, xsec, ideg, imn, xsc

;0:40:30.289    41:16:08.73    008-060       1    TARGET
for i_fstar = 0LL, n_elements(tab_SDSS_fstar.ra) - 1 do printf, lun_obs, strcompress(STRJOIN([string(ihr[i_fstar]), string(imin[i_fstar]), string(xsec[i_fstar])],':'), /rem )+'	'+strcompress(STRJOIN([string(ideg[i_fstar]), string(imn[i_fstar]), string(xsc[i_fstar])],':'), /rem )+'	'+strcompress(tab_SDSS_fstar[i_fstar].OBJID, /rem)+'	1	target'



tab_gsc = mrdfits('gsc.fits',1)

index = where(tab_gsc.fmag gt 5 and tab_gsc.fmag lt 15.5)
help, index

readcol, 'gsc_ra_dec_offset.txt', a0, a1, a2, a3, a4
delta_ra = a1[0]
delta_dec = a1[1]

ra_new = tab_gsc[index].raj2000 + delta_ra / 3600.d / cos(tab_gsc[index].dej2000)
dec_new = tab_gsc[index].dej2000 + delta_dec / 3600.d  

radec, ra_new, dec_new, ihr, imin, xsec, ideg, imn, xsc

;0:40:30.289    41:16:08.73    008-060       1    TARGET
for i_gsc = 0LL, n_elements(index) - 1 do printf, lun_obs, strcompress(STRJOIN([string(ihr[i_gsc]), string(imin[i_gsc]), string(xsec[i_gsc])],':'), /rem )+'	'+strcompress(STRJOIN([string(ideg[i_gsc]), string(imn[i_gsc]), string(xsc[i_gsc])],':'), /rem )+'	'+strcompress(tab_gsc[index[i_gsc]].GSC2_3, /rem)+'	0	guide'



free_lun, lun_obs

end
