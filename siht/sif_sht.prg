#include "ld.ch"



// ------------------------------------
// pozicionira se na grupu 
// ------------------------------------
function gr_pos( cId )
local nTArea := SELECT()
local lRet := .f.

O_KONTO
select konto
seek cId

if FOUND()
	lRet := .t.
endif

select (nTArea)
return lRet


// -------------------------------------------
// vraca naziv grupe
// -------------------------------------------
function g_gr_naz( cId )
local xRet := ""

if gr_pos( cId )
	xRet := ALLTRIM( konto->naz )
endif

return xRet




