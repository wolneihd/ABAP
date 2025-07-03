*&---------------------------------------------------------------------*
*& Report ZEXER0003
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZEXER0003.

SELECTION-SCREEN BEGIN OF BLOCK b1.
  PARAMETERS p_cat(1) TYPE c.
SELECTION-SCREEN END OF BLOCK b1.

START-OF-SELECTION.

CASE p_cat.
  WHEN 'A'.
    WRITE: 'MOTO'.
  WHEN 'B'.
    WRITE: 'CARRO'.
  WHEN 'C'.
    WRITE: 'VEICULOS DE CARGA'.
  WHEN 'D'.
    WRITE: 'ONIBUS'.
  WHEN 'E'.
    WRITE: 'CAMINHÕES'.
ENDCASE.