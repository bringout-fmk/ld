#include "ld.ch"


// --------------------------------------------------
// funkcija exporta podataka poreskih kartica
// --------------------------------------------------
function pk_export()
local nCnt := 0
local cFExp := ""
local aErrors := {}
local cSep := "#"

O_RADN
o_pk_tbl()

if _g_params( @cFExp ) == 0
	return
endif

cFExp := ALLTRIM( cFExp )

// sql export
pk_sql_export( cFExp )


return


// ----------------------------------------
// parametri exporta
// ----------------------------------------
static function _g_params( cFile )
local GetList := {}
local nX := 1

cFile := PADR("c:\test\", 200)

Box(,5,65)

	@ m_x + nX, m_y + 2 SAY "Lokacija:" GET cFile ;
		VALID !EMPTY(cFile) ;
		PICT "@S40"

	read
BoxC()

if LastKey() == K_ESC
	return 0
endif

return 1



