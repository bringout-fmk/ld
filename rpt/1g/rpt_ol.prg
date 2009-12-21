#include "ld.ch"


static __mj_od
static __mj_do
static __god_od
static __god_do
static __xml := 0

// ---------------------------------------
// otvara potrebne tabele
// ---------------------------------------
function ol_o_tbl()

O_OBRACUNI
O_PAROBR
O_PARAMS
O_RJ
O_RADN
O_KBENEF
O_VPOSLA
O_TIPPR
O_KRED
O_DOPR
O_POR
O_LD

return

// ---------------------------------------------------------
// sortiranje tabele LD
// ---------------------------------------------------------
function ol_sort(cRj, cGod_od, cGod_do, cMj_od, cMj_do, ;
			cRadnik, cTipRpt, cObr )
local cFilter := ""

private cObracun := cObr

if lViseObr
	if !EMPTY(cObr)
		cFilter += "obr == " + cm2str(cObr)
	endif
endif

if !EMPTY(cRj)
	
	if !EMPTY(cFilter)
		cFilter += " .and. "
	endif
	
	cFilter += Parsiraj(cRj,"IDRJ")
endif

if !EMPTY(cFilter)
	set filter to &cFilter
	go top
endif

if EMPTY(cRadnik) 
	if cTipRpt $ "1#2"
		INDEX ON SortPrez(idradn)+str(godina)+str(mjesec)+idrj TO "TMPLD"
	   	go top
	else
		INDEX ON str(godina)+str(mjesec)+SortPrez(idradn)+idrj TO "TMPLD"
		go top
		seek str(cGod_od,4)+str(cMj_od,2)+cRadnik
	endif
else
	set order to tag (TagVO("2"))
	go top
	seek str(cGod_od,4)+str(cMj_od,2)+cRadnik
endif

return


// ---------------------------------------------
// upisivanje podatka u pomocnu tabelu za rpt
// ---------------------------------------------
static function _ins_tbl( cRadnik, cNazIspl, dDatIsplate, nMjesec, ;
		nGodina, nPrihod, ;
		nPrihOst, nBruto, nDop_u_st, nDopPio, ;
		nDopZdr, nDopNez, nDop_uk, nNeto, nKLO, ;
		nLOdb, nOsn_por, nIzn_por, nUk, nUSati, nIzn1, nIzn2, ;
		nIzn3, nIzn4, nIzn5 )

local nTArea := SELECT()

O_R_EXP
select r_export
append blank

replace idradn with cRadnik
replace naziv with cNazIspl
replace mjesec with nMjesec
replace mj_opis with NazMjeseca( nMjesec, nGodina, .t. )
replace godina with nGodina
replace datispl with dDatIsplate
replace prihod with nPrihod
replace prihost with nPrihOst
replace bruto with nBruto
replace dop_u_st with nDop_u_st
replace dop_pio with nDopPio
replace dop_zdr with nDopZdr
replace dop_nez with nDopNez
replace dop_uk with nDop_uk
replace neto with nNeto
replace klo with nKlo
replace l_odb with nLOdb
replace osn_por with nOsn_Por
replace izn_por with nIzn_Por
replace ukupno with nUk
replace sati with nUSati

if nIzn1 <> nil
	replace tp_1 with nIzn1
endif
if nIzn2 <> nil
	replace tp_2 with nIzn2
endif
if nIzn3 <> nil
	replace tp_3 with nIzn3
endif
if nIzn4 <> nil
	replace tp_4 with nIzn4
endif
if nIzn5 <> nil
	replace tp_5 with nIzn5
endif


select (nTArea)
return



// ---------------------------------------------
// kreiranje pomocne tabele
// ---------------------------------------------
function ol_tmp_tbl()
local aDbf := {}

AADD(aDbf,{ "IDRADN", "C", 6, 0 })
AADD(aDbf,{ "NAZIV", "C", 15, 0 })
AADD(aDbf,{ "DATISPL", "D", 8, 0 })
AADD(aDbf,{ "MJESEC", "N", 2, 0 })
AADD(aDbf,{ "MJ_OPIS", "C", 15, 0 })
AADD(aDbf,{ "GODINA", "N", 4, 0 })
AADD(aDbf,{ "PRIHOD", "N", 12, 2 })
AADD(aDbf,{ "PRIHOST", "N", 12, 2 })
AADD(aDbf,{ "BRUTO", "N", 12, 2 })
AADD(aDbf,{ "DOP_U_ST", "N", 12, 2 })
AADD(aDbf,{ "DOP_PIO", "N", 12, 2 })
AADD(aDbf,{ "DOP_ZDR", "N", 12, 2 })
AADD(aDbf,{ "DOP_NEZ", "N", 12, 2 })
AADD(aDbf,{ "DOP_UK", "N", 12, 2 })
AADD(aDbf,{ "NETO", "N", 12, 2 })
AADD(aDbf,{ "KLO", "N", 5, 2 })
AADD(aDbf,{ "L_ODB", "N", 12, 2 })
AADD(aDbf,{ "OSN_POR", "N", 12, 2 })
AADD(aDbf,{ "IZN_POR", "N", 12, 2 })
AADD(aDbf,{ "UKUPNO", "N", 12, 2 })
AADD(aDbf,{ "SATI", "N", 12, 2 })
AADD(aDbf,{ "TP_1", "N", 12, 2 })
AADD(aDbf,{ "TP_2", "N", 12, 2 })
AADD(aDbf,{ "TP_3", "N", 12, 2 })
AADD(aDbf,{ "TP_4", "N", 12, 2 })
AADD(aDbf,{ "TP_5", "N", 12, 2 })

t_exp_create( aDbf )

O_R_EXP
// index on ......
index on idradn + STR(godina,4) + STR(mjesec,2) tag "1"

return


// ------------------------------------------
// obracunski list radnika
// ------------------------------------------
function r_obr_list()
local nC1:=20
local i
local cTPNaz
local nKrug:=1
local cRj := SPACE(60)
local cRadnik := SPACE(_LR_) 
local cPrimDobra := SPACE(100)
local cIdRj
local cMj_od
local cMj_do
local cGod_od
local cGod_do
local cDopr10 := "10"
local cDopr11 := "11"
local cDopr12 := "12"
local cDopr1X := "1X"
local cTipRpt := "1"
local cObracun := gObracun
local cWinPrint := "N"

// kreiraj pomocnu tabelu
ol_tmp_tbl()

cIdRj := gRj
cMj_od := gMjesec
cMj_do := gMjesec
cGod_od := gGodina
cGod_do := gGodina

cPredNaz := SPACE(50)
cPredAdr := SPACE(50)
cPredJMB := SPACE(13)

// otvori tabele
ol_o_tbl()

select params

private cSection:="4"
private cHistory:=" "
private aHistory:={}

RPar("i1",@cPredNaz)
RPar("i2",@cPredAdr)  

cPredJMB := IzFmkIni("Specif","MatBr","--",KUMPATH)
cPredJMB := PADR(cPredJMB, 13)

Box("#OBRACUNSKI LISTOVI RADNIKA", 15, 75)

@ m_x + 1, m_y + 2 SAY "Radne jedinice: " GET cRj PICT "@!S25"
@ m_x + 2, m_y + 2 SAY "Period od:" GET cMj_od pict "99"
@ m_x + 2, col() + 1 SAY "/" GET cGod_od pict "9999"
@ m_x + 2, col() + 1 SAY "do:" GET cMj_do pict "99" 
@ m_x + 2, col() + 1 SAY "/" GET cGod_do pict "9999"

if lViseObr
  	@ m_x+2,col()+2 SAY "Obracun:" GET cObracun WHEN HelpObr(.t.,cObracun) VALID ValObr(.t.,cObracun)
endif

@ m_x + 4, m_y + 2 SAY "Radnik (prazno-svi radnici): " GET cRadnik ;
	VALID EMPTY(cRadnik) .or. P_RADN(@cRadnik)
@ m_x + 5, m_y + 2 SAY "Isplate u usl. ili dobrima: " GET cPrimDobra pict "@S30"
@ m_x + 7, m_y + 2 SAY "   Doprinos iz pio: " GET cDopr10 
@ m_x + 8, m_y + 2 SAY "   Doprinos iz zdr: " GET cDopr11
@ m_x + 9, m_y + 2 SAY "   Doprinos iz nez: " GET cDopr12
@ m_x + 10, m_y + 2 SAY "Doprinos iz ukupni: " GET cDopr1X

@ m_x + 12, m_y + 2 SAY "Naziv preduzeca: " GET cPredNaz pict "@S30"
@ m_x + 12, col()+1 SAY "JID: " GET cPredJMB
@ m_x + 13, m_y + 2 SAY "Adresa: " GET cPredAdr pict "@S30"

@ m_x + 15, m_y + 2 SAY "(1) OLP-1021 / (2) GIP-1022: " GET cTipRpt ;
	VALID cTipRpt $ "12" 

@ m_x + 15, col() + 2 SAY "win stampa (D/N)?" GET cWinPrint ;
	VALID cWinPrint $ "DN" PICT "@!" 

read
	
clvbox()
	
ESC_BCR

BoxC()

if lastkey() == K_ESC
	return
endif

// staticke
__mj_od := cMj_od
__mj_do := cMj_do
__god_od := cGod_od
__god_do := cGod_do

if cWinPrint == "D"
	__xml := 1
else
	__xml := 0
endif

// upisi vrijednosti
select params
WPar("i1", cPredNaz)
WPar("i2", cPredAdr)  

select ld

// sortiraj tabelu i postavi filter
ol_sort( cRj, cGod_od, cGod_do, cMj_od, cMj_do, cRadnik, cTipRpt, cObracun )

// nafiluj podatke obracuna
ol_fill_data( cRj, cGod_od, cGod_do, cMj_od, cMj_do, cRadnik, cPrimDobra, ;
	cDopr10, cDopr11, cDopr12, cDopr1X, cTipRpt, cObracun )

// stampa izvjestaja xml/oo3
_xml_print( cTipRpt )

if __xml == 1
	return
endif

// printaj obracunski list
if cTipRpt == "1"
	olp_print( cMj_od, cMj_do )
else
	gip_print( )
endif

return


// ----------------------------------------
// stampa xml-a
// ----------------------------------------
static function _xml_print( cTip )
local cOdtName := ""
local cOutput := "c:\ld_out.odt"

if __xml == 0
	return
endif

// napuni xml fajl
_fill_xml()

do case
	case cTip == "1"
		cOdtName := "ld_olp.odt"
	case cTip == "2"
		cOdtName := "ld_gip.odt"
endcase

save screen to cScreen

clear screen

cJODRep := ALLTRIM( gJODRep )

// stampanje labele
cCmdLine := "java -jar " + cJODRep + " " + ;
	"c:\" + cOdtName + " c:\data.xml " + cOutput

run &cCmdLine

clear screen

cOOStart := '"' + ALLTRIM( gOOPath ) + ALLTRIM( gOOWriter ) + '"'
cOOParam := ""

// otvori naljepnicu
cCmdLine := "start " + cOOStart + " " + cOOParam + " " + cOutput

run &cCmdLine

restore screen from cScreen

return



// --------------------------------------------
// filuje xml fajl sa podacima izvjestaja
// --------------------------------------------
static function _fill_xml()
local nTArea := SELECT()
local nT_prih := 0
local nT_pros := 0
local nT_bruto := 0
local nT_neto := 0
local nT_poro := 0
local nT_pori := 0
local nT_dop_s := 0
local nT_dop_u := 0
local nT_d_zdr := 0
local nT_d_pio := 0
local nT_d_nez := 0
local nT_klo := 0
local nT_lodb := 0

// otvori xml za upis
open_xml("c:\data.xml")
// upisi header
xml_head()

xml_subnode("rpt", .f.)

// naziv firme
xml_node( "p_naz", strkzn( ALLTRIM(cPredNaz), "8", "U" ) )
xml_node( "p_adr", strkzn( ALLTRIM(cPredAdr), "8", "U" ) )
xml_node( "p_jmb", ALLTRIM(cPredJmb) )
xml_node( "p_per", g_por_per() )

select r_export
set order to tag "1"
go top

do while !EOF()
	
	// po radniku
	cT_radnik := field->idradn
	
	// pronadji radnika u sifrarniku
	select radn
	seek cT_radnik

	select r_export

	xml_subnode("radnik", .f.)

	xml_node("ime", strkzn( ALLTRIM(radn->ime) + ;
		" (" + ALLTRIM(radn->imerod) + ;
		") " + ALLTRIM(radn->naz), "8", "U" ) )

	xml_node("mb", ALLTRIM(radn->matbr) )
	
	xml_node("adr", strkzn( ALLTRIM(radn->streetname) + ;
		" " + ALLTRIM(radn->streetnum), "8", "U" ) )

	nT_prih := 0
	nT_pros := 0
	nT_bruto := 0
	nT_neto := 0
	nT_poro := 0
	nT_pori := 0
	nT_dop_s := 0
	nT_dop_u := 0
	nT_d_zdr := 0
	nT_d_pio := 0
	nT_d_nez := 0
	nT_klo := 0
	nT_lodb := 0
		
	nCnt := 0

	do while !EOF() .and. field->idradn == cT_radnik
		
		xml_subnode("obracun", .f.)

		xml_node("rbr", STR( ++nCnt ) )
		xml_node("pl_opis", strkzn( ALLTRIM( field->mj_opis ), ;
			"8", "U" ) )
		xml_node("mjesec", STR( field->mjesec ) )
		xml_node("godina", STR( field->godina ) )
		xml_node("prihod", STR( field->prihod, 12, 2 ) )
		xml_node("prih_o", STR( field->prihost, 12, 2 ) )
		xml_node("bruto", STR( field->bruto, 12, 2 ) )
		xml_node("do_us", STR( field->dop_u_st, 12, 2 ) )
		xml_node("do_uk", STR( field->dop_uk, 12, 2 ) )
		xml_node("do_pio", STR( field->dop_pio, 12, 2 ) )
		xml_node("do_zdr", STR( field->dop_zdr, 12, 2 ) )
		xml_node("do_nez", STR( field->dop_nez, 12, 2 ) )
		xml_node("neto", STR( field->neto, 12, 2 ) )
		xml_node("klo", STR( field->klo, 12, 2 ) )
		xml_node("l_odb", STR( field->l_odb, 12, 2 ) )
		xml_node("p_osn", STR( field->osn_por, 12, 2 ) )
		xml_node("p_izn", STR( field->izn_por, 12, 2 ) )
		xml_node("uk", STR( field->ukupno, 12, 2 ) )
		xml_node("d_isp", DTOC( field->datispl ) )
		xml_node("opis", strkzn( ALLTRIM( field->naziv ), "8", "U") )

		xml_subnode("obracun", .t.)
		
		nT_prih += field->prihod
		nT_pros += field->prihost
		nT_bruto += field->bruto
		nT_neto += field->neto
		nT_poro += field->osn_por
		nT_pori += field->izn_por
		nT_dop_s += field->dop_u_st
		nT_dop_u += field->dop_uk
		nT_d_zdr += field->dop_zdr
		nT_d_pio += field->dop_pio
		nT_d_nez += field->dop_nez
		nT_klo += field->klo
		nT_lodb += field->l_odb

		skip
	enddo

	// upisi totale za radnika
	xml_subnode("total", .f.)

	xml_node("prihod", STR( nT_prih, 12, 2 ) )
	xml_node("prih_o", STR( nT_pros, 12, 2 ) )
	xml_node("bruto", STR( nT_bruto, 12, 2 ) )
	xml_node("neto", STR( nT_neto, 12, 2 ) )
	xml_node("p_izn", STR( nT_pori, 12, 2 ) )
	xml_node("p_osn", STR( nT_poro, 12, 2 ) )
	xml_node("do_st", STR( nT_dop_s, 12, 2 ) )
	xml_node("do_uk", STR( nT_dop_u, 12, 2 ) )
	xml_node("do_pio", STR( nT_d_pio, 12, 2 ) )
	xml_node("do_zdr", STR( nT_d_zdr, 12, 2 ) )
	xml_node("do_nez", STR( nT_d_nez, 12, 2 ) )
	xml_node("klo", STR( nT_klo, 12, 2 ) )
	xml_node("l_odb", STR( nT_lodb, 12, 2 ) )

	xml_subnode("total", .t.)
	
	// zatvori radnika
	xml_subnode("radnik", .t.)

enddo

// zatvori <rpt>
xml_subnode("rpt", .t.)

select (nTArea)
return


// ----------------------------------------------
// stampa obracunskog lista
// ----------------------------------------------
static function gip_print()
local cT_radnik := ""
local cLine := ""

O_R_EXP
select r_export
set order to tag "1"
go top

START PRINT CRET
? "#%LANDS#"

do while !EOF()

	cT_radnik := field->idradn

	// zaglavlje izvjestaja
	gip_zaglavlje( cT_radnik )

	P_COND2
	// zaglavlje tabele
	cLine := gip_t_header()

	nCount := 0

	nUprihod := 0
	nUPrihOst := 0
	nUBruto := 0
	nUDopSt := 0
	nUDopPio := 0
	nUDopZdr := 0
	nUDopNez := 0
	nUDopUk := 0
	nUNeto := 0
	nUKLO := 0
	nULODb := 0
	nUOsnPor := 0
	nUIznPor := 0

	do while !EOF() .and. field->idradn == cT_radnik

		? mj_opis

		@ prow(), nPoc:=pcol()+1 SAY STR(prihod,12,2)
		nUPrihod += prihod
		@ prow(), pcol()+1 SAY STR(prihost,12,2)
		nUPrihOst += prihost
		@ prow(), pcol()+1 SAY STR(bruto,12,2)
		nUBruto += bruto
		@ prow(), pcol()+1 SAY STR(dop_u_st,12,2) 
		nUDopSt := dop_u_st
		@ prow(), pcol()+1 SAY STR(dop_pio,12,2)
		nUDopPio += dop_pio
		@ prow(), pcol()+1 SAY STR(dop_zdr,12,2)
		nUDopZdr += dop_zdr
		@ prow(), pcol()+1 SAY STR(dop_nez,12,2)
		nUDopNez += dop_nez
		@ prow(), pcol()+1 SAY STR(dop_uk,12,2)
		nUDopUk += dop_uk
		@ prow(), pcol()+1 SAY STR(neto,12,2)
		nUNeto += neto
		@ prow(), pcol()+1 SAY STR(klo,12,2)
		nUKLO += klo
		@ prow(), pcol()+1 SAY STR(l_odb,12,2)
		nULOdb += l_odb
		@ prow(), pcol()+1 SAY STR(osn_por,12,2)
		nUOsnPor += osn_por
		@ prow(), pcol()+1 SAY STR(izn_por,12,2)
		nUIznPor += izn_por
		@ prow(), pcol()+1 SAY datispl

		skip
	enddo

	? cLine

	? "UKUPNO:"
	@ prow(), nPoc SAY STR(nUPrihod,12,2)
	@ prow(), pcol()+1 SAY STR(nUPrihOst,12,2)
	@ prow(), pcol()+1 SAY STR(nUBruto,12,2)
	@ prow(), pcol()+1 SAY STR(nUDopSt,12,2)
	@ prow(), pcol()+1 SAY STR(nUDopPio,12,2)
	@ prow(), pcol()+1 SAY STR(nUDopZdr,12,2)
	@ prow(), pcol()+1 SAY STR(nUDopNez,12,2)
	@ prow(), pcol()+1 SAY STR(nUDopUk,12,2)
	@ prow(), pcol()+1 SAY STR(nUNeto,12,2)
	@ prow(), pcol()+1 SAY STR(nUKLO,12,2)
	@ prow(), pcol()+1 SAY STR(nULOdb,12,2)
	@ prow(), pcol()+1 SAY STR(nUOsnPor,12,2)
	@ prow(), pcol()+1 SAY STR(nUIznPor,12,2)

	? cLine

	gip_potpis()

	FF
		
enddo

END PRINT

return

// ---------------------------------------
// potpis za obrazac GIP
// ---------------------------------------
static function gip_potpis()

P_12CPI
P_COND
? "Upoznat sam sa sankicajama propisanim Zakonom o Poreznoj upravi FBIH i izjavljujem"
? "da su svi podaci navedeni u ovoj prijavi tacni, potpuni i jasni, te potvrdjujem da su svi"
? "porezi i doprinosi za ovog uposlenika uplaceni."
? SPACE(80) + "Potpis poslodavca/isplatioca", SPACE(5) + "Datum:"

return



// ----------------------------------------------
// stampa obracunskog lista
// ----------------------------------------------
static function olp_print()
local cT_radnik := ""
local cLine := ""

O_R_EXP
select r_export
set order to tag "1"
go top

START PRINT CRET
? "#%LANDS#"

nCntPrint := 0

do while !EOF()

	cT_radnik := field->idradn
	//nMjesec := field->mjesec

	// zaglavlje izvjestaja
	olp_zaglavlje( cT_radnik )

	P_COND2

	// zaglavlje tabele
	cLine := olp_t_header()

	nCount := 0

	do while !EOF() .and. field->idradn == cT_radnik 

		? PADL( ALLTRIM( STR(++nCount)), 3 ) + ")"

		@ prow(), pcol()+1 SAY datispl
		@ prow(), pcol()+1 SAY PADR(ALLTRIM(naziv) + "/ " + ;
			ALLTRIM(mj_opis), 15)
		@ prow(), pcol()+1 SAY STR(prihod,12,2)
		@ prow(), pcol()+1 SAY STR(prihost,12,2)
		@ prow(), pcol()+1 SAY STR(bruto,12,2)
		@ prow(), pcol()+1 SAY STR(dop_u_st,12,2) PICT "999999999.99%"
		@ prow(), pcol()+1 SAY STR(dop_pio,12,2)
		@ prow(), pcol()+1 SAY STR(dop_zdr,12,2)
		@ prow(), pcol()+1 SAY STR(dop_nez,12,2)
		@ prow(), pcol()+1 SAY STR(dop_uk,12,2)
		@ prow(), pcol()+1 SAY STR(neto,12,2)
		@ prow(), pcol()+1 SAY STR(klo,12,2)
		@ prow(), pcol()+1 SAY STR(l_odb,12,2)
		@ prow(), pcol()+1 SAY STR(osn_por,12,2)
		@ prow(), pcol()+1 SAY STR(izn_por,12,2)
		@ prow(), pcol()+1 SAY STR(ukupno,12,2)

		++ nCntPrint
		
		skip
	enddo

	? cLine

	FF
		
enddo

END PRINT

return


// ----------------------------------------
// stampa headera tabele
// ----------------------------------------
static function gip_t_header()
local aLines := {}
local aTxt := {}
local i 
local cLine := ""
local cTxt1 := ""
local cTxt2 := ""
local cTxt3 := ""
local cTxt4 := ""

AADD( aLines, { REPLICATE("-", 15) } )
AADD( aLines, { REPLICATE("-", 12) } )
AADD( aLines, { REPLICATE("-", 12) } )
AADD( aLines, { REPLICATE("-", 12) } )
AADD( aLines, { REPLICATE("-", 12) } )
AADD( aLines, { REPLICATE("-", 12) } )
AADD( aLines, { REPLICATE("-", 12) } )
AADD( aLines, { REPLICATE("-", 12) } )
AADD( aLines, { REPLICATE("-", 12) } )
AADD( aLines, { REPLICATE("-", 12) } )
AADD( aLines, { REPLICATE("-", 12) } )
AADD( aLines, { REPLICATE("-", 12) } )
AADD( aLines, { REPLICATE("-", 12) } )
AADD( aLines, { REPLICATE("-", 12) } )
AADD( aLines, { REPLICATE("-", 8) } )

AADD( aTxt, { "Mjesec", "", "", "1" })
AADD( aTxt, { "Prihod", "u KM", "", "2" })
AADD( aTxt, { "Prih.u ost.", "stvarima ili", "uslugama", "3" })
AADD( aTxt, { "Bruto placa", "(2+3)", "", "4" })
AADD( aTxt, { "Ukupna stopa", "doprinosa", "iz place", "5" })
AADD( aTxt, { "Iznos dopr.", "za pio", "", "6" })
AADD( aTxt, { "Iznos dopr.", "za", "zdravstvo", "7" })
AADD( aTxt, { "Iznos dopr.", "za", "nezaposl.", "8" })
AADD( aTxt, { "Ukupno", "doprinosi", "(6+7+8)", "9" })
AADD( aTxt, { "Neto placa", "(4-9)", "", "10" })
AADD( aTxt, { "Faktor licnog", "odbitka", "", "11" })
AADD( aTxt, { "Iznos odbitka", "(11 x 300)", "", "12" })
AADD( aTxt, { "Osnovica", "poreza (10-12)", "", "13" })
AADD( aTxt, { "Iznos", "poreza", "(13 x 0.1)",  "14" })
AADD( aTxt, { "Datum", "uplate", "", "15" })

for i := 1 to LEN( aLines )
	cLine += aLines[ i, 1 ] + SPACE(1)
next

for i := 1 to LEN( aTxt )
	
	// koliko je sirok tekst ?
	nTxtLen := LEN( aLines[i, 1] )

	// prvi red
	cTxt1 += PADC( "(" + aTxt[i, 4] + ")", nTxtLen ) + SPACE(1)
	cTxt2 += PADC( aTxt[i, 1], nTxtLen ) + SPACE(1)
	cTxt3 += PADC( aTxt[i, 2], nTxtLen ) + SPACE(1)
	cTxt4 += PADC( aTxt[i, 3], nTxtLen ) + SPACE(1)

next

// ispisi zaglavlje tabele
? cLine
? cTxt1
? cTxt2
? cTxt3
? cTxt4
? cLine

return cLine




// ----------------------------------------
// stampa headera tabele
// ----------------------------------------
static function olp_t_header()
local aLines := {}
local aTxt := {}
local i 
local cLine := ""
local cTxt1 := ""
local cTxt2 := ""
local cTxt3 := ""
local cTxt4 := ""

AADD( aLines, { REPLICATE("-", 4) } )
AADD( aLines, { REPLICATE("-", 8) } )
AADD( aLines, { REPLICATE("-", 15) } )
AADD( aLines, { REPLICATE("-", 12) } )
AADD( aLines, { REPLICATE("-", 12) } )
AADD( aLines, { REPLICATE("-", 12) } )
AADD( aLines, { REPLICATE("-", 12) } )
AADD( aLines, { REPLICATE("-", 12) } )
AADD( aLines, { REPLICATE("-", 12) } )
AADD( aLines, { REPLICATE("-", 12) } )
AADD( aLines, { REPLICATE("-", 12) } )
AADD( aLines, { REPLICATE("-", 12) } )
AADD( aLines, { REPLICATE("-", 12) } )
AADD( aLines, { REPLICATE("-", 12) } )
AADD( aLines, { REPLICATE("-", 12) } )
AADD( aLines, { REPLICATE("-", 12) } )
AADD( aLines, { REPLICATE("-", 12) } )

AADD( aTxt, { "R.br", "", "", "1" })
AADD( aTxt, { "Datum", "isplate", "", "2" })
AADD( aTxt, { "Vrsta", "isplate", "", "3" })
AADD( aTxt, { "Prihod", "u KM", "", "4" })
AADD( aTxt, { "Prih.u ost.", "stvarima ili", "uslugama", "5" })
AADD( aTxt, { "Bruto placa", "(4+5)", "", "6" })
AADD( aTxt, { "Ukupna stopa", "doprinosa", "iz place", "7" })
AADD( aTxt, { "Iznos dopr.", "za pio", "", "8" })
AADD( aTxt, { "Iznos dopr.", "za", "zdravstvo", "9" })
AADD( aTxt, { "Iznos dopr.", "za", "nezaposl.", "10" })
AADD( aTxt, { "Ukupno", "doprinosi", "(8+9+10)", "11" })
AADD( aTxt, { "Neto placa", "(6-11)", "", "12" })
AADD( aTxt, { "Faktor licnog", "odbitka", "", "13" })
AADD( aTxt, { "Iznos odbitka", "(13 x 300)", "", "14" })
AADD( aTxt, { "Osnovica", "poreza (12-14)", "", "15" })
AADD( aTxt, { "Iznos", "poreza", "(15 x 0.1)",  "16" })
AADD( aTxt, { "Iznos place", "za isplatu", "(12-16)", "17" })

for i := 1 to LEN( aLines )
	cLine += aLines[ i, 1 ] + SPACE(1)
next

for i := 1 to LEN( aTxt )
	
	// koliko je sirok tekst ?
	nTxtLen := LEN( aLines[i, 1] )

	// prvi red
	cTxt1 += PADC( "(" + aTxt[i, 4] + ")", nTxtLen ) + SPACE(1)
	cTxt2 += PADC( aTxt[i, 1], nTxtLen ) + SPACE(1)
	cTxt3 += PADC( aTxt[i, 2], nTxtLen ) + SPACE(1)
	cTxt4 += PADC( aTxt[i, 3], nTxtLen ) + SPACE(1)

next

// ispisi zaglavlje tabele
? cLine
? cTxt1
? cTxt2
? cTxt3
? cTxt4
? cLine

return cLine


// ----------------------------------------------------------
// vraca string poreznog perioda
// ----------------------------------------------------------
static function g_por_per()

local cRet := ""

cRet += ALLTRIM(STR(__mj_od)) + "/" + ALLTRIM(STR(__god_od))  
cRet += " - "
cRet += ALLTRIM(STR(__mj_do)) + "/" + ALLTRIM(STR(__god_do))
cRet += " godine"

return cRet



// ----------------------------------------
// stampa zaglavlja izvjestaja
// ----------------------------------------
static function olp_zaglavlje( cRadnik )
local nTArea := SELECT()

cPorPer := g_por_per()

?
P_10CPI
B_ON
? SPACE(10) + "Obrazac OLP-1021"
? SPACE(5) + "OBRACUNSKI LIST PLACA"
B_OFF
@ prow(), pcol() + 10 SAY "Porezni period: " + cPorPer
?
P_COND
? "Dio 1 - podaci o poslodavcu/isplatiocu i poreznom obvezniku"
P_12CPI

select radn
seek cRadnik

? PADR( "JIB/JMB isplatioca: " + cPredJmb, 60 ), "JMB zaposlenika: " + radn->matbr
? PADR( "Naziv: " + cPredNaz, 60 ), "Ime: " + ALLTRIM(radn->ime) + " (" + ;
	ALLTRIM(radn->imerod) + ") " + ALLTRIM(radn->naz) 
? PADR( "Adresa: " + cPredAdr, 60 ), "Adresa: " + ;
	ALLTRIM(radn->streetname) + " " + ;
	ALLTRIM(radn->streetnum)

?
P_COND
? SPACE(1) + "Dio 2 - podaci o isplacenim placama i drugim oporezivim naknadama, obracunatim, obustavljenim, i uplacenim doprinosima i porezu"

select (nTArea)
return

// ----------------------------------------
// stampa zaglavlja izvjestaja
// ----------------------------------------
static function gip_zaglavlje( cRadnik )
local nTArea := SELECT()

cPorPer := g_por_per()

?
P_10CPI
B_ON
? SPACE(10) + "Obrazac GIP-1022"
? SPACE(2) + "GODISNJI IZVJESTAJ O UKUPNO ISPLACENIM"
? SPACE(2) + "PLACAMA I DRUGIM LICNIM PRIMANJIMA"
B_OFF
P_10CPI
@ prow(), pcol() + 10 SAY "Porezni period: " + cPorPer
?
P_COND
? "Dio 1 - podaci o poslodavcu/isplatiocu i poreznom obvezniku"
P_12CPI

select radn
seek cRadnik

? PADR( "JIB/JMB isplatioca: " + cPredJmb, 60 ), "JMB zaposlenika: " + ;
	radn->matbr
? PADR( "Naziv: " + cPredNaz, 60 ), "Ime: " + ALLTRIM(radn->ime) + " (" + ;
	ALLTRIM(radn->imerod) + ") " + ALLTRIM(radn->naz) 
? PADR( "Adresa: " + cPredAdr, 60 ), "Adresa: " + ALLTRIM(radn->streetname) + ;
	" " + ;
	ALLTRIM(radn->streetnum)

?
P_10CPI
P_COND
? SPACE(1) + "Dio 2 - podaci o prihodima, doprinosima, porezu"

select (nTArea)
return


// -------------------------------------------
// vraca string sa datumom uslovskim
// -------------------------------------------
static function __date( nGod, nMj )
local cRet

cRet := PADR( ALLTRIM( STR( nGod ) ), 4 ) + ;
	PADL( ALLTRIM( STR( nMj ) ) , 2, "0" )

return cRet



// ---------------------------------------------------------
// napuni podatke u pomocnu tabelu za izvjestaj
// ---------------------------------------------------------
function ol_fill_data( cRj, cGod_od, cGod_do, cMj_od, cMj_do, ;
	cRadnik, cPrimDobra, cDopr10, cDopr11, cDopr12, cDopr1X, cRptTip, ;
	cObracun, cTp1, cTp2, cTp3, cTp4, cTp5 )
local i
local cPom
local nPrDobra
local nTp1 := 0
local nTp2 := 0
local nTp3 := 0
local nTp4 := 0
local nTp5 := 0

// dodatni tipovi primanja
if cTp1 == nil
	cTp1 := ""
endif
if cTp2 == nil
	cTp2 := ""
endif
if cTp3 == nil
	cTp3 := ""
endif
if cTp4 == nil
	cTp4 := ""
endif
if cTp5 == nil
	cTp5 := ""
endif

lDatIspl := .f.
if obracuni->(fieldpos("DAT_ISPL")) <> 0
	lDatIspl := .t.
endif

select ld

do while !eof() 

	if __date( field->godina, field->mjesec ) < __date( cGod_od, cMj_od )   
		skip
		loop
	endif

	if __date( field->godina, field->mjesec ) > __date( cGod_do, cMj_do )
		skip
		loop
	endif

	cT_radnik := field->idradn

	if !EMPTY(cRadnik)
		if cT_radnik <> cRadnik
			skip
			loop
		endif
	endif
	
	cTipRada := g_tip_rada( ld->idradn, ld->idrj )

	// samo pozicionira bazu PAROBR na odgovarajuci zapis
	ParObr( ld->mjesec, ld->godina, IF(lViseObr, ld->obr,), ld->idrj )

	select radn
	seek cT_radnik
	
	if !( cTipRada $ " #I#N") 
		select ld
		skip
		loop
	endif

	select ld

	nBruto := 0
	nBrDobra := 0
	nDoprStU := 0
	nDopPio := 0
	nDopZdr := 0
	nDopNez := 0
	nDopUk := 0
	nNeto := 0
	nPrDobra := 0
	nTp1 := 0
	nTp2 := 0
	nTp3 := 0
	nTp4 := 0
	nTp5 := 0

	do while !EOF() .and. field->idradn == cT_radnik 
	
		if __date( field->godina, field->mjesec ) < ;
			__date( cGod_od, cMj_od ) 
			skip
			loop
		endif

		if __date( field->godina, field->mjesec ) > ;
			__date( cGod_do, cMj_do )
			skip
			loop
		endif

		// uvijek provjeri tip rada, ako ima vise obracuna
		cTipRada := g_tip_rada( ld->idradn, ld->idrj )
		
		ParObr( ld->mjesec, ld->godina, IF(lViseObr, ld->obr,), ld->idrj )
		
		if !( cTipRada $ " #I#N") 
			skip
			loop
		endif
		
		nPrDobra := 0

   		if !EMPTY( cPrimDobra ) 
     		   for t:=1 to 99
       			cPom := IF( t>9, STR(t,2), "0"+STR(t,1) )
       			if ld->( FIELDPOS( "I" + cPom ) ) <= 0
         			EXIT
       			endif
       			nPrDobra += IF( cPom $ cPrimDobra, LD->&("I"+cPom), 0 )
     		   next
   		endif
		
		// ostali tipovi primanja
		if !EMPTY( cTp1 )
			nTp1 := LD->&( "I" + cTp1 )
		endif
		if !EMPTY( cTp2 )
			nTp2 := LD->&( "I" + cTp2 )
		endif
		if !EMPTY( cTp3 )
			nTp3 := LD->&( "I" + cTp3 )
		endif
		if !EMPTY( cTp4 )
			nTp4 := LD->&( "I" + cTp4 )
		endif
		if !EMPTY( cTp5 )
			nTp5 := LD->&( "I" + cTp5 )
		endif


		nNeto := field->uneto
		nKLO := radn->klo
		nL_odb := field->ulicodb
		
		// bruto 
		nBruto := bruto_osn( nNeto, cTipRada, nL_odb ) 
		
		// minimalni bruto
		nMBruto := min_bruto( nBruto, field->usati )

		// bruto primanja u uslugama ili dobrima
		// za njih posebno izracunaj bruto osnovicu
		if nPrDobra > 0
			nBrDobra := bruto_osn( nPrDobra, cTipRada, nL_odb )
		endif
		
		// ukupno dopr iz 31%
		nDoprIz := u_dopr_iz( nMBruto, cTipRada )
		
		// osnovica za porez
		nPorOsn := ( nBruto - nDoprIz ) - nL_odb
		
		// ako je neoporeziv radnik, nema poreza
		if !radn_oporeziv( radn->id, ld->idrj ) .or. ;
			( nBruto - nDoprIz ) < nL_odb
			nPorOsn := 0
		endif
		
		// porez je ?
		nPorez := izr_porez( nPorOsn, "B" )
		
		select ld
		
		// na ruke je
		nNaRuke := ( nBruto - nDoprIz ) - nPorez

		// ocitaj doprinose, njihove iznose
		nDopr10 := Ocitaj( F_DOPR , cDopr10 , "iznos" , .t. )
		nDopr11 := Ocitaj( F_DOPR , cDopr11 , "iznos" , .t. )
		nDopr12 := Ocitaj( F_DOPR , cDopr12 , "iznos" , .t. )
		nDopr1X := Ocitaj( F_DOPR , cDopr1X , "iznos" , .t. )
		
		// izracunaj doprinose
		nIDopr10 := round2(nMBruto * nDopr10 / 100, gZaok2)
		nIDopr11 := round2(nMBruto * nDopr11 / 100, gZaok2)
		nIDopr12 := round2(nMBruto * nDopr12 / 100, gZaok2)
		nIDopr1X := round2(nMBruto * nDopr1X / 100, gZaok2)

		dDatIspl := DATE()
		if lDatIspl 
			dDatIspl := g_isp_date( field->idrj, ;
					field->godina, ;
					field->mjesec )
		endif

		nIsplata := ((nBruto - nIDopr1X) - nPorez)
		
		// da li se radi o minimalcu ?
		if cTipRada $ " #I#N#" 
			nIsplata := min_neto( nIsplata , field->usati )
		endif

		// ubaci u tabelu podatke
		_ins_tbl( cT_radnik, ;
				"placa", ;
				dDatIspl, ;
				ld->mjesec, ;
				ld->godina, ;
				nBruto - nBrDobra, ;
				nBrDobra, ;
				nBruto, ;
				nDopr1X,;
				nIDopr10, ;
				nIDopr11, ;
				nIDopr12, ;
				nIDopr1X, ;
				nBruto - nIDopr1X, ;
				nKLO, ;
				nL_Odb, ;
				nPorOsn, ;
				nPorez, ;
				nIsplata, ;
				ld->usati, ;
				nTp1, ;
				nTp2, ;
				nTp3, ;
				nTp4, ;
				nTp5 )
				
		select ld
		skip

	enddo

enddo

return


