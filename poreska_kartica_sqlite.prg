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
#include "hbsqlit3.ch" 

#define TRACE
#define DB_NAME "pk.sqlite3"
#define CRLF CHR(13) + CHR(10)
#define cSpace  " "
#define cQuote  "'"

// --------------------------------------------------------------
// export poreske kartice
// --------------------------------------------------------------
function pk_sql_export( cFileLocation, lEmptyDb, cConvert )
local cSql := ""
local cTbl 
local cScr
save screen to cScr
clear screen


if cFileLocation == nil
	cFileLocation := "c:\"
endif

if lEmptyDb == nil
	lEmptyDb := .f.
endif

if cConvert == nil
	cConvert := "5"
endif

? sqlite3_libversion()

if sqlite3_libversion_number() < 3005001
	return
endif

create_db( cFileLocation, lEmptyDb )

select pk_radn
go top

cTbl := "pk_radn"
create_from_dbf( cSql, cTbl, cFileLocation, cConvert )

select pk_data
go top

cTbl := "pk_data"
create_from_dbf( cSql, cTbl, cFileLocation, cConvert )

inkey(0)

restore screen from cScr

return


// -----------------------------------------------
// kreiranje database-a
// -----------------------------------------------
function create_db( cFileLocation, lEmpty )
local lCreateIfNotExist := .f.
local db := sqlite3_open( cFileLocation + ;
	DB_NAME, lCreateIfNotExist )

if lEmpty == .t. .and. ! Empty( db )
	sqlite3_exec( db, "DROP TABLE pk_data;" )
	sqlite3_exec( db, "DROP TABLE pk_radn;" )
endif

return


// ------------------------------------------
// kopiraj podatke iz dbf-a
// ------------------------------------------
static function copy_from_dbf( cFileLocation )
local lCreateIfNotExist := .t.
local db := sqlite3_open( cFileLocation + DB_NAME, lCreateIfNotExist )
local stmt
local nCCount, nCType, nI, nJ

local aCType :=  { "SQLITE_INTEGER", "SQLITE_FLOAT", "SQLITE_TEXT", "SQLITE_BLOB", "SQLITE_NULL" }

local aTable

IF ! Empty( db )

#ifdef TRACE
      sqlite3_profile( db, .t. )
      sqlite3_trace( db, .t. )
#endif
      sqlite3_exec( db, "PRAGMA auto_vacuum=0" )
      sqlite3_exec( db, "PRAGMA page_size=4096" )

      IF sqlite3_exec( db, TABLE_SQL ) == SQLITE_OK
         ? "CREATE TABLE t1 - Ok" 
      END

      sqlite3_exec( db, ;
         "BEGIN TRANSACTION;" + ;
         "INSERT INTO t1( name, age ) VALUES( 'Bob', 52 );" + ;
         "INSERT INTO t1( name, age ) VALUES( 'Fred', 40 );" + ;
         "INSERT INTO t1( name, age ) VALUES( 'Sasha', 25 );" + ;
         "INSERT INTO t1( name, age ) VALUES( 'Ivet', 28 );" + ;
         "COMMIT;" )

      ? "BEGIN TRANSACTION" 
      ? "INSERT INTO t1( name, age ) VALUES( 'Bob', 52 )" 
      ? "INSERT INTO t1( name, age ) VALUES( 'Fred', 40 )" 
      ? "INSERT INTO t1( name, age ) VALUES( 'Sasha', 25 )" 
      ? "INSERT INTO t1( name, age ) VALUES( 'Ivet', 28 )" 
      ? "COMMIT" 

      ? "The number of database rows that were changed: " + ltrim( str( sqlite3_changes( db ) ) )
      ? "Total changes: " + ltrim( str( sqlite3_total_changes( db ) ) )

      sqlite3_sleep( 3000 )

      stmt := sqlite3_prepare( db, "INSERT INTO t1( name, age ) VALUES( :name, :age )")
      IF ! Empty( stmt )
         IF sqlite3_bind_text( stmt, 1, "Andy" ) == SQLITE_OK .AND. ;
            sqlite3_bind_int( stmt, 2, 17 ) == SQLITE_OK
            IF sqlite3_step( stmt ) == SQLITE_DONE
               ? "INSERT INTO t1( name, age ) VALUES( 'Andy', 17 ) - Done" 
            ENDIF
         ENDIF
         sqlite3_reset( stmt )

         IF sqlite3_bind_text( stmt, 1, "Mary" ) == SQLITE_OK .AND. ;
            sqlite3_bind_int( stmt, 2, 19 ) == SQLITE_OK
            IF sqlite3_step( stmt ) == SQLITE_DONE
               ? "INSERT INTO t1( name, age ) VALUES( 'Mary', 19 ) - Done" 
            ENDIF
         ENDIF
         sqlite3_clear_bindings( stmt )
         sqlite3_finalize( stmt )
      ENDIF

      ? "The number of database rows that were changed: " + ltrim( str( sqlite3_changes( db ) ) )
      ? "Total changes: " + ltrim( str( sqlite3_total_changes( db ) ) )
      ? "Last _ROWID_: " + str( sqlite3_last_insert_rowid( db ) )
      ? "" 

      stmt := sqlite3_prepare( db, "SELECT * FROM t1 WHERE name == :name ")
      sqlite3_bind_text( stmt, 1, "Andy" )

      ?
      ? "SELECT * FROM t1 WHERE name == 'Andy'" 
      nJ := 0

      DO WHILE sqlite3_step( stmt ) == SQLITE_ROW
         nCCount := sqlite3_column_count( stmt )
         ++nJ
         ? "Record # " + str( nJ )

         IF nCCount > 0
            FOR nI := 0 TO nCCount - 1
               nCType := sqlite3_column_type( stmt, nI )
               ? "Column name : " + sqlite3_column_name( stmt, nI )
               ? "Column type : " + aCType[ nCType ]
               ? "Column value: " 

            SWITCH nCType
            CASE SQLITE_BLOB
               ?? "BLOB" //sqlite3_column_blob( stmt, nI )
               EXIT

            CASE SQLITE_INTEGER
               ?? str ( sqlite3_column_int( stmt, nI ) )
               EXIT

            CASE SQLITE_NULL
               ?? "NULL" 
               EXIT

            CASE SQLITE_TEXT
               ?? sqlite3_column_text( stmt, nI )
               EXIT
            END SWITCH

            NEXT nI
         ENDIF
      ENDDO
      ? "Total records - " + str( nJ )

      sqlite3_clear_bindings( stmt )
      sqlite3_finalize( stmt )

      sqlite3_sleep( 3000 )

      stmt := sqlite3_prepare( db, "SELECT * FROM t1 WHERE age >= ?5")
      sqlite3_bind_int( stmt, 5, 40 )

      ?
      ? "SELECT * FROM t1 WHERE age >= 40 " 
      nJ := 0
      DO WHILE sqlite3_step( stmt ) == SQLITE_ROW
         nCCount := sqlite3_column_count( stmt )
         ++nJ
         ? "Record # " + str( nJ )

         IF nCCount > 0
            FOR nI := 1 TO nCCount
               nCType := sqlite3_column_type( stmt, nI )
               ? "Column name : " + sqlite3_column_name( stmt, nI )
               ? "Column type : " + aCType[ nCType ]
               ? "Column value: " 
            SWITCH nCType
            CASE SQLITE_BLOB
               ?? "BLOB" //sqlite3_column_blob( stmt, nI )
               EXIT

            CASE SQLITE_INTEGER
               ?? str( sqlite3_column_int( stmt, nI ) )
               EXIT

            CASE SQLITE_NULL
               ?? "NULL" 
               EXIT

            CASE SQLITE_TEXT
               ?? sqlite3_column_text( stmt, nI )
               EXIT
            END SWITCH

            NEXT nI
         ENDIF
      ENDDO
      ? "Total records - " + str( nJ )
      sqlite3_clear_bindings( stmt )
      sqlite3_finalize( stmt )

      sqlite3_sleep( 3000 )

      ?
      ? "SELECT id, name, age + 5 FROM t1" 
      stmt := sqlite3_prepare( db, "SELECT id, name, age + 5 FROM t1")

      ? sqlite3_column_name( stmt, 1 )
      ? sqlite3_column_name( stmt, 2 )
      ? sqlite3_column_name( stmt, 3 )

      ? aCType[ sqlite3_column_type( stmt, 1 ) ]
      ? aCType[ sqlite3_column_type( stmt, 2 ) ]
      ? aCType[ sqlite3_column_type( stmt, 3 ) ]

      ? sqlite3_column_decltype( stmt, 1 )
      ? sqlite3_column_decltype( stmt, 2 )
      ? sqlite3_column_decltype( stmt, 3 )

      sqlite3_finalize( stmt )

      sqlite3_sleep( 3000 )

      ?
      ? "sqlite3_get_table" 
      ?
      aTable := sqlite3_get_table( db, "SELECT name, age  FROM t1 WHERE age BETWEEN 10 AND 20" )
      FOR nI := 1 TO Len( aTable )
         FOR nJ := 1 TO Len( aTable[nI] )
            ?? aTable[nI][nJ], " " 
         NEXT nJ
         ?
      NEXT nI

      sqlite3_sleep( 3000 )
   ENDIF

RETURN


// --------------------------------------------------------------------
// kreiraj sqlite iz dbf-a
// --------------------------------------------------------------------
function create_from_dbf( cSQL, cTbl, cLocation, cConv )
LOCAL aStruct
LOCAL cData := ""
LOCAL cDBase
LOCAL n
LOCAL cFlist := ""
LOCAL nFields
LOCAL cField_Def
LOCAL cHealocal 
LOCAL lCreateIfNotExist := .t.
LOCAL db := sqlite3_open( cLocation + DB_NAME, lCreateIfNotExist )

#include "dbstruct.ch"

*COPY STRUCTURE EXTENDED TO struc //.dbf
*USE struc NEW
*LIST field_name, field_type, field_len ,field_dec
aStruct := DBSTRUCT()

AEVAL( aStruct, {| aField | cData := cData + ;
                            aField[ DBS_NAME ] + " " + ;
                            aField[ DBS_TYPE ] + " " +;
                LTRIM( STR( aField[ DBS_LEN ] )) + " " +;
                LTRIM( STR( aField[ DBS_DEC ] )) + CRLF } )
? cData

cDBase := cTbl


// build field list
nFields := LEN( aStruct )

FOR n := 1 TO nFields
    cFList := cFList + ;
              cSpace + aStruct[ n][DBS_NAME] + cSpace +;
              ConvertFldType( aStruct[ n][DBS_TYPE] ) +;
              IIF( ConvertFldLen( aStruct[ n][DBS_TYPE] ), ;
                   "(" + LTRIM( STR( aStruct[ n][DBS_LEN] )) + ")", ;
                   "") +;
              IIF( n < nFields, "," , "")
NEXT


cField_Def := LOWER( cFList )

cHeader := "create table " + cDBase + " (" + cField_Def + ");"

? cHeader

sqlite3_exec( db, cHeader )

GO TOP

DO WHILE ! EOF()

   // Put all fields in a row list comma separated
   cFList := ""
   FOR n := 1 TO nFields
       
       cFList := cFList + ;
       cQuote + RTRIM( xconvert( FieldGet( n ) ) ) + cQuote+ ; 
       	IIF( n < FCOUNT(), ",", "")
   
   NEXT

   // konvertuj u utf-8
   cFList := strkzn( cFList, cConv, "U" ) 

   cSQL := "insert into " + cDBase + " values(" + ;
   	cFList + ");"

   ? cSQL

   cInsert := "BEGIN TRANSACTION;" + cSQL + ";COMMIT;"

   sqlite3_exec( db, cInsert )   
   // insert reccord

   SKIP

ENDDO

? "Ukupni broj promjena: " + ltrim( str( sqlite3_total_changes( db ) ) )
?
?
?

return 


// ----------------------------------------------------------------
// Conversion scheme of types from Clipper/Harbour to SQLite
// Warning !!
// It's a work in progress and would have some errors
// ----------------------------------------------------------------
static function xConvert( xData, nPad )
LOCAL cData, cType, nLen
cType := VALTYPE( xData )

DO CASE
   CASE cType == "N"
        cData := STR( xData )
   CASE cType == "C"
        cData := xData
   CASE cType == "L"
       cData := IIF( xData == .T., "TRUE", "FALSE")
   CASE cType == "A"
        nLen := LEN(xData)
        cData := "ARRAY[" + IIF( nLen > 0, STR( nLen, 2), "0") + "]"
   CASE cType == "B"
        cData := "BLOCK"
   CASE cType == "U"
        cData := "UNDEF"
   CASE cType == "D"
        ? xData
        cData := DTOS( xData )
   OTHERWISE
        cData := VALTYPE( xData)
ENDCASE

IF nPad == NIL .OR. !( VALTYPE( nPad ) == "N" )
ELSE
   cData := PADL( LTRIM(cData), nPad, " ")
ENDIF

RETURN( cData)


*--------------------------------
 FUNCTION ConvertFldType( cType )
*---------------------------------------------------------------------------
* Get a Clipper type and return closest SQLite type
*---------------------------------------------------------------------------
LOCAL aTypes := { { "C", "CHAR"  }, { "L", "BOOLEAN" },;
                  { "M", "TEXT"  }, { "O", "BINARY" },;
                  { "N", "DOUBLE"}, { "D", "TIMESTAMP" } }
*             { "C", "" },;
LOCAL nPos := ASCAN( aTypes, {|aVal| aVal[1] == cType })
RETURN( IIF( nPos == 0, "", aTypes[nPos][2] ))


*-------------------------------
 FUNCTION ConvertFldLen( cType )
*---------------------------------------------------------------------------
* Get a Clipper type and return if field Len is required for SQLite type
*---------------------------------------------------------------------------
LOCAL aTypes := { { "C", "CHAR" ,  .T. }, { "L", "BOOLEAN",  .F. },;
                  { "M", "TEXT" ,  .T. }, { "O", "BINARY" ,  .T. },;
                  { "N", "DOUBLE", .F. }, { "D", "TIMESTAMP",.F. } }
LOCAL nPos := ASCAN( aTypes, {|aVal| aVal[1] == cType })
RETURN( IIF( nPos == 0, .F., aTypes[nPos][3] ))


