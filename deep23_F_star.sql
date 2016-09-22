--http://skyserver.sdss.org/dr12/en/tools/search/sql.aspx

select 
p.ra, p.dec, p.dered_u, p.dered_g, p.dered_r, p.dered_i, p.dered_z,
p.extinction_u,p.extinction_g,p.extinction_r,p.extinction_i,p.extinction_z,
p.objid,p.psfMag_u, p.psfMag_g, p.psfMag_r, p.psfMag_i, 
p.psfMag_z, p.type, p.PROBPSF_R

from PhotoObj as p
where
p.psfMag_g < 18 
-- AND p.secTarget&34 > 0

and
p.psfMag_u - p.psfMag_g >=  0.9 and p.psfMag_u - p.psfMag_g <= 1.4 and
p.psfMag_g - p.psfMag_r >=  0.1 and p.psfMag_g - p.psfMag_r <= 0.5 and
p.psfMag_r - p.psfMag_i >= -0.1 and p.psfMag_r - p.psfMag_i <= 0.3

and p.ra  between 352. and 353
and p.dec between -0.2 and 0.5

