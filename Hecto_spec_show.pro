path_to_spec = '~/Jobs/Extent_SDSS/XMMLSS_pre_data/xmm_lss_2010_hecto/2010.1011/reduction/0000/'
specfile = 'spHect-2010.1011_xmm_lss_2010_rev_2.fits'
path_to_specz = '~/Jobs/Extent_SDSS/XMMLSS_pre_data/xmm_lss_2010_hecto/2010.1011/reduction/0000/'
specz_log = 'spHect-2010.1011_xmm_lss_2010_rev_2.zlog'

tab_spec = mrdfits(path_to_spec+specfile, 1, h)
tab_catalog = mrdfits(path_to_spec+specfile, 5, h)

readcol, path_to_specz + specz_log, target, ra, dec, RMAG, specz, speczerr, qz, a1,a2,a3, class, $
		format = 'a,d,d,f,f,f,i,i,i,i,a'

index = sort(tab_catalog.RMAG)

for i_spec = 0, n_elements(index) - 1 do begin
	
	print, 'ra:	', ra[index[i_spec]]*15, tab_catalog[index[i_spec]].ra
	
	plot, tab_spec[*,[index[i_spec]]], yran = [-1,5], charsize = 1.5
	xyouts, 500, 4, strtrim(tab_catalog[index[i_spec]].RMAG,2), charsize = 2, charthick = 2
	
	set_plot,'ps'
	device, filename=strtrim(index[i_spec],2)+'.eps',/color,/encapsulated

	if RMAG[index[i_spec]] ge 20 or RMAG[index[i_spec]] eq 0. then begin
	
	yrange = [-1, 5]
	plot, tab_spec[*,[index[i_spec]]], yran = yrange, charsize = 0.5,xstyle = 1, ystyle = 1,xthick = 4,ythick = 4,charthick = 4,thick = 1,xtitle = textoidl(' '),ytitle = textoidl(' ')  


	xyouts, 500, 4, 'RMAG = '+strtrim(tab_catalog[index[i_spec]].RMAG,2), charsize = 2, charthick = 4
	xyouts, 500, 4, 'RMAG = '+strtrim(RMAG[index[i_spec]],2), charsize = 2, charthick = 4
	xyouts, 500, 3.5, 'z = '+strtrim(specz[index[i_spec]],2) + '', charsize = 2, charthick = 4
	xyouts, 500, 3., 'qz = '+strtrim(qz[index[i_spec]],2), charsize = 2, charthick = 4
	xyouts, 1000, -0.5, strtrim(ra[index[i_spec]]*15.d,2)+'	 '+strtrim(dec[index[i_spec]],2), charsize = 2, charthick = 4
	;plot,  ,  , psym = 3,  xrange = [ , ],yrange = [ , ]
	
	endif


	if RMAG[index[i_spec]] le 20 and RMAG[index[i_spec]] gt 19. then begin
	yrange = [-1, 10]
	plot, tab_spec[*,[index[i_spec]]], yran = yrange, charsize = 0.5,xstyle = 1, ystyle = 1,xthick = 4,ythick = 4,charthick = 4,thick = 1,xtitle = textoidl(' '),ytitle = textoidl(' ')  


	xyouts, 500, 8, 'RMAG = '+strtrim(tab_catalog[index[i_spec]].RMAG,2), charsize = 2, charthick = 4
	xyouts, 500, 8, 'RMAG = '+strtrim(RMAG[index[i_spec]],2), charsize = 2, charthick = 4
	xyouts, 500, 7., 'z = '+strtrim(specz[index[i_spec]],2) + '', charsize = 2, charthick = 4
	xyouts, 500, 6., 'qz = '+strtrim(qz[index[i_spec]],2), charsize = 2, charthick = 4
	xyouts, 1000, -0.5, strtrim(ra[index[i_spec]]*15.d,2)+'	 '+strtrim(dec[index[i_spec]],2), charsize = 2, charthick = 4
	;plot,  ,  , psym = 3,  xrange = [ , ],yrange = [ , ]
	endif
	
	if RMAG[index[i_spec]] le 19 and RMAG[index[i_spec]] gt 16. then begin
	yrange = [-1, 15]
	plot, tab_spec[*,[index[i_spec]]], yran = yrange, charsize = 0.5,xstyle = 1, ystyle = 1,xthick = 4,ythick = 4,charthick = 4,thick = 1,xtitle = textoidl(' '),ytitle = textoidl(' ')  

	xyouts, 500, 13, 'RMAG = '+strtrim(tab_catalog[index[i_spec]].RMAG,2), charsize = 2, charthick = 4
	xyouts, 500, 13, 'RMAG = '+strtrim(RMAG[index[i_spec]],2), charsize = 2, charthick = 4
	xyouts, 500, 11.5, 'z = '+strtrim(specz[index[i_spec]],2) + '', charsize = 2, charthick = 4
	xyouts, 500, 10., 'qz = '+strtrim(qz[index[i_spec]],2), charsize = 2, charthick = 4
	xyouts, 1000, -0.5, strtrim(ra[index[i_spec]]*15.d,2)+'	 '+strtrim(dec[index[i_spec]],2), charsize = 2, charthick = 4
	;plot,  ,  , psym = 3,  xrange = [ , ],yrange = [ , ]
	endif
	
	
	
	
	DEVICE, /CLOSE
	DEVICE,ENCAPSULATED=0
	set_plot, 'x'
			
	http_string = "'http://skyserver.sdss.org/dr12/SkyserverWS/ImgCutout/getjpeg?TaskName=Skyserver.Chart.Image&ra="+strtrim(ra[index[i_spec]]*15.d,2)+"&dec="+strtrim(dec[index[i_spec]],2)+"&scale=0.39612&width=300&height=300&opt=GST&query=SR(10,20)"
	
	print, http_string
	spawn, 'wget -c '+http_string+'''' + '  -O '+strtrim(index[i_spec],2)+'.jpg'
;	spawn, 'open '+strtrim(index[i_spec],2)+'.jpg'

;	cc_pause
endfor

openw, lun_tex, 'SDSS_Hecto.tex',/get_lun


printf, lun_tex, '\documentclass[11pt,preprint]{aastex}
printf, lun_tex, '%\usepackage{CJK}
printf, lun_tex, '\usepackage{graphicx}
printf, lun_tex, '\usepackage{epsfig}
printf, lun_tex, '\usepackage{epstopdf}
printf, lun_tex, '
printf, lun_tex, '\usepackage{amssymb}
printf, lun_tex, '\usepackage{amsmath}
printf, lun_tex, '\usepackage{mathrsfs}
printf, lun_tex, '\usepackage{bm}
printf, lun_tex, '
printf, lun_tex, '\usepackage{bmpsize}
printf, lun_tex, '
printf, lun_tex, '\usepackage{latexsym}
printf, lun_tex, '\usepackage{natbib}
printf, lun_tex, '\usepackage{ulem}
printf, lun_tex, '\usepackage{cases}
printf, lun_tex, '\usepackage{color}
printf, lun_tex, '\usepackage{cancel}
printf, lun_tex, '\usepackage{extarrows}
printf, lun_tex, '\usepackage{lscape}
printf, lun_tex, '
printf, lun_tex, '
printf, lun_tex, '
printf, lun_tex, '\begin{document}
printf, lun_tex, '\section{SDSS image Hecto spec}

for i_spec = 0, n_elements(index)-1 do begin
	printf, lun_tex, '\begin{figure}[ht!]
	printf, lun_tex, '\centering
	printf, lun_tex, '\includegraphics[width=0.3\textwidth]{'+strtrim(index[i_spec],2)+'.jpg}'
	printf, lun_tex, '\includegraphics[width=0.6\textwidth]{'+strtrim(index[i_spec],2)+'.eps}'
	printf, lun_tex, '\caption{.}%\label{fig}
	printf, lun_tex, '\end{figure}
	printf, lun_tex, '
	printf, lun_tex, '
	
	if i_spec mod 12 eq 1 then printf, lun_tex, '\clearpage
	
endfor

printf, lun_tex, '\end{document}
free_lun, lun_tex
	

spawn, 'pdflatex SDSS_Hecto.tex'
spawn, 'open SDSS_Hecto.pdf'	









end
