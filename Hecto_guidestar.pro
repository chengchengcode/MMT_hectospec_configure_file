;
;This is an IDL code transfer the guide
;
;gsc file comes from http://www.cadc-ccda.hia-iha.nrc-cnrc.gc.ca/cadcbin/astrocat/gsc
;
;copy the raw output into gsc.txt
;
;Fmag is about the R mag:	
;"Gunn r to Photographic F: F = r - 0.25 + 0.17*(g-r)" 
;from https://www.astro.umd.edu/~ssm/ASTR620/mags.html
;
;Improvement can be made by counting the line 46:
;--------  ----------  ----------  ----------  --------  ----- ----- ----- ----- - ------  -----
;by how many '-' signs are there to detemain the char number in the function strmid
;
;but I am now a little bit tired
;
;C.Cheng, 20160915, UA

file_gsc = 'gsc.txt'
line_start = 46
output_gsc_fits_name = 'gsc.fits'

LineCount = FILE_LINES(file_gsc);
string_temp_line = strarr(LineCount)

gsc = {r_c : -99.99 ,$
GSC2_3 : 'XXX'      ,$
RAJ2000 : -99.99d   ,$
DEJ2000 : -99.99d   ,$
Epoch : -99.99      ,$
Fmag : -99.99       ,$
jmag : -99.99       ,$
Vmag : -99.99       ,$
Nmag : -99.99       ,$
Class : -99         ,$
a : -99.99          ,$
e : -99.99          $
}

gsc = replicate(gsc, LineCount - line_start)

gsc.r_c = fltarr(Linecount-line_start)
gsc.GSC2_3 = strarr(Linecount-line_start)
gsc.RAJ2000 = dblarr(Linecount-line_start)
gsc.DEJ2000 = dblarr(Linecount-line_start)
gsc.Epoch = fltarr(Linecount-line_start)
gsc.Fmag = fltarr(Linecount-line_start) - 99.99
gsc.jmag = fltarr(Linecount-line_start) - 99.99
gsc.Vmag = fltarr(Linecount-line_start) - 99.99
gsc.Nmag = fltarr(Linecount-line_start) - 99.99
gsc.Class = intarr(Linecount-line_start) -99
gsc.a = fltarr(Linecount-line_start) - 99.99
gsc.e = fltarr(Linecount-line_start) - 99.99


openr, lun_gsc, file_gsc, /get_lun
readf,lun_gsc,string_temp_line,format='(a)'
free_lun, lun_gsc

for i_gsc = line_start, LineCount - 1 do begin
;	print, string_temp_line[i_gsc]
	if i_gsc mod 1001 eq 1 then print, LineCount - 1 - i_gsc , '	<------', systime() 

;print, strmid(string_temp_line[i_gsc], 2, 6), $
;' '+strmid(string_temp_line[i_gsc], 10, 10), $
;' '+strmid(string_temp_line[i_gsc], 22, 10), $
;' '+strmid(string_temp_line[i_gsc], 34, 10), $
;' '+strmid(string_temp_line[i_gsc], 46, 8), $
;' '+strmid(string_temp_line[i_gsc], 56, 5), $
;' '+strmid(string_temp_line[i_gsc], 62, 5), $
;' '+strmid(string_temp_line[i_gsc], 68, 5), $
;' '+strmid(string_temp_line[i_gsc], 74, 5), $
;' '+strmid(string_temp_line[i_gsc], 80, 1), $
;' '+strmid(string_temp_line[i_gsc], 84, 4), $
;' '+strmid(string_temp_line[i_gsc], 91, 3)
	
	gsc[i_gsc - line_start].r_c = float(strmid(string_temp_line[i_gsc], 2, 6))
	gsc[i_gsc - line_start].GSC2_3 = strmid(string_temp_line[i_gsc], 10, 10)
	gsc[i_gsc - line_start].RAJ2000 = double(strmid(string_temp_line[i_gsc], 22, 10))
	gsc[i_gsc - line_start].DEJ2000 = double(strmid(string_temp_line[i_gsc], 34, 10))
	gsc[i_gsc - line_start].Epoch = float(strmid(string_temp_line[i_gsc], 46, 7))

	if strmid(string_temp_line[i_gsc], 56, 5) ne '     ' then gsc[i_gsc - line_start].Fmag = float(strmid(string_temp_line[i_gsc], 56, 5))
	if strmid(string_temp_line[i_gsc], 62, 5) ne '     ' then gsc[i_gsc - line_start].jmag = float(strmid(string_temp_line[i_gsc], 62, 5))
	if strmid(string_temp_line[i_gsc], 68, 5) ne '     ' then gsc[i_gsc - line_start].Vmag = float(strmid(string_temp_line[i_gsc], 68, 5))
	if strmid(string_temp_line[i_gsc], 74, 5) ne '     ' then gsc[i_gsc - line_start].Nmag = float(strmid(string_temp_line[i_gsc], 74, 5))
	if strmid(string_temp_line[i_gsc], 80, 1) ne ' ' then gsc[i_gsc - line_start].Class = fix(strmid(string_temp_line[i_gsc], 80, 1))
	if strmid(string_temp_line[i_gsc], 84, 4) ne '    ' then gsc[i_gsc - line_start].a = float(strmid(string_temp_line[i_gsc], 84, 4))
	if strmid(string_temp_line[i_gsc], 91, 3) ne '   ' then gsc[i_gsc - line_start].e = float(strmid(string_temp_line[i_gsc], 91, 3))
		


endfor

spawn, 'rm '+output_gsc_fits_name
mwrfits, gsc, output_gsc_fits_name


end
