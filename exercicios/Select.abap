*&---------------------------------------------------------------------*
*& Report ZEXER0007
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zexer0007.

* IMPORTACAÇÃO DA TABELA
TABLES scarr.

* TABELA INTERNA
DATA: t_scarr TYPE TABLE OF scarr.

* WORK AREA
DATA: w_scarr TYPE scarr.

SELECTION-SCREEN BEGIN OF BLOCK bc01 WITH FRAME TITLE TEXT-001.
  PARAMETERS: s_carrId TYPE string.
SELECTION-SCREEN END OF BLOCK bc01.

START-OF-SELECTION.

  SELECT * FROM scarr INTO TABLE t_scarr
   WHERE CARRID = s_carrId.

LOOP AT t_scarr INTO w_scarr.
  WRITE:/ w_scarr-carrid, w_scarr-carrname, w_scarr-currcode, w_scarr-url.
ENDLOOP.