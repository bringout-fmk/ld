/* 
 * This file is part of the bring.out FMK, a free and open source 
 * accounting software suite,
 * Copyright (c) 1996-2011 by bring.out doo Sarajevo.
 * It is licensed to you under the Common Public Attribution License
 * version 1.0, the full text of which (including FMK specific Exhibits)
 * is available in the file LICENSE_CPAL_bring.out_FMK.md located at the 
 * root directory of this source code archive.
 * By using this software, you agree to be bound by its terms.
 */


#include "ld.ch"


// ----------------------------------------
// funkcija za prijavu u obracun
// ----------------------------------------
function ParObracun()
local nX := 1
local nPadL := 20

if gAHonorar == "D"
	O_IZDANJA
endif

O_RJ
O_PARAMS

select rj

Box(, 4 +IF(lViseObr, 1, 0), 50)
	
	set cursor on
	
	@ m_x + nX, m_y + 2 SAY PADL( "Radna jedinica", nPadL ) GET gRJ ;
		valid P_Rj(@gRj) pict "@!"
	
	++nX

	@ m_x + nX, m_y + 2 SAY PADL( "Mjesec", nPadL ) GET gMjesec pict "99"
 	
	++nX
	
	@ m_x + nX, m_y + 2 SAY PADL( "Godina", nPadL ) GET gGodina pict "9999"
 	
	++nX

	@ m_x + nX, m_y + 2 SAY PADL( "Varijanta obracuna", nPadL ) GET gVarObracun

	if lViseObr
		
		++nX
   		
		@ m_x + nX, m_y + 2 SAY PADL( "Obracun", nPadL ) GET gObracun ;
			WHEN HelpObr(.f.,gObracun) VALID ValObr(.f.,gObracun)
	
	endif
 	
	read
 	
	clvbox()
	
BoxC()

if (LASTKEY()<>K_ESC)

	select params
 	
	Wpar("rj",@gRJ)
 	Wpar("mj",@gMjesec)
 	Wpar("go",@gGodina)
 	Wpar("ob",@gObracun)
 	Wpar("ov",@gVarObracun)
 	
	select params
	use

endif

if gZastitaObracuna=="D"
	IspisiStatusObracuna(gRj, gGodina, gMjesec)
endif

return



function IspisiStatusObracuna(cRj,nGodina,nMjesec)

if GetObrStatus(cRj,nGodina,nMjesec)$"ZX"
	cStatusObracuna:="Obracun zakljucen !!!    "
	cClr:="W/R"
endif

if GetObrStatus(cRj,nGodina,nMjesec)$"UP"
	cStatusObracuna:="Obracun otvoren          "
	cClr:="W/B"
endif

if GetObrStatus(cRj,nGodina,nMjesec)=="N"
	cStatusObracuna:="Nema otvorenog obracuna !"
	cClr:="W/R"
endif

@ 24,1 SAY cStatusObracuna COLOR cClr

return



