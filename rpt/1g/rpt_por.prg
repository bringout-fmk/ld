/* 
 * This file is part of the bring.out FMK, a free and open source 
 * accounting software suite,
 * Copyright (c) 1996-2011 by bring.out doo Sarajevo.
 * It is licensed to you under the Common Public Attribution License
 * version 1.0, the full text of which (including FMK specific Exhibits)
 * is available in the file LICENSE_CPAL_bring.out_FMK.md located at the 
 * root directory of this source code archive.
 * By using this software, you agree to be bound by its terms.
 */


#include "ld.ch"

// -------------------------------------
// obracun i prikaz poreza
// -------------------------------------
function obr_porez( nPor, nPor2, nPorOps, nPorOps2, nUPorOl, cTipPor )
local cAlgoritam := ""
local nOsnova := 0

if cTipPor == nil
	cTipPor := ""
endif

select por
go top

nPom:=0
nPor:=0
nPor2:=0
nPorOps:=0
nPorOps2:=0
nC1:=20

cLinija:="----------------------- -------- ----------- -----------"

if cUmPD=="D"
	m+=" ----------- -----------"
endif

if cUmPD=="D"
	P_12CPI
	? "----------------------- -------- ----------- ----------- ----------- -----------"
	? Lokal("                                 Obracunska     Porez    Preplaceni     Porez   ")
	? Lokal("     Naziv poreza          %      osnovica   po obracunu    porez     za uplatu ")
	? "          (1)             (2)        (3)     (4)=(2)*(3)     (5)     (6)=(4)-(5)"
	? "----------------------- -------- ----------- ----------- ----------- -----------"
endif

do while !eof()
	
	cAlgoritam := get_algoritam()
	
	// ako to nije taj tip poreza preskoci
	if !EMPTY( cTipPor )
		if por_tip <> cTipPor
			skip
			loop
		endif
	endif

	if prow() > ( 64 + gPStranica )
		//FF
	endif

	? id, "-", naz
	
	if cAlgoritam == "S"
		@ prow(), pcol() + 1 SAY "st.por"
	else
		@ prow(), pcol() + 1 SAY iznos pict "99.99%"
	endif
	
	nC1 := pcol() + 1
	
	if !EMPTY(poopst)
     		
		if poopst=="1"
       			?? Lokal(" (po opst.stan)")
     		elseif poopst=="2"
       			?? Lokal(" (po opst.stan)")
     		elseif poopst=="3"
       			?? Lokal(" (po kant.stan)")
     		elseif poopst=="4"
       			?? Lokal(" (po kant.rada)")
     		elseif poopst=="5"
       			?? Lokal(" (po ent. stan)")
     		elseif poopst=="6"
       			?? Lokal(" (po ent. rada)")
       			?? Lokal(" (po opst.rada)")
     		endif
     		
		nOOP:=0      
		// ukupna Osnovica za Obracun Poreza za po opstinama
     		
		nPOLjudi:=0  
     		// ukup.ljudi za po opstinama
     		
		nPorOps:=0
     		nPorOps2:=0
     		
		if cAlgoritam == "S"
			cSeek := por->id
		else
			cSeek := SPACE(2)
		endif
		
		select opsld
     		seek cSeek + por->poopst
     		
		? strtran(cLinija,"-","=")
     		
		do while !eof() .and. porid == cSeek ;
			.and. id == por->poopst
		
			cOpst := opsld->idops
			
			select ops
			hseek cOpst
			
			select opsld
		        
			if !ImaUOp("POR", POR->id)
		        	
				skip 1
			   	loop
				
		        endif
		        
			if cAlgoritam == "S"
				
			  ? idops, ops->naz
				
			  nPom := 0
			  
			  do while !EOF() .and. porid == cSeek ;
				.and. id == por->poopst ;
				.and. idops == cOpst
				
				if t_iz_1 <> 0
				  ? " -obracun za stopu "
				  @ prow(), pcol()+1 SAY t_st_1 pict "99.99%"
				  @ prow(), pcol()+1 SAY "="
		        	  @ prow(), pcol()+1 SAY t_iz_1 pict gpici
		        	endif
				
				if t_iz_2 <> 0
				  ? " -obracun za stopu "
				  @ prow(), pcol()+1 SAY t_st_2 pict "99.99%"
				  @ prow(), pcol()+1 SAY "="
		        	  @ prow(), pcol()+1 SAY t_iz_2 pict gpici
		        	endif
				
				if t_iz_3 <> 0
				  ? " -obracun za stopu "
				  @ prow(), pcol()+1 SAY t_st_3 pict "99.99%"
				  @ prow(), pcol()+1 SAY "="
		        	  @ prow(), pcol()+1 SAY t_iz_3 pict gpici
		        	endif
				
				if t_iz_4 <> 0
				  ? " -obracun za stopu "
				  @ prow(), pcol()+1 SAY t_st_4 pict "99.99%"
				  @ prow(), pcol()+1 SAY "="
		        	  @ prow(), pcol()+1 SAY t_iz_4 pict gpici
		        	endif
			
				if t_iz_5 <> 0
				  ? " -obracun za stopu "
				  @ prow(), pcol()+1 SAY t_st_5 pict "99.99%"
				  @ prow(), pcol()+1 SAY "="
		        	  @ prow(), pcol()+1 SAY t_iz_5 pict gpici
		        	endif
			
				nPom += t_iz_1
				nPom += t_iz_2 
				nPom += t_iz_3
				nPom += t_iz_4
				nPom += t_iz_5
				
				skip
					
			  enddo

			  @ prow(), pcol()+1 SAY "UK="
			  @ prow(), pcol()+1 SAY nPom PICT gPici
			  
			  Rekapld("POR"+por->id+idops,cGodina,cMjesec,nPom,iznos,idops,NLjudi())
			  
			else
			
			  ? idops, ops->naz
		       	  
			  // ovo je osnovica za porez
			  nTmpPor := iznos

			  if por->por_tip == "B"
			  	// ako je na bruto onda je ovo osnovica
			  	nTmpPor := iznos3
			  elseif por->por_tip == "R"
			  	// ako je na ruke onda je osnovica
				nTmpPor := iznos5
			  endif

			  @ prow(), nC1 SAY nTmpPor picture gpici
			  
			  // osnovica ne moze biti negativna
			  if nTmpPor < 0
			  	nTmpPor := 0
			  endif

			  nPom := round2(max(por->dlimit,por->iznos/100*nTmpPor),gZaok2)
			  
			  @ prow(), pcol()+1 SAY nPom pict gpici
		        
			  if cUmPD=="D"
		        	@ prow(),pcol()+1 SAY nPom2:=round2(max(por->dlimit,por->iznos/100*piznos),gZaok2) pict gpici
		        	@ prow(),pcol()+1 SAY nPom-nPom2 pict gpici
		        	
				Rekapld("POR"+por->id+idops,cgodina,cmjesec,nPom-nPom2,0,idops,NLjudi())
		        	nPorOps2 += nPom2
		          else
		        	
				Rekapld("POR"+por->id+idops,cgodina,cmjesec,nPom,nTmpPor,idops,NLjudi())
			  endif
		        
			endif
			
			nOOP += nTmpPor
		        
			nOsnova += nTmpPor

			nPOLjudi += ljudi
		        nPorOps += nPom
		       
		        if cAlgoritam <> "S"
				skip
		        endif
			
			if prow() > (64 + gPStranica)
				//FF
			endif
		
		enddo
		select por
		
		? cLinija
		
		nPor += nPorOps
		nPor2 += nPorOps2
		
	endif
   	
	if !EMPTY(poopst)
	
     		? Lokal("Ukupno po ops.:")
     		
		@ prow(), nC1 SAY nOOP pict gpici
     		@ prow(),pcol()+1 SAY nPorOps   pict gpici
     		
		if cUmPD=="D"
       			@ prow(),pcol()+1 SAY nPorOps2   pict gpici
       			@ prow(),pcol()+1 SAY nPorOps-nPorOps2   pict gpici
       			Rekapld("POR"+por->id,cgodina,cmjesec,nPorOps-nPorOps2,0,,NLjudi())
     		else
       			Rekapld("POR"+por->id,cgodina,cmjesec,nPorOps,nOOP,,"("+ALLTRIM(STR(nPOLjudi))+")")
     		endif
		
     		? cLinija
   	else
     		
		nTmpOsnova := nUNeto
		if por->por_tip == "B"
			nTmpOsnova := nUPorOsnova
		elseif por->por_tip == "R"
			nTmpOsnova := nUPorNROsnova
		endif
		
		if nTmpOsnova < 0
			nTmpOsnova := 0
		endif
		
		nOsnova := nTmpOsnova

		@ prow(),nC1 SAY nTmpOsnova pict gpici
		@ prow(),pcol()+1 SAY nPom:=round2(max(dlimit,iznos/100*nTmpOsnova),gZaok2) pict gpici
     		if cUmPD=="D"
       			@ prow(),pcol()+1 SAY nPom2:=round2(max(dlimit,iznos/100*nUNeto2),gZaok2) pict gpici
       			@ prow(),pcol()+1 SAY nPom-nPom2 pict gpici
       			Rekapld("POR"+por->id,cgodina,cmjesec,nPom-nPom2,0)
       			nPor2+=nPom2
     		else
       			Rekapld("POR"+por->id,cgodina,cmjesec,nPom,nTmpOsnova,,"("+ALLTRIM(STR(nLjudi))+")")
     		endif
     		
		nPor += nPom
   	endif
	
	skip
enddo

? cLinija
? Lokal("Ukupno Porez")
@ prow(),nC1 SAY space(len(gpici))
@ prow(),pcol()+1 SAY nPor - nUPorOl pict gpici

if cUmPD=="D"
	@ prow(),PCOL()+1 SAY nPor2              pict gpici
  	@ prow(),pcol()+1 SAY nPor-nUPorOl-nPor2 pict gpici
endif

? cLinija

return nOsnova



// ----------------------------------------------------
// izracunaj porez na osnovu tipa
// ----------------------------------------------------
function izr_porez( nOsnovica, cTipPor )
local nPor
local nPom
local nPorOl
local cAlgoritam
local aPor

if cTipPor == nil
	cTipPor := ""
endif

O_POR

select por
go top
	
nPom:=0
nPor:=0
nPorOl:=0

do while !eof()
	
	// vrati algoritam poreza
	cAlgoritam := get_algoritam()
	
	PozicOps( POR->poopst )
	
	IF !ImaUOp("POR",POR->id)
		SKIP 1
		LOOP
	ENDIF
		
	// sracunaj samo poreze na bruto
	if !EMPTY(cTipPor) .and. por->por_tip <> cTipPor
		skip 
		loop
	endif
	
	// obracunaj porez
	aPor := obr_por( por->id, nOsnovica, 0 )
	
	nTmp := isp_por( aPor, cAlgoritam, "", .f., .t. )
	
	if nTmp < 0
		nTmp := 0
	endif

	nPor += nTmp
	
	skip 1
enddo

return nPor

