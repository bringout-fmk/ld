#include "ld.ch"

EXTERNAL DESCEND
EXTERNAL RIGHT

/*! \fn Main(cKorisn,cSifra,p3,p4,p5,p6,p7)
 *  \brief
 */

function Main(cKorisn,cSifra,p3,p4,p5,p6,p7)
*{
	MainLD(cKorisn,cSifra,p3,p4,p5,p6,p7)
return
*}


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


