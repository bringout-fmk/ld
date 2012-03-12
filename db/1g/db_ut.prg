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


// -----------------------------------------
// provjera podataka za migraciju f18
// -----------------------------------------
function f18_test_data()
local _a_sif := {}
local _a_data := {}
local _a_ctrl := {} 
local _chk_sif := .f.

if Pitanje(, "Provjera sifrarnika (D/N) ?", "N") == "D"
	_chk_sif := .t.
endif

// provjeri sifrarnik
if _chk_sif == .t.
	f18_sif_data( @_a_sif, @_a_ctrl )
endif

// provjeri ld podatke
f18_ld_data( @_a_data, @_a_ctrl )

// prikazi rezultat testa
f18_rezultat( _a_ctrl, _a_data, _a_sif )

return



// -----------------------------------------
// provjera ld, radn
// -----------------------------------------
static function f18_ld_data( data, checksum )
local _n_c_iznos := 0
local _n_c_stavke := 0
local _stavka, _firma, _mjesec, _radnik, _godina
local _scan, _chk_radn

O_LD

select ld
set order to tag "1"
go top

Box(, 2, 60 )

do while !EOF()
	
	_firma := field->idfirma
	_mjesec := field->mjesec
	_godina := field->godina
	_radnik := field->idradn
	_stavka := _firma + ", " + _godina + ", " + ;
		_mjesec + ", " + _radnik

	if EMPTY( _godina )
		skip
		loop
	endif

	@ m_x + 1, m_y + 2 SAY "stavka: " + _stavka

	// kontrolni broj
	++ _n_c_stavke
	_n_c_iznos += ( field->uneto + field->i01 )

enddo

BoxC()

if _n_c_stavke > 0
	AADD( checksum, { "ld data", _n_c_stavke, _n_c_iznos } )
endif

return
 

