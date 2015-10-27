function dlg_fieldlinetrace_xy, b, StartPoint_XY, $
    direction = direction, $
    ds = _ds, $
    nS = nS, $
	FieldLine_XYZ = fieldLine_XYZ, $
	FieldLine_CYL = fieldLine_CYL, $
    B_FieldLine_XYZ = B_FieldLine_XYZ, $
    B_FieldLine_CYL = B_FieldLine_CYL, $
	perp = perp, $
	use_dlg_bField = use_dlg_bField, $
    analytic_b = analytic_b


	xStart	= StartPoint_XY[0]
	yStart	= StartPoint_XY[1]	
	zStart	= 0

    ; RK4 
	; ---

    c_XYZ = [xStart,yStart,zStart]
    b_XYZ = bHere_XYZ2 (b, c_XYZ)

    c_XYZ_array = c_XYZ

    b_XYZ_array = b_XYZ

    if keyword_set(nS) then stepCnt = nS else stepCnt = 10000
    if keyword_set(_ds) then _dS = _ds else _dS = 0.01
    if keyword_set(direction) then _TraceSign = direction else _TraceSign = 1

    dS = _TraceSign * _dS

    if keyword_set(analytic_b) then begin

        for s=0,stepCnt-1 do begin

            b_XYZ = transpose(get_b(c_XYZ[0],c_XYZ[1]))
            if perp then b_XYZ = cross([0,0,1],b_XYZ)
            bMag = mag(b_XYZ)

            K1  = dS * b_XYZ / bMag

            b_XYZ = transpose(get_b(c_XYZ[0]+K1[0]/2.0,c_XYZ[1]+K1[1]/2.0))
            if perp then b_XYZ = cross([0,0,1],b_XYZ)
            bMag = mag(b_XYZ)

            K2  = dS * b_XYZ / bMag

            b_XYZ = transpose(get_b(c_XYZ[0]+K2[0]/2.0,c_XYZ[1]+K2[1]/2.0))
            if perp then b_XYZ = cross([0,0,1],b_XYZ)
            bMag = mag(b_XYZ)

            K3  = dS * b_XYZ / bMag

            b_XYZ = transpose(get_b(c_XYZ[0]+K3[0],c_XYZ[1]+K3[1]))
            if perp then b_XYZ = cross([0,0,1],b_XYZ)
            bMag = mag(b_XYZ)

            K4  = dS * b_XYZ / bMag

            c_XYZ   = c_XYZ + ( K1 + 2 * K2 + 2 * K3 + K4 ) / 6.0
           
            b_XYZ = transpose(get_b(c_XYZ[0],c_XYZ[1]))
            if perp then b_XYZ = cross([0,0,1],b_XYZ)
            bMag = mag(b_XYZ)

            c_XYZ_array  = [ [c_XYZ_array],[c_XYZ] ]

            b_XYZ_array  = [ [b_XYZ_array],[b_XYZ] ]

	    endfor

 
    endif else begin
        for s=0,stepCnt-1 do begin

            b_XYZ  = bHere_XYZ2 ( b, c_XYZ, bMag=bMagTrace, Perp=perp )

            K1  = dS * b_XYZ / bMagTrace 

            b_XYZ  = bHere_XYZ2 ( b, c_XYZ + K1 / 2.0, bMag=bMagTrace, Perp=perp )

            K2  = dS * b_XYZ / bMagTrace 

            b_XYZ  = bHere_XYZ2 ( b, c_XYZ + K2 / 2.0, bMag=bMagTrace, Perp=perp )

            K3  = dS * b_XYZ / bMagTrace 

            b_XYZ  = bHere_XYZ2 ( b, c_XYZ + K3, bMag=bMagTrace, Perp=perp )

            K4  = dS * b_XYZ / bMagTrace 

            c_XYZ   = c_XYZ + ( K1 + 2 * K2 + 2 * K3 + K4 ) / 6.0
           
            b_XYZ   = bHere_XYZ2 ( b, c_XYZ, bMag=bMagTrace, Perp=perp )

            c_XYZ_array  = [ [c_XYZ_array],[c_XYZ] ]

            b_XYZ_array  = [ [b_XYZ_array],[b_XYZ] ]

	    endfor

    endelse

	FieldLine_XYZ= c_XYZ_array
    B_FieldLine_XYZ = b_XYZ_array

	return, FieldLine_XYZ

end