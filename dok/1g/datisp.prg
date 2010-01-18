#include "ld.ch" 

// -----------------------------------------
// unos datuma isplate plaæe
// -----------------------------------------
function unos_disp()
local dDatPr 
local dDat1
local dDat2
local dDat3
local dDat4
local dDat5
local dDat6
local dDat7
local dDat8
local dDat9
local dDat10
local dDat11
local dDat12
local nGod := YEAR(DATE())
local cObr := " "
local cRj := "  "
local nX := 1
local cOk := "D"

O_OBRACUNI

if obracuni->(FIELDPOS("DAT_ISPL")) == 0 .or. obracuni->(FIELDPOS("OBR")) == 0
	MsgBeep("Potrebna modifikacija struktura LD.CHS !!!#Prekidam operaciju")
	return
endif


Box(, 19, 65)
	
	@ m_x + nX, m_y + 2 SAY "*** Unos datuma isplata placa" COLOR "I"
	
	++nX
	++nX
	
	@ m_x + nX, m_y + 2 SAY "Tekuca godina:" GET nGod PICT "9999"
	
	@ m_x + nX, col() + 2 SAY "Radna jedinica:" GET cRJ PICT "99" ;
		VALID EMPTY(cRJ) .or. P_RJ(@cRJ)
	
	@ m_x + nX, col() + 2 SAY "Obracun:" GET cObr VALID cObr $ " 123456789"
	
	++nX
	
	@ m_x + nX, m_y + 2 SAY "----------------------------------------"  
	++nX

	read

	// uzmi parametre postojece
	// prethodna godina
	dDatPr := g_isp_date( cRj, nGod - 1, 12, cObr )
	// od mjeseca 1 do mjeseca 12 tekuce godine
	dDat1 := g_isp_date( cRj, nGod, 1, cObr )
	dDat2 := g_isp_date( cRj, nGod, 2, cObr )
	dDat3 := g_isp_date( cRj, nGod, 3, cObr )
	dDat4 := g_isp_date( cRj, nGod, 4, cObr )
	dDat5 := g_isp_date( cRj, nGod, 5, cObr )
	dDat6 := g_isp_date( cRj, nGod, 6, cObr )
	dDat7 := g_isp_date( cRj, nGod, 7, cObr )
	dDat8 := g_isp_date( cRj, nGod, 8, cObr )
	dDat9 := g_isp_date( cRj, nGod, 9, cObr )
	dDat10 := g_isp_date( cRj, nGod, 10, cObr )
	dDat11 := g_isp_date( cRj, nGod, 11, cObr )
	dDat12 := g_isp_date( cRj, nGod, 12, cObr )

	@ m_x + nX, m_y + 2 SAY " - 12." + ALLTRIM(STR(nGod-1)) + ;
		" => " GET dDatPr
	++nX
	
	@ m_x + nX, m_y + 2 SAY " - 01." + ALLTRIM(STR(nGod)) + ;
		" => " GET dDat1
	++nX
	
	@ m_x + nX, m_y + 2 SAY " - 02." + ALLTRIM(STR(nGod)) + ;
		" => " GET dDat2
	++nX
	
	@ m_x + nX, m_y + 2 SAY " - 03." + ALLTRIM(STR(nGod)) + ;
		" => " GET dDat3
	++nX
	
	@ m_x + nX, m_y + 2 SAY " - 04." + ALLTRIM(STR(nGod)) + ;
		" => " GET dDat4
	++nX
	
	@ m_x + nX, m_y + 2 SAY " - 05." + ALLTRIM(STR(nGod)) + ;
		" => " GET dDat5
	++nX
	
	@ m_x + nX, m_y + 2 SAY " - 06." + ALLTRIM(STR(nGod)) + ;
		" => " GET dDat6
	++nX
	
	@ m_x + nX, m_y + 2 SAY " - 07." + ALLTRIM(STR(nGod)) + ;
		" => " GET dDat7
	++nX
	
	@ m_x + nX, m_y + 2 SAY " - 08." + ALLTRIM(STR(nGod)) + ;
		" => " GET dDat8
	++nX
	
	@ m_x + nX, m_y + 2 SAY " - 09." + ALLTRIM(STR(nGod)) + ;
		" => " GET dDat9
	++nX
	
	@ m_x + nX, m_y + 2 SAY " - 10." + ALLTRIM(STR(nGod)) + ;
		" => " GET dDat10
	++nX
	
	@ m_x + nX, m_y + 2 SAY " - 11." + ALLTRIM(STR(nGod)) + ;
		" => " GET dDat11
	++nX
	
	@ m_x + nX, m_y + 2 SAY " - 12." + ALLTRIM(STR(nGod)) + ;
		" => " GET dDat12

	++nX
	++nX
	
	@ m_x + nX, m_y + 2 SAY "Unos ispravan (D/N)" GET cOk ;
		VALID cOK $ "DN" ;
		PICT "@!"

	read
BoxC()

if LastKey() <> K_ESC

	if cOk == "N"
		return
	endif
	
	nGodina := nGod

	// setuj promjene
	// prethodna godina
	s_isp_date( cRJ, nGodina - 1 , 12, cObr, dDatPr )
	// od 1 do 12 mjeseca tekuce
	s_isp_date( cRJ, nGodina, 1, cObr, dDat1 )
	s_isp_date( cRJ, nGodina, 2, cObr, dDat2 )
	s_isp_date( cRJ, nGodina, 3, cObr, dDat3 )
	s_isp_date( cRJ, nGodina, 4, cObr, dDat4 )
	s_isp_date( cRJ, nGodina, 5, cObr, dDat5 )
	s_isp_date( cRJ, nGodina, 6, cObr, dDat6 )
	s_isp_date( cRJ, nGodina, 7, cObr, dDat7 )
	s_isp_date( cRJ, nGodina, 8, cObr, dDat8 )
	s_isp_date( cRJ, nGodina, 9, cObr, dDat9 )
	s_isp_date( cRJ, nGodina, 10, cObr, dDat10 )
	s_isp_date( cRJ, nGodina, 11, cObr, dDat11 )
	s_isp_date( cRJ, nGodina, 12, cObr, dDat12 )

endif

return


// --------------------------------------------
// vraca tekuce isplate za godinu
// --------------------------------------------
function g_isp_date( cRj, nGod, nMjesec, cObr )
local dDate := CTOD("")
local nTArea := SELECT()
O_OBRACUNI

select obracuni
set order to tag "RJ"
go top

seek  cRJ + ALLTRIM(STR( nGod )) + FmtMjesec( nMjesec ) + "G" + cObr

if field->rj == cRj .and. ;
	field->mjesec = nMjesec .and. ;
	field->godina = nGod .and. ;
	field->obr == cObr .and. ;
	field->status == "G"

	dDate := field->dat_ispl

else
	dDate := CTOD("")
endif

select (nTArea)
return dDate


// ----------------------------------------
// setuje datum isplate za mjesec
// ----------------------------------------
static function s_isp_date( cRj, nGod, nMjesec, cObr, dDatIspl )
local nTArea := SELECT()

O_OBRACUNI

select obracuni
set order to tag "RJ"
go top
seek  cRJ + ALLTRIM(STR( nGod )) + FmtMjesec( nMjesec ) + "G" + cObr


if field->rj == cRj .and. ;
	field->mjesec = nMjesec .and. ;
	field->godina = nGod .and. ;
	field->obr == cObr .and. ;
	field->status == "G"
	
	replace dat_ispl with dDatIspl
else
	append blank
	replace rj with cRj
	replace godina with nGod
	replace mjesec with nMjesec
	replace obr with cObr
	replace status with "G"
	replace dat_ispl with dDatIspl
endif


select (nTArea)
return


