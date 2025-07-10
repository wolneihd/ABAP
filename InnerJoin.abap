*&---------------------------------------------------------------------*
*& Report ZR0013
*&---------------------------------------------------------------------*
*& TABELA SEM HEADER LINE / COM WORK-AREA.
*&---------------------------------------------------------------------*
REPORT zr0013.

TABLES zt0005.

* Cada campo dentro dela herda o tipo de dado das tabelas Z do seu sistema: zt0005 e zt0001
* Similiar a um construtor
TYPES: BEGIN OF ty_mater,
         mater  LIKE zt0005-mater,
         denom  LIKE zt0005-denom,
         brgew  LIKE zt0005-brgew,
         ntgew  LIKE zt0005-ntgew,
         gewei  LIKE zt0005-gewei,
         status LIKE zt0005-status,
         tpmat  LIKE zt0001-tpmat,
         denom1 LIKE zt0001-denom,
       END OF ty_mater.

* tabela interna
* t_mater pode armazenar várias linhas, onde cada linha tem a estrutura definida por ty_mater.
DATA t_mater TYPE TABLE OF ty_mater.

* work area
DATA: w_mater TYPE ty_mater.

SELECTION-SCREEN BEGIN OF BLOCK b01 WITH FRAME TITLE TEXT-001.
  SELECT-OPTIONS: s_tpmat FOR zt0005-tpmat,
                  s_mater FOR zt0005-mater.
SELECTION-SCREEN END OF BLOCK b01.

START-OF-SELECTION.

  SELECT zt0005~mater zt0005~denom zt0005~brgew zt0005~ntgew zt0005~gewei zt0005~status zt0001~tpmat zt0001~denom
      FROM zt0005
     INNER JOIN zt0001
        ON zt0005~tpmat = zt0001~tpmat
      INTO TABLE t_mater
     WHERE zt0005~tpmat IN s_tpmat
       AND zt0005~mater IN s_mater.

  IF sy-subrc <> 0.
    MESSAGE TEXT-002 TYPE 'I'.
  ENDIF.

  LOOP AT t_mater INTO w_mater.
    WRITE:/ w_mater-tpmat, w_mater-mater,w_mater-denom, w_mater-brgew, w_mater-ntgew, w_mater-gewei, w_mater-status, w_mater-tpmat.
  ENDLOOP.