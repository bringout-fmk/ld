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
static function _ins_tbl( cRadnik, cIdRj, cTipRada, cNazIspl, dDatIsplate, ;
		nMjesec, nMjisp, cIsplZa, cVrsta, ;
		nGodina, nPrihod, ;
		nPrihOst, nBruto, nMBruto, nDop_u_st, nDopPio, ;
		nDopZdr, nDopNez, nDop_uk, nNeto, nKLO, ;
		nLOdb, nOsn_por, nIzn_por, nUk, nUSati, nIzn1, nIzn2, ;
		nIzn3, nIzn4, nIzn5 )

local nTArea := SELECT()

O_R_EXP
select r_export
append blank

replace tiprada with cTipRada
replace idrj with cIdRj
replace idradn with cRadnik
replace naziv with cNazIspl
replace mjesec with nMjesec
replace mj_opis with NazMjeseca( nMjesec, nGodina, .f., .t. )
replace mj_ispl with NazMjeseca( nMjesec, nGodina, .f., .f. )
replace ispl_za with cIsplZa
replace vr_ispl with cVrsta
replace godina with nGodina
replace datispl with dDatIsplate
replace prihod with nPrihod
replace prihost with nPrihOst
replace bruto with nBruto
replace mbruto with nMBruto
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
AADD(aDbf,{ "IDRJ", "C", 2, 0 })
AADD(aDbf,{ "TIPRADA", "C", 1, 0 })
AADD(aDbf,{ "NAZIV", "C", 15, 0 })
AADD(aDbf,{ "DATISPL", "D", 8, 0 })
AADD(aDbf,{ "MJESEC", "N", 2, 0 })
AADD(aDbf,{ "MJ_OPIS", "C", 15, 0 })
AADD(aDbf,{ "MJ_ISPL", "C", 15, 0 })
AADD(aDbf,{ "ISPL_ZA", "C", 50, 0 })
AADD(aDbf,{ "VR_ISPL", "C", 50, 0 })
AADD(aDbf,{ "GODINA", "N", 4, 0 })
AADD(aDbf,{ "PRIHOD", "N", 12, 2 })
AADD(aDbf,{ "PRIHOST", "N", 12, 2 })
AADD(aDbf,{ "BRUTO", "N", 12, 2 })
AADD(aDbf,{ "MBRUTO", "N", 12, 2 })
AADD(aDbf,{ "DOP_U_ST", "N", 12, 2 })
AADD(aDbf,{ "DOP_PIO", "N", 12, 2 })
AADD(aDbf,{ "DOP_ZDR", "N", 12, 2 })
AADD(aDbf,{ "DOP_NEZ", "N", 12, 2 })
AADD(aDbf,{ "DOP_UK", "N", 12, 4 })
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
local cWinPrint := "E"
local nOper := 1

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

nPorGodina := 2009
cOperacija := "Novi"
dDatUnosa := DATE()
dDatPodnosenja := DATE()
nBrZahtjeva := 1

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

Box("#OBRACUNSKI LISTOVI RADNIKA", 17, 75)

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

@ m_x + 15, col() + 2 SAY "stampa/export (S/E)?" GET cWinPrint ;
	VALID cWinPrint $ "SE" PICT "@!" 

read

dPerOd := DATE()
dPerDo := DATE()

// daj period od - do
g_per_oddo( cMj_od, cGod_od, cMj_do, cGod_do, @dPerOd, @dPerDo )

if cWinPrint == "E"
	
	nPorGodina := cGod_do

	@ m_x + 16, m_y + 2 SAY "P.godina" GET nPorGodina ;
		PICT "9999"
	@ m_x + 16, col() + 2 SAY "Dat.podnos." GET dDatPodnosenja 
	@ m_x + 16, col() + 2 SAY "Dat.unosa" GET dDatUnosa 

	@ m_x + 17, m_y + 2 SAY "operacija: 1 (novi) 2 (izmjena) 3 (brisanje)" ;
		GET nOper PICT "9"
	
	read
endif

cOperacija := g_operacija( nOper )

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

if cWinPrint == "S"
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

if __xml == 1
	_xml_print( cTipRpt )
else
	nBrZahtjeva := g_br_zaht()
	_xml_export( cTipRpt )
endif

return


// --------------------------------------
// vraca period od-do
// --------------------------------------
static function g_per_oddo( cMj_od, cGod_od, cMj_do, cGod_do, ;
	dPerOd, dPerDo )
local cTmp := ""

cTmp += "01" + "."
cTmp += PADL( ALLTRIM( STR( cMj_od) ) , 2, "0" ) + "." 
cTmp += ALLTRIM( STR( cGod_od ) )

dPerOd := CTOD( cTmp )

cTmp := g_day( cMj_do ) + "."
cTmp += PADL( ALLTRIM( STR( cMj_do ) ) , 2, "0" ) + "." 
cTmp += ALLTRIM( STR( cGod_do ) )

dPerDo := CTOD( cTmp )

return

// ------------------------------------------
// vraca koliko dana ima u mjesecu
// ------------------------------------------
static function g_day( nMonth )
local cDay := "31"
do case
	case nMonth = 1
		cDay := "31"
	case nMonth = 2
		cDay := "28"
	case nMonth = 3
		cDay := "31"
	case nMonth = 4
		cDay := "30"
	case nMonth = 5
		cDay := "31"
	case nMonth = 6
		cDay := "30"
	case nMonth = 7
		cDay := "31"
	case nMonth = 8
		cDay := "31"
	case nMonth = 9
		cDay := "30"
	case nMonth = 10
		cDay := "31"
	case nMonth = 11
		cDay := "30"
	case nMonth = 12
		cDay := "31"

endcase

return cDay



// -------------------------------------
// vraca vrstu isplate
// -------------------------------------
static function g_v_ispl( cId )
local cIspl := "Plata"

if cId == "1"
	cIspl := "Plata"
elseif cId == "2"
	cIspl := "Plata + ostalo"
endif

return cIspl



static function g_operacija( nOper )
local cOperacija := ""

if nOper = 1
	cOperacija := "Novi"
elseif nOper = 2
	cOperacija := "Izmjena"
elseif nOper = 3
	cOperacija := "Brisanje"
else
	cOperacija := "Novi"
endif

return cOperacija 


// -----------------------------------------------
// vraca broj zahtjeva
// -----------------------------------------------
static function g_br_zaht()
local nTArea := SELECT()
local cT_radnik 
local nCnt
local nRet := 0

select r_export
set order to tag "1"
go top

do while !EOF()
	
	cT_radnik := field->idradn
	nCnt := 0

	do while !EOF() .and. field->idradn == cT_radnik
		nCnt := 1
		skip
	enddo
	
	nRet += nCnt

enddo

select (nTArea)
return nRet



// ----------------------------------------
// export xml-a
// ----------------------------------------
static function _xml_export( cTip )
local cMsg

if __xml == 1
	return
endif

if cTip == "1"
	return
endif

// napuni xml fajl
_fill_e_xml()

cMsg := "Export xml datoteke zavrsen. Datoteka se nalazi#"
cMsg += "na lokaciji c:\export.xml#"
cMsg += "Potrebno promjeniti naziv xml fajla u TIN.xml gdje je#"
cMsg += "TIN id broj preduzeca, zatim zipovati fajl u TIN.zip."

msgbeep( cMsg )

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


// ------------------------------------
// header za export
// ------------------------------------
static function _xml_head()
local cStr := '<?xml version="1.0" encoding="UTF-8"?><PaketniUvozObrazaca xmlns="urn:PaketniUvozObrazaca_V1_0.xsd">'

xml_head( .t., cStr )

return



// --------------------------------------------
// filuje xml fajl sa podacima za export
// --------------------------------------------
static function _fill_e_xml()
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
local nT_bbd := 0
local nT_klo := 0
local nT_lodb := 0

// otvori xml za upis
open_xml( "c:\export.xml" )

// upisi header
_xml_head()

// ovo ne treba zato sto je u headeru sadrzan ovaj prvi sub-node !!!
// <paketniuvozobrazaca>
//xml_subnode("PaketniUvozObrazaca", .f.)

// <podacioposlodavcu>
xml_subnode("PodaciOPoslodavcu", .f. )

 // naziv firme
 xml_node( "JIBPoslodavca", ALLTRIM(cPredJmb) )
 xml_node( "NazivPoslodavca", strkzn( ALLTRIM(cPredNaz), "8", "U" ) )
 xml_node( "BrojZahtjeva", STR( nBrZahtjeva ) )
 xml_node( "DatumPodnosenja", xml_date( dDatPodnosenja ) )

xml_subnode("PodaciOPoslodavcu", .t. )

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

	xml_subnode("Obrazac1022", .f.)

	xml_subnode("Dio1PodaciOPoslodavcuIPoreznomObvezniku", .f.)
	
	 xml_node("JIBJMBPoslodavca", ALLTRIM(cPredJmb) )
 	 xml_node("Naziv", strkzn( ALLTRIM(cPredNaz), "8", "U" ) )
 	 xml_node("AdresaSjedista", strkzn( ALLTRIM( cPredAdr ), "8", "U") )
 	 xml_node("JMBZaposlenika", ALLTRIM( radn->matbr ) )
 	 xml_node("ImeIPrezime", strkzn( ALLTRIM(radn->ime) + " " + ;
	 	ALLTRIM(radn->naz), "8", "U" ) )
	 xml_node("AdresaPrebivalista", strkzn( ALLTRIM(radn->streetname) + ;
		" " + ALLTRIM(radn->streetnum), "8", "U" ) )
	 xml_node("PoreznaGodina", STR( nPorGodina ) )
	 
	 xml_node("PeriodOd", xml_date( dPerOd ) )
	 xml_node("PeriodDo", xml_date( dPerDo ) )

	xml_subnode("Dio1PodaciOPoslodavcuIPoreznomObvezniku", .t.)
	
	xml_subnode("Dio2PodaciOPrihodimaDoprinosimaIPorezu", .f.)
	
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
	nT_bbd := 0
	nT_klo := 0
	nT_lodb := 0
		
	nCnt := 0

	do while !EOF() .and. field->idradn == cT_radnik
		
		// ukupni doprinosi
		replace field->dop_uk with field->dop_pio + ;
			field->dop_nez + field->dop_zdr

		replace field->osn_por with ( field->bruto - field->dop_uk ) - ;
			field->l_odb
	
		// ako je neoporeziv radnik, nema poreza
		if !radn_oporeziv( field->idradn, field->idrj ) .or. ;
			field->osn_por < 0 
			replace field->osn_por with 0
		endif

		if field->osn_por > 0
			replace field->izn_por with field->osn_por * 0.10
		else
			replace field->izn_por with 0
		endif

		replace field->neto with (field->bruto - field->dop_uk) - ;
			field->izn_por
	
		if field->tiprada $ " #I#N#" 
			replace field->neto with ;
				min_neto( field->neto , field->sati )
		endif

		
		xml_subnode("PodaciOPrihodimaDoprinosimaIPorezu", .f.)

		xml_node("Mjesec", STR( field->mjesec ) )
		xml_node("IsplataZaMjesecIGodinu", ;
			strkzn( ALLTRIM(field->ispl_za), "8", "U" ) )
		xml_node("VrstaIsplate", ;
			strkzn( ALLTRIM(field->vr_ispl), "8", "U" ))
		xml_node("IznosPrihodaUNovcu", ;
			STR( field->prihod, 12, 2 ) ) 
		xml_node("IznosPrihodaUStvarimaUslugama", ;
			STR( field->prihost, 12, 2 ) )
		xml_node("BrutoPlaca", STR( field->bruto, 12, 2 ) )
		xml_node("IznosZaPenzijskoInvalidskoOsiguranje", ;
			STR( field->dop_pio, 12, 2 ) )
		xml_node("IznosZaZdravstvenoOsiguranje", ;
			STR( field->dop_zdr, 12, 2 ) )
		xml_node("IznosZaOsiguranjeOdNezaposlenosti", ;
			STR( field->dop_nez, 12, 2 ) )
		xml_node("UkupniDoprinosi", STR( field->dop_uk , 12, 2 ) )
		xml_node("PlacaBezDoprinosa", ;
			STR( field->bruto - field->dop_uk , 12, 2 ) )
		
		xml_node("FaktorLicnihOdbitakaPremaPoreznojKartici", ;
			STR( field->klo, 12, 2 ) )
		
		xml_node("IznosLicnogOdbitka", STR( field->l_odb, 12, 2 ) )
		
		xml_node("OsnovicaPoreza", STR( field->osn_por, 12, 2 ) )
		xml_node("IznosUplacenogPoreza", STR( field->izn_por, 12, 2 ) )
		
		xml_node("NetoPlaca", STR( field->neto, 12, 2 ) )
		xml_node("DatumUplate", xml_date( field->datispl ) )
		
		//xml_node("opis", strkzn( ALLTRIM( field->naziv ), "8", "U") )
		//xml_node("uk", STR( field->ukupno, 12, 2 ) )

		xml_subnode("PodaciOPrihodimaDoprinosimaIPorezu", .t.)
		
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
		nT_bbd += ( field->bruto - field->dop_uk )
		nT_klo += field->klo
		nT_lodb += field->l_odb

		skip
	enddo

	xml_subnode("Ukupno", .f.)

	xml_node("IznosPrihodaUNovcu", STR( nT_prih, 12, 2 ) )
	xml_node("IznosPrihodaUStvarimaUslugama", ;
		STR( nT_pros, 12, 2 ) )

	xml_node("BrutoPlaca", STR( nT_bruto, 12, 2 ) )
	xml_node("IznosZaPenzijskoInvalidskoOsiguranje", ;
		STR( nT_d_pio, 12, 2 ) )

	xml_node("IznosZaZdravstvenoOsiguranje", ;
		STR( nT_d_zdr, 12, 2 ) )

	xml_node("IznosZaOsiguranjeOdNezaposlenosti", ;
		STR( nT_d_nez, 12, 2 ) )

	xml_node("UkupniDoprinosi", STR( nT_dop_u, 12, 2 ) )
	xml_node("PlacaBezDoprinosa", STR( nT_bbd, 12, 2 ) )
	xml_node("IznosLicnogOdbitka", STR( nT_lodb, 12, 2 ) )
	xml_node("OsnovicaPoreza", STR( nT_poro, 12, 2 ) )
	xml_node("IznosUplacenogPoreza", STR( nT_pori, 12, 2 ) )
	xml_node("NetoPlaca", STR( nT_neto, 12, 2 ) )

	xml_subnode("Ukupno", .t.)

	xml_subnode("Dio2PodaciOPrihodimaDoprinosimaIPorezu", .t.)

	xml_subnode("Dio3IzjavaPoslodavcaIsplatioca", .f.)
	 xml_node("JIBJMBPoslodavca", ALLTRIM(cPredJmb) )
 	 xml_node("DatumUnosa", xml_date( dDatUnosa ) )
 	 xml_node("NazivPoslodavca", strkzn( ALLTRIM(cPredNaz), "8", "U" ) )
	xml_subnode("Dio3IzjavaPoslodavcaIsplatioca", .t.)

	xml_subnode("Dokument", .f.)
	  xml_node("Operacija", cOperacija )
	xml_subnode("Dokument", .t.)
	

	xml_subnode("Obrazac1022", .t. )

enddo

// zatvori <PaketniUvoz...>
xml_subnode("PaketniUvozObrazaca", .t.)

select (nTArea)
return



// --------------------------------------------
// filuje xml fajl sa podacima izvjestaja
// --------------------------------------------
static function _fill_xml()
local nTArea := SELECT()
local nT_prih := 0
local nT_pros := 0
local nT_bruto := 0
local nT_bbd := 0
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
	nT_bbd := 0
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

		// ukupni doprinosi
		replace field->dop_uk with field->dop_pio + ;
			field->dop_nez + field->dop_zdr

		replace field->osn_por with ( field->bruto - field->dop_uk ) - ;
			field->l_odb
	
		// ako je neoporeziv radnik, nema poreza
		if !radn_oporeziv( field->idradn, field->idrj ) .or. ;
			field->osn_por < 0 
			replace field->osn_por with 0
		endif

		if field->osn_por > 0
			replace field->izn_por with field->osn_por * 0.10
		else
			replace field->izn_por with 0
		endif

		replace field->neto with (field->bruto - field->dop_uk) - ;
			field->izn_por
	
		if field->tiprada $ " #I#N#" 
			replace field->neto with ;
				min_neto( field->neto , field->sati )
		endif

		xml_subnode("obracun", .f.)

		xml_node("rbr", STR( ++nCnt ) )
		xml_node("pl_opis", strkzn( ALLTRIM( field->mj_opis ), ;
			"8", "U" ) )
		xml_node("mjesec", STR( field->mjesec ) )
		xml_node("godina", STR( field->godina ) )
		xml_node("isp_m", strkzn( ALLTRIM(field->mj_ispl), "8", "U") )
		xml_node("isp_z", strkzn( ALLTRIM(field->ispl_za), "8", "U" ) )
		xml_node("isp_v", strkzn( g_v_ispl(ALLTRIM(field->vr_ispl));
			, "8", "U" ))
		xml_node("prihod", STR( field->prihod, 12, 2 ) ) 
		xml_node("prih_o", STR( field->prihost, 12, 2 ) )
		xml_node("bruto", STR( field->bruto, 12, 2 ) )
		xml_node("do_us", STR( field->dop_u_st, 12, 2 ) )
		xml_node("do_uk", STR( field->dop_uk, 12, 2 ) )
		xml_node("do_pio", STR( field->dop_pio, 12, 2 ) )
		xml_node("do_zdr", STR( field->dop_zdr, 12, 2 ) )
		xml_node("do_nez", STR( field->dop_nez, 12, 2 ) )
		xml_node("bbd", STR( field->bruto - field->dop_uk, 12, 2 ) )
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
		nT_bbd += ( field->bruto - field->dop_uk )
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
	xml_node("bbd", STR( nT_bbd, 12, 2 ) )
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
local nIDopr10 := 0000.00000
local nIDopr11 := 0000.00000
local nIDopr12 := 0000.00000
local nIDopr1X := 0000.00000 

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

		// radna jedinica
		cRadJed := ld->idrj

		// uvijek provjeri tip rada, ako ima vise obracuna
		cTipRada := g_tip_rada( ld->idradn, ld->idrj )
		
		ParObr( ld->mjesec, ld->godina, IF(lViseObr, ld->obr,), ;
				ld->idrj )
		
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
		nKLO := g_klo( field->ulicodb )
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
		
		// ocitaj doprinose, njihove iznose
		nDopr10 := Ocitaj( F_DOPR , cDopr10 , "iznos" , .t. )
		nDopr11 := Ocitaj( F_DOPR , cDopr11 , "iznos" , .t. )
		nDopr12 := Ocitaj( F_DOPR , cDopr12 , "iznos" , .t. )
		nDopr1X := Ocitaj( F_DOPR , cDopr1X , "iznos" , .t. )

		// izracunaj doprinose
		nIDopr10 := ROUND( nMBruto * nDopr10 / 100 , 4 )
		nIDopr11 := ROUND( nMBruto * nDopr11 / 100, 4 )
		nIDopr12 := ROUND( nMBruto * nDopr12 / 100, 4 )

		// zbirni je zbir ova tri doprinosa
		nIDopr1X := ROUND( nIDopr10 + nIDopr11 + nIDopr12, 4 )
		
		// ukupno dopr iz 31%
		//nDoprIz := u_dopr_iz( nMBruto, cTipRada )
		
		// osnovica za porez
		nPorOsn := ( nBruto - nIDopr1X ) - nL_odb
		
		// ako je neoporeziv radnik, nema poreza
		if !radn_oporeziv( radn->id, ld->idrj ) .or. ;
			( nBruto - nIDopr1X ) < nL_odb
			nPorOsn := 0
		endif

		// porez je ?
		nPorez := izr_porez( nPorOsn, "B" )

		select ld
	
		// na ruke je
		nNaRuke := ROUND( nBruto - nIDopr1X - nPorez, 2 ) 
		
		nIsplata := nNaRuke

		// da li se radi o minimalcu ?
		if cTipRada $ " #I#N#" 
			nIsplata := min_neto( nIsplata , field->usati )
		endif

		nMjIspl := 0
		cIsplZa := ""
		cVrstaIspl := ""
		dDatIspl := DATE()
		cObr := " "
		
		if lViseObr
			cObr := field->obr
		endif

		if lDatIspl 
			dDatIspl := g_isp_date( field->idrj, ;
					field->godina, ;
					field->mjesec, ;
					cObr, @nMjIspl, ;
					@cIsplZa, @cVrstaIspl )
		endif


		// ubaci u tabelu podatke
		_ins_tbl( cT_radnik, ;
				cRadJed, ;
				cTipRada, ;
				"placa", ;
				dDatIspl, ;
				ld->mjesec, ;
				nMjIspl, ;
				cIsplZa, ;
				cVrstaIspl, ;
				ld->godina, ;
				nBruto - nBrDobra, ;
				nBrDobra, ;
				nBruto, ;
				nMBruto, ;
				nDopr1X,;
				nIDopr10, ;
				nIDopr11, ;
				nIDopr12, ;
				nIDopr1X, ;
				nNaRuke, ;
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


