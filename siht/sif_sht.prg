#include "ld.ch"


// -----------------------------------------------
// grupe objekata ili slicno, sifrarnik
// -----------------------------------------------
function p_sgroup( cId, dx, dy )
local nArr
nArr:=SELECT()
private imekol := {}
private kol := {}

select (F_NORSIHT)
if (!used())
	O_NORSIHT
endif

// struktura sifrarnika
AADD(ImeKol,{ "id", {|| id}, "id", {|| .t. },{|| .t.}  })
AADD(ImeKol, { "naziv" , {|| naz} , "naz" } )
AADD(ImeKol, { "n1" , {|| n1} , "n1" } )
AADD(ImeKol, { "k1" , {|| k2} , "k2" } )
AADD(ImeKol, { "k2" , {|| k2} , "k2" } )

for i := 1 to LEN( ImeKol )
	AADD( kol, i )
next

select (nArr)

return PostojiSifra(F_NORSIHT, 1, 10, 70, Lokal("Grupe"), ;
	@cId, dx, dy)



// ------------------------------------
// pozicionira se na grupu 
// ------------------------------------
function gr_pos( cId )
local nTArea := SELECT()
local lRet := .f.

O_NORSIHT
select norsiht
seek cId

if FOUND()
	lRet := .t.
endif

select (nTArea)
return lRet


// -------------------------------------------
// vraca naziv grupe
// -------------------------------------------
function g_sg_naz( cId )
local xRet := ""

if gr_pos( cId )
	xRet := ALLTRIM( norsiht->naz )
endif

return xRet




