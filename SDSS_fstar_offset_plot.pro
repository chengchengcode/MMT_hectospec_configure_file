;tab = mrdfits('../catalog/tab_all_spec.fits',1)
;tab_SDSS_fstar = mrdfits('SDSS_fstar.fits',1)

readcol, 'match_catalog_SDSS_fstar_ELAIS_N1.txt', index_OBS, ra_OBS, dec_OBS, index_SDSS_fstar, $
			ra_SDSS_fstar, dec_SDSS_fstar, flux_SDSS_fstar, prob_SDSS_fstar, format = 'll, d, d, ll, d,d, f, f'




ran_x = (ra_OBS - ra_SDSS_fstar) * cos(dec_SDSS_fstar) * 3600.d
ran_y = (dec_OBS - dec_SDSS_fstar) * 3600.d

xbinsize = 0.025
ybinsize = 0.025

xrange = [-2,2]
yrange = [-2,2]


density = HIST_2D(ran_x, ran_y, Min1=xrange[0], Max1=xrange[1], Bin1=xbinsize, $
                            Min2=yrange[0], Max2=yrange[1], Bin2=ybinsize)

maxDensity = Ceil(Max(density)/1e2) * 5
scaledDensity = 255.-BytScl(density, Min=0, Max=maxDensity)                   

window, 0, xsize = 500, ysize = 500
cgImage, scaledDensity, XRange=xrange, YRange=yrange, /Axes, $
      XTitle=textoidl('\DeltaRA = RA_{obs} - RA_{SDSS_fstar}'), YTitle=textoidl('\DeltaDec = Dec_{obs} - Dec_{SDSS_fstar}'), $
      Position=[0.2, 0.3, 0.7, 0.7]

cgContour, density, LEVELS=maxDensity*[0.25, 0.5, 0.75], /OnImage, $
       C_Colors=['Tan','Tan', 'Brown'], C_Annotation=['Low', 'Avg', 'High'], $
       C_Thick=1, C_CharThick=1

cghistoplot, ran_x, xrange = xrange, bin = xbinsize, Position=[0.2, 0.7, 0.7, 0.9] ,/noer, xstyle = 4 , /outl
cghistoplot, ran_y, yrange = yrange, bin = ybinsize, Position=[0.7, 0.3, 0.9, 0.7] ,/noer, ystyle = 4, rotat = 90., /outl


cgColorbar, Position=[0.125, 0.075, 0.9, 0.125], Title='Density', $
    Range=[maxDensity,0], NColors=254, Bottom=1, OOB_Low='gray', $
    TLocation='Top'



!x.thick = 4.
!y.thick = 4.

!p.charsize = 1.5
!p.charthick = 4

set_plot,'ps'
device, filename='SDSS_fstar_offset.eps',/color,/encapsulated, xsize = 20, ysize = 20

cgImage, scaledDensity, XRange=xrange, YRange=yrange, /Axes, $
    XTitle=textoidl('\DeltaRA" = (RA_{obs} - RA_{SDSS_fstar}) * cos(Dec_{SDSS_fstar})'), YTitle=textoidl('\DeltaDec" = Dec_{obs} - Dec_{SDSS_fstar}'), $
      Position=[0.2, 0.3, 0.7, 0.8]

;cgContour, density, LEVELS=maxDensity*[0.25, 0.5, 0.75], /OnImage, $
;       C_Colors=['Tan','Tan', 'Brown'], C_Annotation=['Low', 'Avg', 'High'], $
;       C_Thick=5, C_CharThick=5

cghistoplot, ran_x, xrange = xrange, bin = xbinsize, Position=[0.2, 0.8, 0.7, 0.99] ,/noer, xstyle = 4, ytitle = '#', /outl, XTHICK = 4, YTHICK = 4, thick = 4, color = cgcolor('black')
cghistoplot, ran_y, yrange = yrange, bin = ybinsize, Position=[0.7, 0.3, 0.9, 0.8] ,/noer, ystyle = 4, rotat = 90., xtitle = '#', /outl, XTHICK = 4, YTHICK = 4, thick = 4, color = cgcolor('black')


cgColorbar, Position=[0.125, 0.075, 0.9, 0.125], Title='Density', $
    Range=[maxDensity,0], NColors=254, Bottom=1, OOB_Low='gray', $
    TLocation='Top', TEXTTHICK = 4


DEVICE, /CLOSE
DEVICE,ENCAPSULATED=0
set_plot, 'x'


!x.thick = 1.
!y.thick = 1.

!p.charsize = 1.
!p.charthick = 1.




openw, lun_SDSS_fstar, 'ra_dec_offset_SDSS_fstar.txt', /get_lun
printf, lun_SDSS_fstar, 'Delta ra = (ra_OBS - ra_SDSS_fstar) * cos(dec_SDSS_fstar) * 3600.d'
histogauss, ran_x, aa
printf, lun_SDSS_fstar, aa
printf, lun_SDSS_fstar, 'Delta dec = (dec_OBS - dec_SDSS_fstar) * 3600.d'
histogauss, ran_y, aa
printf, lun_SDSS_fstar, aa
printf, lun_SDSS_fstar, '%
printf, lun_SDSS_fstar, '%
printf, lun_SDSS_fstar, '% HISTOGAUSS, OUTPUT ARGUMENTS:
printf, lun_SDSS_fstar, '%       A = coefficients of the Gaussian fit: Height, mean, sigma
printf, lun_SDSS_fstar, '%               A[0]= the height of the Gaussian
printf, lun_SDSS_fstar, '%               A[1]= the mean
printf, lun_SDSS_fstar, '%               A[2]= the standard deviation
printf, lun_SDSS_fstar, '%               A[3]= the half-width of the 95% conf. interval of the standard
printf, lun_SDSS_fstar, '%                     mean
printf, lun_SDSS_fstar, '%               A[4]= 1/(N-1)*total( (y-mean)/sigma)^2 ) = a measure of 
printf, lun_SDSS_fstar, '%                       normality

free_lun, lun_SDSS_fstar

























end