#include "\dev\fmk\ld\ld.ch"


// ------------------------------------------
// obracunaj i prikazi doprinose
// ------------------------------------------
function obr_doprinos( nDopr, nDopr2 )

m:="----------------------- -------- ----------- -----------"

if cUmPD=="D"
  m+=" ----------- -----------"
endif
select dopr
go top

nPom:=nDopr:=0
nPom2:=nDopr2:=0
nC1:=20

if cUmPD=="D"
  ? "----------------------- -------- ----------- ----------- ----------- -----------"
  ? Lokal("                                 Obracunska   Doprinos   Preplaceni   Doprinos  ")
  ? Lokal("    Naziv doprinosa        %      osnovica   po obracunu  doprinos    za uplatu ")
  ? "          (1)             (2)        (3)     (4)=(2)*(3)     (5)     (6)=(4)-(5)"
  ? "----------------------- -------- ----------- ----------- ----------- -----------"
endif

do while !eof()

  if prow()>55+gpStranica
     FF
  endif

  // ako je BENEF i ako je osnova 0 preskoci ovaj doprinos
  if ("BENEF" $ naz) .and. nUBNOsnova == 0
      skip
      loop 
  endif

  if right(id,1)=="X"
   ? cLinija
  endif
  ? id,"-",naz

  @ prow(),pcol()+1 SAY iznos pict "99.99%"
  nC1:=pcol()+1

  if empty(idkbenef) // doprinos udara na neto

    altd()
    if !empty(poopst)
      if poopst=="1"
        ?? Lokal(" (po opst.stan)")
      elseif poopst=="2"
        ?? Lokal(" (po opst.rada)")
      elseif poopst=="3"
        ?? Lokal(" (po kant.stan)")
      elseif poopst=="4"
        ?? Lokal(" (po kant.rada)")
      elseif poopst=="5"
        ?? Lokal(" (po ent. stan)")
      elseif poopst=="6"
        ?? Lokal(" (po ent. rada)")
      endif
      ? strtran(m,"-","=")
      nOOD:=0          // ukup.osnovica za obra�un doprinosa za po op�tinama
      nPOLjudi:=0      // ukup.ljudi za po op�tinama
      nDoprOps:=0
      nDoprOps2:=0
      select opsld
      seek dopr->poopst
      altd()
      do while !eof() .and. id==dopr->poopst
        altd()
        select ops; hseek opsld->idops; select opsld
        IF !ImaUOp("DOPR",DOPR->id)
          SKIP 1; LOOP
        ENDIF
        ? idops,ops->naz
        nBOOps:=round2(iznos*parobr->k3/100,gZaok2)
        @ prow(),nc1 SAY nBOOps picture gpici
        nPom:=round2(max(dopr->dlimit,dopr->iznos/100*nBOOps),gZaok2)
        if cUmPD=="D"
          nBOOps2:=round2(piznos*nPK3/100,gZaok2)
          nPom2:=round2(max(dopr->dlimit,dopr->iznos/100*nBOOps2),gZaok2)
        endif
        if round(dopr->iznos,4)=0 .and. dopr->dlimit>0
          nPom:=dopr->dlimit*opsld->ljudi
          if cUmPD=="D"
            nPom2:=dopr->dlimit*opsld->pljudi
          endif
        endif
        @ prow(),pcol()+1 SAY  nPom picture gpici
        if cUmPD=="D"
          @ prow(),pcol()+1 SAY  nPom2 picture gpici
          @ prow(),pcol()+1 SAY  nPom-nPom2 picture gpici
          Rekapld("DOPR"+dopr->id+idops,cgodina,cmjesec,nPom-nPom2,0,idops,NLjudi())
          nDoprOps2+=nPom2
          nDoprOps+=nPom
        else
          Rekapld("DOPR"+dopr->id+opsld->idops,cgodina,cmjesec,npom,nBOOps,idops,NLjudi())
          nDoprOps+=nPom
        endif
        nOOD += nBOOps
        nPOLjudi += ljudi
        skip
        if prow()>62+gPStranica; FF; endif
      enddo // opsld
      select dopr
      ? cLinija
      ? Lokal("UKUPNO") + SPACE(1),DOPR->ID
//      @ prow(),nC1 SAY nBO pict gpici
      @ prow(),nC1 SAY nOOD pict gpici
      @ prow(),pcol()+1 SAY nDoprOps pict gpici
      if cUmPD=="D"
        @ prow(),pcol()+1 SAY nDoprOps2 pict gpici
        @ prow(),pcol()+1 SAY nDoprOps-nDoprOps2 pict gpici
        Rekapld("DOPR"+dopr->id,cgodina,cmjesec,nDoprOps-nDoprOps2,0,,NLjudi())
        nPom2:=nDoprOps2
      else
        if nDoprOps>0
//          Rekapld("DOPR"+dopr->id,cgodina,cmjesec,nDoprOps,nBO,,NLjudi())
          Rekapld("DOPR"+dopr->id,cgodina,cmjesec,nDoprOps,nOOD,,"("+ALLTRIM(STR(nPOLjudi))+")")
        endif
      endif
      ? cLinija
      nPom:=nDoprOps
    else
      // doprinosi nisu po opstinama
      altd()
      if "BENEF" $ dopr->naz
           nBo:=round2(parobr->k3/100*nUBNOsnova,gZaok2)
      else
           nBo:=round2(parobr->k3/100*nUNetoOsnova,gZaok2)
      endif
      @ prow(),nC1 SAY nBO pict gpici
      nPom:=round2(max(dlimit,iznos/100*nBO),gZaok2)
      if cUmPD=="D"
        nPom2:=round2(max(dlimit,iznos/100*nBO2),gZaok2)
      endif
      if round(iznos,4)=0 .and. dlimit>0
          nPom:=dlimit*nljudi      // nije po opstinama
          if cUmPD=="D"
            nPom2:=dlimit*nljudi      // nije po opstinama ?!?nLjudi
          endif
      endif
      @ prow(),pcol()+1 SAY nPom pict gpici
      if cUmPD=="D"
        @ prow(),pcol()+1 SAY nPom2 pict gpici
        @ prow(),pcol()+1 SAY nPom-nPom2 pict gpici
        Rekapld("DOPR"+dopr->id,cgodina,cmjesec,nPom-nPom2,0)
      else
        Rekapld("DOPR"+dopr->id,cgodina,cmjesec,nPom,nBO,,"("+ALLTRIM(STR(nLjudi))+")")
      endif
    endif // poopst
  else
  //**************** po stopama beneficiranog radnog staza ?? nije testirano
    nPom0:=ASCAN(aNeta,{|x| x[1]==idkbenef})
    if nPom0<>0
      nPom2:=parobr->k3/100*aNeta[nPom0,2]
    else
      nPom2:=0
    endif
    if round2(nPom2,gZaok2)<>0
      @ prow(),pcol()+1 SAY nPom2 pict gpici
      nC1:=pcol()+1
      @ prow(),pcol()+1 SAY nPom:=round2(max(dlimit,iznos/100*nPom2),gZaok2) pict gpici
    endif
  endif  // ****************  nije testirano

  if right(id,1)=="X"
    ? cLinija
    IF !lGusto
      ?
    ENDIF
    nDopr+=nPom
    if cUmPD=="D"
      nDopr2+=nPom2
    endif
  endif

  skip
  if prow()>56+gPStranica; FF; endif
enddo
? cLinija 
? Lokal("Ukupno Doprinosi")
@ prow(),nc1 SAY space(len(gpici))
@ prow(),pcol()+1 SAY nDopr  pict gpici
if cUmPD=="D"
  @ prow(),pcol()+1 SAY nDopr2  pict gpici
  @ prow(),pcol()+1 SAY nDopr-nDopr2  pict gpici
endif
? cLinija

return
