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


// --------------------------------------------------
// funkcija exporta podataka poreskih kartica
// --------------------------------------------------
function pk_export()
local nCnt := 0
local cFExp := ""
local cEmptyDb := "D"
local lEmpty := .f.
local aErrors := {}
local cSep := "#"
local cConvert := "8"

O_RADN
o_pk_tbl()

if _g_params( @cFExp, @cEmptyDb, @cConvert ) == 0
	return
endif

cFExp := ALLTRIM( cFExp )

if cEmptyDb == "D"
	lEmpty := .t.
endif

// sql export
pk_sql_export( cFExp, lEmpty, cConvert )


return


// ----------------------------------------
// parametri exporta
// ----------------------------------------
static function _g_params( cFile, cEmptyDb, cConvert )
local GetList := {}
local nX := 1

cFile := PADR("c:\sigma\ruby\", 200)

Box(,5,65)

	@ m_x + nX, m_y + 2 SAY "Lokacija:" GET cFile ;
		VALID !EMPTY(cFile) ;
		PICT "@S40"

	++ nX

	@ m_x + nX, m_y + 2 SAY "Prvo isprazni database (D/N)?" GET cEmptyDb ;
		VALID cEmptyDb $ "DN" ;
		PICT "@!"
	++ nX

	@ m_x + nX, m_y + 2 SAY "Konverzija znakova:" GET cConvert ;
		VALID cConvert $ "012345678"

	read
BoxC()

if LastKey() == K_ESC
	return 0
endif

return 1



