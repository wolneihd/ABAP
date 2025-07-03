*&---------------------------------------------------------------------*
*& Report ZEXER0002
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZEXER0002 NO STANDARD PAGE HEADING.

CONSTANTS: lc_pi TYPE p DECIMALS 13 VALUE '3.1415926535897'.

DATA: ld_raio      TYPE p DECIMALS 2 VALUE '3',
      ld_area      TYPE p DECIMALS 2,
      ld_str_raio(10) TYPE c,
      ld_str_area(10) TYPE c,
      ld_texto     TYPE string.

ld_area = ( ld_raio * ld_raio ) * lc_pi.

WRITE ld_raio TO ld_str_raio.
WRITE ld_area TO ld_str_area.

CONCATENATE 'A área do círculo de raio' ld_str_raio 'é' ld_str_area INTO ld_texto SEPARATED BY space.

WRITE: ld_texto.