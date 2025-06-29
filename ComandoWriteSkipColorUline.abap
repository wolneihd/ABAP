*&---------------------------------------------------------------------*
*& Report ZR0003
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZR0003 NO STANDARD PAGE HEADING.

WRITE:/ 'Primeira linha'.
SKIP 1.
WRITE:/ 'Terceira linha'.
WRITE:/ 'Fundo vermelho' COLOR 6.
WRITE:/ 'Letra vermelha' COLOR 6 INVERSE.
ULINE.
FORMAT COLOR 1. "A partir daqui tudo sera azul!
WRITE:/ 'Todo esse texto'.
WRITE: 'será impresso em'.
WRITE: 'azul!'.
ULINE.
FORMAT RESET.

DATA col TYPE i VALUE 0.

" Código pego na documentação:
DO 8 TIMES.
  col = sy-index - 1.
  FORMAT COLOR = col.
  WRITE: /  col              COLOR OFF,
           'INTENSIFIED ON'  INTENSIFIED ON,
           'INTENSIFIED OFF' INTENSIFIED OFF,
           'INVERSE ON'      INVERSE ON.
ENDDO.

*& Syntax of color  Value in col  Color
*& { COL_BACKGROUND }	  0	GUI-dependent
*& { 1 | COL_HEADING }  1 Gray-blue
*& { 2 | COL_NORMAL }	  2	Light gray
*& { 3 | COL_TOTAL }    3 Yellow
*& { 4 | COL_KEY }      4 Blue-green
*& { 5 | COL_POSITIVE }	5	Green
*& { 6 | COL_NEGATIVE }	6	Red
*& { 7 | COL_GROUP }    7 Purple