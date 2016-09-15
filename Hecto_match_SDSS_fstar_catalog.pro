tab = mrdfits('../catalog/tab_all_spec.fits',1)
tab_SDSS_fstar = mrdfits('xmmlss_f_stars.fits',1)


head_img = headfits('../XMM-LSS/CLAUDS_XMMLSS.u.fits')
extast, head_img, ast_img


ra_standard 	= tab.ra
dec_standard 	= tab.dec

ra_XXX 	 	= tab_SDSS_fstar.RA
dec_XXX		= tab_SDSS_fstar.DEC
flux_XXX	= 10.^((31.4 - tab_SDSS_fstar.PSFMAG_R) / 2.5 )


ad2xy, ra_XXX, dec_XXX, ast_img, x_XXX, y_XXX
ad2xy, ra_standard, dec_standard, ast_img, x_standard, y_standard

area_XXX	= 8.

dis_criterion = 2.		;	arcsec


openw, lun_match, 'match_catalog_SDSS_fstar_CFHTLS.txt', /get_lun

for i_match = 0LL, n_elements(ra_standard) - 1LL do begin
	
;	if mag_ch4[i_match] gt 19.5 then continue
	
	if(i_match mod 5000 eq 1)then begin
   		print,  n_elements(ra_standard)-1  - i_match, ' <----- for ', systime()
	endif

	index_inside = where( abs(x_standard[i_match] - x_XXX) lt 20. and abs(y_standard[i_match] - y_XXX) lt 20. )
	if index_inside[0] eq -1 then begin
		continue
	endif

	sph_distance = sphdist(ra_standard[i_match], dec_standard[i_match], ra_XXX[index_inside], dec_XXX[index_inside],/degrees)*60.d *60.d
	index = where(sph_distance lt dis_criterion)
	if index[0] ne -1 then begin
		sph_distance = sphdist(ra_standard[i_match], dec_standard[i_match], ra_XXX[index_inside[index]], dec_XXX[index_inside[index]],/degrees)*60.d *60.d
		
		index_min = where(sph_distance eq min(sph_distance))
		index_min = index_min[0]
		
		sph_distance_min = min(sph_distance)
		flux_limit = flux_XXX[index_inside[index[index_min]]]
		
		index_flux_limit = where(flux_XXX ge flux_limit)
		index_flux_limit_size = size(index_flux_limit)
		index_flux_limit_number = index_flux_limit_size[1]
		flux_limit_number_density = index_flux_limit_number*1. / (area_XXX*3600.*3600.)
;		print, exp(- !pi * sph_distance_min^2. * flux_limit_number_density)
		
			if flux_XXX[index_inside[index[index_min]]] eq -99. then begin
				continue
			endif
		
			printf, lun_match, i_match, ra_standard[i_match], dec_standard[i_match], $;tab_standard[i_match].fc,tab_standard[i_match].fw,$
			index_inside[index[index_min]], ra_XXX[index_inside[index[index_min]]],dec_XXX[index_inside[index[index_min]]],flux_XXX[index_inside[index[index_min]]],$			
			exp(- !pi * sph_distance_min^2. * flux_limit_number_density), format = '(i,2d55.10, i,4d55.10)'

	endif
endfor

free_lun, lun_match



















end
