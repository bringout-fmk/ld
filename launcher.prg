#include "ld.ch"

EXTERNAL RIGHT
EXTERNAL LEFT
EXTERNAL FIELDPOS

#ifdef LIB

/*! \fn Main(cKorisn,cSifra,p3,p4,p5,p6,p7)
 *  \brief
 */

function Main(cKorisn,cSifra,p3,p4,p5,p6,p7)
*{
	MainLD(cKorisn,cSifra,p3,p4,p5,p6,p7)
return
*}

#endif


function TFileRead()
return


/*! \fn MainLD(cKorisn,cSifra,p3,p4,p5,p6,p7)
 *  \brief
 */

function MainLD(cKorisn,cSifra,p3,p4,p5,p6,p7)
*{
local oLD
local cModul

oLD:=TLDModNew()
cModul:="LD"

PUBLIC goModul

goModul:=oLD
oLD:init(NIL, cModul, D_LD_VERZIJA, D_LD_PERIOD , cKorisn, cSifra, p3,p4,p5,p6,p7)

oLD:run()

return 


