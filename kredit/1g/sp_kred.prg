#include "ld.ch"

// -------------------------------------------------
// specifikacija kredita po kreditorima
// -------------------------------------------------
function sp_kredita()
local nMjesec
local nGodina
local cIdRj
local cObr
local cIdRadnik
local cTpKr

// uslovi izvjestaja
if _getVars( @nMjesec, @nGodina, @cIdRj, @cObr, ;
	@cIdRadnik, @cTpKr ) == .f.
	
	return

endif


return


// setovanje varijabli za izvjestaj
static function _getVars( nMj, nGod, cRj, cObr, cIdRadn, cTpKr )
local lRet := .t.
local nX := 1

cTpKr := "30"
nMj := gMjesec
nGod := gGodina
cRj := SPACE(50)
cObr := " "
cIdRadn := SPACE(6)

Box(,6, 60)

	@ m_x + nX, m_y + 2 SAY "Za period:" GET nMj
	@ m_x + nX, col() + 1 SAY "/" GET nGod

	++ nX

	@ m_x + nX, m_y + 2 SAY "Za period:" GET nMj

	read
BoxC()

if LastKey() == K_ESC
	lRet := .f.
endif

return lRet


