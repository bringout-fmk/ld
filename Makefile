ROOT = ../harbour/harbour/

HB_INC_COMPILE += -I$(TOP)../fmk_lib/include
HB_LIB_COMPILE += $(HB_LIB_QT) -Lc:/harbour/lib

PRG_SOURCES=\
      launcher.prg \
      codes_menu.prg \
      codes.prg \
      admin_menu.prg \
      autorski_honorar_rpt.prg \
      autroski_honorar_spec.prg \
      autorski_honorar_ut.prg \
      brisanje_obracuna_menu.prg \
      datum_isplate.prg \
      doprinosi.prg \
      gvars.prg \
      install.prg \
      korekcija_obracuna.prg \
      krediti.prg \
      krediti_menu.prg \
      krediti_util.prg \
      ld_menu.prg \
      main_util.prg \
      obracun_menu.prg \
      ostale_operacije_menu.prg \
      parametri.prg \
      parametri_menu.prg \
      poreska_kartica_data.prg \
      poreska_kartica_db.prg \
      poreska_kartica_export.prg \
      poreska_kartica_main.prg \
      porez.prg \
      prijava.prg \
      rekalkulacija.prg \
      rekalkulacija_menu.prg \
      reports_menu.prg \
      rpt_akontacija_poreza.prg \
      rpt_kartica_plate.prg \
      rpt_kartica_v2.prg \
      rpt_kartica_va.prg \
      rpt_kartica_vp.prg \
      rpt_kartica_vs.prg \
      rpt_kartica_vu.prg \
      rpt_main.prg \
      rpt_main_2.prg \
      rpt_obracunski_list.prg \
      rpt_platni_spisak.prg \
      rpt_porezi.prg \
      rpt_pregled_neta.prg \
      rpt_pregled_plata.prg \
      rpt_pregled_plata_vise_mjeseci.prg \
      rpt_pregled_po_racunima.prg \
      rpt_pregled_primanja.prg \
      rpt_rekapitulacija.prg \
      rpt_rekapitulacija_v2.prg \
      rpt_specifikacija.prg \
      rpt_specifikacija_v2.prg \
      rpt_specifikacija_vs.prg \
      rpt_specifikacija_vu.prg \
      rpt_topli_obrok.prg \
      rpt_util.prg \
      spec_util.prg \
      tdb_ld.prg \
      unos_obracuna.prg \
      zakljucenje_obracuna.prg

LIBS=\
        hbvm \
        hbrtl \
        hblang \
        hbrdd \
        hbrtl \
        hbmacro \
        hbpp \
        rddcdx \
        rddfpt \
        rddntx \
        hbcommon \
        hbct \
        hbmisc \
        fmk_skeleton \
        fmk_security \
        fmk_common \
        fmk_ui \
        fmk_db \
        fmk_codes \
        fmk_event \
	fmk_rules \
	fmk_ugov \
	fmk_exp_dbf \
	fmk_lokalizacija \
	fmk_rabat \
        hbdebug \
        hbqt \
        QtGui4 \
        QtCore4 \
        QtNetwork4 \
        QtWebkit4 \
        supc++ \
        gtqtc

               

EXE_NAME=ld.exe
PRG_MAIN=launcher.prg


include $(TOP)$(ROOT)config/bin.cf


HB_FLAGS = -n -b -ufmk_std.ch -kM -gc0 -I$(TOP) -I$(HB_INC_COMPILE)

launcher.c : ../../launcher.prg ../../fin.ch
	$(HB) ../../launcher.prg $(PRG_USR) $(HB_FLAGS)

launcher.o : launcher.c
	$(CC) $(CPPFLAGS) $(CFLAGS) $(C_USR) $(CC_IN) launcher.c -olauncher.o
copy:
	cp -v w32/mingw32/launcher.exe /c/sigma/ld.exe

all: copy


