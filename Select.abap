*&---------------------------------------------------------------------*
*& Report ZR0009
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZR0009.

TABLES T005T.

PARAMETERS P_SPRAS LIKE T005T-SPRAS DEFAULT 'PT'.

ULINE /(30).

WRITE: /01 '|',
        02 'País',
        07 '|',
        08 'Denominação',
        30 '|'.

ULINE /(30).

SELECT * FROM T005T WHERE SPRAS = P_SPRAS.
WRITE: /01 '|',
        02 T005T-land1,
        07 '|',
        08 T005T-landx,
        30 '|'.
ULINE /(30).
ENDSELECT.