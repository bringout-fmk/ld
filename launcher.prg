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

EXTERNAL DESCEND
EXTERNAL RIGHT

/*! \fn Main(cKorisn,cSifra,p3,p4,p5,p6,p7)
 *  \brief
 */

function Main(cKorisn,cSifra,p3,p4,p5,p6,p7)

	// set language
	//REQUEST HB_CODEPAGE_PLISO

	//hb_setcodepage("PLISO")
	//hb_settermcp("PLISO",.t.)

	MainLD(cKorisn,cSifra,p3,p4,p5,p6,p7)
return


function TFileRead()
return


/*! \fn MainLD(cKorisn,cSifra,p3,p4,p5,p6,p7)
 *  \brief
 */

function MainLD(cKorisn,cSifra,p3,p4,p5,p6,p7)
*{
local oLD
local cModul

cModul:="LD"
PUBLIC goModul

oLd:=TLdMod():new(NIL, cModul, D_LD_VERZIJA, D_LD_PERIOD , cKorisn, cSifra, p3,p4,p5,p6,p7)
goModul:=oLd

oLd:run()

return 


