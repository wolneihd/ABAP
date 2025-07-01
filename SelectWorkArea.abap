*&---------------------------------------------------------------------*
*& Report ZR0007
*&---------------------------------------------------------------------*
*& Pelo SAP, ideal deve ser o work area.
*&---------------------------------------------------------------------*
REPORT zr0010.

TABLES t005t.

* Tabela interna sem header line
DATA: t_t005t TYPE TABLE OF t005t,
      w_t005t TYPE t005t. " Workarea

PARAMETERS p_spras LIKE t005t-spras DEFAULT 'PT'.

ULINE /(30).

WRITE: /01 '|',
        02 'País',
        07 '|',
        08 'Denominação',
        30 '|'.

ULINE /(30).

SELECT * FROM t005t INTO TABLE t_t005t WHERE spras = p_spras.

LOOP AT t_t005t INTO w_t005t.
  WRITE: /01 '|',
          02 w_t005t-land1,
          07 '|',
          08 w_t005t-landx,
          30 '|'.
  ULINE /(30).
ENDLOOP.
