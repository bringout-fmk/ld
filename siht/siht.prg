#include "ld.ch"


// -----------------------------------------------
// definisanje sihtarice
// -----------------------------------------------
function def_siht( lNew )
local nBoxX := 10
local nBoxY := 65
local nX := 1
local cIdRadn := SPACE(6)
local nGodina := gGodina
local nMjesec := gMjesec
local cGroup := SPACE(7)
local cOpis := SPACE(50)

O_RADSIHT
select radsiht
set order to tag "2"

Box(, nBoxX, nBoxY )
	
   do while .t.

	@ m_x + nX, m_y + 2 SAY "*** Unos / obrada sihtarica po grupama"
	
	++ nX
	++ nX

	@ m_x + nX, m_y + 2 SAY "godina" GET nGodina PICT "9999"
	@ m_x + nX, col() + 2 SAY "mjesec" GET nMjesec PICT "99"

	++ nX
	
	@ m_x + nX, m_y + 2 SAY "grupa:" GET cGroup ;
		VALID { || p_konto( @cGroup ), ;
			show_it( g_gr_naz( cGroup ), 40 ) }

	++ nX

	@ m_x + nX, m_y + 2 SAY "opis:" GET cOpis PICT "@S40"

	++ nX
	
	@ m_x + nX, m_y + 2 SAY "radnik:" GET cIdRadn ;
		VALID { || p_radn( @cIdRadn ), ;
			show_it( _rad_ime( cIdRadn), 30 )}

	read

	if LastKey() == K_ESC
		exit
	endif

	// pronadji ovaj zapis u RADSIHT
	select radsiht
	go top
	seek cGroup + STR(nGodina) + STR(nMjesec) + cIdRadn

	if !FOUND()
		append blank
		scatter()
		_godina := nGodina
		_mjesec := nMjesec
		_idkonto := cGroup
		_opis := cOpis
		_idradn := cIdRadn
		_dandio := "G"
		_izvrseno := 0
	else
		scatter()
	endif

	++ nX
	++ nX

	@ m_x + nX, m_y + 2 SAY "broj odradjenih sati:" GET _izvrseno ;
		PICT "99999.99"
	
	read

	if LastKey() == K_ESC
		exit
	endif
	
	gather()

	// resetuj varijable
	cIdRadn := SPACE(6)


	nX := 1

   enddo
	
BoxC()

return


// ---------------------------------------------------
// uslovi izvjestaja
// ---------------------------------------------------
static function g_vars( nGod, nMj, cRadn, cGroup )
local nRet := 1
private GetList := {}

Box(, 2, 60)
	@ m_x + 1, m_y + 2 SAY "Godina" GET nGod PICT "9999"
	@ m_x + 1, col() + 2 SAY "Godina" GET nMj PICT "99"
	@ m_x + 2, m_y + 2 SAY "Grupa" GET cGroup ;
		VALID EMPTY(cGroup) .or. p_konto(@cGroup)
	@ m_x + 2, col() + 2 SAY "Radnik" GET cRadn ;
		VALID EMPTY(cRadn) .or. p_radn(@cRadn)
	read
BoxC()

if LastKey() == K_ESC
	nRet := 0
endif

return nRet



// --------------------------------------------
// daj mi obradjene sihtarice
// 
// lInfo - za prikaz na kartici .t.
// vraca ukupne sate radnika
// --------------------------------------------
function get_siht( lInfo, nGodina, nMjesec, cIdRadn, cGroup )
local nTArea := SELECT()
local cFilter := ""
local nLineLen := 70

if pcount() <= 1
	
	// nema parametara unesenih
	nMjesec := gMjesec
	nGodina := gGodina
	cGroup := SPACE(7)
	cIdRadn := SPACE(6)

	if g_vars( @nGodina, @nMjesec, @cIdRadn, @cGroup ) == 0
		return
	endif

endif

if pcount() == 0
	lInfo := .f.
endif

if !EMPTY( cIdRadn )
	nLineLen := 50
endif
altd()
sort_siht( nGodina, nMjesec, cIdRadn, cGroup )
set order to tag "2"
go top

if lInfo == .f.
	START PRINT CRET
	?
endif

? "Lista satnica po sihtarici: ", STR(nMjesec) + "/" + STR(nGodina) 
? REPLICATE( "-", nLineLen )
? PADR("rbr", 4), ;
	PADR("objekat", 30), ;
	if(EMPTY(cIdRadn), PADR("radnik", 20), ""), ;
	PADR("sati", 15)

? REPLICATE( "-", nLineLen )

nT_sati := 0
nCnt := 0
do while !EOF()

	? PADL( ALLTRIM(STR(++nCnt)) + ".", 4 ), ;
	  PADR( g_gr_naz( field->idkonto ), 30 ), ;
	  if(EMPTY(cIdRadn), PADR( _rad_ime( field->idradn ), 20 ), "" ), ;
	  STR( field->izvrseno, 12, 2 )

	nT_sati += field->izvrseno

	skip
enddo

? REPLICATE("-", nLineLen )
? PADL( "UKUPNO SATI: " + STR(nT_sati, 12, 2), nLineLen )
? REPLICATE("-", nLineLen )

if lInfo == .f.
	FF
	END PRINT
endif

go top
set filter to

select (nTArea)
return nT_sati



// --------------------------------------------
// lista sihtarice
// 
// --------------------------------------------
function get_siht2()
local nTArea := SELECT()
local cFilter := ""
local nLineLen := 43
local nMjesec
local nGodina
local cGroup
local cIdRadn
local nCol := 12

// nema parametara unesenih
nMjesec := gMjesec
nGodina := gGodina
cGroup := SPACE(7)
cIdRadn := SPACE(6)

if g_vars( @nGodina, @nMjesec, @cIdRadn, @cGroup ) == 0
	return
endif

sort_siht( nGodina, nMjesec, cIdRadn, cGroup )
set order to tag "4"
// "4","idradn+str(godina)+str(mjesec)+idkonto"
go top

START PRINT CRET
?

? "Lista satnica po sihtarici: ", STR(nMjesec) + "/" + STR(nGodina) 
? REPLICATE( "-", nLineLen )
? PADR("rbr", 5), PADR("radnik", 20), PADR("sati", 15)
? REPLICATE( "-", nLineLen )

nT_sati := 0
nT_tsati := 0
nCnt := 0

// zavrti se po radnicima...
do while !EOF()

  cId_radn := field->idradn
  nT_sati := 0

  do while !EOF() .and. field->idradn == cId_radn

    nT_sati += field->izvrseno
    nT_tsati += field->izvrseno

    skip
  
  enddo

  // ispisi ukupno
  ? PADL( ALLTRIM( STR( ++nCnt, 4 )) + ".", 5 )
  @ prow(), pcol()+1 SAY PADR( _rad_ime( cId_radn ), 20 )
  @ prow(), nCol := pcol()+1 SAY STR(nT_sati, 12, 2)

enddo

? REPLICATE("-", nLineLen )
? "UKUPNO SATI: "
@ prow(), nCol SAY STR( nT_tsati, 12, 2 )
? REPLICATE("-", nLineLen )

FF
END PRINT

go top
set filter to

select (nTArea)
return


// ------------------------------------------------------------
// sortiranje sihtarice
// ------------------------------------------------------------
function sort_siht( nGodina, nMjesec, cIdRadn, cGroup )
local cFilter

cFilter := "godina =" + STR( nGodina )  
cFilter += " .and. mjesec = " + STR( nMjesec )
cFilter += " .and. dandio == 'G' "

if !EMPTY( cIdRadn )
	cFilter += " .and. idradn == " + cm2str( cIdRadn )
endif

if !EMPTY( cGroup )
	cFilter += " .and. idkonto == " + cm2str( cGroup )
endif

O_RADSIHT
select radsiht
set filter to &cFilter
go top

return


// ------------------------------------------
// brisanje sihtarice
// ------------------------------------------
function del_siht()
local nMjesec := gMjesec
local nGodina := gGodina
local cGroup := SPACE(7)
local cIdRadn := SPACE(6)
local nTArea := SELECT()
local cFilter := ""

if g_vars( @nGodina, @nMjesec, @cIdRadn, @cGroup ) == 0
	return
endif

sort_siht( nGodina, nMjesec, cIdRadn, cGroup )

if Pitanje(,"Pobrisati zapise sa ovim kriterijem (D/N)","N") == "N"
	return
endif

set order to tag "2"
go top

nCnt := 0
do while !EOF()
	++ nCnt
	delete
	skip
enddo

go top
set filter to

msgbeep("pobrisao " + ALLTRIM(STR(nCnt)) + " zapisa..." )

return



// ------------------------------------------------
// prikazuje cItem u istom redu gdje je get
// cItem - string za prikazati
// nPadR - n vrijednost pad-a
// ------------------------------------------------
function show_it(cItem, nPadR)

if nPadR <> nil
	cItem := PADR( cItem, nPadR )
endif

@ row(), col() + 3 SAY cItem

return .t.


// ------------------------------------------------
// vraca ime i prezime radnika
// ------------------------------------------------
function _rad_ime( cId, lImeOca )
local xRet := ""
local nTArea := SELECT()

if lImeOca == nil
	lImeOca := .f.
endif

O_RADN
seek cId

xRet := ALLTRIM( field->ime )
xRet += " "
if lImeOca == .t.
	xRet += "(" + ALLTRIM( field->imerod ) + ") "
endif
xRet += ALLTRIM( field->naz )

select (nTArea)
return xRet




